#!/bin/bash
# Every native panel provider must resolve all four fleet tiers.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
export GARDEN_ROOT
source "$JOBS/common.sh"

fail=0
for provider in anthropic openai; do
  for tier in mentat mentor minion myrmidon; do
    model="$(tier_model_for_provider "$tier" "$provider" 2>/dev/null || true)"
    if [ -n "$model" ]; then
      printf 'PASS: %s/%s -> %s\n' "$provider" "$tier" "$model"
    else
      printf 'FAIL: %s has no %s model\n' "$provider" "$tier"
      fail=1
    fi
  done
done

[ "$(tier_model_for_provider minion openai)" = gpt-5.6-terra ] \
  || { echo 'FAIL: OpenAI automatic minion fallback changed'; fail=1; }
[ "$(tier_model_for_provider myrmidon openai)" = gpt-5.6-luna ] \
  || { echo 'FAIL: OpenAI myrmidon default is not Luna'; fail=1; }
[ "$(model_dispatch_tier openai gpt-5.4-mini)" = myrmidon ] \
  || { echo 'FAIL: Mini is not classified myrmidon'; fail=1; }

exit "$fail"
