let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  imports = [
    aagl-gtk-on-nix.module
  ];

  programs.anime-game-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
}
