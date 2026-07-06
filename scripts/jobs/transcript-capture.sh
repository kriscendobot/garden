#!/bin/bash
# transcript-capture.sh — the per-tick transcript sweep (runs on EVERY host).
#
# Design: designs/transcript-journal-capture.md (Decision 2). Operator page:
# context/operations/transcripts.md. Each tick, in this fixed order:
#
#   1. Reconcile Claude Code's `cleanupPeriodDays` to 36500 ("effectively never")
#      into ~/.claude/settings.json — UNCONDITIONALLY, first, whether or not the
#      archive is armed. settings.json is gitignored so it cannot propagate via
#      git; this idempotent read-modify-write is how every existing host converges
#      on deletion-disabled (the launcher seed covers only new instances).
#   2. Read config/transcripts-remote from the synced journal. Absent → the
#      archive is UNARMED: log inert and exit 0. The spool keeps accumulating and
#      nothing is lost; only the push is gated.
#   3. Ensure the per-host capture clone of the transcripts2 orphan branch.
#   4. Drain the spool + sweep idle/changed ~/.claude/projects sessions, each
#      through redact_stream then gzip -n, into
#      transcripts/<GARDEN>/<encoded-cwd>/<session-id>.jsonl.gz with an appended
#      index/<GARDEN>.tsv row.
#   5. Nothing new → quiet one-liner, exit 0. Else commit + CAS push (fetch/reset/
#      reapply, verified). Per-host paths are disjoint, so a retry always applies.
#   6. ONLY after a verified push: clear the drained spool entries and update the
#      ledger. Local originals under ~/.claude/projects are left untouched.
#
# It reads only our own transcripts and invokes no LLM, so the monitoring-safety
# constraint does not apply and it runs on every host (no is-main-host gate).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="transcript-capture"

require_tools git gzip jq sed

# --- 1. reconcile cleanupPeriodDays (unconditional, first) -------------------
# read-modify-write via jq so Claude Code's other keys (theme, …) survive — the
# CLI rewrites this file, so a template overwrite would clobber it. Atomic mv;
# create-if-absent. Never fatal: a malformed settings.json is logged and skipped
# rather than crash-looping the timer.
: "${GARDEN_CLAUDE_SETTINGS:=$HOME/.claude/settings.json}"
reconcile_settings() {
  local f="$GARDEN_CLAUDE_SETTINGS" tmp cur
  mkdir -p "$(dirname "$f")" 2>/dev/null || true
  if [ -f "$f" ]; then
    cur="$(jq -r '.cleanupPeriodDays // empty' "$f" 2>/dev/null || true)"
    [ "$cur" = "36500" ] && return 0
    tmp="$(mktemp "${f}.XXXXXX" 2>/dev/null)" || { log "WARN: reconcile: mktemp failed for $f"; return 0; }
    if jq '.cleanupPeriodDays = 36500' "$f" > "$tmp" 2>/dev/null && [ -s "$tmp" ]; then
      mv -f "$tmp" "$f" && log "reconciled cleanupPeriodDays=36500 in $f"
    else
      rm -f "$tmp" 2>/dev/null || true
      log "WARN: reconcile: could not rewrite $f (malformed JSON?); leaving it untouched"
    fi
  else
    tmp="$(mktemp "${f}.XXXXXX" 2>/dev/null)" || { log "WARN: reconcile: mktemp failed for $f"; return 0; }
    if printf '{\n  "cleanupPeriodDays": 36500\n}\n' > "$tmp"; then
      mv -f "$tmp" "$f" && log "created $f with cleanupPeriodDays=36500"
    else
      rm -f "$tmp" 2>/dev/null || true
    fi
  fi
}
reconcile_settings

# --- 2. read the armed transcripts remote from the journal -------------------
# Same read path the issue-inbox config uses: a dedicated journal clone, a
# best-effort bounded fetch, then `git show origin/journal2:config/…`. A missing
# config means UNARMED — not an error. GARDEN_TRANSCRIPTS_REMOTE overrides for
# tests (skips the journal read entirely).
JCLONE="${GARDEN_TRANSCRIPTS_JOURNAL:-$GARDEN_STATE/transcripts/journal}"
read_remote() {
  if [ -n "${GARDEN_TRANSCRIPTS_REMOTE:-}" ]; then
    printf '%s\n' "$GARDEN_TRANSCRIPTS_REMOTE"; return 0
  fi
  ensure_clone "$JCLONE"
  journal_fetch "$JCLONE" >/dev/null 2>&1 || true
  git -C "$JCLONE" show "origin/$JOURNAL_BRANCH:config/transcripts-remote" 2>/dev/null \
    | sed -e 's/#.*//' | tr -d '[:space:]' | head -1
}
REMOTE="$(read_remote || true)"
if [ -z "$REMOTE" ]; then
  log "inert: no config/transcripts-remote set (run set-transcripts-remote.sh <url> to arm); spooling continues, pushing nothing"
  exit 0
