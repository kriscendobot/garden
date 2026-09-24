#!/bin/bash
# seat-gate-procurer.sh — the COST-GATED dispatch for the procurer jury seat
# (build versus buy). panel.sh's `seat_review` calls it as
# `<seat> <pr> <worktree> <base>` and it OWNS the seat's per-juror block on stdout
# in every branch, following seat-gate-reexport-auditor.sh.
# design: designs/export-index-build-vs-buy.md § 5; rule: skills/build-vs-buy/SKILL.md.
#
# Branches:
#   no name-pass hits                 -> APPROVE block, NO claude -p.
#   index or detector unavailable     -> COMMENT-ONLY block naming the reason, NO
#                                        claude -p (never a silent approve).
#   hits                              -> rank them (strong > weak, unwaived before
#                                        waived; blocked hits listed, never
#                                        dispatched), judge the top K (8) with one
#                                        low-tier `claude -p` each, at most 4 at a
#                                        time, through a verdict cache, then map the
#                                        JSON verdicts to findings deterministically
#                                        (skills/build-vs-buy/procure.cjs block).
# The model returns data only ({"verdict":"buy|adapt|build","confidence","reason"});
# the gate decides the verdict level.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
: "${GARDEN_ROOT:=$(cd "$HERE/../../.." && pwd)}"
: "${GARDEN_STATE:=$GARDEN_ROOT/.garden-state}"
: "${JURORS_DIR:=$HERE/../../../roles/jurors}"
SKILL_DIR="$HERE/../../../skills/build-vs-buy"
DETECT="${GARDEN_BUILD_VS_BUY_DETECT:-$SKILL_DIR/detect.cjs}"
PROCURE="$SKILL_DIR/procure.cjs"
ENSURE="${GARDEN_EXPORT_INDEX_ENSURE:-$HERE/../export-index/ensure-export-index.sh}"
NODE_BIN="${GARDEN_NODE_BIN:-node}"
K="${GARDEN_PROCURER_MAX_HITS:-8}"
PARALLEL="${GARDEN_PROCURER_PARALLEL:-4}"
CACHE_DIR="${GARDEN_PROCURER_CACHE:-$GARDEN_STATE/build-vs-buy}"

seat="${1:-procurer}"
pr="${2:?pr}"  # part of the seat-gate contract; the block is PR-agnostic
: "$pr"
wt="${3:?worktree}"
base="${4:-HEAD~1}"
brief="$JURORS_DIR/$seat/AGENT.md"
RULE="skills/build-vs-buy/SKILL.md"

approve_block() {
  cat <<BLOCK
### $seat

**Verdict:** approve

**Findings:**
- none — no added declaration shares a name with a function another package exports. [rule: $RULE]
BLOCK
}

unavailable_block() {  # $1: reason
  cat <<BLOCK
### $seat

**Verdict:** comment-only

**Findings:**
- Build versus buy could not be checked: $1. This is surfaced, NOT treated as clean. [rule: $RULE]
BLOCK
}

command -v "$NODE_BIN" >/dev/null 2>&1 || { unavailable_block "node is unavailable"; exit 0; }
base_sha="$(git -C "$wt" rev-parse --verify --quiet "$base^{commit}")" \
  || { unavailable_block "the diff base $base does not resolve"; exit 0; }
index="$("$ENSURE" "$wt" "$base_sha" 2>/dev/null)" \
  || { unavailable_block "the export index for $base_sha could not be built"; exit 0; }
index_args=(--index "$index")
slug="$(sed -n '1s/^# repo=\([^ ]*\) .*/\1/p' "$index")"
while IFS= read -r provider; do
  [ -n "$provider" ] && index_args+=(--index "$provider")
done < <("$ENSURE" --providers "$wt" "$slug" 2>/dev/null)

run="$(mktemp -d "${TMPDIR:-/tmp}/procurer.XXXXXX")"
trap 'rm -rf "$run"' EXIT
(cd "$wt" && "$NODE_BIN" "$DETECT" --repo . --base "$base_sha" "${index_args[@]}" --passes name) >"$run/hits.jsonl" 2>/dev/null \
  || { unavailable_block "the build-vs-buy detector errored"; exit 0; }
[ -s "$run/hits.jsonl" ] || { approve_block; exit 0; }

mkdir -p "$CACHE_DIR" "$run/verdicts"
# Bounded cache: a verdict unused for 30 days is re-judged on demand.
find "$CACHE_DIR" -maxdepth 1 -type f -mtime +30 -delete 2>/dev/null
"$NODE_BIN" "$PROCURE" plan "$run/hits.jsonl" "$K" "$CACHE_DIR" >"$run/plan.jsonl" \
  || { unavailable_block "the hit ranking failed"; exit 0; }

judge_one() {  # judge_one <rank> <cache-file>
  local rank="$1" cache="$2" reply="$run/reply-$1" out="$run/verdicts/$1.json"
  if [ -s "$cache" ]; then touch "$cache"; cp "$cache" "$out"; return 0; fi
  command -v claude >/dev/null 2>&1 || return 0
  local model_args=() budget_args=()
  [ -n "${GARDEN_PANEL_SEAT_MODEL:-}" ] && model_args=(--model "$GARDEN_PANEL_SEAT_MODEL")
  [[ "${GARDEN_CLAUDE_CALL_BUDGET_USD:-}" =~ ^[0-9]+([.][0-9]+)?$ ]] && budget_args=(--max-budget-usd "$GARDEN_CLAUDE_CALL_BUDGET_USD")
  # cd "$wt" so the transcript is metered with the rest of the panel.
  (cd "$wt" && claude -p "${model_args[@]}" "${budget_args[@]}" --dangerously-skip-permissions \
      "$("$NODE_BIN" "$PROCURE" prompt "$run/plan.jsonl" "$rank" "$brief")") >"$reply" 2>/dev/null || true
  if "$NODE_BIN" "$PROCURE" parse "$reply" >"$out.tmp" 2>/dev/null; then
    mv -f "$out.tmp" "$out"
    cp "$out" "$cache.tmp.$$" && mv -f "$cache.tmp.$$" "$cache"
  else
    rm -f "$out.tmp"
  fi
}

while IFS=$'\t' read -r rank cache; do
  while [ "$(jobs -rp | wc -l)" -ge "$PARALLEL" ]; do wait -n; done
  judge_one "$rank" "$cache" &
done < <(jq -r 'select(.dispatch) | "\(.rank)\t\(.cache)"' "$run/plan.jsonl")
wait

"$NODE_BIN" "$PROCURE" block "$seat" "$run/plan.jsonl" "$run/verdicts" \
  || unavailable_block "the disposition map failed"
exit 0
