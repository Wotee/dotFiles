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
### Prerequisites
```pwsh
wsl --install -d Ubuntu-24.04
```
```bash
sudo apt update
sudo apt full-upgrade -y
```

### Steps
1. Install nix-stuff
```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```
2. Install dotfiles
```bash
nix shell nixpkgs#home-manager nixpkgs#gh nixpkgs#stow \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--command sh -c "\
cd ~ && mkdir git && cd git && gh auth login && gh repo clone Wotee/dotFiles && cd dotFiles && stow -t ~ */ && home-manager switch"
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
