#!/bin/bash
# model-routing-test.sh — the data-driven model-routing table (common.sh + the
# journal override + set-model-routing.sh).
#
# The provider classification (which backend may claim a `model:`-pinned job) and
# each provider's fleet-default model are DATA read from a journal-backed routing
# table, not hardcoded case arms. This test asserts:
#
#   CLASSIFY   — the tracked default table (model-routing-defaults.tsv) routes the
#                CURRENT reality: qwen* → local (hermit) ONLY, claude-* → anthropic
#                ONLY, gpt-*/o[0-9]*/codex-* → openai ONLY, and a gpt-oss:* tag is
#                UNPINNED (no provider) — no longer auto-local.
#   DEFAULTS   — model_routing_default returns qwen3:0.6b (local), gpt-5.6-terra (openai),
#                empty (anthropic); role/fleet defaults ride the table.
#   OVERRIDE   — a journal config/model-routing (or GARDEN_MODEL_ROUTING_FILE) takes
#                precedence over the tracked default and CHANGES routing with no code.
#   FAIL-SAFE  — with the journal absent AND the tracked file unreadable, the inline
#                built-in fallback still gives the correct (qwen) classification.
#   EDIT HELPER— set-model-routing.sh upserts/removes a provider row on the journal
#                (CAS), validates before writing, and rejects an invalid table.
#
# Hermetic: sources common.sh against throwaway env / a throwaway bare journal. No
# real garden, journal, or network.
#
# Usage: model-routing-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job cannot
# splice its own GARDEN_*/JOURNAL_* under the fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "CLASSIFY — the tracked default table routes the current (qwen) reality"; hr
[ "$(resolve_model_tier local qwen3:0.6b)" = "qwen3:0.6b" ] && ok "qwen3:0.6b (served tag) → local" || bad "qwen tag not local"
[ -z "$(resolve_model_tier anthropic qwen3:0.6b)" ]          && ok "qwen3:0.6b is NOT anthropic" || bad "qwen leaked to anthropic"
[ -z "$(resolve_model_tier openai qwen3:0.6b)" ]             && ok "qwen3:0.6b is NOT openai" || bad "qwen leaked to openai"
[ "$(resolve_model_tier anthropic claude-opus-4-8)" = "claude-opus-4-8" ] && ok "claude-* → anthropic" || bad "claude not anthropic"
[ "$(resolve_model_tier openai gpt-5.6)" = "gpt-5.6" ]       && ok "gpt-5.6 → openai" || bad "gpt-5.6 not openai"
[ "$(resolve_model_tier openai o3)" = "o3" ]                 && ok "o3 → openai" || bad "o3 not openai"
[ -z "$(resolve_model_tier openai opus)" ]                   && ok "'opus' word not mis-captured by openai (o[0-9]* not o*)" || bad "openai captured opus"
# gpt-oss is retired from local and excluded from openai → UNPINNED (no provider).
[ -z "$(resolve_model_tier local gpt-oss:20b)" ]  && ok "gpt-oss:20b is NOT local" || bad "gpt-oss still local"
[ -z "$(resolve_model_tier openai gpt-oss:20b)" ] && ok "gpt-oss:20b is NOT openai (!gpt-oss* exclude)" || bad "gpt-oss captured by openai"
[ -z "$(resolve_model_tier anthropic gpt-oss:20b)" ] && ok "gpt-oss:20b is NOT anthropic (fully unpinned)" || bad "gpt-oss leaked to anthropic"
# Hosted Moonshot K3 is a distinct, exact id. It cannot cross-route onto the
# OpenAI, Anthropic, or local worker providers.
[ "$(resolve_model_tier moonshot kimi-k3)" = "kimi-k3" ] && ok "kimi-k3 -> moonshot" || bad "kimi-k3 not moonshot"
[ -z "$(resolve_model_tier openai kimi-k3)" ] && ok "kimi-k3 is NOT openai" || bad "kimi leaked to openai"
[ -z "$(resolve_model_tier anthropic kimi-k3)" ] && ok "kimi-k3 is NOT anthropic" || bad "kimi leaked to anthropic"
[ -z "$(resolve_model_tier local kimi-k3)" ] && ok "kimi-k3 is NOT local" || bad "kimi leaked to local"

# ============================================================================
hr; echo "DEFAULTS — fleet defaults ride the routing table"; hr
[ "$(model_routing_default local)" = "qwen3:0.6b" ]   && ok "local fleet default = qwen3:0.6b" || bad "local default ($(model_routing_default local))"
[ "$(model_routing_default openai)" = "gpt-5.6-terra" ] && ok "openai fleet default = gpt-5.6-terra" || bad "openai default"
[ -z "$(model_routing_default moonshot)" ] && ok "moonshot has no fleet default" || bad "moonshot default"
[ -z "$(model_routing_default anthropic)" ]           && ok "anthropic default empty (sentinel decided in code)" || bad "anthropic default not empty"
[ "$(role_default_model hermit builder)" = "qwen3:0.6b" ] && ok "hermit builder role default = qwen3:0.6b (from table)" || bad "hermit builder default"

