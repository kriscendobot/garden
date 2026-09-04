#!/bin/bash
# rolling-deploy-test.sh — the leader-orchestrated rolling deploy end to end
# (designs/follower-self-deploy.md), against throwaway fixtures (no real systemd, no
# real deploy, a throwaway journal remote).
#
# Covers:
#   - STATIC: the scripts parse; NEITHER conductor nor follower daemon invokes claude/
#     an LLM; the attestation-boundary invariant — no `msgs/` path is read to decide to
#     deploy, and the conductor issues NO sysop `deploy` op (only benign `drain`).
#   - host=<GARDEN> requirement token: a capable host claims a host-pinned job; an
#     incapable host skips it (the mechanism the canary probe rides).
#   - the CANARY-PROBE short-circuit: a real gardener claims a `canary-probe: true` job
#     pinned to it and completes it to tada with NO handler (the no-LLM round trip).
#   - FOLLOWER-FIRST ORDERING + canary pass advances the leader LAST: release f1 →
#     f1 deploys → validate (probe→tada) passes → release f2 → f2 passes → leader
#     self-deploys, and never before.
#   - a CANARY FAIL HALTS the roll: the leader never advances, the failed canary is
#     left drained (a benign drain op), the maintainer is paged, and a later tick keeps
#     holding.
#   - an operator-drained follower is SKIPPED (the roll proceeds with the rest).
#   - the LEADER-ONLY fleet self-deploys directly (no canary by construction).
#   - the follower daemon's leaderless-grace HEADLESS fallback; a live-leader-no-release
#     HOLD; and the operator-drained DECLINE (publishes operator-drained, no deploy).
#   - the SETTLE window floors tip age before any release.
#
# Usage: rolling-deploy-test.sh
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# --- hermetic baseline (mirror sysop-test.sh: scrub ambient fleet env) --------
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
export GARDEN_ROOT="$ROOT"

TR=/home/kris/.garden-rolling-deploy-test
rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
BRANCH=journal2
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
git_id=(-c user.name=test -c user.email=test@localhost)

LEADER="leaderhost-garden-aaaa1111"
F1="follower-a-garden-bbbb2222"
F2="follower-b-garden-cccc3333"
TARGET="1111111111111111111111111111111111111111"
TARGET12="${TARGET:0:12}"
MOCK="$HERE/mock-systemctl.sh"

# --- seed the shared origin --------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/index msgs hosts config \
           deploy/roll fleet/health fleet/deployed inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/index msgs hosts config \
           deploy/roll fleet/health fleet/deployed inbox/maintainer/unread inbox/maintainer/read; do
    touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: rolling-deploy fixtures"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# --- helpers -----------------------------------------------------------------
push_change() {  # push_change <path> <content|@DELETE> <msg>
  local path="$1" content="$2" msg="$3" wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  if [ "$content" = "@DELETE" ]; then git -C "$wt" rm -q "$path" 2>/dev/null || true
  else mkdir -p "$(dirname "$wt/$path")"; printf '%s' "$content" > "$wt/$path"; git -C "$wt" add "$path"; fi
  git -C "$wt" "${git_id[@]}" commit -q -m "$msg" 2>/dev/null || true
  git -C "$wt" push -q origin "HEAD:$BRANCH" 2>/dev/null || true
  rm -rf "$wt"
}
from_bare() { git -C "$BARE" show "$BRANCH:$1" 2>/dev/null; }
# A real completion lands under a date shard jobs/tada/<yyyy/mm/dd>/<base>.md, so find
# it by tree scan rather than the flat path.
tada_tree_path() { git -C "$BARE" ls-tree -r --name-only "$BRANCH" 2>/dev/null | grep -E "jobs/tada/(.*/)?$1\.md$" | head -1; }
tada_from_bare() { local p; p="$(tada_tree_path "$1")"; [ -n "$p" ] && from_bare "$p" || true; }
seed_fleet_hosts() {  # every host present in the fleet
  local h; for h in "$@"; do push_change "hosts/$h" $'gardeners: 1\nupdated_by: test' "seed host $h"; done
}
simulate_follower_deploy() {  # <host> <sha> [roll_status] [unit_failures] [first_bad]
  local h="$1" sha="$2" status="${3:-deployed}" failures="${4:-0}" firstbad="${5:--}"
  push_change "fleet/deployed/$h" "$sha" "sim: $h deployed $sha"
  push_change "fleet/health/$h" \
    "host: $h"$'\n'"deployed_sha: $sha"$'\n'"roll_status: $status"$'\n'"unit_failures: $failures"$'\n'"unit_total: 12"$'\n'"first_bad_unit: $firstbad"$'\n'"at: now" \
    "sim: $h health $status"
}
seed_probe_tada() {  # <host> — seed the canary probe's tada as if the round trip completed
  local probe="canary-probe-$1-$TARGET12"
  push_change "jobs/tada/$probe.md" "canary-probe: ok"$'\n'"host: $1"$'\n' "sim: probe $probe completed"
}

