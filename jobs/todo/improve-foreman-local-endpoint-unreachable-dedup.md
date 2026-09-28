---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/codex-provider-common.sh
codex_provider_preflight's "local inference endpoint not reachable" branch (codex-provider-common.sh:155-159) only `printf`s to stderr, unlike its sibling "serves no $model" branch four lines above (:150-153) which calls `alert_maintainer "ollama-model-less-endpoint-${GARDEN}" "$msg"` for deduped/throttled delivery. On host endolin-garden-ece02cb4, the local endpoint has been unreachable (no `garden-ollama.service`, no `ollama.service`) for 25+ minutes, so `foreman-claude.sh` hits this branch every 5-minute tick (09:57, 10:02, 10:07, 10:12, 10:17, 10:22Z) and floods `journalctl -p warning` with an identical multi-line diagnosis each time, with no coalesced maintainer notice ever raised. Add an `alert_maintainer "local-endpoint-unreachable-${GARDEN}" "$msg"` call in the not-reachable branch, mirroring the model-less branch, so repeated ticks fold into one throttled notice instead of raw per-tick log spam. Add the matching `alert_maintainer_clear` call at the top of the function (or wherever `codex_local_endpoint_ready` next succeeds) so the notice retires once the endpoint recovers, matching the model-less branch's lifecycle.
