{ pkgs, ... }:

{
  wayland.windowManager.mango = {
    enable = true;
    autostart_sh = ''
      noctalia &
      sleep 1 && alacritty &
      sleep 2 && floorp &
      sleep 3 && steam &
    '';
    settings = {
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
      shadow_only_floating = 0;
      shadows_size = 4;
      shadows_blur = 12;
      shadows_position_x = 2;
      shadows_position_y = 2;
      shadowscolor = "0x000000ff";

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

      # Keybindings
      bind = [
        # Core
        "ALT,Return,spawn,alacritty"
        "ALT,space,spawn,fuzzel"
        "ALT,Q,killclient"
        "SUPER,M,quit"
        "ALT,r,reload_config"

        # Noctalia IPC binds
        "SUPER,space,spawn,noctalia msg panel-toggle launcher"
        "SUPER,s,spawn,noctalia msg panel-toggle control-center"
        "SUPER,comma,spawn,noctalia msg settings-toggle"

        # Media keys
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%+"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_SINK@ 5%-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_SINK@ toggle"

        # Focus (vim-style)
        "ALT,h,focusdir,left"
        "ALT,l,focusdir,right"
        "ALT,j,focusdir,down"
        "ALT,k,focusdir,up"
        "SUPER,Tab,focusstack,next"
        "SUPER,u,focuslast"

        # Swap window (vim-style)
        "SUPER+SHIFT,h,exchange_client,left"
        "SUPER+SHIFT,l,exchange_client,right"
        "SUPER+SHIFT,j,exchange_client,down"
        "SUPER+SHIFT,k,exchange_client,up"

        # Move floating window (vim-style)
        "CTRL+SHIFT,h,movewin,-50,+0"
        "CTRL+SHIFT,l,movewin,+50,+0"
        "CTRL+SHIFT,j,movewin,+0,+50"
        "CTRL+SHIFT,k,movewin,+0,-50"

        # Resize floating window (vim-style)
        "CTRL+ALT,h,resizewin,-50,+0"
        "CTRL+ALT,l,resizewin,+50,+0"
        "CTRL+ALT,j,resizewin,+0,+50"
        "CTRL+ALT,k,resizewin,+0,-50"

        # Window states
        "ALT,f,togglefullscreen"
        "ALT,a,togglemaximizescreen"
        "ALT,backslash,togglefloating"
        "ALT+SHIFT,f,togglefakefullscreen"
        "SUPER,g,toggleglobal"
        "SUPER,i,minimized"
        "SUPER+SHIFT,I,restore_minimized"
        "SUPER,o,toggleoverlay"
        "ALT,z,toggle_scratchpad"
        "ALT,Tab,toggleoverview"

        # Tag switching
        "SUPER,Left,viewtoleft"
        "SUPER,Right,viewtoright"
        "CTRL,Left,viewtoleft_have_client"
        "CTRL,Right,viewtoright_have_client"
        "CTRL+SUPER,Left,tagtoleft"
        "CTRL+SUPER,Right,tagtoright"

        "CTRL,1,view,1"
        "CTRL,2,view,2"
        "CTRL,3,view,3"
        "CTRL,4,view,4"
        "CTRL,5,view,5"

        # Move windows to tags
        "ALT,1,tag,1"
        "ALT,2,tag,2"
        "ALT,3,tag,3"
        "ALT,4,tag,4"
        "ALT,5,tag,5"

        # Layout switching
        "ALT,t,setlayout,tile"
        "ALT,s,setlayout,scroller"
        "SUPER,n,switch_layout"

        # Scroller
        "ALT,e,set_proportion,1.0"
        "SUPER,x,switch_proportion_preset"

        # Screenshots (Wayland grim + slurp + satty + wl-clipboard)
        "ALT,p,spawn_shell,mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim -g \"$g\" \"$f\" && wl-copy --type image/png < \"$f\""
        "ALT+SHIFT,p,spawn_shell,mkdir -p $HOME/Pictures/Screenshots && f=$HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png && grim \"$f\" && wl-copy --type image/png < \"$f\""
        "ALT+CTRL,p,spawn_shell,f=$(mktemp -t shot-XXXXXX.png) && grim \"$f\" && wl-copy --type image/png < \"$f\" && rm -f \"$f\""
        "SUPER+SHIFT,s,spawn_shell,mkdir -p $HOME/Pictures/Screenshots && g=$(slurp) && [ -n \"$g\" ] && grim -g \"$g\" - | satty --filename - --output-filename $HOME/Pictures/Screenshots/$(date +%Y%m%d%H%M%S).png"
      ];

      # Scroll to switch tags
      axisbind = [
        "SUPER,UP,viewtoleft_have_client"
        "SUPER,DOWN,viewtoright_have_client"
      ];

      # Mouse bindings
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
        "NONE,btn_middle,togglemaximizescreen"
      ];

      # Window rules for Steam games
      windowrule = [
        "isfullscreen:1,title:^(.*) - Steam$"

        # Tag 1 - terminals
        "tags:1,appid:^Alacritty$"
        "tags:1,appid:^org.kde.konsole$"

        # Tag 2 - web browsers
        "tags:2,appid:^floorp$"
        "tags:2,appid:^io.github.Aylur.floorp$"

        # Tag 3 - steam
        "tags:3,appid:^steam$"
        "tags:3,appid:^steam_app$"
      ];
    };
  };
}
