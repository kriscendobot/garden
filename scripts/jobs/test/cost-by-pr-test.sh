#!/bin/bash
# Hermetic proof of cost-by-pr.sh: the job->PR join (jobs/index + validated base-name),
# true-cost pricing on the rate card, the ceiling/measured split, the unattributed
# bucket, and the measured join-coverage figure. No provider, agent, or network — the
# PR oracle is supplied as a --pr-cache TSV so the run is deterministic and offline.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
command -v jq >/dev/null 2>&1 || { echo "SKIP: jq unavailable"; exit 0; }

TR="$(mktemp -d "${TMPDIR:-/tmp}/cost-by-pr.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
J="$TR/journal"; mkdir -p "$J"/{reputation/events,jobs/index,jobs/tada}
git init -q "$J"; git -C "$J" checkout -q -b journal2

# --- a rate card the test fully controls (journal card outranks the tracked seed) ---
mkdir -p "$J/reputation"
cat > "$J/reputation/rate-card.md" <<'EOF'
# test rate card
| provider | model | thoughtfulness | dollars_per_second | price_basis | source | measured_at |
| --- | --- | --- | --- | --- | --- | --- |
| anthropic | * | * | 0.000069 | measured | test | 2026-08-02 |
| moonshot | kimi-k3 | * | 0.001338 | measured | test | 2026-08-02 |
| openai | * | * | 0.005154 | provisional | test ceiling | 2026-08-02 |
| * | * | * | 0.005154 | provisional | test ceiling | 2026-08-02 |
EOF

mkev() { # base provider model tht duration
  cat > "$J/reputation/events/$1.md" <<EOF
---
base: $1
kind: gardener
provider: $2
model: $3
thoughtfulness: $4
work_class: gardener:s
target: main2
accepted: true
agentic_dollars: censored
human_dollars: 0
aggregate_dollars: censored
attempts: 1
duration_secs: $5
source: live
---
event $1
EOF
}
# feat-a: anthropic, joined to #10 by an authoritative jobs/index directive edge.
mkev feat-a anthropic claude-default medium 1000
# endojs-endo-but-for-bots-42-fix: moonshot, joined to #42 ONLY by a validated base-name
#   edge (no jobs/index entry) — 42 is a real PR in the cache, so it must resolve.
mkev endojs-endo-but-for-bots-42-fix moonshot kimi-k3 medium 500
# arc-status-daily-20260101-000000: a garden-internal press with a date that is NOT a
#   PR (8-digit token) — must land UNATTRIBUTED, never mis-joined to some PR #20260101.
mkev arc-status-daily-20260101-000000 anthropic claude-default low 300
# codex-audit-endo-but-for-bots-42: openai — its cost is CEILING, and though its name
#   carries 42 it must still route to #42's ceiling column, not the measured one.
mkev codex-audit-endo-but-for-bots-42 openai gpt-5 high 400
# tune-endo-but-for-bots-retry-to-10: the false-join regression guard. It is classified
#   to endo-but-for-bots and its "10" IS a real PR in the cache — but "10" is neither
#   PR-shaped (no pr/#/pull-request prefix) nor slug-adjacent, so it must NOT join
#   (this is the real xs2rust-endor-stage10 -> endo#10 bug in miniature).
mkev tune-endo-but-for-bots-retry-to-10 anthropic claude-default low 100

# jobs/index: the authoritative comment-directive -> base edge for feat-a.
printf 'base: feat-a\nidentity: endojs/endo-but-for-bots#10:comment:111\n' > "$J/jobs/index/aaaa1111"

git -C "$J" add -A; git -C "$J" -c user.name=t -c user.email=t@localhost commit -qm seed

# the PR oracle (repo TAB number TAB state).
cat > "$TR/prcache.tsv" <<EOF
endojs/endo-but-for-bots	10	merged
endojs/endo-but-for-bots	42	merged
EOF

out="$(GARDEN_STATE="$TR/state" bash "$JOBS/cost-by-pr.sh" --dir "$J" --pr-cache "$TR/prcache.tsv" --json)"
echo "$out" | jq . >/dev/null 2>&1 && ok "emits valid JSON" || { bad "invalid JSON: $out"; echo "cost-by-pr-test: $PASS passed, $((FAIL)) failed"; exit 1; }

# join coverage: 3 of 5 priced bases map to a PR (feat-a, endo-42, codex-42; the press
# and the stray-"10" base do not).
jc="$(echo "$out" | jq -r '.coverage.joined_bases')"; pc="$(echo "$out" | jq -r '.coverage.priced_bases')"
[ "$pc" = 5 ] && ok "priced all 5 events" || bad "priced=$pc (want 5)"
[ "$jc" = 3 ] && ok "joined 3 of 5 bases to a PR" || bad "joined=$jc (want 3)"

# feat-a -> #10 via jobs/index, measured 1000*0.000069 = 0.069. If the stray-"10" base
# had false-joined, #10 would read 0.069 + 100*0.000069 = 0.0759 — so this also guards
# the false-join regression.
m10="$(echo "$out" | jq -r '.prs[] | select(.pr=="endojs/endo-but-for-bots#10") | .measured_usd')"
awk -v v="$m10" 'BEGIN{exit !(v>0.0689 && v<0.0691)}' && ok "#10 measured \$0.069 — only feat-a, the stray-10 base did NOT false-join" || bad "#10 measured=$m10 (want ~0.069)"

# #42 gets BOTH a measured moonshot contribution (base-name edge) AND a ceiling openai one.
m42="$(echo "$out" | jq -r '.prs[] | select(.pr=="endojs/endo-but-for-bots#42") | .measured_usd')"
c42="$(echo "$out" | jq -r '.prs[] | select(.pr=="endojs/endo-but-for-bots#42") | .ceiling_usd')"
awk -v v="$m42" 'BEGIN{exit !(v>0.668 && v<0.670)}' && ok "#42 measured \$0.669 (moonshot via validated base-name)" || bad "#42 measured=$m42 (want ~0.669)"
awk -v v="$c42" 'BEGIN{exit !(v>2.06 && v<2.07)}' && ok "#42 ceiling \$2.06 (openai kept OUT of measured)" || bad "#42 ceiling=$c42 (want ~2.06)"

# the dated press and the stray-"10" base are both unattributed, never mis-joined.
uj="$(echo "$out" | jq -r '.unattributed.jobs')"
[ "$uj" = 2 ] && ok "the press + the stray-10 base are unattributed (2 jobs)" || bad "unattributed jobs=$uj (want 2)"
echo "$out" | jq -e '[.prs[].pr] | index("endojs/endo-but-for-bots#20260101") | not' >/dev/null \
  && ok "no phantom PR minted from a date token" || bad "a date token was mis-joined to a PR"

# the ceiling total is exactly the openai event; measured excludes it.
tc="$(echo "$out" | jq -r '.totals.ceiling_usd')"
awk -v v="$tc" 'BEGIN{exit !(v>2.06 && v<2.07)}' && ok "ceiling total is the openai event alone" || bad "ceiling total=$tc (want ~2.06)"

echo "cost-by-pr-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
