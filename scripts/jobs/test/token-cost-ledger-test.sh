#!/bin/bash
# Hermetic end-to-end proof: handler handoff -> journal CostRecord -> tada footer
# -> reputation event -> reducer arm attempt.  No provider or agent is involved.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"; ROOT="$(cd "$JOBS/../.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1 GARDEN_ROOT="$ROOT" GARDEN_NO_MAINTAINER_ALERT=1
TR="$(mktemp -d "${TMPDIR:-/tmp}/token-ledger.XXXXXX")"; HANDLER="$(dirname "$ROOT")/token-ledger-handler-$$.sh"; trap 'rm -rf "$TR" "$HANDLER"' EXIT
BARE="$TR/journal.git"; SEED="$TR/seed"; git init -q --bare "$BARE"; git init -q "$SEED"
git -C "$SEED" checkout -q -b journal2
( cd "$SEED"; mkdir -p jobs/{todo,doin,tada,bids} work repos msgs hosts entries schedules cursors inbox/maintainer/{unread,read} reputation/{events,pending,arms,verdicts,reviews};
  for d in jobs/todo jobs/doin jobs/tada jobs/bids work repos msgs hosts entries schedules cursors inbox/maintainer/unread inbox/maintainer/read reputation/events reputation/pending reputation/arms reputation/verdicts reputation/reviews; do touch "$d/.gitkeep"; done
  printf -- '---\nrole: builder\n---\nledger fixture\n' > jobs/todo/ledger-job.md
  git add -A; git -c user.name=test -c user.email=test@localhost commit -qm seed; git remote add origin "$BARE"; git push -q -u origin journal2 )
cat > "$HANDLER" <<'EOF'
#!/bin/bash
printf 'finished\n<<<GARDEN-JOB-COMPLETE>>>\n' > "$3"
printf '%s\n' '{"source":"result","model":"claude-opus-4-8","input_tokens":120,"output_tokens":30,"cache_creation_tokens":7,"cache_read_tokens":9,"total_cost_usd":0.1234,"num_turns":2}' > "$GARDEN_USAGE_FILE"
: > "$GARDEN_COMPLETION_SENTINEL"
EOF
chmod +x "$HANDLER"
env GARDEN=ledger-host GARDEN_STATE="$TR/state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_JOB_HANDLER="$HANDLER" "$JOBS/gardener.sh" 1 >"$TR/g.log" 2>&1 || true
V="$TR/v"; git clone -q --single-branch --branch journal2 "$BARE" "$V"
row="$V/usage/ledger-job.jsonl"
[ -s "$row" ] && ok "completion wrote usage/ledger-job.jsonl" || bad "missing usage row: $(tail -5 "$TR/g.log" | tr '\n' '|')"
if [ -s "$row" ]; then
  jq -e '.outcome=="tada" and .total_cost_usd==0.1234 and .input_tokens==120 and .source=="result"' "$row" >/dev/null \
    && ok "row preserves provider dollars and raw token classes" || bad "wrong row: $(cat "$row")"
fi
grep -q '<!-- garden-usage-begin:' "$V/jobs/tada/ledger-job.md" && grep -q 'Cost: \$0.1234' "$V/jobs/tada/ledger-job.md" \
  && ok "tada report carries the machine-stamped Cost footer" || bad "missing/incorrect footer"
event="$V/reputation/events/ledger-job.md"
grep -q '^agentic_dollars: 0.123400$' "$event" && ok 'reputation event uses measured $0.123400' || bad "event censored: $(grep agentic_dollars "$event" 2>/dev/null || true)"
env GARDEN=ledger-host GARDEN_STATE="$TR/reducer" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 "$JOBS/reputation-reduce.sh" >/dev/null 2>&1 || true
V2="$TR/v2"; git clone -q --single-branch --branch journal2 "$BARE" "$V2"
arm="$V2/reputation/arms/gardener/anthropic/claude-opus-4-8/high/build-s@main2.md"
grep -q '^attempts: 1$' "$arm" && ok "reducer advanced the arm to attempts: 1" || bad "arm not advanced"
echo "token-cost-ledger-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
