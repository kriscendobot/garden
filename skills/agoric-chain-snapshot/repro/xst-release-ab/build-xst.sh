#!/bin/bash
# Build the stock upstream `xst` (the standalone XS shell) from a tagged
# Moddable-OpenSource/moddable RELEASE — no agoric fork, no patches. This is the
# engine mhofman asked to confirm the ymax0 flat/flatMap value-stack overflow
# against (kriskowal/garden#9, comment 4907678857): "verify the stack overflow
# using xst instead of our worker … release xst, from before and after 73aad47b".
#
# 73aad47b ("XS: fix array flat/sort stack overflows") landed 2026-01-20, between
# release 7.0.0 (2026-01-16, BEFORE — no fix) and 7.1.0 (2026-02-11, AFTER — has
# the leaf-only pop). 8.3.0 (2026-07-03) is the latest release and also carries
# only the leaf-only pop.
#
# Usage: build-xst.sh <tag>   e.g. build-xst.sh 7.0.0
# Output: prints the absolute path to the built xst binary.
set -euo pipefail
tag="${1:?usage: build-xst.sh <tag>  (e.g. 7.0.0 | 7.1.0 | 8.3.0)}"
WORK="${XST_AB_WORK:-$HOME/.cache/garden-scratch/xst-ab}"
src="$WORK/src/moddable-$tag"
mkdir -p "$WORK/src"
if [ ! -d "$src" ]; then
  curl -sL "https://github.com/Moddable-OpenSource/moddable/archive/refs/tags/$tag.tar.gz" \
    -o "$WORK/src/$tag.tar.gz"
  tar xzf "$WORK/src/$tag.tar.gz" -C "$WORK/src"
fi
# xst must live on an exec filesystem; the release build tree is fine.
( cd "$src/xs/makefiles/lin" && MODDABLE="$src" make -f xst.mk GOAL=release >/dev/null 2>&1 )
bin="$src/build/bin/lin/release/xst"
[ -x "$bin" ] || { echo "build failed: $bin missing" >&2; exit 1; }
echo "$bin"
