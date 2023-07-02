{ config, pkgs, ... }:
{
  # for Lazyvim plugin
  home.packages = [
    pkgs.clang-tools_16
    pkgs.rtags
    pkgs.lazygit
  ];

  # neovim local config file
  home.file = {
    # 这将创建一个软链接 ~/.config/spacemacs -> /etc/nixos/home-manager/develop/spacemacs.conf
    ".spacemacs".source = "/etc/nixos/home-manager/develop/spacemacs.conf";
  };
 
  programs.emacs.enable = true;
  services.emacs.enable = true;

}
