{
  config,
  pkgs,
  ...
}: {
  programs = {
    zsh = {
      enable = true;
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

        tmu() {
          local session_name=\"$1\"
          if [ -z \"$session_name\" ]; then
            echo \"Usage: tmu <session-name>\"
            return 1
          fi

          if tmux has-session -t \"session_name\" 2>/dev/null; then
            echo \"Attaching to existing tmux session: $session_name\"
            tmux attach-session -t \"$session_name\"
          else
            echo \"Starting new tmuxifier session: $session_name\"
            tmuxinator \"$session_name\"
          fi
        }

        # Dotnet tools
        path+=('/home/wote/.dotnet/tools')

        # fnm
        export PATH=/home/$USER/.fnm:$PATH
        eval \"$(fnm env --use-on-cd)\"

        # Oh my posh
        eval \"$(oh-my-posh init zsh --config '/home/wote/wotpuccin.omp.json')\"

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
";
    };
  };
}
