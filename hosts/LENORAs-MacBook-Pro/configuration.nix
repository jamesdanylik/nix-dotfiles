{ ... }: {
  # system.stateVersion = "23.05";
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  services.nix-daemon.enable = true;

  system.defaults.dock.autohide = true;

  programs.zsh.enable = true;

  users.users.lenoracaldera = {
    name = "lenoracaldera";
    home = "/Users/lenoracaldera";
  };
}
