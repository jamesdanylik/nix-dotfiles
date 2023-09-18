{ ... }: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        font-family: NotoMono NF;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "hyprland/workspaces" "tray" "idle_inhibitor" ];
        modules-right = [ "cava" "wireplumber" "cpu" "temperature" "memory" "disk" "network" "clock" ];


        "hyprland/workspaces" = {
          active-only = "true";
          format = "{name}";
        };

        tray = {
          icon-size = 15;
          spacing = 15;
        };

        idle_inhibitor = {
          format = "{status}";
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
          format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
            on-click-right = "mode";
          };
        };

        wireplumber = {
          format = "{volume}%";
          format-muted = "MUTE";
          scroll-step = 0.2;
        };

        cpu = {
          format = "{usage}%";
          interval = 10;
        };

        temperature = {
          format = "{temperatureC}°C";

        };

        memory = {
          format = "{percentage}%";
          interval = 30;
        };

        disk = {
          interval = 30;
          format = "{percentage_free}%";
          path = "/";
        };

        network = {
          interval = 60;
          family = "ipv4";
          format = "{ifname}: {ipaddr}";
        };

        clock = {
          timezone = "America/Los_Angeles";
        };

      };
    };
  };
}
