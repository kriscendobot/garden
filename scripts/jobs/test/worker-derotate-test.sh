#!/bin/bash
# Hermetic coverage for worker-derotate.sh: heartbeat-driven worker-leveling
# derotation and its exact, ownership-gated restore.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/var/tmp}/garden-worker-derotate.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }
git_id=(-c user.name=test -c user.email=test@example.invalid)

LEADER=leader-host; A=alpha-host; B=beta-host; C=gamma-host
BARE="$TR/journal.git"; WORK="$TR/work"
git init -q --bare "$BARE"
git init -q "$WORK"; git -C "$WORK" checkout -q -b journal2
git -C "$WORK" "${git_id[@]}" commit -q --allow-empty -m seed
git -C "$WORK" remote add origin "$BARE"
git -C "$WORK" push -q -u origin journal2
git -C "$WORK" config user.name test; git -C "$WORK" config user.email test@example.invalid

ALERT_LOG="$TR/alert.log"; : >"$ALERT_LOG"
ALERT_SINK="$TR/alert-sink"
cat >"$ALERT_SINK" <<EOF
#!/bin/bash
printf 'ALERT key=%s msg=%s\n' "\$1" "\$(printf %s "\$2" | head -1)" >> "$ALERT_LOG"
EOF
chmod +x "$ALERT_SINK"

NOW=100000
resync() { git -C "$WORK" fetch -q origin journal2; git -C "$WORK" reset -q --hard origin/journal2; }
beat() { # host age-seconds  (pool-scoped heartbeat, as usage-meter publishes)
  mkdir -p "$WORK/budget/live/pool-$1"
  printf 'host: %s\nsampled_at_epoch: %s\n' "$1" "$((NOW - $2))" >"$WORK/budget/live/pool-$1/$1"
}
publish() { git -C "$WORK" add -A; git -C "$WORK" "${git_id[@]}" commit -q -m fixture --allow-empty; git -C "$WORK" push -q origin HEAD:journal2; }
seed() { # leveling rows...
  resync
  rm -rf "$WORK/budget" "$WORK/worker-derotate"; mkdir -p "$WORK/config"
  { printf '# fixture\nmonk-fleet-ceiling\t10\ncleric-fleet-ceiling\t0\n'; for r in "$@"; do printf 'host\t%s\n' "$r"; done; } \
    >"$WORK/config/worker-leveling"
}
tick() {
  env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN="$LEADER" GARDEN_LEADER="$LEADER" \
    GARDEN_STATE="$TR/state" GARDEN_WORKER_DEROTATE_NOW="$NOW" GARDEN_HOST_OFFLINE_AFTER=1800 \
    GARDEN_ALERT_CMD="$ALERT_SINK" GARDEN_WORKER_DEROTATE_CONFIRM="${CONFIRM:-2}" \
    /bin/bash "$JOBS/worker-derotate.sh" "$@" >>"$TR/tick.log" 2>&1
}
row() { resync; awk -v h="$1" '$1=="host"&&$2==h{print $3" "$4}' "$WORK/config/worker-leveling"; }
marker() { resync; [ -f "$WORK/worker-derotate/$1" ]; }
alerts() { grep -c "key=$1 " "$ALERT_LOG" || true; }

# 1. present→offline: zeroes the row and records the exact prior caps, once.
seed "$LEADER	4	4" "$A	3	2" "$B	4	0"
beat "$LEADER" 60; beat "$A" 60; beat "$B" 7200; publish
tick
if [ "$(row "$B")" = "4 0" ] && ! marker "$B"; then ok "first offline observation only confirms (dwell 1/2), no change"
else bad "first offline tick changed the row early: $(row "$B")"; fi
tick
if [ "$(row "$B")" = "0 0" ] && marker "$B" \
   && grep -q '^prior_monk: 4$' "$WORK/worker-derotate/$B" && grep -q '^prior_cleric: 0$' "$WORK/worker-derotate/$B" \
   && grep -q '^reason: heartbeat-offline$' "$WORK/worker-derotate/$B" \
   && [ "$(row "$A")" = "3 2" ] && [ "$(row "$LEADER")" = "4 4" ] \
   && grep -q '^monk-fleet-ceiling	10$' "$WORK/config/worker-leveling"; then
  ok "confirmed offline host zeroed, prior caps 4 0 recorded, peers and ceilings untouched"
else bad "derotation wrong: B='$(row "$B")' marker=$(marker "$B" && echo y || echo n)"; fi
before="$(alerts "worker-derotate-$B")"
tick; tick; tick
after="$(alerts "worker-derotate-$B")"
if [ "$before" = 1 ] && [ "$after" = 1 ]; then ok "derotation notice is edge-triggered: 1 notice after 1 tick, still 1 after 3 more"
else bad "derotation notice count before=$before after=$after"; fi

# 2. offline→present on a mechanism-owned row: restores exactly and notices once.
resync; beat "$B" 30; publish
tick
if [ "$(row "$B")" = "4 0" ] && ! marker "$B"; then ok "heartbeat resumed: owned row restored exactly to 4 0 and marker dropped"
else bad "restore wrong: B='$(row "$B")'"; fi
if grep -q "key=worker-derotate-$B msg=RECOVERED: heartbeat resumed for $B" "$ALERT_LOG"; then ok "restore closes the same notice key with one RECOVERED notice"
else bad "recovery notice missing: $(cat "$ALERT_LOG")"; fi
rec_before="$(grep -c RECOVERED "$ALERT_LOG" || true)"; tick; tick
if [ "$(grep -c RECOVERED "$ALERT_LOG" || true)" = "$rec_before" ] && [ "$(row "$B")" = "4 0" ]; then ok "steady present host: no further notices or writes"
else bad "present host churned after restore"; fi