fi

# --- redaction (defense in depth behind the private remote) ------------------
# Deterministic secret masking applied to every stored transcript. One growable
# list of shapes; each keeps a short identifying prefix and replaces the token
# tail with …REDACTED. Residual risk (shapes the list does not know) is accepted;
# the private remote is the primary guarantee. LC_ALL=C keeps sed byte-oriented.
redact_stream() {
  LC_ALL=C sed -E \
    -e 's/(gh[pousr]_)[A-Za-z0-9]{20,}/\1…REDACTED/g' \
    -e 's/(github_pat_)[A-Za-z0-9_]{20,}/\1…REDACTED/g' \
    -e 's/(sk-ant-)[A-Za-z0-9-]{20,}/\1…REDACTED/g' \
    -e 's/([Aa]uthorization: [Bb]earer )[A-Za-z0-9._~+/=-]+/\1…REDACTED/g'
}

BRANCH="$GARDEN_TRANSCRIPTS_BRANCH"
CLONE="${GARDEN_TRANSCRIPTS_CLONE:-$GARDEN_STATE/transcripts/clone}"
LEDGER="${GARDEN_TRANSCRIPT_LEDGER:-$GARDEN_STATE/transcripts/captured.tsv}"
SPOOL="$GARDEN_TRANSCRIPTS_SPOOL"

# --- 3. ensure the per-host capture clone of transcripts2 --------------------
# Shape: --single-branch --branch transcripts2 --filter=blob:none + sparse
# checkout of only THIS host's subtree, so the working copy stays small however
# large the fleet corpus grows. A plain single-branch clone is an acceptable
# degraded mode when the remote lacks partial-clone. If the branch does not exist
# on the remote yet, init a local orphan; the first push creates it. A genuine
# connectivity outage skips the tick cleanly.
ls_branch() {  # 0 = branch present on remote, 1 = absent, 75 = network outage
  local out err
  err="$(mktemp)"; out="$(git ls-remote --heads "$REMOTE" "$BRANCH" 2>"$err" || true)"
  if [ -s "$err" ] && is_transient_net_error "$err"; then rm -f "$err"; return 75; fi
  rm -f "$err"
  [ -n "$out" ]
}
sparse_set() {
  git -C "$CLONE" sparse-checkout set "transcripts/$GARDEN" "index/$GARDEN" >/dev/null 2>&1 || true
}
init_orphan() {
  rm -rf "$CLONE"; mkdir -p "$CLONE"
  git -C "$CLONE" init -q
  git -C "$CLONE" checkout -q --orphan "$BRANCH"
  git -C "$CLONE" remote add origin "$REMOTE" 2>/dev/null \
    || git -C "$CLONE" remote set-url origin "$REMOTE"
}
ensure_clone_ready() {
  local rc
  if [ -d "$CLONE/.git" ]; then
    git -C "$CLONE" remote set-url origin "$REMOTE" 2>/dev/null \
      || git -C "$CLONE" remote add origin "$REMOTE" 2>/dev/null || true
  else
    rm -rf "$CLONE" 2>/dev/null || true
    mkdir -p "$(dirname "$CLONE")"
    if ls_branch; then rc=0; else rc=$?; fi
    if [ "$rc" -eq 75 ]; then
      log "offline: cannot reach transcripts remote; skipping tick (spool retained)"
      exit 0
    fi
    if [ "$rc" -eq 0 ]; then
      local tmp="${CLONE}.tmp.$$"; rm -rf "$tmp"
      if git clone -q --single-branch --branch "$BRANCH" --filter=blob:none "$REMOTE" "$tmp" 2>/dev/null \
         || git clone -q --single-branch --branch "$BRANCH" "$REMOTE" "$tmp" 2>/dev/null; then
        mv "$tmp" "$CLONE"
        git -C "$CLONE" sparse-checkout init >/dev/null 2>&1 || true
        sparse_set
      else
        rm -rf "$tmp"
        log "WARN: clone of $REMOTE ($BRANCH) failed though the branch exists; initializing a fresh orphan"
        init_orphan
      fi
    else
      log "transcripts2 branch absent on $REMOTE; initializing a local orphan (first push creates it)"
      init_orphan
    fi
  fi
  git -C "$CLONE" config user.name  "$(bot_name)"
  git -C "$CLONE" config user.email "$(bot_email)"
}

