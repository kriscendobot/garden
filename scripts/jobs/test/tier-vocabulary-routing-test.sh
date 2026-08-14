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
[ "$(model_dispatch_tier local qwen3.6)" = minion ] && ok "local Qwen is minion" || bad "local tier"
[ "$(model_pull_bytes local qwen3.6)" = 23938333577 ] && ok "local Qwen has reviewed pull size" || bad "local Qwen pull size"
model_dispatch_tier openai gpt-new >/dev/null 2>&1 && bad "unknown model classified" || ok "unknown model fails closed"
[ "$(model_dispatch_tier anthropic claude-opus-5)" = mentor ] && ok "Opus 5 is mentor" || bad "Opus 5 tier"
[ "$(model_dispatch_tier openai gpt-5.6-sol)" = mentor ] && ok "Sol is mentor" || bad "Sol tier"
[ "$(tier_model_for_provider mentor anthropic)" = claude-opus-5 ] && ok "mentor selects Opus 5 for Anthropic" || bad "mentor Opus 5 selection"
[ "$(tier_model_for_provider mentor openai)" = gpt-5.6-sol ] && ok "mentor selects Sol for OpenAI" || bad "mentor Sol selection"
[ "$(tier_model_for_provider mentor moonshot)" = kimi-k3 ] && ok "mentor still selects Kimi for Moonshot" || bad "mentor Kimi selection"
[ "$(resolve_model_tier anthropic opus5)" = claude-opus-5 ] && ok "opus5 alias binds Opus 5" || bad "opus5 binding"
[ "$(resolve_model_tier openai sol)" = gpt-5.6-sol ] && ok "sol alias binds Sol" || bad "sol binding"
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/kimi-k3)" = mentor ] && ok "Fireworks Kimi K3 is mentor" || bad "Fireworks Kimi tier"
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/deepseek-v4-pro)" = minion ] && ok "Fireworks Deepseek V4 Pro is minion" || bad "Fireworks Deepseek tier"
[ "$(model_dispatch_tier fireworks fireworks/accounts/fireworks/models/gpt-oss-120b)" = myrmidon ] && ok "Fireworks gpt-oss-120b is myrmidon" || bad "Fireworks gpt-oss-120b tier"
[ "$(tier_model_for_provider mentor fireworks)" = fireworks/accounts/fireworks/models/glm-5p2 ] && ok "mentor selects Fireworks GLM 5.2 (first listed)" || bad "mentor Fireworks selection"
[ "$(tier_model_for_provider minion fireworks)" = fireworks/accounts/fireworks/models/deepseek-v4-pro ] && ok "minion selects Fireworks Deepseek V4 Pro" || bad "minion Fireworks selection"
[ "$(tier_model_for_provider myrmidon fireworks)" = fireworks/accounts/fireworks/models/gpt-oss-120b ] && ok "myrmidon selects Fireworks gpt-oss-120b" || bad "myrmidon Fireworks selection"
[ -z "$(tier_model_for_provider mentat fireworks)" ] && ok "mentat has no Fireworks model (manual-only)" || bad "mentat Fireworks boundary"

auto="$(printf '%s\\n' '---' 'role: builder' 'model: opus' 'fallback-model: fable' '---' body | automatic_route_body)"
printf '%s\\n' "$auto" | grep -qx 'tier: mentor' && ok "automatic output pins mentor capability" || bad "automatic tier route"
! printf '%s\\n' "$auto" | grep -Eq '^(model|fallback-model):' && ok "automatic output contains no concrete model pin" || bad "automatic model leaked"
printf '%s\\n' "$auto" | grep -qx 'fallback-tier: minion' && ok "automatic fallback is a capability tier" || bad "automatic fallback"
printf '%s\\n' "$auto" | grep -qx 'dispatch: automatic' && ok "automatic marker" || bad "automatic marker"
! printf '%s\\n' "$auto" | grep -q '^fallback-model:' && ok "automatic output removes legacy fallback-model pin" || bad "automatic fallback-model leaked"

[ "$(resolve_model_tier anthropic mentat)" = claude-fable-5 ] && ok "manual mentat binds Fable" || bad "mentat binding"
[ "$(resolve_model_tier moonshot kimi-k3)" = kimi-k3 ] && ok "mentor Kimi binds" || bad "mentor binding"
[ "$(tier_model_for_provider minion anthropic)" = claude-opus-4-8 ] && ok "minion selects Opus when Anthropic is available" || bad "minion Opus selection"
[ "$(tier_model_for_provider minion openai)" = gpt-5.6-terra ] && ok "minion selects Codex when OpenAI is available" || bad "minion Codex selection"
[ "$(tier_model_for_provider mentor fireworks)" = fireworks/accounts/fireworks/models/glm-5p2 ] && ok "mentor selects GLM 5.2 when Fireworks is constrained" || bad "Fireworks mentor selection"
[ "$(tier_model_for_provider minion fireworks)" = fireworks/accounts/fireworks/models/deepseek-v4-pro ] && ok "Fireworks minion selects Deepseek V4 Pro" || bad "Fireworks minion route"
[ -z "$(tier_model_for_provider mentat moonshot)" ] && ok "mentat is not available through automatic Moonshot routing" || bad "mentat boundary"
[ "$(role_default_model gardener designer)" = claude-opus-4-8 ] && ok "designer default targets Opus" || bad "designer default"
[ "$(role_default_model gardener builder)" = claude-opus-4-8 ] && ok "builder default targets Opus" || bad "builder default"
[ -z "$(role_default_model mystic builder)" ] && ok "Kimi has no role default" || bad "mystic builder default"

legacy="$(mktemp)"; printf '%s\n' '---' 'model: kimi-k3' '---' > "$legacy"
[ "$(job_tier "$legacy")" = mentor ] && ok "legacy concrete Kimi job migrates deterministically" || bad "legacy migration"
printf '%s\n' '---' 'tier: minion' '---' > "$legacy"
[ "$(job_tier "$legacy")" = minion ] && ok "tier intent survives a model assignment change" || bad "tier intent"
printf '%s\n' '---' 'tier: minion' 'model: kimi-k3' '---' > "$legacy"
[ "$(job_tier "$legacy")" = minion ] && ok "concrete compatibility pins cannot override durable tier intent" || bad "model overrode tier"
rm -f "$legacy"

exit "$fail"
