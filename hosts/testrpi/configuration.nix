{ pkgs, ... }: {
  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "@wheel" ];
  };

  security.sudo.wheelNeedsPassword = false;

  users = {
    users.test = {
      isNormalUser = true;
      initialPassword = "test";
      group = "testgroup";
      extraGroups = [ "wheel" "video" "render" "audio" ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        # testlaptop pubkey
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGtIKYOkswHOCV8awcE5xxvlLt1sli0qILzHLm7loV6o test"
      ];
    };
    groups.testgroup = { };
  };

  programs.zsh.enable = true;
  environment.systemPackages = [
    pkgs.mpv
    pkgs.yt-dlp
  ];

  systemd.services.kittytv = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      User = "test";
      Group = "testgroup";
      ExecStart = "${pkgs.mpv}/bin/mpv --audio-device=alsa/sysdefault --loop-playlist=force 'https://www.youtube.com/watch?v=dC0-Q8fFIpQ'";
      # ExecStart = "${pkgs.mpv}/bin/mpv --script-opts=ytdl_hook-ytdl_path=${pkgs.yt-dlp}/bin/yt-dlp --ytdl-format=bestvideo[height<=?1080][fps<=?30][vcodec!=?vp9]+bestaudio/best --audio-device=alsa/sysdefault 'https://www.youtube.com/watch?v=dC0-Q8fFIpQ'";
    };
  };

  services.automatic-timezoned.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };
}
