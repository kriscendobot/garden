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

echo "== provision: apt + docker (official repo, with buildx) =="
apt-get update -y
apt-get install -y git ca-certificates curl gnupg
# `./garden build` runs `docker build --allow network.host`, a BuildKit entitlement
# flag. Install Docker CE from Docker's official apt repo so the buildx plugin and
# integrated BuildKit are present (Ubuntu's stock docker.io ships neither reliably),
# matching how the garden is built on a real host.
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
arch="$(dpkg --print-architecture)"
codename="$(. /etc/os-release && echo "$VERSION_CODENAME")"
echo "deb [arch=$arch signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $codename stable" \
  > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
# The bot user runs Docker without sudo (matches the ./garden posture on any host).
usermod -aG docker "$OWNER"

echo "== provision: clone reviewed garden revision =="
# A full clone of the branch already carries all of its history, so the pinned
# commit is normally present locally (checkout accepts an abbreviated sha). Only if
# it is somehow absent do we fetch it — and a remote fetch by sha needs the FULL
# 40-char id (GitHub rejects an abbreviated ref), so build-ami resolves the full sha.
if [[ ! -d "$CHECKOUT/.git" ]]; then
  sudo -u "$OWNER" git clone --branch "$BRANCH" "$REPO" "$CHECKOUT"
fi
sudo -u "$OWNER" git -C "$CHECKOUT" fetch origin "$BRANCH"
if ! sudo -u "$OWNER" git -C "$CHECKOUT" cat-file -e "${COMMIT}^{commit}" 2>/dev/null; then
  sudo -u "$OWNER" git -C "$CHECKOUT" fetch --depth 1 origin "$COMMIT"
fi
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

echo "== provision: unprivileged Chromium launch smoke test =="
# Prove the freshly baked image can launch a headless Chromium — the property
# browser-verification jobs depend on — so a missing shared library fails HERE, in
# the bake, not at a browser job's first use after a container recreation. Runs the
# smoke INSIDE a throwaway container off the built image, as the UNPRIVILEGED bot
# user, with an exec-capable $HOME (the garden's /tmp is a noexec tmpfs). The script
# is fed over stdin (`bash -ls`) so it needs no bind mount, and a login shell picks
# up /etc/profile.d/garden.sh (node on PATH). --entrypoint bash bypasses systemd; we
# only need node here, not the unit manager.
HERE="$(cd "$(dirname "$0")" && pwd)"
uid="$(id -u "$OWNER")"
smoke_out="$(sudo -u "$OWNER" -H bash -lc \
  "sg docker -c 'docker run --rm -i --user ${uid} -e HOME=/home/${OWNER} \
     --entrypoint bash garden-${OWNER} -ls' < '$HERE/chromium-smoke.sh'" 2>&1)" || {
  echo "$smoke_out"
  echo "== provision: FAIL — Chromium launch smoke test did not pass =="
  exit 1
}
echo "$smoke_out"
grep -q "CHROMIUM-LAUNCH-OK" <<<"$smoke_out" || {
  echo "== provision: FAIL — Chromium launch smoke test produced no OK marker =="
  exit 1
}
echo "== provision: Chromium launch smoke test PASSED =="

echo "== provision: DONE =="
