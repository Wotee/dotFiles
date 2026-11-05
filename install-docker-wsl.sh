#!/usr/bin/env bash
set -euo pipefail

if [[ ${EUID} -eq 0 ]]; then
  echo "Run this script as your normal user; it invokes sudo when needed." >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot identify this Linux distribution: /etc/os-release is missing." >&2
  exit 1
fi

# shellcheck source=/dev/null
. /etc/os-release

if [[ ${ID:-} != "ubuntu" ]]; then
  echo "This installer supports Ubuntu only (detected: ${ID:-unknown})." >&2
  exit 1
fi

if ! grep -qi microsoft /proc/sys/kernel/osrelease; then
  echo "This installer is intended for Ubuntu running under WSL 2." >&2
  exit 1
fi

if [[ "$(ps -p 1 -o comm=)" != "systemd" ]]; then
  echo "Docker requires systemd in this setup." >&2
  echo "Add the following to /etc/wsl.conf, then run 'wsl --shutdown' from PowerShell:" >&2
  printf '\n[boot]\nsystemd=true\n' >&2
  exit 1
fi

architecture="$(dpkg --print-architecture)"
codename="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"

if [[ -z "$codename" ]]; then
  echo "Cannot determine the Ubuntu codename." >&2
  exit 1
fi

echo "Installing Docker Engine for Ubuntu ${VERSION_ID} (${codename}, ${architecture})..."

# Docker CE packages conflict with distro-provided Docker/containerd packages.
conflicting_packages=()
for package in \
  docker.io \
  docker-compose \
  docker-compose-v2 \
  docker-doc \
  docker-buildx \
  podman-docker \
  containerd \
  runc; do
  if dpkg-query -W -f='${db:Status-Abbrev}' "$package" 2>/dev/null | grep -q '^ii'; then
    conflicting_packages+=("$package")
  fi
done

if ((${#conflicting_packages[@]})); then
  sudo apt-get remove -y "${conflicting_packages[@]}"
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources >/dev/null <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${codename}
Components: stable
Architectures: ${architecture}
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

sudo systemctl enable --now docker.service containerd.service
sudo groupadd --force docker
sudo usermod -aG docker "$USER"

sudo docker version >/dev/null

cat <<'EOF'

Docker Engine is installed and running.

Close all WSL terminals and run `wsl --shutdown` from PowerShell before using
Docker without sudo. Then verify the installation in WSL with:

  docker run --rm hello-world
  docker compose version
  docker buildx version

Membership in the docker group grants root-equivalent access to this machine.
EOF
