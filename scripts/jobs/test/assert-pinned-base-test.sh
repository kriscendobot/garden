#!/bin/bash
# assert-pinned-base-test.sh — the deterministic merge-base-pinning sensor and its
# ensure-pr.sh PR-open integration (review-misses/clusters/merge-base-pinning.md,
# count=4 across endojs/endo-but-for-bots #719/#831/#836).
#
# Under test (all deterministic, NO LLM, NO network — a fake gh):
#   NAME MODE (the shape-(1) string gate ensure-pr runs at PR-open):
#     * a pinned <base>-<sha> snapshot passes (rc 0) — master/llm/main/stacked.
#     * a floating trunk (master/llm/main) is refused (rc 5).
#   PR MODE (the review-time gate the gauntlet runs before spend):
#     * a pinned base with a small commit count passes (rc 0).
#     * a floating base is the shape-(1) miss (rc 5).
#     * a wide entrained delta on a pinned base is the shape-(2) signal (rc 6).
#     * a gh read failure is INCONCLUSIVE (rc 4), never a silent pass.
#   ENSURE-PR INTEGRATION:
#     * a draft create against a FLOATING base is refused before any gh pr create.
#     * GARDEN_ALLOW_FLOATING_BASE=1 is the justified-exception escape hatch.
#     * a pinned base still creates normally (the #719/#831/#836 fix does not
#       regress the happy path).

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SENSOR="$JOBS/gardening/assert-pinned-base.sh"
ENSURE="$JOBS/gardening/ensure-pr.sh"
STUB="$HERE/ensure-pr-gh-stub.sh"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
export GARDEN_ROOT="$ROOT"

# /tmp is noexec in the container; executable stubs live under $HOME.
TR="$(mktemp -d "$HOME/.garden-pin-test.XXXXXX")"
trap '[ "$FAIL" -eq 0 ] && rm -rf "$TR"' EXIT
chmod +x "$STUB"

rc_of() { local rc; "$@" >/dev/null 2>&1; rc=$?; printf '%s' "$rc"; }

hr; echo "STATIC — the sensor parses"; hr
bash -n "$SENSOR" && ok "assert-pinned-base.sh parses" || bad "syntax error in assert-pinned-base.sh"

hr; echo "NAME MODE — pinned snapshots pass, floating trunks are refused"; hr
for b in master-2708cac llm-6beb4e5 main-abc1234 feat/foo-abc1234 llm-6beb4e5f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5; do
  [ "$(rc_of bash "$SENSOR" name "$b")" = 0 ] && ok "pinned '$b' → 0" || bad "pinned '$b' not accepted"
done
for b in master llm main develop trunk release; do
  [ "$(rc_of bash "$SENSOR" name "$b")" = 5 ] && ok "floating '$b' → 5" || bad "floating '$b' not refused"
done

# --- a fake gh for PR mode: emits baseRefName + a commit list of a chosen length --
mk_gh() {  # mk_gh <file> <baseRefName> <commit-count> | 'FAIL'
  local f="$1" base="$2" n="$3"
  if [ "$base" = FAIL ]; then
    printf '#!/bin/bash\nexit 1\n' >"$f"
  else
    { printf '#!/bin/bash\n'
      printf 'commits="$(for i in $(seq 1 %s); do printf "{},"; done)"; commits="${commits%%,}"\n' "$n"
      printf '[ "$1" = pr ] && printf '"'"'{"baseRefName":"%s","commits":[%%s]}\\n'"'"' "$commits"\n' "$base"
    } >"$f"
  fi
  chmod +x "$f"
}

hr; echo "PR MODE — the live-PR gate applies both shapes"; hr
mk_gh "$TR/gh-ok.sh"        llm-6beb4e5 3
mk_gh "$TR/gh-floating.sh"  llm         2
mk_gh "$TR/gh-entrained.sh" llm-6beb4e5 79
mk_gh "$TR/gh-fail.sh"      FAIL        0
[ "$(rc_of env GARDEN_GH="$TR/gh-ok.sh"        bash "$SENSOR" pr o/r 1)" = 0 ] && ok "pinned + small → 0" || bad "pinned+small not 0"
[ "$(rc_of env GARDEN_GH="$TR/gh-floating.sh"  bash "$SENSOR" pr o/r 1)" = 5 ] && ok "floating base → 5 (shape 1)" || bad "floating base not 5"
[ "$(rc_of env GARDEN_GH="$TR/gh-entrained.sh" bash "$SENSOR" pr o/r 1)" = 6 ] && ok "79 commits → 6 (shape 2)" || bad "wide delta not 6"
[ "$(rc_of env GARDEN_GH="$TR/gh-fail.sh"      bash "$SENSOR" pr o/r 1)" = 4 ] && ok "gh failure → 4 (inconclusive)" || bad "gh failure not 4"
# The wide-delta threshold is tunable and its default (40) does not trip a normal PR.
[ "$(rc_of env GARDEN_GH="$TR/gh-entrained.sh" GARDEN_PIN_MAX_AHEAD=200 bash "$SENSOR" pr o/r 1)" = 0 ] \
  && ok "GARDEN_PIN_MAX_AHEAD raises the wide-delta threshold" || bad "threshold override ignored"

hr; echo "ENSURE-PR — a draft create against a floating base is refused at the source"; hr
REPO=endojs/endo-but-for-bots
JOB=some-feature-build
export FAKE_PR_DB="$TR/prs.json"; export FAKE_GH_LOG="$TR/gh.log"
ensure_call() {  # ensure_call <base-branch> [VAR=val ...]
  local base_branch="$1"; shift
  printf '[]\n' >"$FAKE_PR_DB"; : >"$FAKE_GH_LOG"
  set +e
  OUT="$(env GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_GH="$STUB" \
             GARDEN_ENSURE_PR_NO_JOURNAL=1 "$@" \
             bash "$ENSURE" "$JOB" "$REPO" feat/some "$base_branch" \
             --title 'feat: thing' --body 'What it does.' 2>"$TR/err")"
  RC=$?; ERR="$(cat "$TR/err")"
  set -e
}
creates() { grep -c '^pr create' "$FAKE_GH_LOG" 2>/dev/null || true; }

ensure_call master
{ [ "$RC" -ne 0 ] && [ "$(creates)" = 0 ]; } \
  && ok "a draft create against floating 'master' is refused, nothing created" \
  || bad "floating base was not refused: rc=$RC creates=$(creates) ($ERR)"
printf '%s\n' "$ERR" | grep -qi 'unpinned\|frozen' && ok "the refusal names the frozen-base rule" || bad "refusal message unclear: $ERR"

ensure_call master GARDEN_ALLOW_FLOATING_BASE=1
{ [ "$RC" -eq 0 ] && [ "$(creates)" = 1 ]; } \
  && ok "GARDEN_ALLOW_FLOATING_BASE=1 is the escape hatch (creates)" \
  || bad "escape hatch did not permit creation: rc=$RC creates=$(creates) ($ERR)"

ensure_call master-abc1234
{ [ "$RC" -eq 0 ] && [ "$(creates)" = 1 ]; } \
  && ok "a pinned base still creates normally (no happy-path regression)" \
  || bad "pinned base failed to create: rc=$RC creates=$(creates) ($ERR)"

hr
if [ "$FAIL" -eq 0 ]; then
  echo "PASS: assert-pinned-base sensor + ensure-pr integration ($PASS checks)"
else
  echo "FAIL: $FAIL check(s) failed, $PASS passed (fixtures kept at $TR)"
fi
[ "$FAIL" -eq 0 ]
