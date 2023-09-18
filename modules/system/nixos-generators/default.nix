{ config, modulesPath, ... }: {
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
      ./vm-host.nix
    ];
    formatAttr = "vm";

    virtualisation.memorySize = 8192;
    virtualisation.cores = 8;
    virtualisation.qemu.guestAgent.enable = true;
  };

  services.qemuGuest.enable = true;
}
