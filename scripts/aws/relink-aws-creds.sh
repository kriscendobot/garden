#!/bin/bash
# relink-aws-creds.sh — re-establish the shared-inode AWS credential hard links.
#
# Usage: relink-aws-creds.sh [checkout-root ...]
#
# The garden keeps ONE AWS credential file, shared by hard link across the host
# home and every checkout root so `HOME=<checkout> aws ...` resolves the same
# secret. Hard links (one inode, many names) are used rather than symlinks
# because the container bind-mounts only the checkout path: a symlink pointing at
# the host ~/.aws would dangle inside the container, but a hard link is just
# another name for the same on-disk inode and stays valid across the mount. This
# only works because every name is on the SAME filesystem (the shared home).
#
# This script points each checkout root's .aws/{credentials,config} back at the
# canonical files under $HOME/.aws (override with AWS_SOURCE_DIR). It is
# idempotent: a name already sharing the source inode is left alone. Run it after
# any manual key edit or rotation, or whenever a link may have been broken (a
# file replaced by copy-and-rename gets a fresh inode and silently unshares).
#
# Checkout roots are DISCOVERED (a garden checkout has CLAUDE.md + roles/ +
# skills/) rather than hard-coded, so a third checkout is picked up automatically.
# Pass roots explicitly to override discovery.
set -euo pipefail

SOURCE_DIR="${AWS_SOURCE_DIR:-$HOME/.aws}"
# credentials is the secret and is required; config carries the region and is
# linked too when present so every home reports the same region.
FILES=(credentials config)

is_garden_checkout() {
  [ -f "$1/CLAUDE.md" ] && [ -d "$1/roles" ] && [ -d "$1/skills" ]
}

roots=()
add_root() {
  is_garden_checkout "$1" || return 0
  local abs; abs="$(cd "$1" && pwd)"
  local r; for r in "${roots[@]:-}"; do [ "$r" = "$abs" ] && return 0; done
  roots+=("$abs")
}

if [ "$#" -gt 0 ]; then
  for arg in "$@"; do
    is_garden_checkout "$arg" || { echo "relink: $arg is not a garden checkout" >&2; exit 1; }
    add_root "$arg"
  done
else
  # HOME may itself be a checkout (inside a container); otherwise the checkouts
  # sit one level below the login home. Consider both.
  add_root "$HOME"
  for d in "$HOME"/*/; do add_root "${d%/}"; done
fi

[ "${#roots[@]}" -gt 0 ] || { echo "relink: no garden checkout roots found" >&2; exit 1; }

[ -f "$SOURCE_DIR/credentials" ] || {
  echo "relink: no credential source at $SOURCE_DIR/credentials" >&2
  echo "        create it first (rotate-key.sh writes it) or set AWS_SOURCE_DIR" >&2
  exit 1; }

status=0
for root in "${roots[@]}"; do
  target_dir="$root/.aws"
  # Skip the source itself: it must not be relinked onto itself.
  if [ -d "$target_dir" ] && [ "$target_dir" -ef "$SOURCE_DIR" ]; then
    echo "relink: $target_dir is the source; skipping"
    continue
  fi
  mkdir -p "$target_dir"; chmod 700 "$target_dir"
  for f in "${FILES[@]}"; do
    src="$SOURCE_DIR/$f"
    [ -f "$src" ] || continue
    dst="$target_dir/$f"
    if [ -e "$dst" ] && [ "$dst" -ef "$src" ]; then
      echo "relink: $dst already shares the source inode"
      continue
    fi
    # ln -f unlinks any existing name and creates a fresh hard link to the source
    # inode. A cross-filesystem target fails here (EXDEV) rather than silently
    # falling back to a copy, which would defeat the shared-inode design.
    if ! ln -f "$src" "$dst" 2>/dev/null; then
      echo "relink: FAILED to hard-link $dst -> $src (different filesystem?)" >&2
      status=1
      continue
    fi
    [ "$f" = credentials ] && chmod 600 "$dst"
    echo "relink: linked $dst"
  done
done
exit "$status"
