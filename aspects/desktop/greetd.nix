{ config, pkgs, lib, ... }:

let
  colors = config.lib.stylix.colors;
  c = config.lib.stylix.colors.withHashtag;
in
{
  # Enable Noctalia Greeter with declarative appearance matching Noctalia desktop
  programs.noctalia-greeter = {
    enable = true;
    greeter-args = "--session Mango --user jason";
    settings = {
      session = {
        default = "Mango";
      };

      user = {
        default = "jason";
      };

      appearance = {
        scheme = "Synced";
        theme_mode = "dark";
        password_style = "random";
        hide_logo = false;
        corner_radius_scale = 1.35;
        font_family = config.stylix.fonts.sansSerif.name;

        wallpaper = {
          path = "/var/lib/noctalia-greeter/wallpaper.jpg";
          fill_mode = "crop";
        };

        palette = {
          primary = c.base0D;
          on_primary = c.base00;
          secondary = c.base0E;
          on_secondary = c.base00;
          tertiary = c.base0B;
          on_tertiary = c.base00;
          error = c.base08;
          on_error = c.base00;
          surface = "#${colors.base00}a6";
          on_surface = "#ffffff";
          surface_variant = "#${colors.base01}66";
          on_surface_variant = "#${colors.base05}e6";
          outline = "#ffffff33";
          shadow = "#00000088";
          hover = "#${colors.base0D}40";
          on_hover = "#ffffff";
        };
      };

      cursor = {
        theme = config.stylix.cursor.name;
        size = config.stylix.cursor.size;
        path = "${config.stylix.cursor.package}/share/icons";
      };
    };
  };

  # Configure greeter state directory permissions and fallback wallpaper for dynamic user sync
  systemd.tmpfiles.rules = [
    "d /var/lib/noctalia-greeter 0775 greeter users -"
    "C+ /var/lib/noctalia-greeter/wallpaper.jpg 0644 greeter users - ${config.stylix.image}"
  ];

  # Allow user sync of Noctalia appearance and system update without password prompt
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.noctalia.greeter.apply-appearance" ||
           (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("command_line") &&
            (action.lookup("command_line").indexOf("noctalia-greeter-apply-appearance") >= 0 ||
             action.lookup("command_line").indexOf("nixos-rebuild") >= 0))) &&
          (subject.isInGroup("users") || subject.isInGroup("wheel") || subject.user == "jason")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Additional sudoers rule for passwordless update and sync execution fallback
  security.sudo.extraRules = [
    {
      groups = [ "wheel" "users" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/noctalia-greeter-apply-appearance";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # Systemd user service for polkit graphical authentication agent
  environment.systemPackages = [ pkgs.hyprpolkitagent ];
  systemd.user.services.hyprpolkitagent = {
    description = "Hyprland Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" "default.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };


  # Configure greeter user home directory and GPU permissions
  users.users.greeter = {
    home = "/var/lib/greetd";
    createHome = true;
    extraGroups = [ "video" "render" "input" "users" ];
  };

  # Sessions for display manager
  services.displayManager.sessionPackages = [ pkgs.mango pkgs.niri ];
  services.displayManager.defaultSession = lib.mkForce null;
}



