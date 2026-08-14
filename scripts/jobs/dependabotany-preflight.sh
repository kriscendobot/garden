#!/bin/bash
# dependabotany-preflight.sh — deterministic preflight gate for the per-project
# daily dependabotany-recheck backstop schedule (roles/botanist/AGENT.md
# § Autonomous disposition, leg 2 "Daily heartbeat over the ledger").
#
# Usage: dependabotany-preflight.sh <schedule-name>
#   <schedule-name> is the scheduler's schedules/<name> file, e.g.
#   `dependabotany-recheck-endo-but-for-bots.md`. The project slug is derived from
#   it by stripping the `dependabotany-recheck-` prefix and the `.md` suffix.
#
# Wired into schedules/dependabotany-recheck-<project>.md as
# `preflight: dependabotany-preflight.sh` (set-schedule.sh attaches it by default
# for this schedule family). The scheduler runs this when the daily cadence
# has elapsed and acts on the exit code (skills/schedule/SKILL.md):
#   exit 0 = work present → dispatch the botanist ledger sweep + advance the clock
#   exit 2 = no work      → advance the clock only, dispatch nothing
# ANY other exit is treated by the scheduler as work-present (fail open), so a
# broken gate never starves the backstop.
#
# WHY. The daily backstop is a safety net for embargoed Dependabot PRs whose
# precise one-shot recheck was lost; in the common steady state it has NOTHING to
# do — no open Dependabot PR and a drained ledger — yet still dispatches an Opus
# botanist that drains, finds nothing due, and writes a verbose
# "no row due / set drained" clean-confirmation entry to the journal every single
# day (e.g. entries/2026/07/01 "embargo set drained", the routine no-op this gate
# removes). This moves that idle/active decision off the dispatched LLM and into
# plain code: dispatch ONLY when there is a genuine reason to sweep.
#
# THE GATE. Skip (exit 2) IFF BOTH hold:
#   (A) the watched repo has ZERO open `dependabot[bot]`-authored PRs, AND
#   (B) the project's dependabotany ledger has NO due row (no active embargo whose
#       maturity date has arrived).
# Otherwise dispatch (exit 0). Any read/enumeration error → fail OPEN (exit 0):
# the backstop must never be starved by a transient GitHub blip or an unparseable
# ledger, only quieted when it can PROVE there is nothing to do.
#
# SOUNDNESS. (A) is the load-bearing guarantee. An ACTIVE embargo is by
# construction an OPEN Dependabot PR waiting for its maturity floor, so it is
# enumerated by the open-PR source; whenever there is real recheck work, (A) is
# false and we dispatch — regardless of how the ledger prose parses. (B) is a
# best-effort, fail-open backstop that adds ONE extra dispatch trigger the open-PR
# check cannot see: a ledger row left behind for a PR that was closed/merged
# externally without the ledger being drained, so the next sweep can reconcile it.
# Because (B) only ever ADDS an exit-0 (dispatch) path — skipping still requires
# (A) — no amount of ledger-parse imprecision can cause an unsafe skip of live
# work.
#
# The two external I/O legs are indirected so the test substitutes deterministic
# stubs, exactly like dependabot-watcher.sh:
#   GARDEN_DEPB_PR_SOURCE <owner/name> <bot-login> -> TSV: number author head updated title
#   GARDEN_DEPB_ENTRIES_DIR                        -> the ledger entries/ tree to grep
#   GARDEN_DEPB_REPO                               -> owner/name override (else derived from the ledger)
#   GARDEN_DEPB_TODAY                              -> UTC YYYY-MM-DD override for the due comparison
# Read-only against the journal: it reuses common.sh's ensure_clone/sync_clone and
# never writes or pushes.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="dependabotany-preflight"

: "${GARDEN_DEPENDABOT_LOGIN:=dependabot[bot]}"
: "${GARDEN_BOT_LOGIN:=kriscendobot}"
: "${GARDEN_DEPB_PR_SOURCE:=$HERE/handlers/ci-pr-source-gh.sh}"
: "${GARDEN_DEPB_PREFLIGHT_CLONE:=$GARDEN_STATE/dependabotany-preflight/journal}"
: "${GARDEN_DEPB_SOURCE_TIMEOUT_SECS:=180}"
: "${GARDEN_DEPB_KILL_AFTER:=10s}"

name="${1:-}"
[ -n "$name" ] || die "usage: dependabotany-preflight.sh <schedule-name>"

# project slug = the schedule stem minus the fixed prefix.
stem="${name%.md}"
case "$stem" in
  dependabotany-recheck-*) project="${stem#dependabotany-recheck-}" ;;
  *) die "schedule '$name' is not a dependabotany-recheck schedule" ;;
esac
[ -n "$project" ] || die "empty project slug derived from schedule '$name'"

# --- sync the journal clone (fail OPEN on an unreadable/offline journal) ------
CLONE="$GARDEN_DEPB_PREFLIGHT_CLONE"
if ! ensure_clone "$CLONE" 2>/dev/null || ! sync_clone "$CLONE" 2>/dev/null; then
  log "WARN: journal unreachable; failing open (dispatch) — never guess the ledger is empty"
  exit 0
fi
ENTRIES="${GARDEN_DEPB_ENTRIES_DIR:-$CLONE/entries}"