# reset the working clone to the remote tip (best-effort). Returns 0 when ready.
sync_transcripts() {
  git -C "$CLONE" fetch -q --filter=blob:none origin "$BRANCH" 2>/dev/null \
    || git -C "$CLONE" fetch -q origin "$BRANCH" 2>/dev/null || true
  if git -C "$CLONE" rev-parse --verify -q "refs/remotes/origin/$BRANCH" >/dev/null 2>&1; then
    git -C "$CLONE" reset -q --hard "origin/$BRANCH" 2>/dev/null || true
    sparse_set
  fi
}

ensure_clone_ready
sync_transcripts

# --- 4. drain the spool + sweep idle/changed sessions ------------------------
# Everything is staged into a tmp workdir FIRST (redacted, gzipped), together with
# the index rows, ledger updates, and the spool files to clear. The push loop then
# copies the staged blobs into the clone tree, so a CAS retry re-applies from the
# same staging without re-reading/re-redacting the sources.
WORK="$(mktemp -d "${TMPDIR:-/tmp}/transcap.XXXXXX")"
cleanup() { rm -rf "$WORK" 2>/dev/null || true; }
trap cleanup EXIT
mkdir -p "$WORK/blobs"

CAPTURED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || echo -)"
NOW_EPOCH="$(date +%s 2>/dev/null || echo 0)"
IDLE="${GARDEN_TRANSCRIPT_IDLE_SECS:-21600}"

# Staging state, index N.
n=0
declare -a ST_DEST=()        # dest rel path in the clone
declare -a ST_BLOB=()        # staged gz blob in $WORK
declare -a ST_ROW=()         # index/<GARDEN>.tsv row
declare -a ST_LEDGERKEY=()   # ledger key (live sweep only; '' for spool)
declare -a ST_LEDGERVAL=()   # ledger value (raw_bytes<TAB>raw_mtime)
declare -a ST_SPOOL=()       # spool .gz to delete after push ('' for live)
declare -a ST_PENDING=()     # pending.tsv identity "sid<TAB>encoded_cwd" ('' for live)
declare -a ST_DROP_PENDING=() # stale pending rows (blob vanished) to drop after push

# stage <encoded_cwd> <sid> <base> <raw_bytes> <raw_mtime|-> <spool_gz|''> <pending_id|''>
# reads the DECOMPRESSED, un-redacted transcript on stdin; redacts + gzips it into
# the staging area and records all the parallel-array bookkeeping.
stage() {
  local enc="$1" sid="$2" base="$3" raw="$4" mtime="$5" spool="$6" pending="$7"
  local blob="$WORK/blobs/$n.gz" gzb
  redact_stream | gzip -n > "$blob" 2>/dev/null || { log "WARN: stage: redact/gzip failed for $sid"; return 0; }
  gzb="$(stat -c %s "$blob" 2>/dev/null || echo 0)"
  ST_DEST[$n]="transcripts/$GARDEN/$enc/$sid.jsonl.gz"
  ST_BLOB[$n]="$blob"
  ST_ROW[$n]="$(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s' "$CAPTURED_AT" "$sid" "${base:--}" "$enc" "$raw" "$gzb" "$mtime")"
  ST_LEDGERKEY[$n]=""             # live sweep overwrites this after the call; '' = spool
  ST_LEDGERVAL[$n]=""
  ST_SPOOL[$n]="$spool"
  ST_PENDING[$n]="$pending"
  n=$((n+1))
}

# --- 4a. drain the spool -----------------------------------------------------
# pending.tsv rows: spooled_at  session_id  job_base(or -)  encoded_cwd. The gz
# blob is at $SPOOL/<encoded_cwd>/<sid>.jsonl.gz. Decompress → stage (which
# redacts). raw_mtime is unknown for a spooled session (the original was rm'd), so
# it is recorded as '-'; raw_bytes is the decompressed size.
if [ -f "$SPOOL/pending.tsv" ]; then
  while IFS=$'\t' read -r sp_at sid base enc; do
    [ -n "${sid:-}" ] && [ -n "${enc:-}" ] || continue
    local_gz="$SPOOL/$enc/$sid.jsonl.gz"
    if [ ! -f "$local_gz" ]; then
      log "WARN: spool row for $sid/$enc has no blob at $local_gz; dropping the stale row"
      ST_DROP_PENDING+=("$sid"$'\t'"$enc")
      continue
    fi
    raw="$(gzip -dc -- "$local_gz" 2>/dev/null | wc -c | tr -d ' ')"
    # Feed via process substitution, NOT a pipe: a `... | stage` runs stage in a
    # subshell and its parallel-array writes would be lost.
    stage "$enc" "$sid" "${base:--}" "${raw:-0}" "-" "$local_gz" "$sid"$'\t'"$enc" \
      < <(gzip -dc -- "$local_gz" 2>/dev/null)
  done < "$SPOOL/pending.tsv"
