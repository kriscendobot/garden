#!/bin/bash
# Regression: automatic dispatch is capped at mentor; Fable is manual-only.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
export GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
source "$JOBS/common.sh"
fail=0
ok() { echo "PASS: $*"; }
bad() { echo "FAIL: $*"; fail=1; }

[ "$(model_dispatch_tier anthropic claude-fable-5)" = mentat ] && ok "Fable is mentat" || bad "Fable tier"
[ "$(model_dispatch_tier moonshot kimi-k3)" = mentor ] && ok "Kimi is mentor" || bad "Kimi tier"
[ "$(model_dispatch_tier anthropic claude-opus-4-8)" = minion ] && ok "Opus is minion" || bad "Opus tier"
[ "$(model_dispatch_tier openai gpt-5.6-terra)" = minion ] && ok "Codex is minion" || bad "Codex tier"
[ "$(model_dispatch_tier local qwen3:0.6b)" = myrmidon ] && ok "local is myrmidon" || bad "local tier"
model_dispatch_tier openai gpt-new >/dev/null 2>&1 && bad "unknown model classified" || ok "unknown model fails closed"

auto="$(printf '%s\\n' '---' 'role: builder' 'model: opus' 'fallback-model: fable' '---' body | automatic_route_body)"
printf '%s\\n' "$auto" | grep -qx 'tier: mentor' && ok "automatic output pins mentor capability" || bad "automatic tier route"
printf '%s\\n' "$auto" | grep -qx 'fallback-tier: minion' && ok "automatic fallback is a capability tier" || bad "automatic fallback"
printf '%s\\n' "$auto" | grep -qx 'dispatch: automatic' && ok "automatic marker" || bad "automatic marker"
! printf '%s\\n' "$auto" | grep -Eq '^(model|fallback-model):' && ok "automatic output contains no concrete model pin" || bad "automatic model leaked"

[ "$(resolve_model_tier anthropic mentat)" = claude-fable-5 ] && ok "manual mentat binds Fable" || bad "mentat binding"
[ "$(resolve_model_tier moonshot kimi-k3)" = kimi-k3 ] && ok "mentor Kimi binds" || bad "mentor binding"
[ "$(tier_model_for_provider mentor moonshot)" = kimi-k3 ] && ok "mentor currently selects Kimi" || bad "mentor selection"
[ "$(tier_model_for_provider minion anthropic)" = claude-opus-4-8 ] && ok "minion selects Opus when Anthropic is available" || bad "minion Opus selection"
[ "$(tier_model_for_provider minion openai)" = gpt-5.6-terra ] && ok "minion selects Codex when OpenAI is available" || bad "minion Codex selection"
[ -z "$(tier_model_for_provider mentat moonshot)" ] && ok "mentat is not available through automatic Moonshot routing" || bad "mentat boundary"
[ "$(role_default_model gardener designer)" = kimi-k3 ] && ok "designer default is capped at mentor" || bad "designer default"
[ "$(role_default_model gardener builder)" = kimi-k3 ] && ok "builder default is capped at mentor" || bad "builder default"
[ "$(role_default_model mystic builder)" = kimi-k3 ] && ok "Kimi builder is mechanically defaultable" || bad "mystic builder default"

legacy="$(mktemp)"; printf '%s\n' '---' 'model: kimi-k3' '---' > "$legacy"
[ "$(job_tier "$legacy")" = mentor ] && ok "legacy concrete Kimi job migrates deterministically" || bad "legacy migration"
printf '%s\n' '---' 'tier: minion' '---' > "$legacy"
[ "$(job_tier "$legacy")" = minion ] && ok "tier intent survives a model assignment change" || bad "tier intent"
rm -f "$legacy"

exit "$fail"
