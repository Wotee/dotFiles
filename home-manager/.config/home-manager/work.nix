{
  config,
  pkgs,
  lib,
  ...
}: let
  combinedDotnet = with pkgs.dotnetCorePackages;
    combinePackages [
      # Still needed in NCP unfortunately
      sdk_6_0
      sdk_8_0
      sdk_9_0
      runtime_8_0
    ];
in {
  home.username = "wote";
  home.homeDirectory = "/home/wote";

  home.stateVersion = "24.11";

  home.packages = [
    pkgs.git
    pkgs.neovim
    pkgs.zsh
    pkgs.unzip # Unzip for Mason LSPs and stuff
    pkgs.gccgo # C compiler for nvim treesitter
    pkgs.fnm # Fast node manager to install nodejs and npm for neovim plugins
    pkgs.tmux
    pkgs.tmuxinator
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
    pkgs.oh-my-posh
    pkgs.zip
    pkgs.direnv
    pkgs.bruno
    pkgs.bitwarden-cli
    pkgs.atuin # Better history
  ];

  # Still needed in NCP unfortunately
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_ROOT = "${combinedDotnet}/share/dotnet";
    MANPAGER = "nvim +Man!";
  };

  # Set zsh as default shell on activation
  home.activation = {
    nodeInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    '';
    # For some reason this did not work when installed as nix pkg, so use the script way
    credProviderInstall = lib.hm.dag.entryAfter ["nodeInstall"] ''
      # wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
      echo "Skipping"
    '';
    bicepLangServerFuckery = lib.hm.dag.entryAfter ["credProviderInstall"] ''
      mkdir -p $HOME/bicep
      ln -s -f ${pkgs.bicep}/lib/bicep/Bicep.LangServer.dll $HOME/bicep/Bicep.LangServer.dll
    '';
    fsAutoComplete = lib.hm.dag.entryAfter ["bicepLangServerFuckery"] ''
      ${combinedDotnet}/share/dotnet/dotnet tool update -g fsautocomplete
    '';
  };

  programs.home-manager.enable = true;
}
