#!/usr/bin/env bash
#
# fetch-chain-snapshot.sh — produce a swing-store snapshot from an Agoric chain
# follower over ssh and convey it back locally, ready to feed to inquisitor.mjs.
#
# Why this exists
# ---------------
# The inquisitor developer tool (packages/cosmic-swingset/tools/inquisitor.mjs,
# Agoric/agoric-sdk#11282) replays and tests an upgrade against a real
# swingstore.sqlite in an ephemeral environment. Its single input is the path to
# a swingstore.sqlite, and it reads the captured block height from the store's
# "host.height" key. So the "chain snapshot" inquisitor wants is a
# transactionally-consistent copy of a follower node's swing-store database.
#
# On an Agoric node the swing-store lives at:
#     <cosmos-home>/data/agoric/swingstore.sqlite      (default home: ~/.agoric)
# alongside transient WAL and SHM companion files. Copying the raw file while the
# node is live can capture a torn read, so this script always produces the copy
# with SQLite "VACUUM INTO", which takes a single read transaction and writes a
# self-contained, consistent database (no WAL or SHM needed).
#
# Two capture modes:
#   - hot (default): leave the node running. Captures the last committed block.
#     Lowest operational risk on a follower you do not own.
#   - halt-at-height: stop the node at a precise height first, so the captured
#     state aligns to a known block (the right shape for reproducing an upgrade
#     at the block just before its core-eval runs), then optionally restart.
#
# The bot identity cannot ssh into followers, so this is an operator script:
# review it, set the connection details, and run it from a host that holds the
# follower's ssh key.
#
# Usage
# -----
#   scripts/agoric/fetch-chain-snapshot.sh --host user@follower [options]
#
# Options:
#   --host USER@HOST        ssh target of the follower (required)
#   --remote-home DIR       cosmos home on the follower (default: ~/.agoric)
#   --out PATH              local output file
#                           (default: ./swingstore-<height>-<UTCstamp>.sqlite)
#   --halt-height N         stop the node, wait until it has committed height N,
#                           then capture (deterministic, more disruptive)
#   --node-stop-cmd CMD     remote command to stop the node
#                           (default: "sudo systemctl stop agd")
#   --node-start-cmd CMD    remote command to start the node
#                           (default: "sudo systemctl start agd")
#   --no-restart            with --halt-height, leave the node stopped after
#   --compress zstd|gzip|none  on-wire compression (default: auto, prefers zstd)
#   --ssh-opts "..."        extra options passed to ssh and scp
#   --keep-remote           do not delete the remote temp snapshot afterward
#   -h, --help              this help
#
# Examples:
#   # hot snapshot of the last committed block
#   ./fetch-chain-snapshot.sh --host agops@follower-1
#
#   # deterministic snapshot one block before upgrade height 12345, then restart
#   ./fetch-chain-snapshot.sh --host agops@follower-1 --halt-height 12344
#
# Then test the upgrade locally:
#   node packages/cosmic-swingset/tools/inquisitor.mjs ./swingstore-<...>.sqlite
#
set -euo pipefail

die() { printf 'fetch-chain-snapshot: %s\n' "$*" >&2; exit 1; }
note() { printf 'fetch-chain-snapshot: %s\n' "$*" >&2; }

# --- defaults -----------------------------------------------------------------
HOST=""
# shellcheck disable=SC2088  # the tilde is deliberately literal here; it is
# expanded on the remote shell via `eval echo`, not on this client.
REMOTE_HOME='~/.agoric'
OUT=""
HALT_HEIGHT=""
NODE_STOP_CMD="sudo systemctl stop agd"
NODE_START_CMD="sudo systemctl start agd"
RESTART_AFTER_HALT=1
COMPRESS="auto"
SSH_OPTS=""
KEEP_REMOTE=0