# Recorders for the conductor's seams.
DEPLOY_LOG="$TR/deploy.log"; DRAIN_LOG="$TR/drain.log"; ALERT_LOG="$TR/alert.log"
: > "$DEPLOY_LOG"; : > "$DRAIN_LOG"; : > "$ALERT_LOG"
cat > "$TR/rec-deploy.sh" <<EOF
#!/bin/bash
printf 'deploy-invoked host=%s\n' "\${GARDEN:-?}" >> "$DEPLOY_LOG"
EOF
cat > "$TR/rec-drain.sh" <<EOF
#!/bin/bash
printf 'drain %s\n' "\$*" >> "$DRAIN_LOG"
EOF
cat > "$TR/rec-alert.sh" <<EOF
#!/bin/bash
printf 'ALERT key=%s\n' "\$1" >> "$ALERT_LOG"
EOF
chmod +x "$TR"/rec-*.sh

run_conductor() {  # run_conductor [EXTRA_ENV=VAL...]
  local state="$TR/state-leader"
  mkdir -p "$state/deploy"
  env -i PATH="$PATH" HOME="$HOME" \
    GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="$LEADER" GARDEN_STATE="$state" GARDEN_LEADER="$LEADER" \
    GARDEN_SELF_DEPLOY_SETTLE=0 GARDEN_CANARY_PROBE_DEADLINE=600 GARDEN_CANARY_WATCH=0 \
    GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$TR/mock-state" GARDEN_MOCK_LOG="$TR/mock-log" \
    GARDEN_UPGRADE_READY_MARKER="$state/deploy/upgrade-ready" \
    GARDEN_ROLLING_DEPLOY_CMD="$TR/rec-deploy.sh" \
    GARDEN_ROLLING_DRAIN_OP="$TR/rec-drain.sh" \
    GARDEN_ROLLING_POST_JOB="$JOBS/post-job.sh" \
    GARDEN_ALERT_CMD="$TR/rec-alert.sh" \
    "$@" \
    "$JOBS/rolling-deploy.sh" >>"$TR/conductor.out" 2>&1
}
set_leader_signal() { mkdir -p "$TR/state-leader/deploy"; printf 'Upgrade ready\n\navailable: %s\n' "$1" > "$TR/state-leader/deploy/upgrade-ready"; }
clear_leader_signal() { rm -f "$TR/state-leader/deploy/upgrade-ready"; }
reset_leader_roll_state() { rm -rf "$TR/state-leader/rolling-deploy/roll" "$TR/state-leader/rolling-deploy/settle"; }

# ============================================================================
hr; echo "STATIC — scripts parse; no LLM; attestation boundary (no bus read / no deploy op)"; hr
for f in rolling-deploy.sh self-deploy.sh; do
  bash -n "$JOBS/$f" && ok "$f parses" || bad "$f has a syntax error"
done
# NO claude/LLM anywhere in the deploy trigger path.
if ! grep -qE '(^|[^a-z])claude( |$|-p)' "$JOBS/rolling-deploy.sh" "$JOBS/self-deploy.sh"; then
  ok "neither conductor nor follower daemon invokes claude/an LLM"
else bad "an LLM invocation leaked into the deploy trigger path"; fi
# The attestation boundary: the conductor sends NO sysop deploy op. Its only op sends
# are benign drain (op=drain). Assert no 'op=deploy' token in either script.
if ! grep -qE 'op=deploy' "$JOBS/rolling-deploy.sh" "$JOBS/self-deploy.sh"; then
  ok "no sysop 'op=deploy' issued by the roll (attestation untouched)"
