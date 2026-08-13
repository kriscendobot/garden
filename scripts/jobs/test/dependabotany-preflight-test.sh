#!/bin/bash
# dependabotany-preflight-test.sh — coverage for the deterministic daily-backstop
# preflight gate (dependabotany-preflight.sh).
#
# The gate decides, in plain code, whether the per-project daily
# `dependabotany-recheck-<project>` sweep has work:
#   exit 0 = work present → dispatch the botanist ledger sweep
#   exit 2 = no work      → advance the clock only, dispatch nothing
# It skips (exit 2) ONLY when BOTH hold: (A) the watched repo has zero open
# `dependabot[bot]` PRs, AND (B) the project's dependabotany ledger has no due row
# (no active embargo whose maturity date has arrived). Any read/enumeration error
# fails OPEN (dispatch), so a transient blip never starves the backstop.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2 (the gate's
# ensure_clone/sync_clone clone from it); the open-PR source is a deterministic
# stub. No real systemd, no live journal, no GitHub. "today" is pinned via
# GARDEN_DEPB_TODAY so due-ness is clock-independent.
#
# Usage: dependabotany-preflight-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PRE="$JOBS/dependabotany-preflight.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet GARDEN_*/JOURNAL_* so a live gardener running this test cannot
# splice the real journal under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

TR=/home/kris/.garden-dependabotany-preflight-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
PROJECT=endo-but-for-bots
REPO=endojs/endo-but-for-bots
SCHED="dependabotany-recheck-$PROJECT.md"
TODAY=2026-08-13
DEP='dependabot[bot]'
git_id=(-c user.name=test -c user.email=test@localhost)

# --- deterministic open-PR source stub ---------------------------------------
# Emits the fixture TSV verbatim (number author head updated title); the gate
# applies the dependabot-author filter itself. An empty/absent fixture = no PRs.
SRCSTUB="$TR/pr-source-stub.sh"
cat > "$SRCSTUB" <<'EOF'
#!/bin/bash
[ -n "${PR_FIXTURE:-}" ] && [ -f "$PR_FIXTURE" ] && cat "$PR_FIXTURE" || true
EOF
chmod +x "$SRCSTUB"
# A source that fails structurally (a broken enumeration, NOT "no open PRs").
FAILSTUB="$TR/pr-source-fail.sh"
printf '#!/bin/bash\necho "boom: 404" >&2\nexit 22\n' > "$FAILSTUB"; chmod +x "$FAILSTUB"

TS='2026-08-13T00:00:00Z'
prline() { printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$REPO" "$TS" "${3:-}"; }

# --- seed helpers ------------------------------------------------------------
# Reset the bare origin to just a schedule file (no ledger entries).
reset_bare() {
  rm -rf "$BARE" "$TR/seed"
  git init -q --bare "$BARE"
  local SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b "$BRANCH"
  ( cd "$SEED"
    mkdir -p schedules entries
    touch schedules/.gitkeep entries/.gitkeep
    printf 'name: %s\ncadence: daily\nlast_dispatched: 2026-08-12T00:00:00Z\npreflight: dependabotany-preflight.sh\n---\nsweep the ledger\n' "$SCHED" > "schedules/$SCHED" )
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
}

# Append a ledger entry (a journal message) at entries/<path> with the given body.
add_entry() {  # add_entry <relpath> <body>
  local rel="$1" body="$2" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  mkdir -p "$wt/entries/$(dirname "$rel")"
  {
    printf -- '---\nkind: message\nrole: botanist\nat: %sT00:00:00Z\n---\n' "${rel%%/*}-x"
    printf '%s\n' "$body"
  } > "$wt/entries/$rel"
  git -C "$wt" add -A; git -C "$wt" "${git_id[@]}" commit -q -m "entry $rel"
  git -C "$wt" push -q origin "$BRANCH"
  rm -rf "$wt"
}

run_pre() {  # run_pre [pr-fixture] [src-stub]  → fills $OUT/$RC
  rm -rf "$TR/clone"
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
             GARDEN=testhost GARDEN_STATE="$TR/state" \
             GARDEN_DEPB_PREFLIGHT_CLONE="$TR/clone" \
             GARDEN_DEPB_TODAY="$TODAY" \
             GARDEN_BOT_LOGIN=kriscendobot \
             GARDEN_DEPB_PR_SOURCE="${2:-$SRCSTUB}" PR_FIXTURE="${1:-}" \
             bash "$PRE" "$SCHED" 2>&1)"
  RC=$?
  set -e
}

# Ledger-entry bodies -----------------------------------------------------------
# A live embargo verdict for one PR, maturing on <date>.
embargo_body() {  # embargo_body <pr> <embargo-date>
  printf 'project: %s\nrepo: %s\nprs:\n  - https://github.com/%s/pull/%s\n\n# Dependabotany ledger: %s — EMBARGO-%s\n\nEMBARGO-%s embargo recorded for PR #%s; maturity floor %sT12:00:00Z.\n' \
    "$PROJECT" "$REPO" "$REPO" "$1" "$REPO" "$2" "$2" "$1" "$2"
}
# A sweep that drains the set (the reliable "off" signal).
drained_body() {
  printf 'project: %s\nrepo: %s\n\n# Dependabotany ledger: %s — embargo set drained, recheck schedule retired\n\nThe embargo set is now empty, leaving **zero** embargoed %s rows; the daily recheck schedule is deleted.\n' \
    "$PROJECT" "$REPO" "$REPO" "$REPO"
}

# ============================================================================
hr; echo "STATIC — dependabotany-preflight.sh parses (bash -n)"; hr
bash -n "$PRE" && ok "parses" || bad "syntax error"

