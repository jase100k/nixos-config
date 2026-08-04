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

        # Allow Borg to operate cleanly if mount path was relocated (e.g. /mnt/data -> /mnt/nas)
        export BORG_RELOCATED_REPO_ACCESS_IS_OK=1
        export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK=1

        REPO="/mnt/nas/backup/jason/borg-repo"
        EXCLUDES="$HOME/.config/borg/excludes"

        # Check if NAS repository path is mounted and accessible
        if [ ! -d "$REPO" ]; then
          echo "⚠️ Borg repository ($REPO) is not accessible! Skipping backup."
          exit 0
        fi

        EXCLUDE_ARGS=()
        if [ -f "$EXCLUDES" ]; then
          EXCLUDE_ARGS+=(--exclude-from "$EXCLUDES")
        fi

        echo "🚀 Starting Borg Nightly Backup..."
        ${pkgs.borgbackup}/bin/borg create \
          --stats \
          "''${EXCLUDE_ARGS[@]}" \
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
