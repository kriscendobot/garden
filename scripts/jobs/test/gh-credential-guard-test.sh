#!/bin/bash
# gh-credential-guard-test.sh — regression guard for the gardener-scaler
# gh-credential health preflight (scripts/jobs/gh-credential-guard.sh).
#
# THE GAP THIS CLOSES: the gh identity wrapper fails a write CLOSED when it cannot
# resolve the bot token, but only reactively — a host with a lapsed kriscendobot
# login looks healthy until a write job trips it (the 2026-09-04
# minion-town-clip-content-store-gc-build stall on endolin-garden-ece02cb4). This
# guard checks the same resolution path proactively and escalates ONCE per failure
# state to the maintainer inbox.
#
# SUBTEST 1 — token resolves AND authenticates → NO emission; stale marker+counter cleared.
# SUBTEST 2 — MISSING token (empty resolution) → ONE maintainer report + ONE journal
#             entry; marker records condition=missing; body is kind:error and names
#             the identity + the `gh auth login` remedy.
# SUBTEST 3 — same MISSING state, second tick → DEDUPED (no new emission).
# SUBTEST 4 — REVOKED persistence gate: a present-but-401 token stays QUIET below the
#             threshold (counter increments) and escalates exactly ONCE at threshold.
# SUBTEST 5 — token resolves but the liveness probe is INCONCLUSIVE (offline/5xx) →
#             NO escalation (an offline host is not a credential gap).
# SUBTEST 6 — CONTAINMENT: a FORGOTTEN maintainer sink override refuses rather than
#             posting to the real bus, and (outside a test context) a real gap still
#             reports — mirrors identity-drift-guard containment (incident 2026-07-28).
#
# Hermetic, in the same LAYERS as identity-drift-guard-test.sh:
#   1. THROWAWAY REMOTE — JOURNAL_REMOTE points at a scratch bare repo.
#   2. TEST SENTINEL — GARDEN_TEST=1 arms guard_no_production_push_in_test.
#   3. FAIL-CLOSED SINK — the guard's emit_sink refuses a real sink under test.
#   4. ENV SCRUB — ambient fleet GARDEN_*/JOURNAL_* cannot splice underneath.
# The token/probe are injected via GARDEN_GH_CRED_TOKEN_CMD / GARDEN_GH_CRED_PROBE_CMD
# so NO real gh is ever touched.
#
# Usage: gh-credential-guard-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# shellcheck disable=SC2046  # names only; see identity-drift-guard-test.sh rationale.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-gh-cred-guard.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BOT="kriscendobot"

# Layer 1: a throwaway journal origin shaped like journal2.
BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED"/{jobs/{todo,doin,tada,index},entries,msgs,hosts,inbox/maintainer/{unread,read}}
find "$SEED" -type d -not -path '*/.git/*' -not -name .git -exec touch {}/.gitkeep \;
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$SEED" push -q "$BARE" HEAD:journal2
GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
export GARDEN_ROOT JOURNAL_BRANCH=journal2
export JOURNAL_REMOTE="$BARE"

bare_inbox_count() {
  git -C "$BARE" ls-tree -r --name-only journal2 2>/dev/null \
    | grep -c '^inbox/maintainer/unread/[^/]*\.md$' || true
}

MAINT_OUT="$TR/maint.out"; JRNL_OUT="$TR/jrnl.out"; export MAINT_OUT JRNL_OUT
CAP_MAINT='cat >> "$MAINT_OUT"; printf "\n===MAINT-EMIT===\n" >> "$MAINT_OUT"'
CAP_JRNL='cat >> "$JRNL_OUT"; printf "\n===JRNL-EMIT===\n" >> "$JRNL_OUT"'

# run_guard <state-dir> <token-cmd> <probe-cmd> [extra env KEY=VAL ...]
run_guard() {
  local state="$1" tokcmd="$2" probecmd="$3"; shift 3
  env GARDEN_STATE="$state" \
      GARDEN_GH_CRED_TOKEN_CMD="$tokcmd" \
      GARDEN_GH_CRED_PROBE_CMD="$probecmd" \
      GARDEN_GH_CRED_GUARD_MAINTAINER_EMIT="$CAP_MAINT" \
      GARDEN_GH_CRED_GUARD_EMIT="$CAP_JRNL" \
      "$@" "$JOBS/gh-credential-guard.sh" > "$state.log" 2>&1 || true
}
n_emit() { grep -c "===$1-EMIT===" "$2" 2>/dev/null || true; }

