{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    theme="Dracula";
    font = {
      size = 14.5;
      name = "FiraCode Nerd Font";
    };
    extraConfig = "confirm_os_window_close 0\n";
    keybindings = {
      "ctrl+c" = "copy_and_clear_or_interrupt";
      "ctrl+v" = "paste_from_clipboard";
    };
  };
 
}

