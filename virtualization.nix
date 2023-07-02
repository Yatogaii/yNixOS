{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  users.extraGroups.libvirtd.members = [ "ykh" ];
  users.extraGroups.kvm.members = [ "ykh" ];
  users.extraUsers.ykh.extraGroups = ["libvirtd" "kvm"];

  nixpkgs.overlays = with pkgs; [
    (self: super: {
      qemu_full = super.qemu_full.overrideAttrs (oldAttrs: {
        postPatch = oldAttrs.postPatch + ''
          sed -i 's/GUI_REFRESH_INTERVAL_DEFAULT 30/GUI_REFRESH_INTERVAL_DEFAULT 16/g' include/ui/console.h
        '';
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    virtmanager 
    virt-viewer
    spice
    spice-gtk
    win-spice
  ];

  virtualisation.vmware.host.enable = true;
}