# --- argument parsing ---------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --host) HOST="${2:?--host needs a value}"; shift 2 ;;
    --remote-home) REMOTE_HOME="${2:?}"; shift 2 ;;
    --out) OUT="${2:?}"; shift 2 ;;
    --halt-height) HALT_HEIGHT="${2:?}"; shift 2 ;;
    --node-stop-cmd) NODE_STOP_CMD="${2:?}"; shift 2 ;;
    --node-start-cmd) NODE_START_CMD="${2:?}"; shift 2 ;;
    --no-restart) RESTART_AFTER_HALT=0; shift ;;
    --compress) COMPRESS="${2:?}"; shift 2 ;;
    --ssh-opts) SSH_OPTS="${2:?}"; shift 2 ;;
    --keep-remote) KEEP_REMOTE=1; shift ;;
    -h|--help) sed -n '2,80p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option: $1 (try --help)" ;;
  esac
done

[ -n "$HOST" ] || die "missing --host USER@HOST (try --help)"
case "$COMPRESS" in auto|zstd|gzip|none) ;; *) die "bad --compress: $COMPRESS" ;; esac
if [ -n "$HALT_HEIGHT" ]; then
  case "$HALT_HEIGHT" in *[!0-9]*|'') die "--halt-height must be a positive integer" ;; esac
fi

# shellcheck disable=SC2086,SC2029  # SSH_OPTS is intentionally word-split, and
# commands are deliberately composed on the client before being sent.
ssh_run() { ssh $SSH_OPTS "$HOST" "$@"; }

note "checking remote prerequisites on $HOST"
ssh_run 'command -v sqlite3 >/dev/null 2>&1' \
  || die "the follower needs the sqlite3 CLI for a consistent VACUUM INTO copy; please install it (apt-get install sqlite3) or run with the node stopped and copy the file directly"

# Resolve the remote swing-store path and a remote temp working directory.
REMOTE_DB=$(ssh_run "printf '%s/data/agoric/swingstore.sqlite' \"\$(eval echo $REMOTE_HOME)\"")
[ -n "$REMOTE_DB" ] || die "could not resolve remote swing-store path"
ssh_run "test -f '$REMOTE_DB'" || die "swing-store not found at $REMOTE_DB on $HOST (set --remote-home)"
REMOTE_TMP=$(ssh_run 'mktemp -d -t swingstore-snap.XXXXXX')
[ -n "$REMOTE_TMP" ] || die "could not create remote temp dir"

cleanup_remote() {
  [ "$KEEP_REMOTE" -eq 1 ] && { note "leaving remote temp $REMOTE_TMP (--keep-remote)"; return; }
  ssh_run "rm -rf '$REMOTE_TMP'" 2>/dev/null || true
}
trap cleanup_remote EXIT

# --- optional halt-at-height --------------------------------------------------
node_was_halted=0
if [ -n "$HALT_HEIGHT" ]; then
  note "stopping node and waiting for committed height >= $HALT_HEIGHT"
  ssh_run "$NODE_STOP_CMD" || die "node stop command failed: $NODE_STOP_CMD"
  node_was_halted=1
  # The committed height is recorded in the swing-store itself (host.height),
  # so after a clean stop we read it back rather than polling cosmos RPC.
  committed=$(ssh_run "sqlite3 '$REMOTE_DB' \"SELECT value FROM kvStore WHERE key='host.height'\"" 2>/dev/null || echo "")
  if [ -z "$committed" ]; then
    note "warning: could not read host.height after stop; proceeding with current state"
  elif [ "$committed" -lt "$HALT_HEIGHT" ]; then
    note "warning: node stopped at committed height $committed, below requested $HALT_HEIGHT."
    note "         the node halted before reaching the target; restart it to catch up, then re-run."
  else
    note "node stopped with committed height $committed"
  fi
fi

# Restart the node as soon as the consistent copy exists (or on any failure),
# unless the operator asked to keep it down.
restart_node() {
  [ "$node_was_halted" -eq 1 ] || return 0
  if [ "$RESTART_AFTER_HALT" -eq 1 ]; then
    note "restarting node: $NODE_START_CMD"
    ssh_run "$NODE_START_CMD" || note "warning: node start command failed: $NODE_START_CMD (start it by hand)"
  else
    note "leaving node stopped (--no-restart); start it with: $NODE_START_CMD"
  fi
  node_was_halted=0
}
trap 'restart_node; cleanup_remote' EXIT

