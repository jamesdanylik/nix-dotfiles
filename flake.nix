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
    };
    darwinConfigurations = {
      "Jamess-MBP" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/Jamess-MBP/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jamesdanylik = import ./hosts/Jamess-MBP/home.nix;
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
              users.jamesdanylik = import ./hosts/Edwards-MacBook-Pro/home.nix;
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
              users.jamesdanylik = import ./hosts/LENORAs-MacBook-Pro/home.nix;
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
