{
  config,
  pkgs,
  ...
}: {
  programs = {
    tmux = {
      enable = true;
      baseIndex = 1;

      plugins = [
        pkgs.tmuxPlugins.catppuccin
      ];

      extraConfig = ''
        # Fix Colors
        set-option default-terminal "tmux-256color"
        set-option -a terminal-overrides ",*256col*:RGB"

        set -g mouse on

        # Fix nvim insert-mode cursor
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

        # Renumber windows
        set-option -g renumber-windows on

        # Statusline location
        set -g status-position top

        # Possibility to set titles
        set -g set-titles on
        set -g set-titles-string "#W"

        # Try to get the window renaming off
        set-window-option -g automatic-rename off


        set -g @catppuccin_flavour 'mocha'
        set -g @catppuccin_window_status_style "rounded"

        # Make the status line pretty and add some modules
        set -g status-right-length 100
        set -g status-left-length 100
        set -g status-left ""
        set -g status-right "#{E:@catppuccin_status_application}"
      '';

      
    };
  };
}
