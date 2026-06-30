#!/usr/bin/env bash
#
# fetch-polkachu-snapshot.sh — obtain an Agoric swing-store from a public
# Polkachu snapshot, extracting ONLY the data/agoric subtree, ready to feed to
# inquisitor.mjs. Unlike fetch-chain-snapshot.sh this needs no ssh and no
# follower credentials, so the bot identity can run it itself.
#
# Why this exists
# ---------------
# inquisitor (packages/cosmic-swingset/tools/inquisitor.mjs, Agoric/agoric-sdk
# #11282) replays and tests an upgrade against a real swingstore.sqlite. Its only
# input is the path to a swingstore.sqlite; it reads the captured block height
# from the store's "host.height" key. The sibling fetch-chain-snapshot.sh pulls
# that database off a follower over ssh — but the bot cannot ssh into a follower.
#
# Polkachu publishes a public, anonymously downloadable Tendermint snapshot of
# Agoric mainnet (https://www.polkachu.com/tendermint_snapshots/agoric) as a
# single agoric_<height>.tar.lz4. That tarball extracts into a cosmos home and
# contains the whole data/ directory: the Tendermint blockstore/state/application
# databases (the multi-gigabyte bulk) PLUS data/agoric/, which holds the
# swingstore.sqlite inquisitor wants. We need ONLY data/agoric, so this script
# decompresses the .tar.lz4 stream and extracts just that member subtree — the
# Tendermint databases are read past and discarded, never written to disk.
#
# Caveat on the download size: the snapshot is one compressed stream and tar
# cannot seek within it, so resolving every data/agoric member still streams the
# whole archive over the wire (tens of gigabytes). What the data/agoric filter
# saves is DISK: only the swing-store subtree lands on disk, not the Tendermint
# databases that dominate the uncompressed snapshot.
#
# A Polkachu snapshot is a recent chain-tip capture, not the historical block of
# any past upgrade. That is the right shape for inquisitor's use here: inquisitor
# injects the contract bundle and runs the core-eval against whatever swing-store
# state it is handed, so a current mainnet swing-store reproduces the v320 70->71
# ymax0 install overflow without needing the exact historical upgrade height.
#
# The cache, the provenance sidecar, and socializing across hosts
# ---------------------------------------------------------------
# A snapshot is tens of gigabytes over the wire, so re-pulling it on every host
# and every run is wasteful. By default the extracted swing-store lands in a
# per-host CACHE directory that is NOT checked into git and survives across jobs:
#
#   $GARDEN_SNAPSHOT_CACHE
#     (default ${GARDEN_STATE:-$HOME/.garden-state}/cache/agoric-snapshots)
#
# laid out one directory per snapshot height: <cache>/agoric-<height>/. Beside
# the extracted swing-store the script writes a provenance.json metadata sidecar
# recording the source URL, height, sha256, and the UTC date of acquisition, so a
# later reader knows exactly what the cached artifact is and where it came from.
# When a valid cached swing-store for the resolved height already exists, the
# script reuses it and skips the download entirely (override with --refresh).
#
# The garden runs on multiple hosts, and any one host may not hold a given
# snapshot. Pulling a copy from a PEER host's cache is gentler on Polkachu than
# re-downloading tens of gigabytes: --from-host HOST rsyncs the peer's snapshot
# cache into this host's cache first, after which the normal cache-hit path uses
# it with no Polkachu request. --use-cached uses the newest cached snapshot
# without any network resolution at all.
#
# Usage
# -----
#   scripts/agoric/fetch-polkachu-snapshot.sh [options]
#
# Options:
#   --url URL          explicit .tar.lz4 snapshot URL. If omitted, the current
#                      URL is resolved by scraping the Polkachu Agoric page.
#   --out-dir DIR      where to extract data/agoric. Default is the per-snapshot
#                      cache directory <cache>/agoric-<height>/ (see --cache-dir).
#                      The swing-store lands at <out-dir>/data/agoric/swingstore.sqlite.
#   --cache-dir DIR    the cache root holding one subdir per snapshot height
#                      (default $GARDEN_SNAPSHOT_CACHE, see above). Not in git.
#   --use-cached       do not resolve or download anything; use the newest valid
#                      swing-store already in the cache. Fails if the cache is empty.
#   --from-host HOST   before resolving, rsync HOST's snapshot cache into this
#                      host's cache (ssh/rsync to a peer garden host). Gentler than
#                      re-pulling from Polkachu. Implies --use-cached unless a
#                      --url is also given.
#   --refresh          re-download even if a cached swing-store for the height exists.
#   --download         save the .tar.lz4 to disk first (resumable with wget -c),
#                      then extract — useful to retry extraction without
#                      re-streaming the whole archive. Default streams in one
#                      pass with no full tarball on disk.
#   --member PATH      tar member subtree to extract (default: data/agoric). Set
#                      this if a snapshot archives paths under a different prefix.
#   --vacuum           after extraction, also write a standalone, WAL-free
#                      <out-dir>/swingstore.sqlite via SQLite VACUUM INTO, the
#                      tidiest single-file input for inquisitor.
#   --keep-archive     with --download, keep the .tar.lz4 after extraction.
#   -h, --help         this help
#
# Examples:
#   # stream the current snapshot into the cache, extract only data/agoric
#   ./fetch-polkachu-snapshot.sh
#
#   # reuse whatever this host already cached, no network at all
#   ./fetch-polkachu-snapshot.sh --use-cached --vacuum
#
#   # socialize: pull the snapshot cache from a peer host, then use it
#   ./fetch-polkachu-snapshot.sh --from-host kriscendobot@endolinbot --vacuum
#
#   # pin a specific snapshot and keep the archive for re-extraction
#   ./fetch-polkachu-snapshot.sh \
#       --url https://snapshots.polkachu.com/snapshots/agoric/agoric_26146641.tar.lz4 \
#       --download --keep-archive
#
# Then test the upgrade locally:
#   node packages/cosmic-swingset/tools/inquisitor.mjs \
#       <out-dir>/data/agoric/swingstore.sqlite
#
set -euo pipefail

