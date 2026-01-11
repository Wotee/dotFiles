{
  config,
  pkgs,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        ls = "eza -la";
        mux = "tmuxinator";
        asr = "atuin scripts run";
      };
      initContent = "
        # Nix profile to get paths right
        if [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then
          . \"$HOME/.nix-profile/etc/profile.d/nix.sh\"
        fi

        # Dotnet tools
        export PATH=$HOME/.dotnet/tools:$PATH

        # fnm
        export PATH=$HOME/.fnm:$PATH
        eval \"$(fnm env --use-on-cd)\"

        # atuin
        eval \"$(atuin init zsh --disable-up-arrow)\"

        # carapace
        export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
        zstyle ':completion:*' format $'\\e[2;37mCompleting %d\\e[m'
        source <(carapace _carapace)

        # direnv
        eval \"$(direnv hook zsh)\"

        # zoxide
        eval \"$(zoxide init zsh)\"

        # starship
        eval \"$(starship init zsh)\"
";
    };
  };
}
