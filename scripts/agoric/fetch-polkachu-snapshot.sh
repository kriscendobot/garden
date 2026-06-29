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
# Usage
# -----
#   scripts/agoric/fetch-polkachu-snapshot.sh [options]
#
# Options:
#   --url URL          explicit .tar.lz4 snapshot URL. If omitted, the current
#                      URL is resolved by scraping the Polkachu Agoric page.
#   --out-dir DIR      where to extract data/agoric (default:
#                      ./agoric-snapshot-<UTCstamp>). The swing-store lands at
#                      <out-dir>/data/agoric/swingstore.sqlite.
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
#   # stream the current snapshot, extract only data/agoric
#   ./fetch-polkachu-snapshot.sh
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
URL=""
OUT_DIR=""
MEMBER="data/agoric"
DOWNLOAD=0
VACUUM=0
KEEP_ARCHIVE=0

# --- argument parsing ---------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --url) URL="${2:?--url needs a value}"; shift 2 ;;
    --out-dir) OUT_DIR="${2:?}"; shift 2 ;;
    --member) MEMBER="${2:?}"; shift 2 ;;
    --download) DOWNLOAD=1; shift ;;
    --vacuum) VACUUM=1; shift ;;
    --keep-archive) KEEP_ARCHIVE=1; shift ;;
    -h|--help) sed -n '2,80p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

# --- local prerequisites ------------------------------------------------------
need() { command -v "$1" >/dev/null 2>&1 || die "missing required tool: $1 ($2)"; }
need curl "to download the snapshot"
need lz4 "to decompress the .tar.lz4 (apt-get install lz4)"
need tar "to extract the data/agoric subtree"
[ "$VACUUM" -eq 1 ] && need sqlite3 "for --vacuum (apt-get install sqlite3)"

# --- resolve the snapshot URL -------------------------------------------------
# Polkachu names each snapshot agoric_<height>.tar.lz4, so the height (and thus
# the URL) changes with every refresh. When no --url is given, scrape the public
# page for the current one. The bucket itself denies listing and the snapshot
# JSON API is not anonymously reachable, so the page is the stable resolver.
if [ -z "$URL" ]; then
  note "resolving current snapshot URL from $SNAPSHOT_PAGE"
  URL=$(curl -fsSL -A 'Mozilla/5.0 (fetch-polkachu-snapshot)' "$SNAPSHOT_PAGE" \
        | grep -oE 'https://snapshots\.polkachu\.com/snapshots/agoric/agoric_[0-9]+\.tar\.lz4' \
        | sort -u | head -1) \
    || die "could not fetch the Polkachu page; pass --url explicitly"
  [ -n "$URL" ] || die "no snapshot URL found on the page; pass --url explicitly"
fi
note "snapshot URL: $URL"

# Report the compressed size up front so the operator knows the wire cost.
SIZE=$(curl -fsSLI "$URL" 2>/dev/null | tr -d '\r' \
       | awk 'tolower($1)=="content-length:"{print $2}' | tail -1 || echo "")
if [ -n "$SIZE" ]; then
  note "compressed size: $SIZE bytes (~$(( SIZE / 1024 / 1024 / 1024 )) GiB) — the full stream is downloaded; only $MEMBER is written to disk"
fi

# --- output directory ---------------------------------------------------------
if [ -z "$OUT_DIR" ]; then
  stamp=$(date -u +%Y%m%dT%H%M%SZ)
  OUT_DIR="./agoric-snapshot-${stamp}"
fi
mkdir -p "$OUT_DIR"

# --- extract only the data/agoric subtree -------------------------------------
# tar matches MEMBER as a path prefix and extracts that whole subtree; the
# Tendermint databases stream past unwritten. --no-same-owner so extraction
# works as an unprivileged user regardless of the snapshot's recorded uids.
if [ "$DOWNLOAD" -eq 1 ]; then
  archive="$OUT_DIR/$(basename "$URL")"
  note "downloading archive to $archive (resumable)"
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

DB="$OUT_DIR/$MEMBER/swingstore.sqlite"
[ -f "$DB" ] || die "no swingstore.sqlite under $OUT_DIR/$MEMBER after extraction"
note "extracted swing-store: $DB"

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

Next: feed it to inquisitor for an upgrade test, for example
    node packages/cosmic-swingset/tools/inquisitor.mjs "$OUT_DB"
then in the REPL load the bundle and run the core-eval, as in
Agoric/agoric-sdk#11282:
    void( fs = await import('fs') );
    Object.keys( bundle = JSON.parse(fs.readFileSync("/tmp/psm-bundle.json","utf-8")) );
    await swingStore.kernelStorage.bundleStore.addBundle(\$bundleID, bundle);
    await runCoreEval(fs.readFileSync("/tmp/psm-core-eval.js","utf-8"));
EOF
