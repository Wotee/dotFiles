{ config, pkgs, ... }: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
      	ls="eza -la";
      };
      initContent = "
        # Nix profile to get paths right
        if [ -e \"$HOME/.nix-profile/etc/profile.d/nix.sh\" ]; then
          . \"$HOME/.nix-profile/etc/profile.d/nix.sh\"
        fi

        # Dotnet tools
        path+=('/home/wote/.dotnet/tools')

        # fnm
        export PATH=/home/$USER/.fnm:$PATH
        eval \"$(fnm env --use-on-cd)\"

        # Oh my posh
        eval \"$(oh-my-posh init zsh --config '/home/wote/wotpuccin.omp.json')\"

        # atuin
        eval \"$(atuin init zsh --disable-up-arrow)\"

";
    };
  };
}