fi

# --- 4b. sweep idle/changed live sessions ------------------------------------
# Load the ledger (encoded_cwd/session_id -> raw_bytes<TAB>raw_mtime) so an
# unchanged, already-captured session is skipped; a grown session (bytes/mtime
# differ) is re-captured, overwriting the same path.
declare -A LEDGER_BYTES=() LEDGER_MTIME=()
if [ -f "$LEDGER" ]; then
  while IFS=$'\t' read -r key lb lm; do
    [ -n "${key:-}" ] || continue
    LEDGER_BYTES["$key"]="$lb"; LEDGER_MTIME["$key"]="$lm"
  done < "$LEDGER"
fi

PROJECTS="${GARDEN_CLAUDE_PROJECTS:-$HOME/.claude/projects}"
if [ -d "$PROJECTS" ]; then
  while IFS= read -r -d '' jsonl; do
    enc="$(basename "$(dirname "$jsonl")")"
    sid="$(basename "$jsonl" .jsonl)"
    mtime="$(stat -c %Y "$jsonl" 2>/dev/null || echo 0)"
    # idle gate: skip a session still being written (mtime within the window).
    [ $(( NOW_EPOCH - mtime )) -ge "$IDLE" ] 2>/dev/null || continue
    raw="$(stat -c %s "$jsonl" 2>/dev/null || echo 0)"
    key="$enc/$sid"
    # new-or-changed gate: skip if the ledger already has this exact size+mtime.
    if [ "${LEDGER_BYTES[$key]:-}" = "$raw" ] && [ "${LEDGER_MTIME[$key]:-}" = "$mtime" ]; then
      continue
    fi
    # back-derive a job base from the gardener-wt-<base> directory-name pattern.
    case "$enc" in
      *gardener-wt-*) base="${enc##*gardener-wt-}" ;;
      *) base="-" ;;
    esac
    redact_in="$jsonl"
    stage "$enc" "$sid" "$base" "$raw" "$mtime" "" "" < "$redact_in"
    # record the ledger update for AFTER a verified push.
    ST_LEDGERKEY[$((n-1))]="$key"
    ST_LEDGERVAL[$((n-1))]="$(printf '%s\t%s' "$raw" "$mtime")"
  done < <(find "$PROJECTS" -type f -name '*.jsonl' -print0 2>/dev/null)
fi

# --- 5. nothing new → quiet exit ---------------------------------------------
if [ "$n" -eq 0 ]; then
  log "nothing to capture (spool empty, no idle/changed sessions)"
  exit 0
fi

# --- copy staged blobs + append index rows into the clone tree ---------------
apply_staged() {
  local i dest
  for (( i=0; i<n; i++ )); do
    dest="$CLONE/${ST_DEST[$i]}"
    mkdir -p "$(dirname "$dest")"
    cp -f "${ST_BLOB[$i]}" "$dest"
    git -C "$CLONE" add -- "${ST_DEST[$i]}" 2>/dev/null || true
  done
  # index rows are per-host (index/<GARDEN>.tsv), append-only, so a peer on another
  # host never conflicts; re-append onto the freshly-reset origin copy each retry.
  mkdir -p "$CLONE/index"
  for (( i=0; i<n; i++ )); do
    printf '%s\n' "${ST_ROW[$i]}" >> "$CLONE/index/$GARDEN.tsv"
  done
  git -C "$CLONE" add -- "index/$GARDEN.tsv" 2>/dev/null || true
}

