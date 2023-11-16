{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    extraConfig = ''
      general {
          border_size = 1
          col.active_border = rgba(000000ff)
          col.inactive_border = rgba(000000ff)
          layout = dwindle
      }

      dwindle {
          pseudotile = true
          preserve_split = true
          no_gaps_when_only = true
          force_split = 0
      }

      master {
          new_is_master = true
      }

      decoration {
          rounding = 8
      }

      exec-once = swaync
      exec-once = blueman-applet

      $mod = SUPER
      bind = $mod, Q, exec, kitty
      bind = $mod, R, exec, wofi --show drun -a
      bind = $mod, B, exec, pkill -SIGUSR1 waybar

      binde = , XF86AudioRaiseVolume, exec, swayosd --output-volume raise
      binde = , XF86AudioLowerVolume, exec, swayosd --output-volume lower
      bind = , XF86AudioMute, exec, swayosd --output-volume mute-toggle
      bindr = CAPS, Caps_Lock, exec, swayosd --caps-lock
      #binde = , XF86MonBrightnessUp, exec, swayosd --brightness raise
      binde = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
      #binde = , XF86MonBrightnessDown, exec, swayosd --brightness lower
      binde = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      bind = , XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = , XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next
      bind = , XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous
      bind = $mod, T, exec, ${pkgs.playerctl}/bin/playerctl play-pause
      bind = $mod, C, killactive
      bind = $mod, M, exit
      bind = $mod, V, togglefloating
      bind = $mod, F, fakefullscreen
      bind = $mod, J, togglesplit

      bindm = $mod, mouse:272, movewindow
      bindm = $mod, mouse:273, resizewindow

      ${builtins.concatStringsSep "\n" (builtins.map (
        key: let
          letter = builtins.substring 0 1 key;
        in ''
          bind = $mod, ${key}, movefocus, ${letter}
          binde = $mod SHIFT, ${key}, movewindow, ${letter}
        '') ["left" "right" "up" "down"] )}

      ${builtins.concatStringsSep "\n" (builtins.genList (
        x: let 
          ws = toString (x+1);
          key = let 
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c*10));
        in ''
          bind = $mod, ${key}, workspace, ${ws}
          binde = $mod SHIFT, ${key}, movetoworkspace, ${ws}
        ''
        ) 10)}
    '';
  };
}
