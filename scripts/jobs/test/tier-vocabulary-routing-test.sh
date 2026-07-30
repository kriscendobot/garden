#!/bin/bash
# Regression: Moonshot exhaustion routes automatic dispatch to Codex/minion;
# Fable/mentat remains manual-only.
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
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/glm-5p2)" = mentor ] && ok "Fireworks GLM 5.2 is mentor" || bad "Fireworks GLM 5.2 tier"
[ "$(model_dispatch_tier anthropic claude-opus-4-8)" = minion ] && ok "Opus is minion" || bad "Opus tier"
[ "$(model_dispatch_tier openai gpt-5.6-terra)" = minion ] && ok "Codex is minion" || bad "Codex tier"
[ "$(model_dispatch_tier local qwen3:0.6b)" = myrmidon ] && ok "local is myrmidon" || bad "local tier"
model_dispatch_tier openai gpt-new >/dev/null 2>&1 && bad "unknown model classified" || ok "unknown model fails closed"

auto="$(printf '%s\\n' '---' 'role: builder' 'model: opus' 'fallback-model: fable' '---' body | automatic_route_body)"
printf '%s\\n' "$auto" | grep -qx 'tier: minion' && ok "automatic output pins minion capability" || bad "automatic tier route"
printf '%s\\n' "$auto" | grep -qx 'model: gpt-5.6-terra' && ok "automatic output retains Codex compatibility pin" || bad "automatic compatibility model"
printf '%s\\n' "$auto" | grep -qx 'fallback-tier: minion' && ok "automatic fallback is a capability tier" || bad "automatic fallback"
printf '%s\\n' "$auto" | grep -qx 'dispatch: automatic' && ok "automatic marker" || bad "automatic marker"
! printf '%s\\n' "$auto" | grep -q '^fallback-model:' && ok "automatic output removes legacy fallback-model pin" || bad "automatic fallback-model leaked"

[ "$(resolve_model_tier anthropic mentat)" = claude-fable-5 ] && ok "manual mentat binds Fable" || bad "mentat binding"
[ "$(resolve_model_tier moonshot kimi-k3)" = kimi-k3 ] && ok "mentor Kimi binds" || bad "mentor binding"
[ "$(tier_model_for_provider minion anthropic)" = claude-opus-4-8 ] && ok "minion selects Opus when Anthropic is available" || bad "minion Opus selection"
[ "$(tier_model_for_provider minion openai)" = gpt-5.6-terra ] && ok "minion selects Codex when OpenAI is available" || bad "minion Codex selection"
[ "$(tier_model_for_provider mentor fireworks)" = fireworks/accounts/fireworks/models/glm-5p2 ] && ok "mentor selects GLM 5.2 when Fireworks is constrained" || bad "Fireworks mentor selection"
[ -z "$(tier_model_for_provider minion fireworks)" ] && ok "Fireworks has no automatic minion route" || bad "Fireworks automatic route"
[ -z "$(tier_model_for_provider mentat moonshot)" ] && ok "mentat is not available through automatic Moonshot routing" || bad "mentat boundary"
[ "$(role_default_model gardener designer)" = gpt-5.6-terra ] && ok "designer default targets Codex" || bad "designer default"
[ "$(role_default_model gardener builder)" = gpt-5.6-terra ] && ok "builder default targets Codex" || bad "builder default"
[ -z "$(role_default_model mystic builder)" ] && ok "Kimi has no role default" || bad "mystic builder default"

legacy="$(mktemp)"; printf '%s\n' '---' 'model: kimi-k3' '---' > "$legacy"
[ "$(job_tier "$legacy")" = mentor ] && ok "legacy concrete Kimi job migrates deterministically" || bad "legacy migration"
printf '%s\n' '---' 'tier: minion' '---' > "$legacy"
[ "$(job_tier "$legacy")" = minion ] && ok "tier intent survives a model assignment change" || bad "tier intent"
printf '%s\n' '---' 'tier: minion' 'model: kimi-k3' '---' > "$legacy"
[ "$(job_tier "$legacy")" = minion ] && ok "concrete compatibility pins cannot override durable tier intent" || bad "model overrode tier"
rm -f "$legacy"

exit "$fail"
