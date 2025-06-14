# Dotfiles

Use `stow` to manage dotfiles.

For example, to install the `nvim` configuration, run:

```sh
stow nvim -t ~
```

If you want to install everything, run
```sh
stow -t ~ */
```

## Install everything to a new machine

1. Clone dotfiles repo
2. Install nix-stuff
```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```
3. install stow 
```bash
sudo apt-get stow
```
4. Stow the dotfiles
```
stow -t ~ */
```
4. Run home manager
```
nix run home-manager switch
```
5. Set zsh as default shell
```bash
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells >/dev/null
chsh -s $HOME/.nix-profile/bin/zsh
```
