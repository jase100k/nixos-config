{ pkgs, ... }:

{
  # Install Borg Backup package
  home.packages = [
    pkgs.borgbackup
  ];

  # Systemd User Service & Timer for Nightly Borg Backup
  systemd.user.services.borg-backup = {
    Unit = {
      Description = "Nightly Borg Backup to NAS";
      Documentation = [ "man:borg(1)" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "run-borg-backup" ''
        set -euo pipefail

        REPO="/mnt/nas/backup/jason/borg-repo"
        EXCLUDES="$HOME/.config/borg/excludes"

        # Check if NAS mount is accessible
        if [ ! -d "/mnt/nas/backup" ]; then
          echo "⚠️ /mnt/nas is not mounted! Skipping backup."
          exit 0
        fi

        echo "🚀 Starting Borg Nightly Backup..."
        ${pkgs.borgbackup}/bin/borg create \
          --stats \
          --exclude-from "$EXCLUDES" \
          --exclude-if-present .nobackup \
          --exclude-caches \
          "$REPO::{now}" "$HOME"

        echo "🧹 Pruning old Borg backups..."
        ${pkgs.borgbackup}/bin/borg prune \
          --keep-daily 7 \
          --keep-weekly 4 \
          --keep-monthly 6 \
          "$REPO"

        echo "✅ Nightly Borg Backup completed successfully."
      '';
    };
  };

  systemd.user.timers.borg-backup = {
    Unit = {
      Description = "Nightly Borg Backup Timer";
    };

    Timer = {
      OnCalendar = "*-*-* 02:00:00";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
