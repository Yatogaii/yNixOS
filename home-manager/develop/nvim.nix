{ config, pkgs, ... }:
{
  # for Lazyvim plugin
  home.packages = [
    pkgs.fd 
    pkgs.ripgrep
    pkgs.lazygit
  ];

  # neovim local config file
  home.file = {
    # 这将创建一个软链接 ~/.config/nvim -> /etc/nixos/home-manager/neovim
    ".config/nvim".source = "/etc/nixos/home-manager/develop/neovim";
  };
}

