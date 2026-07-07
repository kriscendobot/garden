#!/bin/sh
# Build stock `xst` release binaries for the Moddable releases that bracket
# commit 73aad47b ("XS: fix array flat/sort stack overflows"), plus optional
# stackCount=4096 variants (matching agoric on-chain xsnap) for fast A/B.
#
#   73aad47b committed 2026-01-20; bracketed by release 7.0.0 (2026-01-16, BEFORE)
#   and 7.1.0 (2026-02-11, AFTER). 8.3.0 is the latest release (still leaf-only).
#
# Verified ancestry (gh api compare):
#   7.0.0..73aad47b  -> ahead 5, behind 0   (7.0.0 does NOT contain the fix)
#   73aad47b..7.1.0  -> ahead 28, behind 0  (7.1.0 contains the fix)
#
# Output binaries land in $BASE:
#   xst-<tag>-256k    stock release (default xst value stack, 256*1024 slots)
#   xst-<tag>-4096    same source, stackCount patched to on-chain 4096
# Needs: git, gcc/cc, make, python3, ~1GB disk per tag.
set -eu
BASE="${BASE:-$HOME/.cache/garden-scratch/exp9-xst}"
TAGS="${TAGS:-7.0.0 7.1.0 8.3.0}"
mkdir -p "$BASE"
cd "$BASE"

for tag in $TAGS; do
  MOD="$BASE/moddable-$tag"
  [ -d "$MOD" ] || git clone --depth 1 --branch "$tag" \
    https://github.com/Moddable-OpenSource/moddable.git "moddable-$tag"

  # stock 256k-slot release xst
  ( cd "$MOD/xs/makefiles/lin" && MODDABLE="$MOD" make -f xst.mk GOAL=release >/dev/null )
  cp "$MOD/build/bin/lin/release/xst" "$BASE/xst-$tag-256k"

  # stackCount=4096 variant (on-chain xsnap value-stack size)
  sed -i 's/256 \* 1024/4096/g' "$MOD/xs/tools/xst.c"
  ( cd "$MOD/xs/makefiles/lin" && MODDABLE="$MOD" make -f xst.mk GOAL=release >/dev/null )
  cp "$MOD/build/bin/lin/release/xst" "$BASE/xst-$tag-4096"
  git -C "$MOD" checkout -- xs/tools/xst.c   # leave tree pristine

  echo "built xst-$tag-256k, xst-$tag-4096  ($("$BASE/xst-$tag-256k" -v 2>&1 | head -1))"
done