# --- push with a fetch/reset/reapply CAS retry, verified ---------------------
push_transcripts() {  # test seam mirrors _push_journal's GARDEN_PUSH_CMD
  if [ -n "${GARDEN_TRANSCRIPTS_PUSH_CMD:-}" ]; then
    GARDEN_TRANSCRIPTS_PUSH_DIR="$CLONE" GARDEN_TRANSCRIPTS_PUSH_BRANCH="$BRANCH" \
      GARDEN_TRANSCRIPTS_PUSH_REMOTE="$REMOTE" "$GARDEN_TRANSCRIPTS_PUSH_CMD"
  else
    git -C "$CLONE" push -q origin "HEAD:$BRANCH" 2>/dev/null
  fi
}
verify_pushed() {
  local head remote
  head="$(git -C "$CLONE" rev-parse HEAD 2>/dev/null)" || return 1
  git -C "$CLONE" fetch -q origin "$BRANCH" 2>/dev/null || return 1
  remote="$(git -C "$CLONE" rev-parse "origin/$BRANCH" 2>/dev/null)" || return 1
  [ "$head" = "$remote" ] && return 0
  git -C "$CLONE" merge-base --is-ancestor "$head" "$remote" 2>/dev/null
}

pushed=0
for attempt in $(seq 1 "${GARDEN_TRANSCRIPTS_PUSH_RETRIES:-8}"); do
  sync_transcripts
  apply_staged
  if ! git -C "$CLONE" diff --cached --quiet 2>/dev/null; then
    git -C "$CLONE" commit -q -m "transcripts($GARDEN): capture $n session(s) at $CAPTURED_AT" || true
  fi
  if push_transcripts && verify_pushed; then pushed=1; break; fi
  log "push race/verify miss on transcripts2 (attempt $attempt); re-syncing"
  backoff "$attempt"
done

if [ "$pushed" -ne 1 ]; then
  log "WARN: could not land transcript capture after retries; spool + ledger untouched, will retry next tick"
  exit 0
fi

# --- 6. after a VERIFIED push: clear spool entries + update the ledger --------
# Clear the drained spool blobs, rewrite pending.tsv without the drained rows, and
# fold the live-sweep ledger updates in. Everything below is post-success cleanup;
# a failure here only re-captures next tick (idempotent overwrite), never loses.
declare -A DRAINED_PENDING=()
for (( i=0; i<n; i++ )); do
  if [ -n "${ST_SPOOL[$i]:-}" ]; then
    rm -f "${ST_SPOOL[$i]}" 2>/dev/null || true
    [ -n "${ST_PENDING[$i]:-}" ] && DRAINED_PENDING["${ST_PENDING[$i]}"]=1
  fi
  if [ -n "${ST_LEDGERKEY[$i]:-}" ]; then
    LEDGER_BYTES["${ST_LEDGERKEY[$i]}"]="${ST_LEDGERVAL[$i]%%$'\t'*}"
    LEDGER_MTIME["${ST_LEDGERKEY[$i]}"]="${ST_LEDGERVAL[$i]##*$'\t'}"
  fi
done
# also drop any stale pending rows whose blob had vanished.
for pid in "${ST_DROP_PENDING[@]:-}"; do [ -n "$pid" ] && DRAINED_PENDING["$pid"]=1; done

# rewrite pending.tsv without the drained/dropped rows.
if [ -f "$SPOOL/pending.tsv" ]; then
  ptmp="$(mktemp "${SPOOL}/pending.XXXXXX" 2>/dev/null)" || ptmp=""
  if [ -n "$ptmp" ]; then
    while IFS=$'\t' read -r sp_at sid base enc; do
      [ -n "${sid:-}" ] && [ -n "${enc:-}" ] || continue
      [ -n "${DRAINED_PENDING["$sid"$'\t'"$enc"]:-}" ] && continue
      printf '%s\t%s\t%s\t%s\n' "$sp_at" "$sid" "$base" "$enc"
    done < "$SPOOL/pending.tsv" > "$ptmp"
    mv -f "$ptmp" "$SPOOL/pending.tsv" 2>/dev/null || rm -f "$ptmp" 2>/dev/null || true
  fi
  # prune now-empty per-encoding spool dirs (best-effort).
  find "$SPOOL" -mindepth 1 -type d -empty -delete 2>/dev/null || true
fi

# rewrite the ledger from the merged map.
mkdir -p "$(dirname "$LEDGER")" 2>/dev/null || true
ltmp="$(mktemp "${LEDGER}.XXXXXX" 2>/dev/null)" || ltmp=""
if [ -n "$ltmp" ]; then
  for key in "${!LEDGER_BYTES[@]}"; do
    printf '%s\t%s\t%s\n' "$key" "${LEDGER_BYTES[$key]}" "${LEDGER_MTIME[$key]:-0}"
  done > "$ltmp"
  mv -f "$ltmp" "$LEDGER" 2>/dev/null || rm -f "$ltmp" 2>/dev/null || true
fi

log "captured $n transcript session(s) → $BRANCH on $REMOTE"
exit 0