# --- recover the project's dependabotany ledger entries -----------------------
# The ledger has no index; it is only the set of journal entries a sweep greps
# back, so recovery mirrors roles/botanist/AGENT.md step 11 EXACTLY: a
# `project: <slug>` line on its own line AND a case-insensitive `# dependabotany`
# heading. Sorted by path (entries/YYYY/MM/DD/HHMMSSZ-…) = chronological.
mapfile -t LEDGER < <(
  grep -rlE "^project:[[:space:]]*${project}[[:space:]]*\$" "$ENTRIES" 2>/dev/null \
    | while IFS= read -r f; do grep -qiE '^#[[:space:]]*dependabotany' "$f" 2>/dev/null && printf '%s\n' "$f"; done \
    | sort
)

# --- (B) is there a DUE row in the ledger? -----------------------------------
# Reconstruct just enough of the active embargo set to answer "is any matured row
# still active?", conservatively and fail-open:
#   * the LATEST project entry that declares the embargo set drained/empty/retired
#     means NO active rows — the reliable "off" signal a sweep always writes when
#     it empties the set (and the termination clause then deletes the schedule);
#   * otherwise the set is presumed live, and a row is DUE when its
#     `EMBARGO-YYYY-MM-DD` maturity date has arrived.
# ISO dates sort lexically = chronologically, so the string compare is exact.
today="${GARDEN_DEPB_TODAY:-$(date -u +%F)}"
DRAIN_RE='(embargo|embargoed)[^.]*set[^.]*(empty|drained)|zero[^.]*embargoed|no[^.]*embargoed[^.]*rows|schedule[^.]*(deleted|retired)|embargoed set is now empty'

ledger_due=0
if [ "${#LEDGER[@]}" -gt 0 ]; then
  latest="${LEDGER[-1]}"
  if grep -qiE "$DRAIN_RE" "$latest" 2>/dev/null; then
    log "ledger: latest entry ($(basename "$latest")) declares the embargo set drained/retired — no active rows"
  else
    # Presumed-live set: due iff any recorded maturity date is at or before today.
    due_date=""
    while IFS= read -r d; do
      [ -n "$d" ] || continue
      if [ "$d" \< "$today" ] || [ "$d" = "$today" ]; then due_date="$d"; break; fi
    done < <(grep -rhoE 'EMBARGO-[0-9]{4}-[0-9]{2}-[0-9]{2}' "${LEDGER[@]}" 2>/dev/null \
               | sed 's/^EMBARGO-//' | sort -u)
    if [ -n "$due_date" ]; then
      ledger_due=1
      log "ledger: a matured embargo row is present (maturity $due_date <= $today) and the set is not declared drained — work present"
    else
      log "ledger: the set is live but no maturity date has arrived yet (as of $today) — no due row"
    fi
  fi
else
  log "ledger: no dependabotany entries recovered for project '$project' — no due row"
fi

# A due ledger row alone is reason enough to sweep; short-circuit before spending a
# GitHub round-trip.
if [ "$ledger_due" -eq 1 ]; then
  log "preflight: DISPATCH — due dependabotany ledger row for '$project'"
  exit 0
fi

# --- (A) does the repo have any open dependabot[bot] PR? ----------------------
# Determine owner/name: an explicit override, else the most recent `repo:` line in
# the recovered ledger (the authoritative project→repo binding a botanist writes on
# every entry). If neither is available we cannot enumerate — fail OPEN.
repo="${GARDEN_DEPB_REPO:-}"
if [ -z "$repo" ] && [ "${#LEDGER[@]}" -gt 0 ]; then
  for ((i=${#LEDGER[@]}-1; i>=0; i--)); do
    r="$(sed -n 's/^repo:[[:space:]]*//p' "${LEDGER[$i]}" 2>/dev/null | head -1)"
    case "$r" in */*) repo="$r"; break ;; esac
  done
fi
if [ -z "$repo" ]; then
  log "WARN: cannot determine owner/name for project '$project' (no override, no repo: line in the ledger) — failing open (dispatch)"
  exit 0
fi

# Enumerate open PRs through the shared source, bounded so a hung gh cannot outlive
# the tick. A source failure is NOT "no open PRs": fail OPEN so a GitHub blip never
# masquerades as an empty repo (dependabot-watcher.sh's "never guess" discipline).
SRC="$(mktemp)"; ERRF="$(mktemp)"
trap 'rm -f "$SRC" "$ERRF"' EXIT
src_rc=0
if command -v timeout >/dev/null 2>&1; then
  timeout --signal=TERM --kill-after="$GARDEN_DEPB_KILL_AFTER" "${GARDEN_DEPB_SOURCE_TIMEOUT_SECS}s" \
    "$GARDEN_DEPB_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" || src_rc=$?
else
  "$GARDEN_DEPB_PR_SOURCE" "$repo" "$GARDEN_BOT_LOGIN" > "$SRC" 2>"$ERRF" || src_rc=$?
fi
if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  log "WARN: open-PR source failed for $repo (rc=$src_rc) — failing open (dispatch), never guessing 'no open PRs'"
  exit 0
fi

dep_lc="$(printf '%s' "$GARDEN_DEPENDABOT_LOGIN" | tr '[:upper:]' '[:lower:]')"
open_dep=0
while IFS=$'\t' read -r pr author head updated title; do
  [ -n "$pr" ] || continue
  [ "$(printf '%s' "$author" | tr '[:upper:]' '[:lower:]')" = "$dep_lc" ] || continue
  open_dep=$((open_dep+1))
done < "$SRC"

if [ "$open_dep" -gt 0 ]; then
  log "preflight: DISPATCH — $repo has $open_dep open dependabot[bot] PR(s)"
  exit 0
fi

# (A) zero open dependabot PRs AND (B) no due ledger row → genuinely idle.
log "preflight gated: no work for $name — $repo has no open dependabot PRs and the '$project' ledger has no due row"
exit 2
