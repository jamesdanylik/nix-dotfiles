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
  };
  outputs = { nixpkgs, nixos-generators, nix-darwin, home-manager, nixvim, hyprland, ... }: {
    nixosConfigurations = {
      testnixos = nixpkgs.lib.nixosSystem {
        modules = [
          ({ config, pkgs, ... }: {
            system.stateVersion = "23.05";
            imports = [
              nixos-generators.nixosModules.all-formats
              ./modules/system
            ];

            nixpkgs.hostPlatform = "x86_64-linux";
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.cudaSupport = true;

            users = {
              users.test = {
                isNormalUser = true;
                initialPassword = "test";
                group = "testgroup";
                extraGroups = [ "wheel" ];
                shell = pkgs.zsh;
              };
              groups.testgroup = { };
            };

            fonts = {
              packages = with pkgs; [
                (nerdfonts.override { fonts = [ "Noto" ]; })
              ];
              enableDefaultPackages = true;
              fontDir.enable = true;
              fontconfig = {
                enable = true;
                antialias = true;
                defaultFonts = {
                  monospace = [ "NotoMono NF" ];
                };
              };
            };

            security.polkit.enable = true;

            # Enable OpenGL
            hardware.opengl = {
              enable = true;
              driSupport = true;
              driSupport32Bit = true;
              extraPackages = with pkgs; [
                intel-media-driver # LIBVA_DRIVER_NAME=iHD
                vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
                vaapiVdpau
                libvdpau-va-gl
                nvidia-vaapi-driver
                cudatoolkit
                cudatoolkit.lib
              ];
            };

            environment.systemPackages = [
              pkgs.glxinfo
              pkgs.libva-utils
              pkgs.nfs-utils
              pkgs.remmina
              pkgs.transmission-remote-gtk
              pkgs.cava
              # pkgs.raysession # patchbay
            ];

            environment.pathsToLink = [ "/share/zsh" ];

            programs.zsh.enable = true;

            # Load nvidia driver for Xorg and Wayland
            services.xserver.videoDrivers = [ "nvidia" ];

            services.pipewire = {
              enable = true;
              audio.enable = true;
              wireplumber.enable = true;
              alsa.enable = true;
              pulse.enable = true;
              jack.enable = true;
            };

            # For NFS
            boot.supportedFilesystems = [ "nfs" ];
            services.rpcbind.enable = true;

            hardware.nvidia = {
              modesetting.enable = true;
              powerManagement.enable = false;
              powerManagement.finegrained = false;
              open = true;
              nvidiaSettings = true;
              package = config.boot.kernelPackages.nvidiaPackages.stable;
            };
          })
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.test = { config, pkgs, ... }: {
                home.stateVersion = "23.05";
                imports = [
                  hyprland.homeManagerModules.default
                  nixvim.homeManagerModules.nixvim
                  ./modules/home
                ];
                services = {
                  plex-mpv-shim.enable = true;
                  swayidle.enable = true;
                  swayosd.enable = true;
                };
                programs = {
                  home-manager.enable = true;
                  firefox.enable = true;
                  # ls replacement (also see lsd)
                  eza = {
                    enable = true;
                    enableAliases = true;
                  };
                  translate-shell = {
                    enable = true;
                  };
                  yt-dlp = {
                    enable = true;
                  };
                  # zoxide - cd with smart jumps
                  # boxxy - sandboxing for badly behaving linus apps
                  direnv = {
                    enable = true;
                    enableZshIntegration = true;
                    nix-direnv.enable = true;
                  };
                  # document reader, recolor bg's to black
                  zathura = {
                    enable = true;
                    options = {
                      default-bg = "#000000";
                      default-fg = "#ffffff";
                    };
                  };
                  # maintained neofetch fork
                  hyfetch = {
                    enable = true;
                  };
                  # tldr command
                  tealdeer = {
                    enable = true;
                  };
                  # mcfly for ctrl-r replacement
                  # bat colorized cat replacement
                  # command completion, overrides zsh completion
                  carapace = {
                    enable = true;
                    enableZshIntegration = true;
                  };
                  btop = {
                    enable = true;
                    settings = {
                      color_theme = "tokyo-night";
                    };
                  };
                }; # End Programs
              }; # End Test user Home declaration
            }; # End Home Manager delcation
          } # End Home Manager module
        ]; # End modules
      }; # End test configuration
    }; # End NixOS configurations
    darwinConfigurations = {
      "Jamess-MBP" = nix-darwin.lib.darwinSystem {
        modules = [
          ({ config, pkgs, ... }: {
            # system.stateVersion = "23.05";
            nixpkgs.hostPlatform = "aarch64-darwin";
            nixpkgs.config.allowUnfree = true;

            services.nix-daemon.enable = true;

            system.defaults.dock.autohide = true;

            programs.zsh.enable = true;

            users.users.jamesdanylik = {
              name = "jamesdanylik";
              home = "/Users/jamesdanylik";
            };
          })
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.jamesdanylik = { config, pkgs, ... }: {
                home.stateVersion = "23.05";
                home.username = "jamesdanylik";
                home.homeDirectory = "/Users/jamesdanylik";
                imports = [
                  nixvim.homeManagerModules.nixvim
                  ./modules/home/neovim
		  ./modules/home/kitty
                ];

                programs = {
                  home-manager.enable = true;
                  zsh.enable = true;

                  direnv = {
                    enable = true;
                    enableZshIntegration = true;
                    nix-direnv.enable = true;
                  };
                };
              };
            };
          }
        ];
      };
    };
  }; # End outputs
}
