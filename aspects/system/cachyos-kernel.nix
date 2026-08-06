{ config, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  boot.kernelParams = [
    "mitigations=off"
    "amd_pstate=active"
    "amdgpu.ppfeaturemask=0xffffffff"
    "transparent_hugepage=madvise"
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "vm.swappiness" = 10;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
    "net.core.default_qdisc" = "fq_codel";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "ntsync" ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
