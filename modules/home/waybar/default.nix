{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    style = ''
      * {
        font-family: NotoMono NF;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "idle_inhibitor" "hyprland/workspaces" "wireplumber" "cava" "mpris" ];
        modules-right = [ "tray" "cpu" "temperature" "memory" "disk" "battery" "network" "clock" "custom/poweroff" ];

        "hyprland/workspaces" = {
          active-only = "true";
          format = "{name}";
        };

        "custom/poweroff" = {
          format = "{icon}";
          format-icons = [ "󰐥" ];
          on-click = "${pkgs.nwg-bar}/bin/nwg-bar";
          exec-on-event = false;
        };

        tray = {
          icon-size = 15;
          spacing = 15;
        };

        mpris = {
          format = "{status_icon} {player_icon} {dynamic}";
          player-icons = {
            firefox = "";
            default = "󰓃";
          };
          status-icons = {
            paused = "󰏤";
            playing = "󰐊";
            stopped = "󰓛";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            deactivated = "";
            activated = "";
          };
        };

        cava = {
          framerate = 30;
          autosens = 1;
          #sensitivity = 100;
          bars = 14;
          lower_cutoff_freq = 50;
          higher_cutoff_freq = 10000;
          method = "pipewire";
          source = "auto";
          stereo = true;
          reverse = false;
          bar_delimiter = 0;
          monstercat = false;
          waves = false;
          noise_reduction = 0.77;
          input_delay = 2;
          sleep_timer = 5; # need this to prevent cava from sleeping instantly on silence
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
            on-click-right = "mode";
          };
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          scroll-step = 1;
          format-icons = [ "󰕿" "󰖀" "󰕾" ];
          on-click = "/run/current-system/sw/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        cpu = {
          format = "󰒓 {usage}%";
          interval = 10;
        };

        temperature = {
          format = "󰔏 {temperatureC}󰔄";
        };

        memory = {
          format = "󰍛 {percentage}%";
          interval = 30;
        };

        disk = {
          interval = 30;
          format = "󰆼 {percentage_free}%";
          path = "/";
        };

        network = {
          interval = 60;
          family = "ipv4";
          format-disconnected = "󰲛";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-wifi = "{icon} {essid} ({signalStrength}%)";
          format-icons = [ "󰤟" "󰤢" "󰤥" "󰤨" ];
        };

        clock = {
          timezones = [ "America/Los_Angeles" "Etc/UTC" "Asia/Tokyo" ];
          format = "󰥔 {:%e %a %H:%M %Z}";
          actions = {
            on-scroll-up = "tz_up";
            on-scroll-down = "tz_down";
          };
        };
      };
    };
  };
}
