#!/bin/bash
# provision-moddable-xst.sh — provide xst from an exact Moddable release.
#
# The local-verify test-xs step calls this with the release CI pins. It returns
# the bin directory on stdout and otherwise stays quiet. It deliberately never
# falls back to `command -v xst`: a host binary from a different XS release can
# rewrite baselines differently while appearing to run the same suite.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "$HERE/common.sh"

release="${1:-}"
case "$release" in
  *[!A-Za-z0-9._+-]*|'')
    echo "provision-moddable-xst: invalid release '${release}'" >&2
    exit 2 ;;
esac

verify_xst() {
  local candidate="$1" version
  [ -x "$candidate" ] || return 1
  version="$("$candidate" -v 2>&1)" || return 1
  case "$version" in XS\ *) return 0 ;; *) return 1 ;; esac
}

# Explicit means explicit: useful for tests and for an operator-supplied mirror.
# It must still be an executable xst, but its release provenance is the caller's
# responsibility. Ordinary PATH is intentionally not consulted.
if [ -n "${GARDEN_XST:-}" ]; then
  candidate="$GARDEN_XST"
  [ -d "$candidate" ] && candidate="$candidate/xst"
  verify_xst "$candidate" || {
    echo "provision-moddable-xst: GARDEN_XST does not name a working xst" >&2
    exit 1
  }
  dirname "$candidate"
  exit 0
fi

system_root="${GARDEN_XST_SYSTEM_ROOT:-/opt/moddable}"
cache_root="${GARDEN_XST_CACHE_ROOT:-$GARDEN_STATE/tool-cache/moddable}"
for root in "$system_root" "$cache_root"; do
  candidate="$root/$release/bin/xst"
  if verify_xst "$candidate"; then
    dirname "$candidate"
    exit 0
  fi
done

case "$(uname -s):$(uname -m)" in
  Linux:x86_64|Linux:amd64) asset=xst-lin64.zip ;;
  *)
    echo "provision-moddable-xst: Moddable release binaries are not configured for $(uname -s)/$(uname -m)" >&2
    exit 1 ;;
esac

command -v curl >/dev/null 2>&1 || { echo "provision-moddable-xst: curl is required" >&2; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "provision-moddable-xst: unzip is required" >&2; exit 1; }
command -v flock >/dev/null 2>&1 || { echo "provision-moddable-xst: flock is required" >&2; exit 1; }

dest="$cache_root/$release/bin"
mkdir -p "$cache_root/$release"
exec 9>"$cache_root/$release/.provision.lock"
flock 9
if verify_xst "$dest/xst"; then
  printf '%s\n' "$dest"
  exit 0
fi

tmp="$(mktemp -d "$cache_root/$release/.download.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT
base="${GARDEN_MODDABLE_RELEASE_BASE_URL:-https://github.com/Moddable-OpenSource/moddable/releases/download}"
curl -fsSL --retry 3 "$base/$release/$asset" -o "$tmp/xst.zip"
unzip -q "$tmp/xst.zip" -d "$tmp/unpacked"
chmod 755 "$tmp/unpacked/xst"
verify_xst "$tmp/unpacked/xst" || {
  echo "provision-moddable-xst: $release/$asset did not contain a working xst" >&2
  exit 1
}
mkdir -p "$dest"
mv "$tmp/unpacked/xst" "$dest/xst"
printf '%s\n' "$dest"
