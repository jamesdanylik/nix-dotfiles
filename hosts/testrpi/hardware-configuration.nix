{ pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];
  sdImage.compressImage = false;
  nixpkgs.hostPlatform = "aarch64-linux";
  networking = {
    useDHCP = true;
    hostName = "testrpi";
    wireless.enable = true;
  };
  hardware.bluetooth.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.opengl = {
    enable = true;
    setLdLibraryPath = true;
    package = pkgs.mesa_drivers;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
}
