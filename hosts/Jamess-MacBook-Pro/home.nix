{ inputs, ... }: {
  home.stateVersion = "23.05";
  home.username = "jamesdanylik";
  home.homeDirectory = "/Users/jamesdanylik";
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../../modules/home/neovim
    ../../modules/home/kitty
    ../../modules/home/eza
    ../../modules/home/direnv
    ../../modules/home/hyfetch
    ../../modules/home/btop
    ../../modules/home/tealdeer
    ../../modules/home/vscode
  ];

  programs = {
    home-manager.enable = true;
    zsh.enable = true;
  };
}
