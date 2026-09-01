#!/bin/bash
# panel-run-record.sh — the deterministic writer for the COMPACT panel-run record
# on journal2. The scripted review panel (scripts/jobs/gardening/panel.sh) is the
# garden's primary evaluator, yet it left NO durable evidence: every per-seat
# verdict, per-round aggregate, and the appellate block went to a scratch rundir
# that is torn down with the job's worktree. Nothing in the journal recorded which
# seats reviewed which PR, how many fix-loop rounds a PR took, or what the must-fix
# items were — so "is our review process being satisfied rather than served?" was
# unanswerable from the journal (issue #62 follow-up, @jcorbin's cross-analysis).
#
# This is the WRITER half, in the single-writer discipline of reputation.sh /
# review-miss-record.sh: plain deterministic code, NO `claude -p`. panel.sh gathers
# the facts into the rundir as it runs (a `record-meta` file + the per-round seat
# blocks and head sha it already writes), then invokes this writer BEST-EFFORT on
# termination. This script reads the rundir, derives a COMPACT record (verdict
# CLASS per seat only — never the seat's prose — plus a bounded, truncated title
# per must-fix item), and CAS-pushes ONE file per run to the journal.
#
# Design contract:
#  * BOUNDED SIZE. Seat prose stays in the rundir. The record carries only verdict
#    classes and truncated must-fix titles (<=120 chars each, <=20 items/round), so
#    thousands of runs do not bloat journal2 — the abundance failure mode we are
#    trying not to reproduce.
#  * INJECTION HYGIENE. Must-fix titles are LLM-authored text ABOUT a third-party
#    diff: they are DATA. They are truncated and collapsed to a single line and
#    written to a file — NEVER interpolated into a later prompt as instruction.
#  * BEST-EFFORT, NEVER FATAL. A failed journal push logs a WARN and exits 0; it
#    must never fail the panel or block an un-draft. panel.sh also invokes this
#    with `|| true`, so both layers are belt-and-suspenders.
#  * QUIET. The record is a file write. This writer prints nothing to stdout on the
#    happy path (a `log` line goes to stderr); panel.sh routes its stdout to
#    /dev/null so routine records never reach the supervisor's context.
#
# Store layout (journal2 top level):
#   panel-runs/
#     <owner>-<repo>-<pr>/<run-id>.md   # one compact record per panel run
#
# Usage:
#   panel-run-record.sh emit <rundir>
#     Read <rundir>/record-meta and the per-round seat blocks, compose the compact
#     record, and CAS-push it. Re-emitting an identical run is an idempotent no-op
#     (the run-id is derived from the run's identity + per-round head shas, so an
#     unchanged re-run overwrites to byte-identical content and pushes nothing).
#
#   panel-run-record.sh migrate [--dry-run]
#     Reunite the store's LEGACY-SLUG split. Before the origin-URL strip reduced
#     every remote form to one `<owner>/<repo>` key (commit "reduce every origin-URL
#     form to one record store key"), a worktree whose origin git reported as
#     `ssh://git@github.com/<owner>/<repo>.git` (the fleet's actual form, via the
#     hosts' `url.ssh://git@github.com/.insteadOf https://github.com/`) keyed its
#     runs under a DIFFERENT directory, `panel-runs/ssh---git-github.com-<owner>-<repo>-<pr>/`,
#     so one repository accumulated two disjoint archives and a query by repo saw
#     half its history. That fix stopped the split WIDENING but left the already-split
#     records where they lay. This subcommand moves each legacy directory's records
#     into the canonical `panel-runs/<owner>-<repo>-<pr>/` (the legacy name with the
#     fixed `ssh---git-github.com-` prefix stripped is exactly the canonical slug),
#     as a git MV that preserves history and CAS-pushes one commit. It is:
#       * IDEMPOTENT — a second run finds no legacy directory and pushes nothing.
#       * COLLISION-SAFE — a legacy record whose filename already exists in the
#         canonical directory with DIFFERING bytes is REFUSED (left in place, WARNed);
#         an identical duplicate is deduped (the legacy copy git-removed). No record
#         is ever overwritten or lost.
#       * CAS-SAFE — the move is composed against a fresh sync and pushed under the
#         same rebase-retry loop as `emit`, so it races other journal writers safely.
#     `--dry-run` reports what it would move/dedupe/refuse and pushes nothing.
#     Deterministic, no `claude -p`; a schedule or a one-shot invocation reunites the
#     archive without an agent hand-editing journal2.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="panel-run"

