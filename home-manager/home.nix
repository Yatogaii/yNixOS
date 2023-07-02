{ pkgs, ... }: {

  imports = [
    ./cli/zsh.nix
    ./cli/kitty.nix
    ./develop/nvim.nix
    ./develop/emacs.nix
    ./develop/base.nix
  ];
}
