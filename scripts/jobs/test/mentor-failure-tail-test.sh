#!/bin/bash
# mentor-failure-tail-test.sh — when the priority-filtered journalctl scan shows
# systemd failure records for garden-* units, mentor.sh appends exactly one
# bounded, labelled, same-window tail per unique failed unit (capped in count,
# lines, and bytes); a scan with no failure record appends no tails.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/garden-mentor-tail.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; BIN="$TR/bin"
mkdir -p "$BIN" "$TR/state"
git init -q --bare "$BARE"
git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/entries"; : > "$SEED/entries/.keep"
git -C "$SEED" add entries/.keep
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

# journalctl stub: the wildcard priority scan returns $SCAN; a per-unit read
# logs its argv and emits 100 numbered diagnostic lines honoring -n.
cat > "$BIN/journalctl" <<'EOS'
#!/bin/bash
unit=""; n=""; prio=""
while [ $# -gt 0 ]; do
  case "$1" in -u) unit="$2"; shift ;; -n) n="$2"; shift ;; -p) prio="$2"; shift ;; esac
  shift
done
if [ "$unit" = 'garden-*' ]; then cat "$SCAN"; exit 0; fi
printf '%s n=%s prio=%s\n' "$unit" "$n" "$prio" >> "$TAIL_LOG"
[ "$unit" = garden-quiet.service ] && { echo '-- No entries --'; exit 0; }
for i in $(seq 1 100); do echo "Nov 08 22:51:0 h $unit[1]: diag line $i"; done | tail -n "$n"
EOS
cat > "$TR/handler" <<'EOS'
#!/bin/sh
git -C "$2" cat-file -p "$1" > "$DIGEST_LOG"
EOS
chmod +x "$BIN/journalctl" "$TR/handler"
export SCAN="$TR/scan" TAIL_LOG="$TR/tails" DIGEST_LOG="$TR/digest"

run_mentor() {
  rm -f "$TAIL_LOG" "$DIGEST_LOG" "$TR/state/mentor/journalctl-since"
  env PATH="$BIN:$PATH" GARDEN=testhost GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)" \
    GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_HANDLER="$TR/handler" "$@" "$JOBS/mentor.sh"
}
fail() { echo "FAIL: $*"; echo '--- digest'; cat "$DIGEST_LOG" 2>/dev/null; exit 1; }

cat > "$SCAN" <<'EOS'
Nov 08 22:51:01 h systemd[9]: garden-a.service: Main process exited, code=exited, status=1/FAILURE
Nov 08 22:51:01 h systemd[9]: garden-a.service: Failed with result 'exit-code'.
Nov 08 22:51:02 h systemd[9]: garden-ci-watcher@x-y.service: Failed with result 'exit-code'.
Nov 08 22:51:03 h systemd[9]: garden-a.service: Failed with result 'exit-code'.
Nov 08 22:51:04 h systemd[9]: garden-quiet.service: Failed with result 'exit-code'.
Nov 08 22:51:05 h systemd[9]: garden-b.service: Failed with result 'exit-code'.
EOS

# 1. one tail per unique unit, first-seen order, all priorities, bounded lines.
run_mentor env GARDEN_MENTOR_FAILURE_TAIL_LINES=7
[ "$(wc -l < "$TAIL_LOG")" -eq 4 ] || fail "expected 4 unit tails, got $(cat "$TAIL_LOG")"
[ "$(cut -d' ' -f1 "$TAIL_LOG" | tr '\n' ' ')" = 'garden-a.service garden-ci-watcher@x-y.service garden-quiet.service garden-b.service ' ] \
  || fail "unit order/dedupe wrong: $(cat "$TAIL_LOG")"
grep -q 'prio= ' "$TAIL_LOG" || grep -q 'prio=$' "$TAIL_LOG" || fail 'tail was priority-filtered'
grep -qF '===== failed-unit tail 1/4: garden-a.service (last 7 lines' "$DIGEST_LOG" || fail 'missing label'
[ "$(grep -c 'garden-a.service\[1\]: diag line' "$DIGEST_LOG")" -eq 7 ] || fail 'line cap not honored'
grep -q 'diag line 100' "$DIGEST_LOG" || fail 'tail did not keep the end of the window'
grep -q '(no journal lines for garden-quiet.service in this window)' "$DIGEST_LOG" || fail 'empty tail not labelled'

# 2. unit-count cap with an explicit truncation marker; byte cap.
run_mentor env GARDEN_MENTOR_FAILURE_TAIL_UNITS=2 GARDEN_MENTOR_FAILURE_TAIL_BYTES=200
[ "$(wc -l < "$TAIL_LOG")" -eq 2 ] || fail 'unit cap not honored'
grep -qF 'failed-unit tails truncated: 2 more unit(s) omitted: garden-quiet.service garden-b.service' "$DIGEST_LOG" \
  || fail 'missing truncation marker'
body="$(awk '/failed-unit tail 1\/4/{f=1;next} /=====/{f=0} f' "$DIGEST_LOG")"
grep -q "older lines elided" <<< "$body" || fail "missing elision note"
grep -q "^Nov 08 22:51:0 h garden-a.service\[1\]: diag line 100$" <<< "$body" || fail "cap kept a partial tail"
[ "${#body}" -le 200 ] || fail "byte cap not honored (${#body})"

# 3. warnings without a failure record → no tails at all.
echo 'Nov 08 22:51:01 h garden-a.sh[3]: WARN: something odd' > "$SCAN"
run_mentor
[ ! -e "$TAIL_LOG" ] || fail 'tails appended without a failure record'
grep -q 'failed-unit tail' "$DIGEST_LOG" && fail 'digest carries tails without a failure record'
echo 'PASS: mentor-failure-tail-test'