die() { printf 'fetch-polkachu-snapshot: %s\n' "$*" >&2; exit 1; }
note() { printf 'fetch-polkachu-snapshot: %s\n' "$*" >&2; }

# --- defaults -----------------------------------------------------------------
SNAPSHOT_PAGE="https://www.polkachu.com/tendermint_snapshots/agoric"
# Cache root: per-host, outside any reset-prone worktree, never committed. The
# garden's $GARDEN_STATE ($HOME/.garden-state) is the conventional home for such
# state; honour an explicit $GARDEN_SNAPSHOT_CACHE override first.
CACHE_DIR="${GARDEN_SNAPSHOT_CACHE:-${GARDEN_STATE:-$HOME/.garden-state}/cache/agoric-snapshots}"
URL=""
OUT_DIR=""
MEMBER="data/agoric"
DOWNLOAD=0
VACUUM=0
KEEP_ARCHIVE=0
USE_CACHED=0
FROM_HOST=""
REFRESH=0

# --- argument parsing ---------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --url) URL="${2:?--url needs a value}"; shift 2 ;;
    --out-dir) OUT_DIR="${2:?}"; shift 2 ;;
    --cache-dir) CACHE_DIR="${2:?}"; shift 2 ;;
    --use-cached) USE_CACHED=1; shift ;;
    --from-host) FROM_HOST="${2:?--from-host needs a value}"; shift 2 ;;
    --refresh) REFRESH=1; shift ;;
    --member) MEMBER="${2:?}"; shift 2 ;;
    --download) DOWNLOAD=1; shift ;;
    --vacuum) VACUUM=1; shift ;;
    --keep-archive) KEEP_ARCHIVE=1; shift ;;
    -h|--help) sed -n '2,98p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

# A --from-host pull is meant to AVOID Polkachu, so default to using the cache
# the peer populated unless the caller explicitly pinned a --url.
if [ -n "$FROM_HOST" ] && [ -z "$URL" ]; then
  USE_CACHED=1
fi

mkdir -p "$CACHE_DIR"

# --- helpers ------------------------------------------------------------------
# A snapshot dir is "valid" if it holds a non-empty swing-store under MEMBER.
snapshot_db() { printf '%s/%s/swingstore.sqlite' "$1" "$MEMBER"; }
snapshot_valid() { [ -s "$(snapshot_db "$1")" ]; }

