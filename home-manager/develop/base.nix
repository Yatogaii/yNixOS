{ config, pkgs, ... }:
{
  # for Lazyvim plugin
  home.packages = [
    # for c/c++
    pkgs.gnumake
    pkgs.cmake
    pkgs.ninja
    pkgs.gnat13
    pkgs.gdb
    pkgs.gdbgui
  ];

}