# 3. offline→present for a HUMAN zero (no marker): never auto-restored.
: >"$ALERT_LOG"
seed "$LEADER	4	4" "$A	0	0"
beat "$LEADER" 60; beat "$A" 9000; publish
tick; tick
resync; beat "$A" 30; publish
tick; tick
if [ "$(row "$A")" = "0 0" ] && ! marker "$A" && [ ! -s "$ALERT_LOG" ]; then ok "operator-zeroed row is never adopted or restored, offline or present, and raises no notice"
else bad "operator zero was touched: A='$(row "$A")' alerts=$(cat "$ALERT_LOG")"; fi

# 3b. operator re-sets a derotated row while it is offline: their value stands.
seed "$LEADER	4	4" "$A	2	1"
beat "$LEADER" 60; beat "$A" 9000; publish
CONFIRM=1 tick
resync; printf '# fixture\nmonk-fleet-ceiling\t10\ncleric-fleet-ceiling\t0\nhost\t%s\t4\t4\nhost\t%s\t1\t0\n' "$LEADER" "$A" >"$WORK/config/worker-leveling"; publish
tick
resync; beat "$A" 30; publish
tick
if [ "$(row "$A")" = "1 0" ] && ! marker "$A"; then ok "operator re-set of a derotated row relinquishes ownership; resumed heartbeat does not overwrite 1 0 with 2 1"
else bad "operator re-set overwritten: A='$(row "$A")'"; fi

# 4. broken/unreadable heartbeat: neither zeroes nor restores.
: >"$ALERT_LOG"
seed "$LEADER	4	4" "$A	3	0" "$C	0	0"
mkdir -p "$WORK/worker-derotate"
printf 'host: %s\nreason: heartbeat-offline\nprior_monk: 2\nprior_cleric: 0\n' "$C" >"$WORK/worker-derotate/$C"
beat "$LEADER" 60
mkdir -p "$WORK/budget/live/pool-$A" "$WORK/budget/live/pool-$C"
printf 'sampled_at_epoch: garbage\nsampled_at: not-a-date\n' >"$WORK/budget/live/pool-$A/$A"
printf 'sampled_at_epoch: \n' >"$WORK/budget/live/pool-$C/$C"
publish
tick; tick; tick
if [ "$(row "$A")" = "3 0" ] && ! marker "$A"; then ok "unparseable heartbeat never zeroes a live row"
else bad "unknown liveness zeroed A: '$(row "$A")'"; fi
if [ "$(row "$C")" = "0 0" ] && marker "$C"; then ok "unparseable heartbeat never restores an owned row"
else bad "unknown liveness restored C: '$(row "$C")'"; fi
if [ "$(alerts "worker-derotate-unknown-$A")" = 1 ]; then ok "unknown liveness raised once (edge-latched) across 3 ticks"
else bad "unknown alert count $(alerts "worker-derotate-unknown-$A")"; fi

# 5. the leader's own stale heartbeat freezes the whole tick.
: >"$ALERT_LOG"
seed "$LEADER	4	4" "$A	3	0"
beat "$LEADER" 9000; beat "$A" 9000; publish
CONFIRM=1 tick
if [ "$(row "$A")" = "3 0" ] && [ "$(alerts worker-derotate-self-stale)" = 1 ]; then ok "stale leader view freezes derotation loudly"
else bad "stale leader view still acted: A='$(row "$A")'"; fi

# 6. adopt: hand a manually zeroed row to the mechanism (the oros-studio takeover).
seed "$LEADER	4	4" "$A	0	0"
beat "$LEADER" 60; beat "$A" 9000; publish
tick adopt "$A" 4 0
tick
if [ "$(row "$A")" = "0 0" ] && marker "$A" && grep -q '^reason: operator-adopted$' "$WORK/worker-derotate/$A"; then ok "adopted zero held while the host is still offline"
else bad "adopt state wrong: A='$(row "$A")'"; fi
resync; beat "$A" 30; publish
tick
if [ "$(row "$A")" = "4 0" ] && ! marker "$A"; then ok "adopted row restored to the handed-over 4 0 on heartbeat"
else bad "adopted row not restored: A='$(row "$A")'"; fi
if ! tick adopt "$A" 4 0; then ok "adopt refuses a row that is not 0 0"
else bad "adopt accepted a nonzero row"; fi

# 7. the leader never derotates itself; followers never act.
seed "$LEADER	4	4" "$A	3	0"
beat "$LEADER" 60; beat "$A" 9000; publish
env -i PATH="$PATH" HOME="$HOME" GARDEN_TEST=1 GARDEN_ROOT="$ROOT" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
  GARDEN="$A" GARDEN_LEADER="$LEADER" GARDEN_STATE="$TR/state-f" GARDEN_WORKER_DEROTATE_NOW="$NOW" \
  GARDEN_ALERT_CMD="$ALERT_SINK" GARDEN_WORKER_DEROTATE_CONFIRM=1 /bin/bash "$JOBS/worker-derotate.sh" >>"$TR/tick.log" 2>&1
if [ "$(row "$A")" = "3 0" ]; then ok "a follower's tick is a no-op"; else bad "follower acted"; fi

echo "worker-derotate-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ] || { echo "--- tick log"; tail -40 "$TR/tick.log"; }
[ "$fail" -eq 0 ]
