{ ... }: {
  disko.devices = {
    disk.x = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "100M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = { };
        datasets = {
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = "zfs snapshot zroot/local/root@blank";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
          };
        };
      };
    };
  };
}
