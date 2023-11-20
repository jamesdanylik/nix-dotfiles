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
        # james work mpb pubkey
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDAtBvRrgAjslyq7gl5UvOc7SAnut41kEDf9kyqEEki0m6kLStyQ2kQG2nxxP0eV7bxIhIuraM95EuKXCJVqVr4NmPxMIqPeSV5q1vdrF2kosVBKI+mRJtSayZGWBwZbyUJ8/nC+j/ELBxpXzufxpHHtOzf4Y/q/xr1xFBgRfBR8KWHPj80qUuAbQ3nRWPrmEBM5u1VIJf1+Ak+gD8mr10JSm48bkMf8ZxA+iQqFsDIqBcY1g9VXiYQs4KJobkl9FD+5IPy1NquqlpQ86kIPt3gij1vdy9UqZo3WiyUfi0k0XTpKLhKPXJWUoQMTfqnEmuY7Rq0ucWVIzsLCGQyb7t9pAZUKf/demup1E0Ie3H+DeuhZGEog8460mG6YTvsKowH8fYNW62mjy0DEoE9caDCSCwq93uqjHabQ54E1rUetnGnH537UNAjNGA6G6UzlJQyPemEgT6t0F/UudqDRqd1DDzc7SXBJKPRdVCR8fs7JxTUwsCgOpKc/WHSwdkfZ10= jamesdanylik"
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
