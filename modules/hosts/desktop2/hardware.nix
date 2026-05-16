{ self, inputs, ... }:
{
  flake.nixosModules.desktop2Hardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];
      boot.kernelParams = [ "nvidia-drm.modeset=1" ];
      boot.blacklistedKernelModules = [ "nouveau" ];

      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.graphics.enable32Bit = true;

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        STEAM_WAYLAND = "1";
      };

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/e3cb50c4-2d6d-472f-a2ab-a620f428b39d";
        fsType = "ext4";
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/35cb6767-cb37-44a6-bac3-5ab0b5e8f847"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