# --- produce the consistent copy on the remote --------------------------------
REMOTE_SNAP="$REMOTE_TMP/swingstore.sqlite"
note "running VACUUM INTO for a transactionally-consistent copy"
ssh_run "sqlite3 '$REMOTE_DB' \"VACUUM INTO '$REMOTE_SNAP'\"" \
  || die "VACUUM INTO failed on the follower"

# The captured height for naming and for the operator's confidence.
HEIGHT=$(ssh_run "sqlite3 '$REMOTE_SNAP' \"SELECT value FROM kvStore WHERE key='host.height'\"" 2>/dev/null || echo "unknown")
note "captured swing-store at block height: $HEIGHT"

# Integrity check before we pay to transfer it.
ic=$(ssh_run "sqlite3 '$REMOTE_SNAP' 'PRAGMA integrity_check' | head -1" 2>/dev/null || echo "")
[ "$ic" = "ok" ] || die "snapshot failed integrity_check on the follower (got: ${ic:-empty})"

# Remote checksum so we can verify after transfer.
REMOTE_SHA=$(ssh_run "sha256sum '$REMOTE_SNAP' | cut -d' ' -f1")

# Node no longer needs to stay down; restart it now while we transfer.
restart_node

# --- choose compression -------------------------------------------------------
remote_has() { ssh_run "command -v $1 >/dev/null 2>&1"; }
if [ "$COMPRESS" = "auto" ]; then
  if remote_has zstd && command -v zstd >/dev/null 2>&1; then COMPRESS=zstd
  elif remote_has gzip && command -v gzip >/dev/null 2>&1; then COMPRESS=gzip
  else COMPRESS=none; fi
fi
note "compression: $COMPRESS"

# --- default output name ------------------------------------------------------
if [ -z "$OUT" ]; then
  stamp=$(date -u +%Y%m%dT%H%M%SZ)
  OUT="./swingstore-${HEIGHT}-${stamp}.sqlite"
fi
mkdir -p "$(dirname "$OUT")"

# --- transfer + verify --------------------------------------------------------
# shellcheck disable=SC2086
scp_pull() { scp $SSH_OPTS "$HOST:$1" "$2"; }

case "$COMPRESS" in
  zstd)
    command -v zstd >/dev/null 2>&1 || die "local zstd missing; rerun with --compress gzip or none"
    ssh_run "zstd -q -19 --rm -f '$REMOTE_SNAP' -o '$REMOTE_SNAP.zst'" || die "remote zstd failed"
    scp_pull "$REMOTE_SNAP.zst" "$OUT.zst"
    zstd -q -d -f "$OUT.zst" -o "$OUT"
    rm -f "$OUT.zst"
    ;;
  gzip)
    command -v gzip >/dev/null 2>&1 || die "local gzip missing; rerun with --compress none"
    ssh_run "gzip -9 -f '$REMOTE_SNAP'" || die "remote gzip failed"
    scp_pull "$REMOTE_SNAP.gz" "$OUT.gz"
    # gzip -d on "$OUT.gz" writes the decompressed file to "$OUT" (strips .gz).
    gzip -d -f "$OUT.gz"
    ;;
  none)
    scp_pull "$REMOTE_SNAP" "$OUT"
    ;;
esac

# Verify the local copy matches the remote snapshot bit-for-bit.
LOCAL_SHA=$(sha256sum "$OUT" | cut -d' ' -f1)
[ "$LOCAL_SHA" = "$REMOTE_SHA" ] \
  || die "checksum mismatch after transfer (remote $REMOTE_SHA, local $LOCAL_SHA)"

note "done. snapshot at: $OUT"
note "sha256: $LOCAL_SHA"
note "height: $HEIGHT"
cat >&2 <<EOF

Next: feed it to inquisitor for an upgrade test, for example
    node packages/cosmic-swingset/tools/inquisitor.mjs "$OUT"
then in the REPL load the bundle and run the core-eval, as in
Agoric/agoric-sdk#11282:
    void( fs = await import('fs') );
    Object.keys( bundle = JSON.parse(fs.readFileSync("/tmp/psm-bundle.json","utf-8")) );
    await swingStore.kernelStorage.bundleStore.addBundle(\$bundleID, bundle);
    await runCoreEval(fs.readFileSync("/tmp/psm-core-eval.js","utf-8"));
EOF
