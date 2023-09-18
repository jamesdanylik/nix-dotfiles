{ ... }: {
  programs.kitty = {
    enable = true;
    font.name = "NotoMono NF";
    extraConfig = (builtins.readFile ./tokyonight_night.conf);
    shellIntegration.enableZshIntegration = true;
  };
}
