#!/bin/bash
# Shared helpers for hermetic job-system fixtures.

# seed_calibrated_test_pool <journal-tree> <host> <worker-kind>
#
# Give a fixture worker a deliberately generous, measured pool. Production claim
# admission is fail-closed, so end-to-end fixtures that exercise the real worker
# spine must model this journal state explicitly.
seed_calibrated_test_pool() {
  local tree="$1" host="$2" kind="$3" provider pool
  case "$kind" in
    monk|gardener|opencode-anthropic) provider=anthropic ;;
    cleric) provider=openai ;;
    hermit) provider=local ;;
    mystic) provider=moonshot ;;
    fireworker) provider=fireworks ;;
    openrouter) provider=openrouter ;;
    openrouter-promo) provider=openrouter-promo ;;
    friar) provider=ollama-cloud ;;
    *)
      printf 'seed_calibrated_test_pool: unknown worker kind: %s\n' "$kind" >&2
      return 2
      ;;
  esac
  pool="$provider:test"
  mkdir -p "$tree/config"
  if ! grep -qsF "$pool $provider weekly-tokens 73000000 measured" "$tree/config/budget-pools"; then
    printf '%s %s weekly-tokens 73000000 measured\n' "$pool" "$provider" >> "$tree/config/budget-pools"
  fi
  if ! grep -qsF "$pool $host $kind" "$tree/config/subscription-mapping"; then
    printf '%s %s %s\n' "$pool" "$host" "$kind" >> "$tree/config/subscription-mapping"
  fi
}

# fixture_tada_file <journal-tree> <base> — resolve legacy or date-sharded tada.
fixture_tada_file() {
  local tree="$1" base="$2" legacy="$1/jobs/tada/$2.md" found
  if [ -f "$legacy" ]; then
    printf '%s\n' "$legacy"
    return 0
  fi
  found="$(find "$tree/jobs/tada" -type f -name "$base.md" -print -quit 2>/dev/null)"
  [ -n "$found" ] || return 1
  printf '%s\n' "$found"
}

fixture_has_tada() { fixture_tada_file "$1" "$2" >/dev/null; }
