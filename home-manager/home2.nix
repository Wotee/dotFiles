{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "wote";
  home.homeDirectory = "/home/wote";
  home.stateVersion = "24.11";

  home.packages = [
    pkgs.git
    pkgs.neovim
    pkgs.dotnetCorePackages.sdk_9_0
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
    pkgs.oh-my-posh
    pkgs.bitwarden-cli
    pkgs.atuin # Better history
    pkgs.cargo # For alejandra (nix formatter)
  ];

  home.sessionVariables = {
    GTK_THEME = "Adwaita:dark";
    EDITOR = "nvim";
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_9_0}/share/dotnet";
  };

  # Set zsh as default shell on activation
  home.activation = {
    make-zsh-default-shell = lib.hm.dag.entryAfter ["installPackages"] ''
           # if zsh is not the current shell
           PATH="/usr/bin:/bin:$PATH"
           ZSH_PATH="/home/wote/.nix-profile/bin/zsh"
           if [[ $(getent passwd wote) != *"$ZSH_PATH" ]]; then
             echo "ZSH PATH: $ZSH_PATH"
             if grep $ZSH_PATH /etc/shells; then
               echo "The thing is there already"
             else
               echo "Adding zsh to /etc/shells. password might be necessary."
               run echo "$ZSH_PATH" | sudo tee -a /etc/shells
             fi
             echo "setting zsh as default shell (using chsh). password might be necessary."
             if grep $ZSH_PATH /etc/shells; then
               echo "adding zsh to /etc/shells"
             fi
             echo "running chsh to make zsh the default shell"
             run chsh -s $ZSH_PATH wote
             echo "zsh is now set as default shell !"
      echo "Launching zsh"
      echo "##########################################"
      echo "# Rest of the nix setup not run!         #"
      echo "# Restart your shell and run             #"
      echo "# \`nix run home-manager switch\` again!   #"
      echo "##########################################"
      $ZSH_PATH
           fi
    '';
    nodeInstall = lib.hm.dag.entryAfter ["make-zsh-default-shell"] ''
      ${pkgs.fnm}/bin/fnm use --install-if-missing 22
    '';
  };
  programs.home-manager.enable = true;
}
