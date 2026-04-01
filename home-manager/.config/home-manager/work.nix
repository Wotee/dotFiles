{
  config,
  pkgs,
  adoboards,
  opencode,
  lib,
  ...
}: let
  opencodePkg = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace packages/script/src/index.ts \
        --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                       'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    '';
  });

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
    pkgs.gcc # C compiler for nvim treesitter
    pkgs.fnm # Fast node manager to install nodejs and npm for neovim plugins
    pkgs.jq
    pkgs.curl
    pkgs.stow
    (pkgs.azure-cli.withExtensions [
      pkgs.azure-cli-extensions.azure-devops
    ])
    pkgs.eza
    pkgs.fzf
    pkgs.lazygit
    pkgs.delta # Syntax-highlightning pager for git
    combinedDotnet
    pkgs.dotnet-outdated
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
    opencodePkg
    pkgs.starship
    pkgs.difftastic
    pkgs.nodejs_22
    pkgs.snyk
    pkgs.cloc
    pkgs.rtk
    pkgs.uv
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
    # Define a custom layout for git auto-syncing
layout_git_sync() {
  # 1. Only run if we are in the root of the git repo
  if [ "$PWD" != "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
    return
  fi

  # 2. Get the current branch
  local branch=$(git branch --show-current)
  
  # 3. Only act on master or main
  if [[ "$branch" == "master" || "$branch" == "main" ]]; then
    
    # Perform a quiet fetch to check for updates
    # This doesn't move your files, it just updates the remote tracking
    git fetch --quiet origin "$branch"
    
    local local_hash=$(git rev-parse HEAD)
    local remote_hash=$(git rev-parse @{u} 2>/dev/null)

    # 4. Compare and Pull if necessary
    if [ "$local_hash" != "$remote_hash" ] && [ -n "$remote_hash" ]; then
      echo "🚀 direnv: Local $branch is behind. Pulling updates..."
      git pull --rebase --autostash
    else
      echo "✅ direnv: $branch is up to date."
    fi
  fi
}
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTNET_ROOT = "${combinedDotnet}/share/dotnet";
    MANPAGER = "nvim +Man!";
    SNYK_API = "https://app.eu.snyk.io/api";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    RTK_TELEMETRY_DISABLED = 1;
  };

  home.activation = {
    # nodeInstall = lib.hm.dag.entryAfter ["installPackages"] ''
    #   ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    # '';
    # For some reason this did not work when installed as nix pkg, so use the script way
    credProviderInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"
      export ARTIFACTS_CREDENTIAL_PROVIDER_NON_SC=true
      sh -c "$("${pkgs.curl}/bin/curl" -fsSL https://aka.ms/install-artifacts-credprovider.sh)"
      # echo "Skipping"
    '';
    fsAutoComplete = lib.hm.dag.entryAfter ["credProviderInstall"] ''
      ${combinedDotnet}/share/dotnet/dotnet tool update -g fsautocomplete
    '';
  };

  programs.home-manager.enable = true;
}