STORE="panel-runs"
DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"

usage() { awk 'NR>1 && /^#/{sub(/^# ?/,"");print;next} NR>1{exit}' "$0"; }

# --- small deterministic primitives ------------------------------------------

# sanitize <s> — collapse anything outside [A-Za-z0-9._-] to '-' so a slug is a
# single safe path segment.
sanitize() { printf '%s' "${1:-}" | tr -c 'A-Za-z0-9._-' '-'; }

# meta <key> — read `key=value` from the rundir's record-meta file (first match).
meta() { sed -n "s/^$2=//p" "$1/record-meta" 2>/dev/null | head -1; }

# classify_seat <block-file> -> pass | must-fix | comment | error
# The seat's own Verdict line is the signal (approve / request-changes /
# comment-only). An unrecognized-but-non-empty block is a non-blocking `comment`;
# an empty block is an `error` (panel.sh fails such a seat loudly before we get
# here, but the classifier stays defensive).
classify_seat() {
  local v
  v="$(grep -iE 'verdict' "$1" 2>/dev/null | head -1 | tr '[:upper:]' '[:lower:]')"
  case "$v" in
    *request-change*|*'request change'*|*must-fix*|*'must fix'*) printf 'must-fix' ;;
    *approve*)                                                   printf 'pass' ;;
    *comment-only*|*'comment only'*)                             printf 'comment' ;;
    *) if grep -q '[^[:space:]]' "$1" 2>/dev/null; then printf 'comment'; else printf 'error'; fi ;;
  esac
}

# seat_titles <block-file> — the must-fix finding TITLES from one seat's block, as
# DATA: each finding line (a `-`/`*`/numbered bullet) collapsed to one line and
# truncated. The Verdict line is excluded. If no bullet is found, the first
# non-blank, non-Verdict line is used as a single fallback title. Never emits more
# than a few lines here; the round-level cap of <=20 is applied by the caller.
seat_titles() {
  awk '
    function emit(s) {
      gsub(/[[:cntrl:]]/, " ", s);            # strip control chars (defensive)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", s);
      gsub(/[[:space:]]+/, " ", s);
      if (s == "") return;
      if (length(s) > 120) s = substr(s, 1, 117) "...";
      print s;
    }
    tolower($0) ~ /verdict/ { next }                       # never treat the verdict line as a finding
    /^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]+/ {
      line = $0;
      sub(/^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]+/, "", line);
      emit(line); found++; next;
    }
    { if (fallback == "" && $0 ~ /[^[:space:]]/) fallback = $0 }
    END { if (!found && fallback != "") emit(fallback) }
  ' "$1" 2>/dev/null
}

