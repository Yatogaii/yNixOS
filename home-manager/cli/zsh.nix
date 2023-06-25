{ config, pkgs, ... }:
{
  home.packages = [pkgs.zsh pkgs.starship];

  programs.zsh.enable = true;

  # like .zshrc
  programs.zsh.initExtra = ''
    alias ls='ls --color=auto'
    alias ll='ls -l'
  '';

  # useful configs
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.autocd = true; 
  programs.zsh.enableSyntaxHighlighting = true;
  programs.zsh.enableCompletion = true;

  # starship configs
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      prompt_order = [ "package" "character" ];
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}

