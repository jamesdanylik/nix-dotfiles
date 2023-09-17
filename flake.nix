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

              environment.systemPackages = [ pkgs.glxinfo pkgs.libva-utils pkgs.nfs-utils ];
              environment.pathsToLink = [ "/share/zsh" ];
              programs.zsh.enable = true;

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
                  ];
                  services = {
                    plex-mpv-shim.enable = true;
                    swayidle.enable = true;
                    swayosd.enable = true;
                  };
                  programs = {
                    home-manager.enable = true;
                    firefox.enable = true;
                    wofi = {
                      enable = true;
                    };
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
                    waybar = {
                      enable = true;
                      systemd.enable = true;
                      settings = {
                        mainBar = {
                          layer = "top";
                          modules-left = [ "wlr/workspaces" "tray" "idle_inhibitor" ];
                          modules-right = [ "cpu" "temperature" "memory" "clock" ];

                          clock = {
                            timezone = "America/Los_Angeles";
                          };

                          tray = {
                            icon-size = 15;
                            spacing = 15;
                          };
                        };
                      };
                    };
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
                        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
                      '';
                      colorschemes.tokyonight = {
                        enable = true;
                        style = "night";
                      };
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
                            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
                            "<C-f>" = "cmp.mapping.scroll_docs(4)";
                            "<C-Space>" = "cmp.mapping.complete()";
                            "<C-e>" = "cmp.mapping.abort()";
                            "<Tab>" = "cmp.mapping.confirm({ select = true })";
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
                      extraConfig = (builtins.readFile ./tokyonight_night.conf);
                      shellIntegration.enableZshIntegration = true;
                    };
                    zsh = {
                      enable = true;
                      enableVteIntegration = true;
                      plugins = [
                        {
                          name = "powerlevel10k";
                          src = pkgs.zsh-powerlevel10k;
                          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
                        }
                        {
                          name = "fast-syntax-highlighting";
                          src = pkgs.zsh-fast-syntax-highlighting;
                          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
                        }
                        {
                          name = "powerlevel10k-config";
                          src = ./p10k-config;
                          file = "p10k.zsh";
                        }
                      ];
                    };
                  }; # End Programs
                  wayland.windowManager.hyprland = {
                    enable = true;
                    enableNvidiaPatches = true;
                    extraConfig = ''
                      general {
                          border_size = 1
                          col.active_border = rgba(000000ff)
                          col.inactive_border = rgba(000000ff)
                          layout = dwindle
                      }

                      dwindle {
                          pseudotile = true
                          preserve_split = true
                          no_gaps_when_only = true
                          force_split = 0
                      }

                      master {
                          new_is_master = true
                      }

                      decoration {
                          rounding = 8
                      }

                      $mod = SUPER_SHIFT
                      bind = $mod, Q, exec, kitty
                      bind = $mod, R, exec, wofi --show drun

                      bind = $mod, C, killactive
                      bind = $mod, M, exit
                      bind = $mod, V, togglefloating
                      bind = $mod, F, fakefullscreen
                      bind = $mod, J, togglesplit
                      bind = $mod, F, fakefullscreen

                      bindm = $mod, mouse:272, movewindow
                      bindm = $mod, mouse:273, resizewindow

                      ${builtins.concatStringsSep "\n" (builtins.map (
                        key: let
                          letter = builtins.substring 0 1 key;
                        in ''
                          bind = $mod, ${key}, movefocus, ${letter}
                          binde = $mod SHIFT, ${key}, movewindow, ${letter}
                        '') ["left" "right" "up" "down"] )}

                      ${builtins.concatStringsSep "\n" (builtins.genList (
                        x: let 
                          ws = toString (x+1);
                          key = let 
                            c = (x + 1) / 10;
                          in
                            builtins.toString (x + 1 - (c*10));
                        in ''
                          bind = $mod, ${key}, workspace, ${ws}
                          binde = $mod SHIFT, ${key}, movetoworkspace, ${ws}
                        ''
                        ) 10)}
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
