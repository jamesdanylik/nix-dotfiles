{
  description = "Nix configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, home-manager, nixvim, hyprland, ... }: {
    nixosConfigurations = {
      testnixos = nixpkgs.lib.nixosSystem
        {
          modules = [
            ({ config, pkgs, ... }: {
              system.stateVersion = "23.05";
              imports = [
                nixos-generators.nixosModules.all-formats
              ];
              nixpkgs.hostPlatform = "x86_64-linux";
              users = {
                users.test = {
                  isNormalUser = true;
                  initialPassword = "test";
                  group = "testgroup";
                  extraGroups = [ "wheel" ];
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
              };

              environment.systemPackages = [ pkgs.glxinfo ];

              formatConfigs.vm-nvidia = { config, modulesPath, ... }: {
                imports = [
                  "${toString modulesPath}/virtualisation/qemu-vm.nix"
                ];
                formatAttr = "vm";

                virtualisation.memorySize = 8192;
                virtualisation.cores = 8;
                virtualisation.qemu.options = [
                  "-device virtio-vga-gl"
                  "-display sdl,gl=on,show-cursor=off"
                  #"-vga none"
                  #"-device virtio-gpu-pci"
                ];
              };

              formatConfigs.vm-custom = { config, modulesPath, ... }: {
                imports = [
                  ./modules/custom-vm.nix
                ];
                formatAttr = "vm";

                virtualisation.memorySize = 8192;
                virtualisation.cores = 8;
                virtualisation.qemu.guestAgent.enable = true;
              };

              services.qemuGuest.enable = true;

              # Load nvidia driver for Xorg and Wayland
              services.xserver.videoDrivers = [ "nvidia" ];
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
                  ];
                  programs = {
                    home-manager.enable = true;
                    firefox.enable = true;
                    # Nvim Config
                    nixvim = {
                      enable = true;
                      globals = {
                        mapleader = " ";
                      };
                      options = {
                        relativenumber = true;
                        nu = true;
                      };
                      extraPackages = [ pkgs.ripgrep ];
                      extraConfigLua = ''
                        autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                      '';
                      colorschemes.tokyonight.enable = true;
                      plugins = {
                        undotree.enable = true;
                        treesitter.enable = true;
                        telescope = {
                          enable = true;
                          keymaps = {
                            "<leader>pf" = "find_files";
                            "<leader>ps" = "live_grep";
                          };
                        };
                        comment-nvim.enable = true;
                        nvim-cmp = {
                          enable = true;
                          mapping = {
                            "<CR>" = "cmp.mapping.confirm({ select = true })";
                          };
                          sources = [
                            { name = "nvim_lsp"; }
                          ];
                        };
                        lsp = {
                          enable = true;
                          servers = {
                            pylsp = {
                              enable = true;
                              settings = {
                                plugins = {
                                  autopep8.enabled = true;
                                  mccabe.enabled = true;
                                  pycodestyle.enabled = true;
                                  pyflakes.enabled = true;
                                  black.enabled = true;
                                  rope.enabled = true;
                                };
                              };
                            };
                            nil_ls = {
                              enable = true;
                            };
                            lua-ls = {
                              enable = true;
                            };
                            tsserver = {
                              enable = true;
                            };
                            eslint = {
                              enable = true;
                            };
                            vuels = {
                              enable = true;
                            };
                          };
                        }; # End Lsp
                      }; # End Nvim Plugins
                    }; # End NixVim
                    kitty = {
                      enable = true;
                      font.name = "NotoMono NF";
                      extraConfig = (builtins.readFile ./tokyo-night.conf);
                    };
                    # foot = {
                    #   enable = true;
                    #   settings = {
                    #     main = {
                    #       font = "NotoMono NF";
                    #     };
                    #   };
                    # };
                  }; # End Programs
                  wayland.windowManager.hyprland = {
                    enable = true;
                    enableNvidiaPatches = true;
                    extraConfig = ''
                      $mod = SUPER_SHIFT
                      bind = $mod, Q, exec, kitty
                    '';
                  }; # End Hyprland
                }; # End Test user Home declaration
              }; # End Home Manager delcation
            } # End Home Manager module
          ]; # End modules
        }; # End test configuration
    }; # End NixOS configurations
  }; # End outputs
}