# --- emit --------------------------------------------------------------------
cmd_emit() {
  local rundir="${1:?usage: panel-run-record.sh emit <rundir>}"
  [ -d "$rundir" ] || { log "WARN: rundir '$rundir' absent; nothing to record"; return 0; }

  local repo pr panel_kind base disp app_ran app_count
  repo="$(meta "$rundir" repo)";           pr="$(meta "$rundir" pr)"
  panel_kind="$(meta "$rundir" panel_kind)"; base="$(meta "$rundir" base_ref)"
  disp="$(meta "$rundir" disposition)"
  app_ran="$(meta "$rundir" appellate_ran)"; app_count="$(meta "$rundir" appellate_count)"
  [ -n "$repo" ] || repo="$(basename "$rundir")"
  [ -n "$pr" ]   || pr="0"
  [ -n "$panel_kind" ] || panel_kind="code"
  [ -n "$disp" ] || disp="error"

  # Round count + per-round head shas from the rundir (authoritative — panel.sh
  # writes round-<r>.md aggregates and round-<r>.head as it runs). Globbing avoids
  # trusting a possibly-stale meta round count across the max-rounds fail path.
  local rounds=0 r
  for r in $(seq 1 "${GARDEN_PANEL_MAX_ROUNDS:-8}"); do
    [ -f "$rundir/round-$r.md" ] && rounds="$r"
  done

  # Build the compact body and collect all head shas (for the run-id hash).
  local body="" allheads="" mf_total=0
  for r in $(seq 1 "$rounds"); do
    local head verdicts="" seat_count=0 mf_lines="" mf_count=0 seat cls block hsha
    head="$(cat "$rundir/round-$r.head" 2>/dev/null | head -1 | tr -dc 'A-Za-z0-9')"
    [ -n "$head" ] || head="unknown"
    allheads="$allheads:$head"
    hsha="${head:0:8}"
    # Seats that ran this round == the round-<r>.<seat>.md blocks (exclude the
    # aggregate round-<r>.md and any .stderr capture).
    for block in "$rundir"/round-"$r".*.md; do
      [ -e "$block" ] || continue
      case "$block" in *.stderr) continue;; esac
      seat="$(basename "$block")"; seat="${seat#round-$r.}"; seat="${seat%.md}"
      [ -n "$seat" ] || continue
      seat_count=$((seat_count + 1))
      cls="$(classify_seat "$block")"
      verdicts="$verdicts $seat=$cls"
      if [ "$cls" = must-fix ]; then
        local t
        while IFS= read -r t; do
          [ -n "$t" ] || continue
          if [ "$mf_count" -lt 20 ]; then
            mf_lines="$mf_lines
- $seat: $t"
            mf_count=$((mf_count + 1))
          fi
        done < <(seat_titles "$block")
      fi
    done
    mf_total=$((mf_total + mf_count))
    body="$body
## Round $r — head \`$hsha\`

seat verdicts ($seat_count):${verdicts}
must-fix items ($mf_count):${mf_lines}
"
  done

  # appellate: prefer the explicit meta flag; the proposal count is the bullet/
  # numbered-line count in appellate.md (best-effort — free prose otherwise).
  local appellate_field="false" appellate_n=0
  if [ "${app_ran:-0}" = "1" ]; then
    appellate_field="true"
    if [ -n "$app_count" ]; then appellate_n="$app_count"
    elif [ -f "$rundir/appellate.md" ]; then
      appellate_n="$(grep -cE '^[[:space:]]*([-*]|[0-9]+[.)])[[:space:]]' "$rundir/appellate.md" 2>/dev/null || echo 0)"
    fi
  fi
  case "$appellate_n" in ''|*[!0-9]*) appellate_n=0 ;; esac

  # run-id: deterministic over the run's identity + every round's head, so a
  # re-emit of the SAME run is idempotent (byte-identical file) while two genuinely
  # different runs of the same PR (heads diverged) key distinctly. Overridable.
  local slug run_id
  slug="$(sanitize "$repo-$pr")"
  run_id="${GARDEN_PANEL_RUN_ID:-}"
  if [ -z "$run_id" ]; then
    run_id="$(printf '%s|%s|%s|%s|%s' "$repo" "$pr" "$base" "$disp" "$allheads" \
             | (sha1sum 2>/dev/null || shasum) | cut -c1-12)"
  fi
  run_id="$(sanitize "$run_id")"
  local rel="$STORE/$slug/$run_id.md"

  # Compose the record. Frontmatter is compact and greppable; the `epoch:` field is
  # RESERVED for the evaluation-epoch id (designs/evaluation-epochs-panel-calibration.md,
  # Status: Proposed) — left empty here so that design can stamp it without a schema change.
  local content
  content="$(cat <<EOF
