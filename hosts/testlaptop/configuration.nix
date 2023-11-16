{ pkgs, config, ... }: {
  # can also require lib, modulesPath
  system.stateVersion = "23.05";
  imports = [
    ../../modules/system
    ./hardware-configuration.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.automatic-timezoned.enable = true;

  networking = {
    networkmanager.enable = true;
    # wireless = {
    #   enable = true;
    #   userControlled.enable = true;
    # };
    hostId = "41fe9545";
  };

  boot = {
    supportedFilesystems = [ "zfs" "nfs" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      generationsDir.copyKernels = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        #efiInstallAsRemovable = true;
        copyKernels = true;
        efiSupport = true;
        zfsSupport = true;
      };
    };
  };

  users = {
    users.test = {
      isNormalUser = true;
      initialPassword = "test";
      group = "testgroup";
      extraGroups = [ "wheel" "networkmanager" ];
      shell = pkgs.zsh;
    };
    groups.testgroup = { };
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
      twemoji-color-font # for monochrome emjoi fallbacks
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
      # cudatoolkit
      # cudatoolkit.lib
    ];
  };

  environment.systemPackages = with pkgs; [
    glxinfo
    libva-utils
    nfs-utils
    remmina
    transmission-remote-gtk
    cava
    # pkgs.raysession # patchbay
    hyprpicker
    weston
    lshw
    brightnessctl
  ];

  programs.hyprland.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  programs.zsh.enable = true;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # For NFS
  services.rpcbind.enable = true;

  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      settings = {
        General = {
          DisplayServer = "wayland";
          InputMethod = "";
        };
        Wayland.CompositorCommand = "${pkgs.weston}/bin/weston --shell=fullscreen-shell.so";
      };
    };
  };

  # powersaving 
  services.tlp.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