else bad "the roll issues a sysop deploy op (would route through the attestation boundary)"; fi
# The deploy DECISION reads no bus message: neither script reads a msgs/ path.
if ! grep -qE 'msgs/' "$JOBS/rolling-deploy.sh" "$JOBS/self-deploy.sh"; then
  ok "no msgs/ path is read to decide to deploy (design point-4 invariant)"
else bad "a msgs/ read leaked into the deploy decision"; fi

# ============================================================================
hr; echo "REQUIREMENT TOKEN — host=<GARDEN> pins a job to one host's workers"; hr
# A capable host (GARDEN == pinned) claims; an incapable host skips (job stays in todo).
push_change "jobs/todo/pin-demo.md" $'---\nrequires: host='"$F1"$'\n---\n# pin-demo' "seed host-pinned job"
STUB="$HERE/stub-handler.sh"
# Incapable host: F2 must NOT claim pin-demo.
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$F2" GARDEN_STATE="$TR/state-claim-f2" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=0 \
  GARDEN_JOB_HANDLER="$STUB" "$JOBS/gardener.sh" 1 >"$TR/claim-f2.log" 2>&1 || true
if [ -n "$(from_bare jobs/todo/pin-demo.md)" ] && [ -z "$(tada_tree_path pin-demo)" ]; then
  ok "incapable host ($F2) did NOT claim the host=$F1-pinned job (left in todo)"
else bad "incapable host claimed or moved a host-pinned job it should skip"; fi
# Capable host: F1 claims and completes it.
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$F1" GARDEN_STATE="$TR/state-claim-f1" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=0 \
  GARDEN_JOB_HANDLER="$STUB" "$JOBS/gardener.sh" 1 >"$TR/claim-f1.log" 2>&1 || true
if [ -n "$(tada_from_bare pin-demo)" ]; then
  ok "capable host ($F1) claimed and completed the host-pinned job"
else bad "capable host did not complete the host-pinned job (see $TR/claim-f1.log)"; fi

# ============================================================================
hr; echo "CANARY PROBE — a real gardener completes a canary-probe job with NO handler"; hr
push_change "jobs/todo/canary-live.md" $'---\nrequires: host='"$F1"$'\ncanary-probe: true\n---\n# live canary probe' "seed live canary probe"
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$F1" GARDEN_STATE="$TR/state-canary-f1" GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=0 \
  GARDEN_JOB_HANDLER="$STUB" "$JOBS/gardener.sh" 1 >"$TR/canary-live.log" 2>&1 || true
probe_report="$(tada_from_bare canary-live)"
# Proof of the no-LLM path: the report carries the short-circuit's own marker AND the
# worker logged the canary-probe short-circuit line — the handler was never invoked
# (its "working '<base>'" line is only logged on the handler path, not the short-circuit).
if grep -q 'canary-probe: ok' <<<"$probe_report" \
   && grep -q "completed canary probe 'canary-live'" "$TR/canary-live.log" \
   && ! grep -q "working 'canary-live'" "$TR/canary-live.log"; then
  ok "canary-probe job completed via the no-LLM short-circuit (real claim→tada round trip, no handler)"
else bad "canary-probe short-circuit did not complete the round trip (see $TR/canary-live.log)"; fi

# ============================================================================
hr; echo "ROLL — followers first as canaries, canary pass advances the leader LAST"; hr
seed_fleet_hosts "$LEADER" "$F1" "$F2"
set_leader_signal "$TARGET"
reset_leader_roll_state
: > "$DEPLOY_LOG"

# Tick 1: releases the FIRST follower (sorted: F1), leader NOT deployed.
run_conductor
rel_f1="$(from_bare "deploy/roll/$F1" | tr -d '[:space:]')"
if [ "$rel_f1" = "$TARGET" ] && [ -z "$(from_bare "deploy/roll/$F2")" ] && ! grep -q deploy-invoked "$DEPLOY_LOG"; then
  ok "tick 1 released canary F1 only (release token written); leader did NOT advance"
else bad "tick 1 ordering wrong (rel_f1=$rel_f1, f2=$(from_bare deploy/roll/$F2 | tr -d '[:space:]'), deploy=$(cat "$DEPLOY_LOG"))"; fi