# ============================================================================
hr; echo "SUBTEST 1 — healthy token+probe: no emission, stale marker+counter cleared"; hr
S1="$TR/s1"; mkdir -p "$S1"
printf 'host=x|id=y|condition=missing\n' > "$S1/gh-credential-reported"
printf '5\n' > "$S1/gh-credential-suspect-count"
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S1" 'printf gho_livetoken' "printf $BOT"
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "a healthy credential emits nothing"
else
  bad "healthy should not emit (maint=$(n_emit MAINT "$MAINT_OUT") jrnl=$(n_emit JRNL "$JRNL_OUT"))"
fi
[ ! -f "$S1/gh-credential-reported" ] && ok "stale dedup marker cleared when healthy" \
  || bad "stale marker not cleared"
[ ! -f "$S1/gh-credential-suspect-count" ] && ok "stale suspect counter cleared when healthy" \
  || bad "stale counter not cleared"

# ============================================================================
hr; echo "SUBTEST 2 — MISSING token: ONE maintainer report + ONE journal entry"; hr
S2="$TR/s2"; : > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S2" 'printf ""' 'printf ""'   # empty token → MISSING (probe never runs)
[ "$(n_emit MAINT "$MAINT_OUT")" -eq 1 ] && ok "missing token posts exactly ONE maintainer report" \
  || bad "expected 1 maintainer report, got $(n_emit MAINT "$MAINT_OUT")"
[ "$(n_emit JRNL "$JRNL_OUT")" -eq 1 ] && ok "and exactly ONE journal entry" \
  || bad "expected 1 journal entry, got $(n_emit JRNL "$JRNL_OUT")"
grep -q "^kind: error" "$MAINT_OUT" && ok "maintainer body marked kind: error" \
  || bad "maintainer body missing kind: error marker"
grep -qF "$BOT" "$MAINT_OUT" && ok "report names the bot identity" \
  || bad "report did not name the identity"
grep -q "gh auth login" "$MAINT_OUT" && ok "report names the gh auth login remedy" \
  || bad "report missing the remedy"
grep -q "condition=missing" "$S2/gh-credential-reported" 2>/dev/null \
  && ok "dedup marker records condition=missing" \
  || bad "dedup marker missing/wrong: '$(head -1 "$S2/gh-credential-reported" 2>/dev/null)'"

# ============================================================================
hr; echo "SUBTEST 3 — same MISSING state, second tick: DEDUPED"; hr
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S2" 'printf ""' 'printf ""'   # reuse S2 → marker present
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "an unchanged missing state is not re-posted"
else
  bad "re-post on unchanged state (maint=$(n_emit MAINT "$MAINT_OUT") jrnl=$(n_emit JRNL "$JRNL_OUT"))"
fi

# ============================================================================
hr; echo "SUBTEST 4 — REVOKED persistence gate (threshold 2)"; hr
S4="$TR/s4"
AUTHFAIL='echo "gh: Bad credentials (HTTP 401)" >&2; exit 1'
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S4" 'printf gho_present' "$AUTHFAIL" GARDEN_GH_CRED_REVOKED_THRESHOLD=2
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ]; then
  ok "tick 1 of a 401 streak stays quiet (transient tolerance)"
else
  bad "tick 1 should not escalate, got $(n_emit MAINT "$MAINT_OUT")"
fi
[ "$(head -1 "$S4/gh-credential-suspect-count" 2>/dev/null)" = 1 ] \
  && ok "suspect counter incremented to 1" \
  || bad "counter not 1: '$(head -1 "$S4/gh-credential-suspect-count" 2>/dev/null)'"
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S4" 'printf gho_present' "$AUTHFAIL" GARDEN_GH_CRED_REVOKED_THRESHOLD=2
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 1 ]; then
  ok "tick 2 crosses the threshold and escalates exactly ONCE"
