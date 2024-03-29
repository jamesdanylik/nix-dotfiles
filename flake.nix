{
  description = "Nix configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";
  };
  outputs = inputs@{ nixpkgs, nixos-generators, nix-darwin, disko, home-manager, nixvim, hyprland, nur, ... }: {
    nixosConfigurations = {
      testnixos = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.overlays = [ nur.overlay ]; }
          nixos-generators.nixosModules.all-formats
          ./hosts/testnixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.test = import ./hosts/testnixos/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
      testlaptop = nixpkgs.lib.nixosSystem {
        modules = [
          { nixpkgs.overlays = [ nur.overlay ]; }
          nixos-generators.nixosModules.all-formats
          disko.nixosModules.disko
          ./hosts/testlaptop/disk-config.nix
          ./hosts/testlaptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.test = import ./hosts/testlaptop/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
      testrpi = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/testrpi/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      "lain" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ({ pkgs, ... }: {
            home.username = "lain";
            home.homeDirectory = "/home/lain";
            home.stateVersion = "23.05";
            home.packages = with pkgs; [ git-fame ];

            imports = [
              inputs.nixvim.homeManagerModules.nixvim
              ./modules/home/neovim
              ./modules/home/zsh
              ./modules/home/eza
              ./modules/home/direnv
            ];
            programs.home-manager.enable = true;
            # required for Arch Linux
            programs.zsh.initExtra = ''
              export PATH=/home/lain/.nix-profile/bin:$PATH
              export EDITOR=nvim
            '';
          })
        ];
      };
    };
    darwinConfigurations = {
      "Jamess-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/Jamess-MacBook-Pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jamesdanylik = import ./hosts/Jamess-MacBook-Pro/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
      "Edwards-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/Edwards-MacBook-Pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.edwardwilson = import ./hosts/Edwards-MacBook-Pro/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
      "LENORAs-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/LENORAs-MacBook-Pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lenoracaldera = import ./hosts/LENORAs-MacBook-Pro/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
      "Erics-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/Erics-MacBook-Pro/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.ericngo = import ./hosts/Erics-MacBook-Pro/home.nix;
              extraSpecialArgs = {
                inherit inputs;
              };
            };
          }
        ];
      };
    };
  };
}
