{ pkgs, ... }:

let
  mango-cheatsheet = pkgs.writeShellScriptBin "mango-cheatsheet" ''
    printf "SUPER+Return\tTerminal (Alacritty)\nSUPER+Space\tApp Launcher (Fuzzel)\nSUPER+W\tWaypaper GUI Wallpaper Picker\nSUPER+D\tNoctalia App Launcher\nSUPER+S\tNoctalia Control Center\nSUPER+Comma\tNoctalia Settings\nSUPER+SHIFT+S\tScreenshot Area (Satty)\nSUPER+Q\tClose Window\nSUPER+R\tReload MangoWM Config\nSUPER+M\tQuit MangoWM\nSUPER+/\tKeybindings Cheatsheet\nSUPER+F\tToggle Fullscreen\nSUPER+A\tToggle Maximize Screen\nSUPER+\\\tToggle Floating\nSUPER+SHIFT+F\tToggle Fake Fullscreen\nSUPER+G\tToggle Global Window\nSUPER+I\tMinimize Window\nSUPER+SHIFT+I\tRestore Minimized\nSUPER+O\tToggle Overlay Window\nSUPER+Z\tToggle Scratchpad\nSUPER+Tab\tToggle Overview\nALT+Tab\tFocus Next Window\nSUPER+H/J/K/L\tFocus Left/Down/Up/Right\nSUPER+SHIFT+H/J/K/L\tMove/Swap Window\nCTRL+SHIFT+H/J/K/L\tMove Floating Window\nCTRL+ALT+H/J/K/L\tResize Floating Window\nSUPER+1..5\tSwitch to Tag 1..5\nSUPER+SHIFT+1..5\tMove Window to Tag 1..5\nSUPER+T\tSet Tile Layout\nSUPER+B\tSet Scroller Layout\nSUPER+N\tSwitch Layout Preset" | ${pkgs.fuzzel}/bin/fuzzel --dmenu -p "Keybindings: " -w 65
  '';
