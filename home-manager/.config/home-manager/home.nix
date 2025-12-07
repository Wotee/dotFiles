{
  config,
  pkgs,
  lib,
  ...
}: let
  latex = with pkgs; (texlive.combine {
    inherit
      (texlive)
      scheme-small
      latexmk
      xetex
      luatex
      amsmath
      mathtools
      geometry
      babel
      fontspec
      unicode-math
      ;
  });
in {
  home.username = "wote";
  home.homeDirectory = "/home/wote";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.git
    pkgs.tmux
    pkgs.neovim
    pkgs.dotnetCorePackages.sdk_10_0
    pkgs.bruno
    pkgs.xdg-utils # Needed for Totals repos visualisation
    pkgs.fnm # Fast node manager to install nodejs and npm for neovim plugins
    pkgs.stow
    pkgs.jq
    pkgs.eza
    pkgs.lazygit
    pkgs.fzf
    pkgs.delta
    pkgs.zsh
    pkgs.unzip # Unzip for Mason LSPs and stuff
    pkgs.gccgo # C compiler for nvim treesitter
    pkgs.bitwarden-cli
    pkgs.atuin # Better history
    pkgs.cargo # For alejandra (nix formatter)
    pkgs.gh
    pkgs.carapace # Multishell completion library
    pkgs.ripgrep
    pkgs.direnv
    pkgs.zoxide
    pkgs.zathura # Nix viewengine
    latex
    pkgs.podman
    pkgs.docker-client # Docker CLI, without Docker daemon
    pkgs.docker-compose # Standalone docker compose v1
    pkgs.podman-compose # Native podman-compose
    pkgs.lazydocker
    pkgs.obsidian
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_10_0}/share/dotnet";
    MANPAGER = "nvim +Man!";
  };

  home.activation = {
    nodeInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    '';
    fsAutoComplete = lib.hm.dag.entryAfter ["nodeInstall"] ''
      ${pkgs.dotnetCorePackages.sdk_10_0}/share/dotnet/dotnet tool update -g fsautocomplete
    '';
  };
  programs.home-manager.enable = true;
}
