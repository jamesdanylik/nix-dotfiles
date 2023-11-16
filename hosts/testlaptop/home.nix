{ config, pkgs, inputs, ... }: {
  home.stateVersion = "23.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };
  # home.shellAliases = {
  #   xterm = "kitty";
  # };
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/home
  ];
  services = {
    plex-mpv-shim.enable = true;
    swayosd.enable = true;
    playerctld.enable = true; # for mpris in waybar
  };
  home.packages = [ pkgs.playerctl pkgs.wev ];

  programs = {
    home-manager.enable = true;
    translate-shell = {
      enable = true;
    };
    yt-dlp = {
      enable = true;
    };
    mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        mpris
        uosc
      ];
    };
    git = {
      enable = true;
    };
    # zoxide - cd with smart jumps
    # boxxy - sandboxing for badly behaving linus apps
    # document reader, recolor bg's to black
    zathura = {
      enable = true;
      options = {
        default-bg = "#000000";
        default-fg = "#ffffff";
      };
    };
    # mcfly for ctrl-r replacement
    # bat colorized cat replacement
    # command completion, overrides zsh completion
    carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  }; # End Programs
} # End Test user Home declaration