else
  bad "tick 2 should escalate once, got $(n_emit MAINT "$MAINT_OUT")"
fi
grep -q "condition=revoked" "$S4/gh-credential-reported" 2>/dev/null \
  && ok "dedup marker records condition=revoked" \
  || bad "revoked marker missing/wrong"
: > "$MAINT_OUT"; : > "$JRNL_OUT"
run_guard "$S4" 'printf gho_present' "$AUTHFAIL" GARDEN_GH_CRED_REVOKED_THRESHOLD=2
[ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] \
  && ok "a still-revoked token is deduped after the first escalation" \
  || bad "revoked re-post (maint=$(n_emit MAINT "$MAINT_OUT"))"

# ============================================================================
hr; echo "SUBTEST 5 — token resolves, probe INCONCLUSIVE (offline): NO escalation"; hr
S5="$TR/s5"; : > "$MAINT_OUT"; : > "$JRNL_OUT"
OFFLINE='echo "dial tcp: lookup api.github.com: no such host" >&2; exit 1'
run_guard "$S5" 'printf gho_present' "$OFFLINE" GARDEN_GH_CRED_REVOKED_THRESHOLD=2
if [ "$(n_emit MAINT "$MAINT_OUT")" -eq 0 ] && [ "$(n_emit JRNL "$JRNL_OUT")" -eq 0 ]; then
  ok "an inconclusive (offline) probe does not escalate"
else
  bad "offline probe escalated (maint=$(n_emit MAINT "$MAINT_OUT"))"
fi
[ ! -f "$S5/gh-credential-suspect-count" ] \
  && ok "an inconclusive probe does not count against the token" \
  || bad "offline probe wrongly incremented the suspect counter"

# ============================================================================
hr; echo "SUBTEST 6 — CONTAINMENT: a FORGOTTEN maintainer override cannot reach the real bus"; hr
S6="$TR/s6"; : > "$JRNL_OUT"
INBOX_BEFORE="$(bare_inbox_count)"
env GARDEN_STATE="$S6" GARDEN_GH_CRED_TOKEN_CMD='printf ""' GARDEN_GH_CRED_PROBE_CMD='printf ""' \
    GARDEN_GH_CRED_GUARD_EMIT="$CAP_JRNL" \
    "$JOBS/gh-credential-guard.sh" > "$TR/s6.log" 2>&1 || true
grep -q 'REFUSING to emit the maintainer-inbox report' "$TR/s6.log" \
  && ok "a sink with no capture override REFUSES rather than posting for real" \
  || bad "forgotten sink did not refuse: $(tr '\n' ' ' < "$TR/s6.log" | tail -c 200)"
[ "$(bare_inbox_count)" -eq "$INBOX_BEFORE" ] \
  && ok "nothing written to the journal origin at all" \
  || bad "forgotten sink still wrote to the journal origin"
[ ! -f "$S6/gh-credential-reported" ] \
  && ok "a refused escalation does not arm the dedup marker (retries next tick)" \
  || bad "dedup marker armed despite a refused escalation"

# Containment must not become SUPPRESSION: outside a test context a real gap reports.
S6B="$TR/s6b"; INBOX_BEFORE="$(bare_inbox_count)"
env GARDEN_TEST=0 GARDEN_STATE="$S6B" GARDEN_GH_CRED_TOKEN_CMD='printf ""' GARDEN_GH_CRED_PROBE_CMD='printf ""' \
    GARDEN_GH_CRED_GUARD_EMIT="$CAP_JRNL" \
    "$JOBS/gh-credential-guard.sh" > "$TR/s6b.log" 2>&1 || true
[ "$(bare_inbox_count)" -gt "$INBOX_BEFORE" ] \
  && ok "outside a test context a REAL gap still posts a maintainer-inbox report" \
  || bad "real gap no longer reports: $(tr '\n' ' ' < "$TR/s6b.log" | tail -c 200)"

# ============================================================================
hr
echo "gh-credential-guard-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