# ============================================================================
hr; echo "OVERRIDE — an explicit table file changes routing with no code edit"; hr
OVR="$(mktemp)"
printf 'local\tmistral*\tmistral-small\n' > "$OVR"
(
  export GARDEN_MODEL_ROUTING_FILE="$OVR"
  [ "$(resolve_model_tier local mistral-small)" = "mistral-small" ] && echo OK1 || echo BAD1
  [ -z "$(resolve_model_tier local qwen3:0.6b)" ]                   && echo OK2 || echo BAD2
  [ "$(model_routing_default local)" = "mistral-small" ]           && echo OK3 || echo BAD3
) | {
  read a; [ "$a" = OK1 ] && ok "override reroutes local → mistral" || bad "override reroute"
  read a; [ "$a" = OK2 ] && ok "override drops qwen (complete-table replacement)" || bad "override qwen drop"
  read a; [ "$a" = OK3 ] && ok "override default = mistral-small" || bad "override default"
}
rm -f "$OVR"

# ============================================================================
hr; echo "FAIL-SAFE — no journal + unreadable tracked file → sane built-in"; hr
(
  export GARDEN_ROOT=/tmp/garden-nonexistent-$$   # tracked defaults file cannot be found
  export GARDEN_ALERT_CMD=/bin/true               # swallow the throttled warning
  [ "$(resolve_model_tier local qwen3:0.6b)" = "qwen3:0.6b" ] && echo OK1 || echo BAD1
  [ -z "$(resolve_model_tier local gpt-oss:20b)" ]      && echo OK2 || echo BAD2
  [ "$(model_routing_default local)" = "qwen3:0.6b" ]   && echo OK3 || echo BAD3
) | {
  read a; [ "$a" = OK1 ] && ok "built-in fallback classifies qwen → local" || bad "fallback qwen"
  read a; [ "$a" = OK2 ] && ok "built-in fallback keeps gpt-oss unpinned" || bad "fallback gpt-oss"
  read a; [ "$a" = OK3 ] && ok "built-in fallback default = qwen3:0.6b" || bad "fallback default"
}

# ============================================================================
hr; echo "EDIT HELPER — set-model-routing.sh upsert/remove/validate over a journal (CAS)"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-mroute.XXXXXX")"
git init -q --bare "$TR/journal.git"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/config"; touch "$SEED/config/.gitkeep"
git -C "$SEED" -c user.name=t -c user.email=t@l add -A
git -C "$SEED" -c user.name=t -c user.email=t@l commit -q -m seed
git -C "$SEED" remote add origin "$TR/journal.git"
git -C "$SEED" push -q -u origin journal2

run_helper() {  # run_helper <args...> — invoke set-model-routing.sh against $TR journal
  env GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 GARDEN=mhost \
      GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
      "$JOBS/set-model-routing.sh" "$@"
}
journal_show() { git -C "$TR/journal.git" show "journal2:config/model-routing" 2>/dev/null; }

run_helper local 'qwen* mistral*' mistral-small >/dev/null 2>&1 \
  && ok "upsert local row committed" || bad "upsert failed"
journal_show | grep -qE '^local	qwen\* mistral\*	mistral-small$' \
  && ok "journal row written verbatim" || bad "journal row wrong ($(journal_show | grep '^local'))"
# a fresh gardener clone of the journal now reads the override via the read precedence.
CLONE="$TR/state/gardeners/1/journal"; git clone -q --branch journal2 "$TR/journal.git" "$CLONE"
( export GARDEN_GARDENER_CLONE="$CLONE"; [ "$(resolve_model_tier local mistral-small)" = "mistral-small" ] ) \
  && ok "gardener clone reads journal override → mistral-small classifies local" || bad "clone did not read override"
# other rows are seeded from the tracked defaults so the table stays COMPLETE.
journal_show | grep -qE '^anthropic	claude-\*' && ok "seeded-from-default anthropic row present (complete table)" || bad "table not complete"
# remove a row.
run_helper --remove openai >/dev/null 2>&1 && ok "remove openai committed" || bad "remove failed"
journal_show | grep -qE '^openai	' && bad "openai row still present after remove" || ok "openai row gone after remove"
# an invalid edit is refused (duplicate handled by upsert; here: empty patterns).
run_helper local '' 2>/dev/null && bad "empty-patterns edit was accepted" || ok "invalid (empty patterns) edit refused"
# --validate on a good and a bad file.
GF="$(mktemp)"; printf 'local\tqwen*\tqwen3:0.6b\n' > "$GF"
run_helper --validate "$GF" >/dev/null 2>&1 && ok "--validate accepts a good table" || bad "--validate rejected a good table"
BF="$(mktemp)"; printf 'local\tqwen*\tq\nlocal\tx*\ty\n' > "$BF"
run_helper --validate "$BF" >/dev/null 2>&1 && bad "--validate accepted a duplicate-provider table" || ok "--validate rejects a duplicate-provider table"
rm -f "$GF" "$BF"; rm -rf "$TR"

# ============================================================================
hr
echo "model-routing-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
