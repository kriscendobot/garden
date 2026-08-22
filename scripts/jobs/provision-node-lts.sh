#!/bin/bash
# provision-node-lts.sh — install the pinned LTS Node major into a version-manager
# root the local-verify Node-parity guard already searches, so a host whose
# primary `node` is a DIFFERENT major ADOPTS the pinned LTS instead of REFUSING
# to verify.
#
# Why this exists: `scripts/jobs/gardening/local-verify.sh` enforces Node runtime
# parity (endojs/endo-but-for-bots#1048): a project that pins a Node major
# (`.node-version`/`.nvmrc`, including the `lts/*` alias) different from the host's
# active `node` fails LOUD (`NODE RUNTIME PARITY`, exit 3) rather than emitting a
# misleading green. The fleet image ships Node 22 as its primary `/usr/local/bin/node`,
# while endo-but-for-bots pins `.node-version=lts/*` → Node 24, so the guard refuses
# every Node-24 project on these hosts until a matching runtime exists. The guard
# already ADOPTS a runtime it can discover under nvm/fnm/n/volta roots (see
# `find_node_bin_for_major` in common.sh). This script drops the pinned LTS into
# `/usr/local/n/versions/node/<version>/`, the `n`-shaped root the guard searches,
# WITHOUT disturbing the primary Node 22 that other tooling relies on.
#
# Reproducible-by-construction: the container image bakes the same layout at build
# time (Dockerfile, the "Node LTS for local-verify parity" layer) by running this
# very script, so a rebuilt-and-deployed host has it without a live provisioning
# step. This script is ALSO the live-host path: run it on a host whose container
# predates the image change to provision without waiting for a redeploy.
#
# The pinned LTS major defaults to GARDEN_NODE_LTS_LATEST (default 24, kept in
# lockstep with common.sh's constant and the Dockerfile's NODE_LTS_MAJOR arg). When
# the current newest LTS advances, bump all three together — see
# skills/node-lts-window-watch.
#
# Usage: provision-node-lts.sh [<major>]
#   <major>  the Node major to install (default: $GARDEN_NODE_LTS_LATEST, else 24)
# Env:
#   GARDEN_NODE_LTS_LATEST  default major when no argument is given
#   NODE_LTS_INSTALL_ROOT   install root (default: /usr/local/n/versions/node)
#
# Idempotent: a run that finds the requested major already installed under the root
# prints the existing path and exits 0 without downloading.

set -euo pipefail

major="${1:-${GARDEN_NODE_LTS_LATEST:-24}}"
major="$(printf '%s' "${major#v}" | tr -cd '0-9')"
[ -n "$major" ] || { echo "provision-node-lts: no valid major given" >&2; exit 2; }

root="${NODE_LTS_INSTALL_ROOT:-/usr/local/n/versions/node}"

# Mutating steps run through $SUDO: nothing if the tree is already writable (the
# Docker build runs as root), else `sudo -n` on a live host (the bot user is in the
# sudo group). Fail loud if neither works rather than half-provisioning.
priv_parent="$root"
while [ ! -d "$priv_parent" ]; do priv_parent="$(dirname "$priv_parent")"; done
if [ -w "$priv_parent" ]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  SUDO="sudo"
else
  echo "provision-node-lts: $root is not writable and passwordless sudo is unavailable" >&2
  exit 1
fi

# Already installed for this major? (Any patch level is fine — the guard matches on
# major.) Confirm the discovered binary actually reports the requested major before
# declaring victory.
if [ -d "$root" ]; then
  for cand in "$root"/v"$major".* "$root"/"$major".*; do
    [ -d "$cand/bin" ] || continue
    have="$("$cand/bin/node" --version 2>/dev/null | sed 's/^v//; s/\..*//')" || have=""
    if [ "$have" = "$major" ]; then
      echo "provision-node-lts: Node $major already present at $cand/bin"
      exit 0
    fi
  done
fi

# Resolve the platform tarball, mirroring the Dockerfile's Node layer exactly
# (NodeSource's apt repo/setup script 403 as of 2026-07, so we pull the official
# nodejs.org tarball directly).
arch="$(dpkg --print-architecture 2>/dev/null || uname -m)"
case "$arch" in
  amd64|x86_64) node_arch=x64 ;;
  arm64|aarch64) node_arch=arm64 ;;
  *) node_arch="$arch" ;;
esac

base="https://nodejs.org/dist/latest-v${major}.x"
tarball="$(curl -fsSL "$base/" \
  | grep -oE "node-v${major}\.[0-9]+\.[0-9]+-linux-${node_arch}\.tar\.gz" | head -1)"
[ -n "$tarball" ] || { echo "provision-node-lts: could not resolve a Node $major linux-$node_arch tarball at $base/" >&2; exit 1; }

# node-vX.Y.Z-linux-<arch>.tar.gz -> X.Y.Z (the `n`-shaped directory name).
version="${tarball#node-v}"; version="${version%%-*}"
dest="$root/$version"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$base/$tarball" -o "$tmp/node.tar.gz"

$SUDO mkdir -p "$dest"
$SUDO tar -C "$dest" --strip-components=1 -xzf "$tmp/node.tar.gz"

# Verify the install lands where the guard looks and reports the right major.
got="$("$dest/bin/node" --version 2>/dev/null || true)"
case "$got" in
  v"$major".*) echo "provision-node-lts: installed Node $got at $dest/bin" ;;
  *) echo "provision-node-lts: install verification failed (got '${got:-none}' at $dest/bin)" >&2; exit 1 ;;
esac