# F1 deploys to target. Tick 2: posts the round-trip probe, still waiting.
simulate_follower_deploy "$F1" "$TARGET"
run_conductor
if [ -n "$(from_bare "jobs/todo/canary-probe-$F1-$TARGET12.md")" ]; then
  probe_body="$(from_bare "jobs/todo/canary-probe-$F1-$TARGET12.md")"
  grep -q "requires: host=$F1" <<<"$probe_body" && grep -q 'canary-probe: true' <<<"$probe_body" \
    && ok "tick 2 posted a host-pinned canary-probe job for F1" \
    || bad "tick 2 probe missing host-pin or canary marker"
else bad "tick 2 did not post the canary probe for F1"; fi
grep -q deploy-invoked "$DEPLOY_LOG" && bad "leader advanced while F1 canary still validating" || ok "leader still not advanced (F1 validating)"

# Probe reaches tada. Tick 3: F1 passes → releases F2.
seed_probe_tada "$F1"
run_conductor
rel_f2="$(from_bare "deploy/roll/$F2" | tr -d '[:space:]')"
if [ "$rel_f2" = "$TARGET" ] && ! grep -q deploy-invoked "$DEPLOY_LOG"; then
  ok "tick 3: F1 canary PASSED → released F2; leader still not advanced"
else bad "tick 3 did not advance the roll to F2 (rel_f2=$rel_f2, deploy=$(cat "$DEPLOY_LOG"))"; fi

# F2 deploys + probe passes. Ticks: post probe, then pass → leader self-deploys LAST.
simulate_follower_deploy "$F2" "$TARGET"
run_conductor                     # posts F2 probe
seed_probe_tada "$F2"
run_conductor                     # F2 passes → all canaries passed → leader self-deploys
if grep -q "deploy-invoked host=$LEADER" "$DEPLOY_LOG"; then
  ok "all canaries passed → leader self-deployed LAST (deploy-garden.sh invoked on the leader)"
else bad "leader did not self-deploy after all canaries passed (deploy log: $(cat "$DEPLOY_LOG"))"; fi

# ============================================================================
hr; echo "HALT — a failed canary halts the roll, leaves the canary drained, never advances the leader"; hr
# Fresh single-follower fleet.
push_change "hosts/$F2" "@DELETE" "drop F2 for the halt fleet"
push_change "deploy/roll/$F1" "@DELETE" "clear F1 release for halt fleet"
push_change "fleet/deployed/$F1" "@DELETE" "clear F1 deployed"
push_change "fleet/health/$F1" "@DELETE" "clear F1 health"
set_leader_signal "$TARGET"; reset_leader_roll_state
: > "$DEPLOY_LOG"; : > "$DRAIN_LOG"; : > "$ALERT_LOG"
run_conductor                                   # release F1
# F1 deploys but with a BROKEN unit-health record (a failed unit).
simulate_follower_deploy "$F1" "$TARGET" deployed "1" "garden-foreman.service"
run_conductor                                   # validate → unit health FAIL → HALT
if ! grep -q deploy-invoked "$DEPLOY_LOG"; then ok "HALT: leader did NOT self-deploy on a failed canary"; else bad "leader advanced on a failed canary"; fi
if grep -q "$F1" "$DRAIN_LOG" && grep -q 'state=on' "$DRAIN_LOG"; then ok "HALT: failed canary F1 left DRAINED (benign drain op sent)"; else bad "failed canary not drained (drain log: $(cat "$DRAIN_LOG"))"; fi
if grep -q "key=rolling-deploy-canary-failed-$F1" "$ALERT_LOG"; then ok "HALT: maintainer paged once, keyed to the failed canary"; else bad "maintainer not paged on canary failure (alerts: $(cat "$ALERT_LOG"))"; fi
# A later tick keeps holding (leader never advances after a recorded halt).
: > "$DEPLOY_LOG"
run_conductor
grep -q deploy-invoked "$DEPLOY_LOG" && bad "leader advanced on a later tick despite the halt" || ok "later tick keeps HOLDING (leader still not advanced)"

