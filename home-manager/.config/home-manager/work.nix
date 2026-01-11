{
  config,
  pkgs,
  adoboards,
  opencode,
  lib,
  ...
}: let
  combinedDotnet = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
      runtime_8_0
    ];
in {

  home.stateVersion = "24.11";

  home.packages = [
    pkgs.git
    pkgs.neovim
    pkgs.zsh
    pkgs.unzip # Unzip for Mason LSPs and stuff
    pkgs.gccgo # C compiler for nvim treesitter
    pkgs.fnm # Fast node manager to install nodejs and npm for neovim plugins
    pkgs.jq
    pkgs.stow
    pkgs.azure-cli
    pkgs.eza
    pkgs.fzf
    pkgs.lazygit
    pkgs.delta # Syntax-highlightning pager for git
    combinedDotnet
    pkgs.azure-functions-core-tools
    pkgs.bicep
    pkgs.zip
    pkgs.bruno
    pkgs.bitwarden-cli
    pkgs.atuin # Better history
    pkgs.sqlcmd # Enable dadbod
    pkgs.cargo
    pkgs.gh
    pkgs.carapace # Multishell completion library
    pkgs.jujutsu
    pkgs.asciinema
    pkgs.ripgrep
    pkgs.wslu
    pkgs.zoxide
    pkgs.obsidian
    pkgs.netcoredbg
    adoboards.packages.${pkgs.stdenv.hostPlatform.system}.default
    opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.starship
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_ROOT = "${combinedDotnet}/share/dotnet";
    MANPAGER = "nvim +Man!";
  };

  home.activation = {
    nodeInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    '';
    # For some reason this did not work when installed as nix pkg, so use the script way
    credProviderInstall = lib.hm.dag.entryAfter ["nodeInstall"] ''
      sh -c "$(curl -fsSL https://aka.ms/install-artifacts-credprovider.sh)"
      # echo "Skipping"
    '';
    fsAutoComplete = lib.hm.dag.entryAfter ["credProviderInstall"] ''
      ${combinedDotnet}/share/dotnet/dotnet tool update -g fsautocomplete
    '';
  };

  programs.home-manager.enable = true;
}