# ============================================================================
hr; echo "NO WORK — no open dependabot PRs + drained ledger: exit 2"; hr
reset_bare
add_entry 2026/08/01/000001Z-a "$(embargo_body 900 2026-08-05)"
add_entry 2026/08/06/000002Z-b "$(drained_body)"     # latest entry declares drain
run_pre ""    # no open PRs
[ "$RC" -eq 2 ] && ok "drained ledger + no PRs → exit 2" || bad "exit $RC (want 2); OUT=$OUT"

# ============================================================================
hr; echo "NO WORK — no open dependabot PRs + live embargo NOT yet due: exit 2"; hr
reset_bare
add_entry 2026/08/10/000001Z-a "$(embargo_body 901 2026-08-20)"   # matures AFTER today
run_pre ""
[ "$RC" -eq 2 ] && ok "future maturity + no PRs → exit 2" || bad "exit $RC (want 2); OUT=$OUT"

# ============================================================================
hr; echo "WORK — a due embargo row, set not drained, zero open PRs: exit 0"; hr
# The reconciliation case: the PR was closed externally without draining the
# ledger, so no open PR exists but a matured row lingers → dispatch to reconcile.
reset_bare
add_entry 2026/08/01/000001Z-a "$(embargo_body 902 2026-08-05)"   # matured before today
run_pre ""
[ "$RC" -eq 0 ] && ok "due ledger row + no PRs → exit 0 (reconcile)" || bad "exit $RC (want 0); OUT=$OUT"
grep -qi 'due dependabotany ledger row' <<<"$OUT" && ok "logged the due-row dispatch" || bad "no due-row log; OUT=$OUT"

# ============================================================================
hr; echo "WORK — an open dependabot PR (drained ledger): exit 0"; hr
reset_bare
add_entry 2026/08/06/000002Z-b "$(drained_body)"     # ledger drained → (B) satisfied
FIX="$TR/prs-open.tsv"; prline 950 "$DEP" 'Bump ses from 1.10.0 to 1.11.0' > "$FIX"
run_pre "$FIX"
[ "$RC" -eq 0 ] && ok "open dependabot PR → exit 0" || bad "exit $RC (want 0); OUT=$OUT"
grep -qi 'open dependabot\[bot\] PR' <<<"$OUT" && ok "logged the open-PR dispatch" || bad "no open-PR log; OUT=$OUT"

# ============================================================================
hr; echo "AUTHOR GATE — only NON-dependabot open PRs (drained ledger): exit 2"; hr
reset_bare
add_entry 2026/08/06/000002Z-b "$(drained_body)"
FIX2="$TR/prs-human.tsv"
{ prline 951 kriscendobot 'chore: refactor'; prline 952 somehuman 'feat: thing'; } > "$FIX2"
run_pre "$FIX2"
[ "$RC" -eq 2 ] && ok "non-dependabot PRs ignored → exit 2" || bad "exit $RC (want 2); OUT=$OUT"

# ============================================================================
hr; echo "FAIL OPEN — open-PR source errors (no drained/due signal): exit 0"; hr
reset_bare
add_entry 2026/08/06/000002Z-b "$(drained_body)"    # (B) satisfied, so (A) is decisive
run_pre "" "$FAILSTUB"
[ "$RC" -eq 0 ] && ok "source failure → fail open (exit 0)" || bad "exit $RC (want 0); OUT=$OUT"
grep -qi 'failing open' <<<"$OUT" && ok "logged the fail-open" || bad "no fail-open log; OUT=$OUT"

# ============================================================================
hr; echo "NO LEDGER — no entries at all, no repo derivable: fail open exit 0"; hr
reset_bare      # only the schedule; no ledger entries → repo cannot be derived
run_pre ""
[ "$RC" -eq 0 ] && ok "undeterminable repo → fail open (exit 0)" || bad "exit $RC (want 0); OUT=$OUT"
grep -qi 'cannot determine owner/name' <<<"$OUT" && ok "logged the undeterminable-repo fail-open" || bad "no undeterminable-repo log; OUT=$OUT"

# ============================================================================
hr; echo "NO LEDGER — no entries, repo via override, zero open PRs: exit 2"; hr
reset_bare
set +e
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost \
           GARDEN_STATE="$TR/state" GARDEN_DEPB_PREFLIGHT_CLONE="$TR/clone2" \
           GARDEN_DEPB_TODAY="$TODAY" GARDEN_BOT_LOGIN=kriscendobot \
           GARDEN_DEPB_REPO="$REPO" \
           GARDEN_DEPB_PR_SOURCE="$SRCSTUB" PR_FIXTURE="" \
           bash "$PRE" "$SCHED" 2>&1)"; RC=$?
set -e
[ "$RC" -eq 2 ] && ok "empty ledger + repo override + no PRs → exit 2" || bad "exit $RC (want 2); OUT=$OUT"

# ============================================================================
hr; echo "BAD NAME — a non-dependabotany schedule name: dies (fail open at scheduler)"; hr
set +e
OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" GARDEN=testhost \
           GARDEN_STATE="$TR/state" GARDEN_DEPB_PREFLIGHT_CLONE="$TR/clone3" \
           bash "$PRE" "some-other-schedule.md" 2>&1)"; RC=$?
set -e
# die → exit 1; the scheduler treats any non-0/non-2 exit as work-present (fail open).
[ "$RC" -ne 0 ] && [ "$RC" -ne 2 ] && ok "wrong schedule name → non-{0,2} exit (scheduler fails open)" || bad "exit $RC (want neither 0 nor 2); OUT=$OUT"

hr; echo "RESULT: $PASS passed, $FAIL failed"; hr
rm -rf "$TR"
[ "$FAIL" -eq 0 ]