# ============================================================================
hr; echo "SKIP — an operator-drained follower is skipped, the roll proceeds with the rest"; hr
seed_fleet_hosts "$F2"                          # two followers again: F1 (drained) + F2 (good)
push_change "deploy/roll/$F1" "@DELETE" "clear F1 release"
push_change "deploy/roll/$F2" "@DELETE" "clear F2 release"
push_change "fleet/deployed/$F1" "@DELETE" "clear F1 deployed"
push_change "fleet/health/$F1" "@DELETE" "clear F1 health"
push_change "fleet/deployed/$F2" "@DELETE" "clear F2 deployed"
push_change "fleet/health/$F2" "@DELETE" "clear F2 health"
set_leader_signal "$TARGET"; reset_leader_roll_state
: > "$DEPLOY_LOG"
run_conductor                                   # release F1
# F1 is operator-drained: it declines and publishes operator-drained (un-advanced sha).
simulate_follower_deploy "$F1" "0000000000000000000000000000000000000000" operator-drained "3/3"
run_conductor                                   # sees drained → SKIP F1, release F2
rel_f2b="$(from_bare "deploy/roll/$F2" | tr -d '[:space:]')"
if [ "$rel_f2b" = "$TARGET" ]; then ok "operator-drained F1 SKIPPED; roll released F2 (proceeds with the rest)"; else bad "roll did not skip drained F1 to F2 (rel_f2=$rel_f2b)"; fi
simulate_follower_deploy "$F2" "$TARGET"
run_conductor; seed_probe_tada "$F2"; run_conductor
if grep -q "deploy-invoked host=$LEADER" "$DEPLOY_LOG"; then ok "leader advanced after the sole live canary (F2) passed"; else bad "leader did not advance after skipping the drained follower"; fi

# ============================================================================
hr; echo "LEADER-ONLY FLEET — no followers → leader self-deploys directly"; hr
push_change "hosts/$F1" "@DELETE" "drop F1"
push_change "hosts/$F2" "@DELETE" "drop F2"
set_leader_signal "$TARGET"; reset_leader_roll_state
: > "$DEPLOY_LOG"
run_conductor
if grep -q "deploy-invoked host=$LEADER" "$DEPLOY_LOG"; then ok "leader-only fleet self-deployed directly (no canary by construction)"; else bad "leader-only fleet did not self-deploy"; fi

# ============================================================================
hr; echo "SETTLE — a fresh tip is not rolled until the settle window elapses"; hr
seed_fleet_hosts "$F1"
push_change "deploy/roll/$F1" "@DELETE" "clear F1 release for settle test"
set_leader_signal "$TARGET"; reset_leader_roll_state
: > "$DEPLOY_LOG"
# SETTLE=600 with NOW pinned to first-observation → not settled → no release.
run_conductor GARDEN_SELF_DEPLOY_SETTLE=600 GARDEN_ROLLING_NOW=1000
if [ -z "$(from_bare "deploy/roll/$F1" | tr -d '[:space:]')" ]; then ok "unsettled tip: no canary released"; else bad "released a canary before the settle window elapsed"; fi
# NOW advanced past the window → now it releases.
run_conductor GARDEN_SELF_DEPLOY_SETTLE=600 GARDEN_ROLLING_NOW=2000
if [ "$(from_bare "deploy/roll/$F1" | tr -d '[:space:]')" = "$TARGET" ]; then ok "settled tip: canary released"; else bad "settled tip was not released"; fi

# ============================================================================
hr; echo "FOLLOWER DAEMON — release / leaderless-grace / hold / operator-drained decline"; hr
: > "$DEPLOY_LOG"
run_self_deploy() {  # run_self_deploy <host> [EXTRA_ENV=VAL...]
  local host="$1"; shift
  local state="$TR/sd-state-$host"
  mkdir -p "$state/deploy"
  env -i PATH="$PATH" HOME="$HOME" \
    GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN="$host" GARDEN_STATE="$state" GARDEN_SELF_DEPLOY_SETTLE=0 \
    GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$TR/mock-state" GARDEN_MOCK_LOG="$TR/mock-log" \
    GARDEN_UPGRADE_READY_MARKER="$state/deploy/upgrade-ready" \
    GARDEN_SELF_DEPLOY_DEPLOY_CMD="$TR/rec-deploy.sh" \
    "$@" \
    "$JOBS/self-deploy.sh" >>"$TR/self-deploy.out" 2>&1
}
sd_signal() { mkdir -p "$TR/sd-state-$1/deploy"; printf 'Upgrade ready\n\navailable: %s\n' "$2" > "$TR/sd-state-$1/deploy/upgrade-ready"; }

