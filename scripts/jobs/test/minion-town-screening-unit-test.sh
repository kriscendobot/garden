#!/bin/bash
# Regression: screening owns a timer outside proxy's 600-second self-heal budget,
# and an rc-124 tick overrun is logged and delivered to the maintainer channel.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
SYSTEMD="$ROOT/scripts/systemd"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-screen-unit.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

bad() { echo "not ok - $*"; exit 1; }
ok() { echo "ok - $*"; }

! grep -q 'screen-delegated-prs' "$JOBS/proxy.sh" \
  || bad "proxy still invokes the screener"
grep -q 'screen-delegated-prs-tick.sh' "$SYSTEMD/garden-minion-town-screening.service" \
  || bad "dedicated service does not own the screener"
grep -q '^Environment=SELF_HEAL_HANDLER_TIMEOUT=0$' "$SYSTEMD/garden-minion-town-screening.service" \
  || bad "the proxy-class 600-second self-heal deadline still wraps screening"
grep -q '^TimeoutStartSec=2100$' "$SYSTEMD/garden-minion-town-screening.service" \
  || bad "dedicated service lacks headroom beyond the 1800-second tick bound"
ok "screening is isolated from the proxy handler budget"

cat > "$TR/screener" <<'EOF'
#!/bin/bash
case "$(cat "$SCREEN_TEST_MODE")" in
  slow) sleep 30 ;;
  pass) exit 0 ;;
esac
EOF
cat > "$TR/alert" <<'EOF'
#!/bin/bash
printf '%s\t%s\t%s\n' "$1" "$(printf '%s' "$2" | tr '\n' ' ')" "${3:-}" >> "$SCREEN_TEST_ALERTS"
EOF
chmod +x "$TR/screener" "$TR/alert"
printf 'slow\n' > "$TR/mode"

common_env=(
  GARDEN_ROOT="$ROOT"
  GARDEN_STATE="$TR/state"
  GARDEN=screen-test-host
  GARDEN_SCREEN_TICK_COMMAND="$TR/screener"
  GARDEN_SCREEN_TICK_TIMEOUT=1
  GARDEN_SCREEN_TICK_KILL_AFTER=1
  GARDEN_ALERT_CMD="$TR/alert"
  SCREEN_TEST_MODE="$TR/mode"
  SCREEN_TEST_ALERTS="$TR/alerts"
)
env "${common_env[@]}" "$JOBS/screen-delegated-prs-tick.sh" >"$TR/out" 2>"$TR/err"
grep -q 'exceeded 1s (rc=124)' "$TR/err" \
  || bad "rc-124 overrun was not logged"
grep -q 'minion-town-screening-tick-failed-screen-test-host' "$TR/alerts" \
  || bad "rc-124 overrun was not sent to the maintainer channel"
[ -f "$TR/state/screening/tick-timeout" ] \
  || bad "rc-124 overrun left no recovery marker"
ok "rc-124 tick overrun is visible and durably marked"

printf 'pass\n' > "$TR/mode"
env "${common_env[@]}" "$JOBS/screen-delegated-prs-tick.sh" >"$TR/recovery.out" 2>"$TR/recovery.err"
grep -q 'RECOVERED:' "$TR/alerts" \
  || bad "successful retry did not close the overrun episode"
[ ! -e "$TR/state/screening/tick-timeout" ] \
  || bad "successful retry did not remove the recovery marker"
ok "successful tick closes the timeout notice"
