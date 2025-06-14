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
1. Install nix and ensure environment variables are set
```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon \
&& . $HOME/.nix-profile/etc/profile.d/nix.sh
```
2. Get dotfiles, install everything
```bash
nix shell nixpkgs#home-manager nixpkgs#gh nixpkgs#stow \
--extra-experimental-features nix-command \
--extra-experimental-features flakes \
--command sh -c "\
cd ~ && mkdir git && cd git && gh auth login && gh repo clone Wotee/dotFiles && cd dotFiles && stow -t ~ */ && home-manager switch"
```
3. Set zsh as default shell
```bash
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells >/dev/null
chsh -s $HOME/.nix-profile/bin/zsh
```
4. Reopen the WSL
5. Run home-manager again to ensure node installation works correctly
```bash
nix run home-manager switch
```