# Newest valid cached snapshot dir (by mtime), or empty.
newest_cached() {
  local d
  while IFS= read -r d; do
    d="${d%/}"
    if snapshot_valid "$d"; then printf '%s\n' "$d"; return 0; fi
  done < <(ls -1dt "$CACHE_DIR"/*/ 2>/dev/null)
  return 1
}

# Write the provenance sidecar beside the cached artifact.
write_provenance() {
  local dir="$1" url="$2" snap_height="$3" host_height="$4" archive_bytes="$5"
  local db sha bytes prov host
  db="$(snapshot_db "$dir")"
  sha=""; bytes=""
  if [ -f "$db" ]; then
    command -v sha256sum >/dev/null 2>&1 && sha="$(sha256sum "$db" | cut -d' ' -f1)"
    bytes="$(stat -c %s "$db" 2>/dev/null || echo "")"
  fi
  host="${GARDEN:-$(hostname -s 2>/dev/null || echo unknown)}"
  prov="$dir/provenance.json"
  cat > "$prov" <<JSON
{
  "schema": "agoric-snapshot-provenance/1",
  "source": "polkachu",
  "source_page": "$SNAPSHOT_PAGE",
  "source_url": "${url}",
  "snapshot_height": "${snap_height}",
  "host_height": "${host_height}",
  "member_extracted": "$MEMBER",
  "swingstore_path": "${MEMBER}/swingstore.sqlite",
  "swingstore_sha256": "${sha}",
  "swingstore_bytes": "${bytes}",
  "archive_compressed_bytes": "${archive_bytes}",
  "acquired_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "acquired_by_host": "${host}",
  "acquired_by_tool": "scripts/agoric/fetch-polkachu-snapshot.sh"
}
JSON
  note "wrote provenance: $prov"
}

# --- socialize: pull a peer host's cache before touching Polkachu -------------
if [ -n "$FROM_HOST" ]; then
  command -v rsync >/dev/null 2>&1 || die "--from-host needs rsync (apt-get install rsync)"
  note "socializing: rsync snapshot cache from $FROM_HOST (gentler than re-pulling from Polkachu)"
  # Mirror the peer's per-snapshot dirs into our cache; -a preserves the tree,
  # --ignore-existing avoids reclobbering a snapshot we already hold.
  rsync -a --info=progress2 --ignore-existing \
        "$FROM_HOST:${GARDEN_SNAPSHOT_CACHE:-\$HOME/.garden-state/cache/agoric-snapshots}/" \
        "$CACHE_DIR/" \
    || die "rsync from $FROM_HOST failed (peer cache path differs? pass it via the peer's \$GARDEN_SNAPSHOT_CACHE)"
fi

# --- use-cached short-circuit -------------------------------------------------
# Reuse a swing-store already on disk, no network resolution at all. This is the
# path --from-host lands in and the cheapest way to re-run inquisitor.
if [ "$USE_CACHED" -eq 1 ] && [ -z "$URL" ]; then
  if cached="$(newest_cached)"; then
    [ -z "$OUT_DIR" ] && OUT_DIR="$cached"
    note "using cached snapshot: $cached"
  else
    die "no valid cached snapshot under $CACHE_DIR (run once without --use-cached, or --from-host a peer)"
  fi
fi

# --- local prerequisites ------------------------------------------------------
need() { command -v "$1" >/dev/null 2>&1 || die "missing required tool: $1 ($2)"; }
# Tools needed only when we actually resolve/download (not on the cached path).
if [ -z "${OUT_DIR:-}" ] || { [ "$USE_CACHED" -eq 0 ] && [ -z "${cached:-}" ]; }; then
  if [ "$USE_CACHED" -eq 0 ]; then
    need curl "to download the snapshot"
    need lz4 "to decompress the .tar.lz4 (apt-get install lz4)"
    need tar "to extract the data/agoric subtree"
  fi
fi
[ "$VACUUM" -eq 1 ] && need sqlite3 "for --vacuum (apt-get install sqlite3)"

# --- resolve the snapshot URL -------------------------------------------------
# Polkachu names each snapshot agoric_<height>.tar.lz4, so the height (and thus
# the URL) changes with every refresh. When no --url is given, scrape the public
# page for the current one. The bucket itself denies listing and the snapshot
# JSON API is not anonymously reachable, so the page is the stable resolver.
HEIGHT_FROM_URL=""
if [ "$USE_CACHED" -eq 0 ] || [ -n "$URL" ]; then
  if [ -z "$URL" ]; then
    note "resolving current snapshot URL from $SNAPSHOT_PAGE"
    URL=$(curl -fsSL -A 'Mozilla/5.0 (fetch-polkachu-snapshot)' "$SNAPSHOT_PAGE" \
          | grep -oE 'https://snapshots\.polkachu\.com/snapshots/agoric/agoric_[0-9]+\.tar\.lz4' \
          | sort -u | head -1) \
      || die "could not fetch the Polkachu page; pass --url explicitly"
    [ -n "$URL" ] || die "no snapshot URL found on the page; pass --url explicitly"
  fi
  note "snapshot URL: $URL"
  HEIGHT_FROM_URL=$(basename "$URL" | sed -n 's/^agoric_\([0-9]\+\)\.tar\.lz4$/\1/p' || true)
fi

# --- output directory (defaults into the cache, keyed by height) --------------
if [ -z "${OUT_DIR:-}" ]; then
  if [ -n "$HEIGHT_FROM_URL" ]; then
    OUT_DIR="$CACHE_DIR/agoric-$HEIGHT_FROM_URL"
  else
    OUT_DIR="$CACHE_DIR/agoric-$(date -u +%Y%m%dT%H%M%SZ)"
  fi
fi

# --- cache hit: reuse an already-extracted swing-store ------------------------
if [ "$REFRESH" -eq 0 ] && snapshot_valid "$OUT_DIR"; then
  note "cache hit: reusing extracted swing-store at $(snapshot_db "$OUT_DIR") (pass --refresh to re-download)"
  DB="$(snapshot_db "$OUT_DIR")"
else
  mkdir -p "$OUT_DIR"
  [ -n "$URL" ] || die "no swing-store at $OUT_DIR and no --url to fetch one"

  # Report the compressed size up front so the operator knows the wire cost.
  SIZE=$(curl -fsSLI "$URL" 2>/dev/null | tr -d '\r' \
         | awk 'tolower($1)=="content-length:"{print $2}' | tail -1 || echo "")
  if [ -n "$SIZE" ]; then
    note "compressed size: $SIZE bytes (~$(( SIZE / 1024 / 1024 / 1024 )) GiB) — the full stream is downloaded; only $MEMBER is written to disk"
  fi

  # --- extract only the data/agoric subtree -----------------------------------
  # tar matches MEMBER as a path prefix and extracts that whole subtree; the
  # Tendermint databases stream past unwritten. --no-same-owner so extraction
  # works as an unprivileged user regardless of the snapshot's recorded uids.
  if [ "$DOWNLOAD" -eq 1 ]; then
    archive="$OUT_DIR/$(basename "$URL")"
    note "downloading archive to $archive (resumable)"
    command -v wget >/dev/null 2>&1 || die "--download needs wget (apt-get install wget)"
    wget -c -O "$archive" "$URL" || die "download failed"
    note "extracting $MEMBER from $archive"
    lz4 -d -c "$archive" | tar -x -C "$OUT_DIR" --no-same-owner "$MEMBER" \
      || die "extraction failed (wrong --member? archive uses a different prefix)"
    if [ "$KEEP_ARCHIVE" -eq 0 ]; then
      rm -f "$archive"
    else
      note "keeping archive (--keep-archive): $archive"
    fi
  else
    note "streaming and extracting only $MEMBER (no full tarball on disk)"
    curl -fL --retry 3 --retry-delay 5 "$URL" \
      | lz4 -d -c - \
      | tar -x -C "$OUT_DIR" --no-same-owner "$MEMBER" \
      || die "stream extraction failed (network drop, or wrong --member)"
  fi

  DB="$(snapshot_db "$OUT_DIR")"
  [ -f "$DB" ] || die "no swingstore.sqlite under $OUT_DIR/$MEMBER after extraction"
  note "extracted swing-store: $DB"
fi

# --- inspect / verify ---------------------------------------------------------
# The swing-store is captured live, so a -wal companion may be present; it was
# extracted alongside the .sqlite (the whole data/agoric subtree) and is applied
# on first open. Read host.height and run an integrity check for confidence.
HEIGHT=""
if command -v sqlite3 >/dev/null 2>&1; then
  HEIGHT=$(sqlite3 "$DB" "SELECT value FROM kvStore WHERE key='host.height'" 2>/dev/null || echo "")
  ic=$(sqlite3 "$DB" 'PRAGMA integrity_check' 2>/dev/null | head -1 || echo "")
  [ "$ic" = "ok" ] || note "warning: integrity_check returned: ${ic:-empty} (a live -wal may need checkpointing; try --vacuum)"
  note "captured swing-store host.height: ${HEIGHT:-unknown}"
fi

# --- provenance sidecar beside the cached artifact ----------------------------
# Track where this snapshot came from and when it was acquired, so a later reader
# (or a peer host that rsyncs the cache) knows exactly what it is holding.
write_provenance "$OUT_DIR" "${URL:-cached}" "${HEIGHT_FROM_URL:-${HEIGHT:-unknown}}" "${HEIGHT:-unknown}" "${SIZE:-}"

OUT_DB="$DB"
if [ "$VACUUM" -eq 1 ]; then
  vac="$OUT_DIR/swingstore.sqlite"
  note "writing a standalone WAL-free copy via VACUUM INTO: $vac"
  sqlite3 "$DB" "VACUUM INTO '$vac'" || die "VACUUM INTO failed"
  OUT_DB="$vac"
fi

note "done."
cat >&2 <<EOF

Swing-store ready at: $OUT_DB
host.height: ${HEIGHT:-unknown}
cached under: $OUT_DIR (provenance: $OUT_DIR/provenance.json)

Next: feed it to inquisitor for an upgrade test, for example
    node packages/cosmic-swingset/tools/inquisitor.mjs "$OUT_DB"
then in the REPL load the bundle and run the core-eval, as in
Agoric/agoric-sdk#11282:
    void( fs = await import('fs') );
    Object.keys( bundle = JSON.parse(fs.readFileSync("/tmp/psm-bundle.json","utf-8")) );
    await swingStore.kernelStorage.bundleStore.addBundle(\$bundleID, bundle);
    await runCoreEval(fs.readFileSync("/tmp/psm-core-eval.js","utf-8"));
EOF
