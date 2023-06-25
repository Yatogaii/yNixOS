{ config, pkgs, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    inherit pkgs;
  };
in
{
  nix.settings.substituters = [ "https://xddxdd.cachix.org" ];
  nix.settings.trusted-public-keys = [ "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8=" ];

  environment.systemPackages = with pkgs; [
    nur.repos.xddxdd.wechat-uos
   # nur.repos.xddxdd.wine-wechat
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
    "electron-19.0.7"
  ];
}