---
kind: panel-run
repo: $repo
pr: $pr
panel_kind: $panel_kind
base_ref: $base
rounds: $rounds
disposition: $disp
must_fix_total: $mf_total
appellate_ran: $appellate_field
appellate_proposals: $appellate_n
epoch:
run_id: $run_id
recorded_by: ${GARDEN:-unknown}
---

# Panel run — $repo #$pr ($panel_kind)

Terminal disposition: **$disp** after **$rounds** round(s).
$body
EOF
)"

  # --- push (best-effort; die from ensure_clone/sync_clone is isolated in a
  # subshell so a journal outage WARNs and never propagates to the panel) -------
  if _panel_record_push "$rel" "$slug" "$content" "$disp" "$rounds"; then
    return 0
  fi
  log "WARN: panel-run record push for $rel failed (best-effort); the rundir retains the detail"
  return 0
}

# _panel_record_push <rel> <slug> <content> <disp> <rounds> — the CAS push, run in
# a subshell so a `die` inside ensure_clone/sync_clone/commit_and_push cannot exit
# the parent. Returns 0 on a successful push OR an idempotent no-op; non-zero on a
# genuine failure (the caller turns that into a WARN).
_panel_record_push() {
  local rel="$1" slug="$2" content="$3" disp="$4" rounds="$5"
  (
    set -uo pipefail
    ensure_clone "$DIR"
    local attempt
    for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-25}"); do
      sync_clone "$DIR"
      mkdir -p "$DIR/$STORE/$slug"
      printf '%s\n' "$content" > "$DIR/$rel"
      git -C "$DIR" add "$rel"
      # Idempotency: an identical re-emit stages no change.
      if git -C "$DIR" diff --cached --quiet -- "$rel" 2>/dev/null; then
        log "panel-run record $rel unchanged; idempotent no-op"
        exit 0
      fi
      if commit_and_push "$DIR" "panel-run($slug) $disp, $rounds round(s) by ${GARDEN:-?}"; then
        log "recorded panel run $rel"
        exit 0
      fi
      log "panel-run record of $rel lost a push race (attempt $attempt); re-syncing"
      backoff "$attempt"
    done
    exit 1
  )
}

# --- migrate ------------------------------------------------------------------
#
# The one legacy slug form that ever leaked. The scp form (`git@host:`) and the
# `https://` form were always stripped; only `ssh://git@github.com/...` was missed,
# and every affected repo is on github.com (the leak came from the hosts'
# `url.ssh://git@github.com/.insteadOf https://github.com/` rewrite). So a single
# FIXED prefix recognizes every split directory, and stripping it yields exactly the
# canonical `<owner>-<repo>-<pr>` slug — because `sanitize` collapses both the
# `owner/repo` slash and the `repo-pr` join to '-' identically in either form.
LEGACY_PREFIX="ssh---git-github.com-"

# canonical_slug_from_legacy <legacy-dirname> -> the canonical slug, or empty if the
# name does not carry the legacy prefix (or would map onto itself).
canonical_slug_from_legacy() {
  local name="$1" slug
  case "$name" in
    "$LEGACY_PREFIX"?*) slug="${name#"$LEGACY_PREFIX"}" ;;
    *)                  printf ''; return 0 ;;
  esac
  [ "$slug" != "$name" ] && printf '%s' "$slug" || printf ''
}

cmd_migrate() {
  local dry=0
  case "${1:-}" in
    --dry-run) dry=1 ;;
    '') ;;
    *) log "WARN: migrate: unknown flag '$1' (only --dry-run); proceeding as a live migration" ;;
  esac
  if _panel_record_migrate "$dry"; then
    return 0
  fi
  log "WARN: panel-run legacy-slug migration push failed after retries (best-effort); the split is unchanged"
  return 0
}

