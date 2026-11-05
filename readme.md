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

#### For podman setup
```bash
sudo apt install uidmap
```

Docker Engine runs directly inside WSL and requires systemd. Ensure
`/etc/wsl.conf` contains:

```ini
[boot]
systemd=true
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
cd ~ && mkdir git && cd git && gh auth login && gh repo clone Wotee/dotFiles && cd dotFiles && rm ../../.gitconfig -f && stow -t ~ */ && home-manager switch"
```
3. Install Docker Engine inside WSL
```bash
./install-docker-wsl.sh
```

The script installs Docker Engine, Compose, and Buildx from Docker's official
Ubuntu repository. It also enables the Docker and containerd systemd services
and adds the current user to the `docker` group.

4. Set zsh as default shell
```bash
echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells >/dev/null
chsh -s $HOME/.nix-profile/bin/zsh
```
5. Close all WSL terminals and run this from PowerShell:
```pwsh
wsl --shutdown
```
6. Reopen WSL and verify Docker
```bash
docker run --rm hello-world
docker compose version
docker buildx version
```
7. Run home-manager again to ensure node installation works correctly
```bash
nix run home-manager switch
```
8. Make sure correct git installation is used
```bash
which git
// Should return something like /home/wote/.nix-profile/bin/git
// and not /usr/bin/git
// If it returns /usr/bin/git, run:
sudo rm /usr/bin/git
```
