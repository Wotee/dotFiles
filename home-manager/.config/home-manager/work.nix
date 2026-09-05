{
  config,
  pkgs,
  adoboards,
  opencode,
  treeSitter,
  lib,
  ...
}: let
  opencodePkg = opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
  azureSkillsSrc = pkgs.fetchFromGitHub {
    owner = "microsoft";
    repo = "azure-skills";
    rev = "v1.2.40";
    hash = "sha256-1wFp3NUT58wE8DTzDVx5ty844S94ea45VUppgCoQXlw=";
  };
  azureSkillsApmManifest = pkgs.writeText "azure-skills-apm.yml" ''
    name: work-global
    version: 1.0.0
    targets:
      - opencode
    dependencies:
      apm:
        - microsoft/azure-skills#v1.2.40
  '';

  combinedDotnet = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_9_0
      sdk_10_0
      runtime_8_0
    ];

  treeSitterCli = treeSitter.packages.${pkgs.stdenv.hostPlatform.system}.cli;
  databricksCli = pkgs.databricks-cli.overrideAttrs (_: {
    doCheck = false;
  });
in {

  nixpkgs.config.allowUnfree = true;

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
    pkgs.cacert
    pkgs.stow
    (pkgs.azure-cli.withExtensions [
      pkgs.azure-cli-extensions.azure-devops
      pkgs.azure-cli-extensions.application-insights
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
    treeSitterCli
    databricksCli
    pkgs.xdg-utils # Needed for Totals repos visualisation
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
    BROWSER = "wslview";
    SNYK_API = "https://app.eu.snyk.io/api";
    OPENCODE_EXPERIMENTAL_LSP_TOOL = "true";
    RTK_TELEMETRY_DISABLED = 1;
  };

  home.file.".local/share/opencode-azure-skills".source = "${azureSkillsSrc}/skills";

  home.activation = {
    # nodeInstall = lib.hm.dag.entryAfter ["installPackages"] ''
    #   ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    # '';
    # For some reason this did not work when installed as nix pkg, so use the script way.
    # Avoid re-downloading it on every switch once the plugin is already present.
    credProviderInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      credProviderDir="$HOME/.nuget/plugins/netcore/CredentialProvider.Microsoft"

      if [ -e "$credProviderDir/CredentialProvider.Microsoft.dll" ]; then
        verboseEcho "Azure Artifacts credential provider already installed."
      elif [[ -v DRY_RUN ]]; then
        verboseEcho "Would install Azure Artifacts credential provider."
      else
        export PATH="${pkgs.curl}/bin:${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"
        export ARTIFACTS_CREDENTIAL_PROVIDER_NON_SC=true
        sh -c "$("${pkgs.curl}/bin/curl" -fsSL https://aka.ms/install-artifacts-credprovider.sh)"
      fi
    '';
    fsAutoComplete = lib.hm.dag.entryAfter ["credProviderInstall"] ''
      ${combinedDotnet}/share/dotnet/dotnet tool update -g fsautocomplete
    '';
    azureSkillsCleanup = lib.hm.dag.entryAfter ["fsAutoComplete" "linkGeneration"] ''
      if [ -e "$HOME/.kiro/settings/mcp.json" ]; then
        if [[ -v DRY_RUN ]]; then
          verboseEcho "Would remove Azure MCP from $HOME/.kiro/settings/mcp.json"
        else
          tmp_mcp_json="$(mktemp)"
          ${pkgs.jq}/bin/jq 'del(.mcpServers.azure)' "$HOME/.kiro/settings/mcp.json" > "$tmp_mcp_json"

          if ${pkgs.jq}/bin/jq -e '.mcpServers == {} or .mcpServers == null' "$tmp_mcp_json" > /dev/null; then
            rm "$tmp_mcp_json"
            run rm $VERBOSE_ARG "$HOME/.kiro/settings/mcp.json"
          else
            run mv $VERBOSE_ARG "$tmp_mcp_json" "$HOME/.kiro/settings/mcp.json"
          fi
        fi
      fi

      if [ -d "$HOME/.kiro/settings" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.kiro/settings"
      fi

      if [ -d "$HOME/.kiro" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.kiro"
      fi

      if [ -d "$HOME/.agents/skills" ]; then
        for skill_path in ${azureSkillsSrc}/skills/*; do
          skill_name="''${skill_path##*/}"
          if [ -e "$HOME/.agents/skills/$skill_name" ]; then
            run rm -rf $VERBOSE_ARG "$HOME/.agents/skills/$skill_name"
          fi
        done

        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.agents/skills"
      fi

      if [ -d "$HOME/.agents" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.agents"
      fi

      if [ -e "$HOME/.apm/apm.yml" ] && ${pkgs.diffutils}/bin/cmp -s "$HOME/.apm/apm.yml" ${azureSkillsApmManifest}; then
        run rm $VERBOSE_ARG "$HOME/.apm/apm.yml"
      fi

      if [ -e "$HOME/.apm/apm_modules/microsoft/azure-skills" ]; then
        run rm -rf $VERBOSE_ARG "$HOME/.apm/apm_modules/microsoft/azure-skills"
      fi

      if [ -d "$HOME/.apm/apm_modules/microsoft" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.apm/apm_modules/microsoft"
      fi

      if [ -d "$HOME/.apm/apm_modules" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.apm/apm_modules"
      fi

      if [ -e "$HOME/.apm/apm.lock.yaml" ] && [ ! -d "$HOME/.apm/apm_modules" ] && ${pkgs.gnugrep}/bin/grep -q 'repo_url: microsoft/azure-skills' "$HOME/.apm/apm.lock.yaml"; then
        run rm $VERBOSE_ARG "$HOME/.apm/apm.lock.yaml"
      fi

      if [ -d "$HOME/.apm" ]; then
        run rmdir $VERBOSE_ARG --ignore-fail-on-non-empty "$HOME/.apm"
      fi
    '';
  };

  programs.home-manager.enable = true;
}
