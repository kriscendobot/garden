#!/bin/bash
# receipt-watcher.sh — per-repo PR-TERMINAL-STATE producer. Watch one gated repo's OWN
# PRs and, the moment one reaches a terminal state (MERGED or CLOSED) that the garden
# actually worked, post exactly one <slug>-pr<N>-receipt job. A gardener then claims it
# and runs the deterministic pr-receipt.sh generator (rows + MRE + post + archive).
#
# Usage: receipt-watcher.sh <repo-slug>      e.g. endojs-endo-but-for-bots
#
# Sibling to ci-watcher.sh (watches CI STATUS) and comment-watcher.sh (watches COMMENT
# text). This one watches PR TERMINAL STATE. Fully DETERMINISTIC — plain-code state
# reads and a fixed mapping, NO `claude -p`, NO external comment text into any model
# (it reads only PR number/state/timestamps; the generator later reads human comment
# bodies only to COUNT and MEASURE length). Injection-safe by construction like
# ci-watcher, and armed only for repos already in the journal's comment-repos/ set
# (reconciled by repo-watcher.sh) — it widens the monitoring surface by nothing
# (CLAUDE.md § Monitoring safety constraint). Leader-only via the unit's ExecCondition.
# Design: designs/pr-completion-receipts.md § The trigger.
#
# THE PIPELINE, per tick:
#   read a durable journal cursor receipts/<slug> (last completion timestamp handled)
#     → enumerate the repo's terminally-closed PRs newest-first (authoritative REST)
#     → keep PRs completed AFTER the cursor (first run seeds the cursor to now and
#       posts NOTHING historical — receipts are for work completed GOING FORWARD)
#     → drop PRs the garden did not work (no jobs/index identity, panel-runs, or
#       gauntlet-archived record naming the PR)
#     → drop PRs that already have a receipt (journal archive file, OR the
#       <!-- garden-receipt: repo#N --> comment marker)
#     → post <slug>-pr<N>-receipt (idempotent by basename via post-job.sh)
#     → advance the cursor to the newest completion fully handled this tick.
#
# The per-PR gh reads are indirected so a test can substitute a deterministic stub:
#   GARDEN_RECEIPT_PR_SOURCE <owner/name>       -> TSV: number state completed_at (ISO)
#   GARDEN_RECEIPT_POST      <basename> <file>  (post-job.sh)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

slug="${1:?usage: receipt-watcher.sh <repo-slug>}"
export GARDEN_TAG="receipt-watcher/$slug"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_RECEIPT_PR_SOURCE:=$HERE/handlers/receipt-pr-source-gh.sh}"
: "${GARDEN_RECEIPT_POST:=$HERE/post-job.sh}"
: "${GARDEN_RECEIPT_WATCH_CLONE:=$GARDEN_STATE/receipt-watcher/journal}"
# On the very first tick (no cursor yet), seed the cursor this far back rather than to
# "now", so a just-completed PR from the last day or two is still picked up — but the
# whole historical backlog is NOT flooded as live comments. Empty ⇒ seed to now.
: "${GARDEN_RECEIPT_SEED_WINDOW:=2 days}"
: "${GARDEN_RECEIPT_SOURCE_TIMEOUT_SECS:=180}"
: "${GARDEN_RECEIPT_KILL_AFTER:=10s}"

fleet_draining && { log "fleet draining; skipping"; exit 0; }
api_cooldown_active && exit 0

owner="${slug%%-*}"; name="${slug#*-}"
repo="$owner/$name"
[ "$owner" != "$slug" ] && [ -n "$name" ] || die "cannot derive owner/name from slug '$slug'"

DIR="$GARDEN_RECEIPT_WATCH_CLONE"
ensure_clone "$DIR"
sync_clone "$DIR" || { log "WARN: journal sync failed — skipping tick (never guess board state)"; exit 0; }

