#!/usr/bin/env bash
# provision.sh — runs ON the builder instance (as root, via SSM RunShellScript) to
# turn a bare pinned Ubuntu ARM64 base into a ready turnkey garden host: Docker
# installed, a reviewed main2 checkout in place, and the garden container image
# already built. It installs NO credential of any kind; the operator supplies the
# Claude login and GitHub credential interactively after launch.
#
# Env (exported by build-ami.sh into the SSM command):
#   GARDEN_TURNKEY_SOURCE_REPO   git URL of the (public) garden repo
#   GARDEN_TURNKEY_SOURCE_BRANCH branch to check out (main2)
#   GARDEN_TURNKEY_SOURCE_COMMIT the exact reviewed revision to pin
#   GARDEN_TURNKEY_CHECKOUT      on-host checkout path (/home/ubuntu/garden)
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

REPO="${GARDEN_TURNKEY_SOURCE_REPO:?}"
BRANCH="${GARDEN_TURNKEY_SOURCE_BRANCH:?}"
COMMIT="${GARDEN_TURNKEY_SOURCE_COMMIT:?}"
CHECKOUT="${GARDEN_TURNKEY_CHECKOUT:?}"
OWNER=ubuntu

echo "== provision: apt + docker =="
apt-get update -y
apt-get install -y docker.io git ca-certificates
systemctl enable --now docker
# The bot user runs Docker without sudo (matches the ./garden posture on any host).
usermod -aG docker "$OWNER"

echo "== provision: clone reviewed garden revision =="
if [[ ! -d "$CHECKOUT/.git" ]]; then
  sudo -u "$OWNER" git clone --branch "$BRANCH" "$REPO" "$CHECKOUT"
fi
sudo -u "$OWNER" git -C "$CHECKOUT" fetch --depth 1 origin "$COMMIT"
sudo -u "$OWNER" git -C "$CHECKOUT" checkout --detach "$COMMIT"
echo "== provision: garden source pinned at =="
sudo -u "$OWNER" git -C "$CHECKOUT" --no-pager log -1 --oneline

echo "== provision: build the garden container image =="
# Run as the bot user via `sg docker` so the build-args (USERNAME/USER_UID) and the
# resulting per-user image tag (garden-ubuntu) match the user the operator will
# enter as. `./garden build` asserts its own success (the Dockerfile's build-time
# `command -v claude`), so a broken image fails here, in the bake, not at first use.
sudo -u "$OWNER" -H bash -lc "cd '$CHECKOUT' && sg docker -c './garden build'"

echo "== provision: verify the image is present =="
sudo -u "$OWNER" -H bash -lc "sg docker -c 'docker image inspect garden-${OWNER} >/dev/null'" \
  && echo "image garden-${OWNER} present"

echo "== provision: DONE =="