in
{
  home.packages = [ mango-cheatsheet ];

  wayland.windowManager.mango = {
    enable = true;

    # Auto-load Noctalia's dynamically generated theme file
    extraConfig = ''
      source=~/.config/mango/noctalia.conf
    '';

    # Clean autostart script
    autostart_sh = ''
      noctalia &
      antigravity-ide &
      alacritty &
      floorp &
      steam -silent &
    '';

    settings = {
      # Window Aesthetics & Layout
      borderpx = 2;
      border_radius = 8;

      # Blur (let Noctalia handle layer effects)
      blur = 1;
      blur_layer = 0;
      blur_optimized = 1;
      blur_params_num_passes = 2;
      blur_params_radius = 5;
      blur_params_noise = 0.02;
      blur_params_brightness = 0.9;
      blur_params_contrast = 0.9;
      blur_params_saturation = 1.0;

      # Shadows (let Noctalia handle layer shadows)
      shadows = 1;
      layer_shadows = 0;
      shadow_only_floating = 1;
      shadows_size = 4;
      shadows_blur = 12;
      shadows_position_x = 2;
      shadows_position_y = 2;

      # Tags
      tagrule = [
        "id:1,layout_name:tile"
        "id:2,layout_name:scroller"
        "id:3,layout_name:tile"
        "id:4,layout_name:tile"
        "id:5,layout_name:tile"
      ];

      # Monitor config - Dell S3422DWG 144Hz
      monitorrule = [
        "name:DP-2,width:3440,height:1440,refresh:144,x:0,y:0,scale:1,vrr:1"
      ];

      # Keybindings (Unified on SUPER modifier to avoid app shortcut conflicts)
      bind = [
        # Core Launchers & App Control
        "SUPER,Return,spawn,alacritty"
        "SUPER,space,spawn,fuzzel"
        "SUPER,w,spawn,waypaper"
        "SUPER,Q,killclient"
        "SUPER,M,quit"
        "SUPER,r,reload_config"

        # Keybindings Cheatsheet Launcher (SUPER + /)
        "SUPER,slash,spawn,${mango-cheatsheet}/bin/mango-cheatsheet"

        # Noctalia IPC Binds
        "SUPER,d,spawn,noctalia msg panel-toggle launcher"
        "SUPER,s,spawn,noctalia msg panel-toggle control-center"
        "SUPER,comma,spawn,noctalia msg settings-toggle"

        # Media Keys
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"

        # Focus (Vim keys)
        "SUPER,h,focusdir,left"
        "SUPER,l,focusdir,right"
        "SUPER,j,focusdir,down"
        "SUPER,k,focusdir,up"
        "ALT,Tab,focusstack,next"
        "SUPER,u,focuslast"

        # Swap Window (Vim keys)
        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,l,exchange_client,right"
        "SUPER+SHIFT,j,exchange_client,down"
        "SUPER+SHIFT,k,exchange_client,up"

        # Move Floating Window
        "CTRL+SHIFT,h,movewin,-50,+0"
        "CTRL+SHIFT,l,movewin,+50,+0"
        "CTRL+SHIFT,j,movewin,+0,+50"
        "CTRL+SHIFT,k,movewin,+0,-50"

        # Resize Floating Window
        "CTRL+ALT,h,resizewin,-50,+0"
        "CTRL+ALT,l,resizewin,+50,+0"
        "CTRL+ALT,j,resizewin,+0,+50"
        "CTRL+ALT,k,resizewin,+0,-50"

        # Window States
        "SUPER,f,togglefullscreen"
        "SUPER,a,togglemaximizescreen"
        "SUPER,backslash,togglefloating"
        "SUPER+SHIFT,f,togglefakefullscreen"
        "SUPER,g,toggleglobal"
        "SUPER,i,minimized"
        "SUPER+SHIFT,I,restore_minimized"
        "SUPER,o,toggleoverlay"
        "SUPER,z,toggle_scratchpad"
        "SUPER,Tab,toggleoverview"

        # Tag Switching (SUPER + 1..5)
        "SUPER,1,view,1"
        "SUPER,2,view,2"
        "SUPER,3,view,3"
        "SUPER,4,view,4"
        "SUPER,5,view,5"
        "SUPER,Left,viewtoleft"
        "SUPER,Right,viewtoright"

        # Move Window to Tag (SUPER + SHIFT + 1..5)
        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "SUPER+SHIFT,4,tag,4"
        "SUPER+SHIFT,5,tag,5"

        # Layout Switching
        "SUPER,t,setlayout,tile"
        "SUPER,b,setlayout,scroller"
        "SUPER,n,switch_layout"
        "SUPER,e,set_proportion,1.0"
        "SUPER,x,switch_proportion_preset"

        # Screenshots
        "SUPER+SHIFT,s,spawn_shell,mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && grim -g \"$g\" - | satty --filename - --output-filename $HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"
      ];

      # Scroll to Switch Tags
      axisbind = [
        "SUPER,UP,viewtoleft_have_client"
        "SUPER,DOWN,viewtoright_have_client"
      ];

      # Mouse Bindings
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
        "NONE,btn_middle,togglemaximizescreen"
      ];

      # Floating & Application Rules
      windowrule = [
        # Steam & Games
        "isfullscreen:1,title:^(.*) - Steam$"
        "isfloating:1,title:^Steam - News$"
        "isfloating:1,title:^Friends List$"

        # System Applets & Audio Control
        "isfloating:1,appid:^pavucontrol$"
        "isfloating:1,appid:^pwvucontrol$"
        "isfloating:1,appid:^nm-connection-editor$"
        "isfloating:1,appid:^blueman-manager$"
        "isfloating:1,appid:^lact$"

        # Security & Authentication Dialogs
        "isfloating:1,appid:^org.kde.polkit-kde-authentication-agent-1$"
        "isfloating:1,appid:^polkit-gnome-authentication-agent-1$"

        # File Dialogs & Screenshot Annotator
        "isfloating:1,title:^Open File$"
        "isfloating:1,title:^Save File$"
        "isfloating:1,title:^Select a Directory$"
        "isfloating:1,appid:^com.nobody.satty$"

        # Tag Routing
        "tags:1,appid:^antigravity-ide$"
        "tags:1,appid:^Alacritty$"
        "tags:1,appid:^org.kde.konsole$"
        "tags:2,appid:^floorp$"
        "tags:2,appid:^io.github.Aylur.floorp$"
        "tags:3,appid:^steam$"
        "tags:3,appid:^steam_app$"
      ];
    };
  };
}