# --- garden_worked_pr <n> : cheap "did the garden touch this PR" gate ---------
# True when a jobs/index identity names repo#n, OR a panel-runs / gauntlet-archived
# record for the PR exists. Deterministic, journal-local, no gh. Keeps the watcher
# from minting receipt jobs for PRs the garden never worked (a foreign merge).
garden_worked_pr() {
  local n="$1"
  [ -d "$DIR/panel-runs/$slug-$n" ] && return 0
  [ -d "$DIR/panel-runs/$slug-pr$n" ] && return 0
  if [ -d "$DIR/jobs/gauntlet-archived" ] && \
     ls "$DIR/jobs/gauntlet-archived/"*"pr$n"* >/dev/null 2>&1; then return 0; fi
  if [ -d "$DIR/jobs/index" ] && \
     grep -rlE "^identity:[[:space:]]*$repo#$n([^0-9]|$)" "$DIR/jobs/index" >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

# --- receipt_exists <n> : idempotency — a receipt already produced -----------
# Journal archive file present is the cheap first guard; the PR-comment marker is the
# authoritative second (a posted-but-not-archived crash). We check the journal file
# here (cheap, no gh); the generator re-checks the comment marker before posting, so a
# missing-file-but-present-marker case is still deduped downstream.
receipt_exists() {
  local n="$1"
  ls "$DIR/receipts/$slug/"*/*/"pr$n.md" >/dev/null 2>&1 && return 0
  return 1
}

# --- cursor (last completion timestamp handled) ------------------------------
cursor_raw="$("$HERE/cursor-get.sh" "receipts/$slug" 2>/dev/null || true)"
cursor="$(printf '%s' "$cursor_raw" | sed -n 's/^last_completed_at:[[:space:]]*//p' | head -1)"
if [ -z "$cursor" ]; then
  # First tick: seed and post nothing historical.
  if [ -n "${GARDEN_RECEIPT_SEED_WINDOW:-}" ]; then
    cursor="$(date -u -d "-${GARDEN_RECEIPT_SEED_WINDOW}" +%FT%TZ 2>/dev/null || date -u +%FT%TZ)"
  else
    cursor="$(date -u +%FT%TZ)"
  fi
  printf 'last_completed_at: %s\n' "$cursor" | "$HERE/cursor-set.sh" "receipts/$slug" >/dev/null 2>&1 || true
  log "first tick on $repo — seeded receipt cursor to $cursor (no historical backfill)"
fi

# --- enumerate terminally-closed PRs (bounded, reaped source) ----------------
SRC="$(mktemp)"; ERRF="$(mktemp)"; SRC_PID=""
cleanup() {
  rm -f "$SRC" "$ERRF"
  local pid="$SRC_PID"; SRC_PID=""
  [ -n "$pid" ] || return 0
  kill -TERM "-$pid" 2>/dev/null || kill -TERM "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
  kill -KILL "-$pid" 2>/dev/null || true
}
trap 'cleanup' EXIT
trap 'cleanup; exit 143' TERM
trap 'cleanup; exit 130' INT

src_rc=0
if command -v timeout >/dev/null 2>&1; then
  timeout --signal=TERM --kill-after="$GARDEN_RECEIPT_KILL_AFTER" "${GARDEN_RECEIPT_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_RECEIPT_PR_SOURCE" "$repo" > "$SRC" 2>"$ERRF" &
  SRC_PID=$!
  wait "$SRC_PID" || src_rc=$?
  SRC_PID=""
else
  "$GARDEN_RECEIPT_PR_SOURCE" "$repo" > "$SRC" 2>"$ERRF" || src_rc=$?
fi
if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  if is_transient_net_error "$ERRF" || is_transient_gh_source_error "$ERRF"; then
    start_api_cooldown "receipt:$slug" >/dev/null 2>&1 || true
    log "WARN: receipt PR source hit a transient network/gh blip — skipping tick (never guess)"
    exit 0
  fi
  die "receipt PR source failed for $repo (rc=$src_rc; see source stderr above)"
fi

# --- process candidates (oldest completion first; advance cursor as we go) ----
# The source emits `number<TAB>state<TAB>completed_at` newest-first. Sort ascending by
# completion so the cursor advances monotonically and a mid-tick post failure leaves
# the cursor BEFORE the unhandled PR (retried next tick).
scanned=0; worked=0; posted=0; skipped=0; newcur="$cursor"
while IFS=$'\t' read -r num st done_at; do
  [ -n "$num" ] || continue
  case "$num" in *[!0-9]*) continue ;; esac
  scanned=$((scanned+1))
  # Only PRs completed strictly after the cursor.
  [ -n "$done_at" ] || continue
  if ! [ "$done_at" \> "$cursor" ]; then continue; fi
  if ! garden_worked_pr "$num"; then
    log "#$num ($st) completed but the garden did not work it (no index/panel/gauntlet record) — skip"
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
    continue
  fi
  worked=$((worked+1))
  if receipt_exists "$num"; then
    log "#$num already has a journal receipt — idempotent skip"
    skipped=$((skipped+1))
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
    continue
  fi
  base="$slug-pr$num-receipt"
  jb="$(mktemp)"
  {
    printf '# receipt (auto) — completion receipt for %s PR #%s (%s)\n\n' "$repo" "$num" "$st"
    printf 'tier: mentor\nfallback-tier: minion\n\n'
    printf 'This OPEN-and-now-%s PR was completed by the garden. Emit its COMPLETION\n' "$st"
    printf 'RECEIPT deterministically — run the generator, which builds the per-engagement\n'
    printf 'rows + the maintainer-review heuristic, posts the PR comment (identity-pinned\n'
    printf 'gh), and archives the receipt in the journal, all idempotently:\n\n'
    printf '    scripts/jobs/pr-receipt.sh %s %s\n\n' "$repo" "$num"
    printf 'It is fail-open and idempotent (journal archive file + comment marker guards),\n'
    printf 'so a re-run never double-posts. Report the archive path and the posted comment\n'
    printf 'URL. See designs/pr-completion-receipts.md and scripts/jobs/pr-receipt.sh.\n\n'
    printf 'PR: https://github.com/%s/pull/%s\n' "$repo" "$num"
  } > "$jb"
  if "$GARDEN_RECEIPT_POST" "$base" "$jb" >/dev/null 2>&1; then
    log "posted $base (auto-receipt on completed #$num)"
    posted=$((posted+1))
    [ "$done_at" \> "$newcur" ] && newcur="$done_at"
  else
    log "WARN: post of $base did not land — leaving cursor before #$num for retry next tick"
    rm -f "$jb"
    break
  fi
  rm -f "$jb"
done < <(sort -t"$(printf '\t')" -k3,3 "$SRC")

if [ "$newcur" \> "$cursor" ]; then
  printf 'last_completed_at: %s\n' "$newcur" | "$HERE/cursor-set.sh" "receipts/$slug" >/dev/null 2>&1 \
    && log "advanced receipt cursor for $slug to $newcur"
fi
log "scanned $scanned closed PR(s) on $repo since $cursor: $worked garden-worked, $posted receipt job(s) posted, $skipped already-receipted"