# (a) PRIMARY: leader released this follower → it deploys.
push_change "deploy/roll/$F1" "$TARGET" "release F1 for follower-daemon test"
sd_signal "$F1" "$TARGET"; : > "$DEPLOY_LOG"
run_self_deploy "$F1" GARDEN_LEADER="$LEADER"
grep -q "deploy-invoked host=$F1" "$DEPLOY_LOG" && ok "follower deploys on a leader release token (primary path)" || bad "follower did not deploy on a release token"

# (b) HOLD: live leader, no release for this host → waits (no deploy).
push_change "deploy/roll/$F2" "@DELETE" "no release for F2"
sd_signal "$F2" "$TARGET"; : > "$DEPLOY_LOG"
run_self_deploy "$F2" GARDEN_LEADER="$LEADER"
grep -q deploy-invoked "$DEPLOY_LOG" && bad "follower deployed with a live leader and no release" || ok "follower HOLDS for the roll (live leader, no release)"

# (c) LEADERLESS-GRACE HEADLESS: no leader marker + leader-sha==target → deploys.
push_change "deploy/leader-sha" "$TARGET" "seed last-known-good leader sha"
sd_signal "$F2" "$TARGET"; : > "$DEPLOY_LOG"
# No GARDEN_LEADER, no journal leader marker → leaderless; leader-sha==target passes the
# "never get ahead of last-known-good" canary.
run_self_deploy "$F2" GARDEN_LEADER=""
grep -q "deploy-invoked host=$F2" "$DEPLOY_LOG" && ok "leaderless headless fallback deploys to the last-known-good sha" || bad "leaderless headless fallback did not deploy"

# (d) LEADERLESS but target AHEAD of last-known-good → HOLDS (never race ahead).
push_change "deploy/roll/$F1" "@DELETE" "clear F1 release so (d) exercises the leaderless path, not the primary"
push_change "deploy/leader-sha" "9999999999999999999999999999999999999999" "lkg behind target"
sd_signal "$F1" "$TARGET"; : > "$DEPLOY_LOG"
run_self_deploy "$F1" GARDEN_LEADER="" GARDEN_SELF_DEPLOY_ANCESTOR_CMD=/bin/false GARDEN_SELF_DEPLOY_STATE="$TR/sd-state-ahead"
grep -q deploy-invoked "$DEPLOY_LOG" && bad "follower raced ahead of the last-known-good sha" || ok "leaderless follower HOLDS when target is ahead of last-known-good"

# (e) OPERATOR-DRAINED DECLINE: released but drained → publishes operator-drained, no deploy.
push_change "deploy/roll/$F1" "$TARGET" "release F1 for drain-decline test"
sd_signal "$F1" "$TARGET"; : > "$DEPLOY_LOG"
mkdir -p "$TR/sd-state-drain/deploy"; printf 'Upgrade ready\n\navailable: %s\n' "$TARGET" > "$TR/sd-state-drain/deploy/upgrade-ready"
touch "$TR/sd-state-drain/draining"
env -i PATH="$PATH" HOME="$HOME" \
  GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
  GARDEN="$F1" GARDEN_STATE="$TR/sd-state-drain" GARDEN_LEADER="$LEADER" GARDEN_SELF_DEPLOY_SETTLE=0 \
  GARDEN_UNIT_CTL="$MOCK" GARDEN_MOCK_STATE="$TR/mock-state" GARDEN_MOCK_LOG="$TR/mock-log" \
  GARDEN_UPGRADE_READY_MARKER="$TR/sd-state-drain/deploy/upgrade-ready" \
  GARDEN_SELF_DEPLOY_DEPLOY_CMD="$TR/rec-deploy.sh" \
  "$JOBS/self-deploy.sh" >>"$TR/self-deploy.out" 2>&1 || true
if ! grep -q "deploy-invoked host=$F1" "$DEPLOY_LOG" && [ "$(sed -n 's/^roll_status:[[:space:]]*//p' <<<"$(from_bare "fleet/health/$F1")" | tail -1)" = operator-drained ]; then
  ok "operator-drained follower DECLINES the release and publishes operator-drained status"
else bad "operator-drained decline did not publish the right status / deployed anyway"; fi

# ============================================================================
hr; echo "RESULTS"; hr
echo "  PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ] || { echo "  (test root kept: $TR)"; exit 1; }
rm -rf "$TR"
exit 0