# _panel_record_migrate <dry> — the CAS-safe migration, in a subshell so a `die`
# inside ensure_clone/sync_clone cannot exit the parent. Returns 0 on a successful
# push OR a no-op (nothing to migrate, or a dry run); non-zero only on a genuine
# push failure after the retry budget.
_panel_record_migrate() {
  local dry="$1"
  (
    set -uo pipefail
    shopt -s nullglob
    ensure_clone "$DIR"
    local attempt
    for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-25}"); do
      sync_clone "$DIR"
      local moved=0 deduped=0 collided=0
      local legacy canonname slug f base src reldest dest
      for legacy in "$DIR/$STORE/$LEGACY_PREFIX"*/; do
        [ -d "$legacy" ] || continue
        canonname="$(basename "$legacy")"
        slug="$(canonical_slug_from_legacy "$canonname")"
        [ -n "$slug" ] || continue
        for f in "$legacy"*; do
          [ -f "$f" ] || continue                    # records are flat files; skip anything else
          base="$(basename "$f")"
          src="$STORE/$canonname/$base"
          reldest="$STORE/$slug/$base"
          dest="$DIR/$reldest"
          if [ -e "$dest" ]; then
            if cmp -s "$f" "$dest"; then
              # Identical duplicate — the canonical record already carries these
              # bytes; drop the legacy copy so the split closes without data loss.
              deduped=$((deduped + 1))
              if [ "$dry" = 1 ]; then
                log "DRY: would dedupe $src (byte-identical to $reldest)"
              else
                git -C "$DIR" rm -q "$src" >/dev/null 2>&1 || rm -f "$f"
              fi
            else
              # Differing content under the same run-id: REFUSE. Never overwrite a
              # canonical record; leave the legacy copy in place for a human to
              # reconcile. Idempotent — a re-run re-detects and re-refuses.
              collided=$((collided + 1))
              log "WARN: migrate collision — $src differs from existing $reldest; leaving the legacy copy untouched"
            fi
          else
            # Clean move: git mv preserves rename history. Ensure the canonical dir
            # exists (git mv creates leading dirs, but be explicit) then move.
            moved=$((moved + 1))
            if [ "$dry" = 1 ]; then
              log "DRY: would move $src -> $reldest"
            else
              mkdir -p "$DIR/$STORE/$slug"
              git -C "$DIR" mv "$src" "$reldest" 2>/dev/null || {
                # Fallback if git mv balks (e.g. an untracked stray): move + restage.
                mv -f "$f" "$dest"
                git -C "$DIR" add "$reldest"
                git -C "$DIR" rm -q --ignore-unmatch "$src" >/dev/null 2>&1 || true
              }
            fi
          fi
        done
      done

      if [ "$dry" = 1 ]; then
        log "migrate --dry-run: would move $moved, dedupe $deduped, refuse $collided collision(s)"
        exit 0
      fi

      # Nothing staged means the archive is already reunited (or only colliders
      # remain, which we deliberately do not touch): an idempotent no-op.
      if git -C "$DIR" diff --cached --quiet 2>/dev/null; then
        if [ "$collided" -gt 0 ]; then
          log "migrate: no changes to push; $collided collision(s) left in place for manual reconciliation"
        else
          log "migrate: no legacy-slug records to reunite; idempotent no-op"
        fi
        exit 0
      fi

      if commit_and_push "$DIR" \
        "panel-run migrate: reunite legacy ssh-slug records ($moved moved, $deduped deduped, $collided collision(s)) by ${GARDEN:-?}"; then
        log "migrate: reunited legacy panel-run records ($moved moved, $deduped deduped, $collided collision(s))"
        exit 0
      fi
      log "migrate lost a push race (attempt $attempt); re-syncing"
      backoff "$attempt"
    done
    exit 1
  )
}

case "${1:-}" in
  -h|--help) usage; exit 0 ;;
  emit)      shift; cmd_emit "$@" ;;
  migrate)   shift; cmd_migrate "$@" ;;
  '')        usage; exit 2 ;;
  *)         log "WARN: unknown subcommand '$1' (emit, migrate; --help for usage)"; exit 0 ;;
esac
