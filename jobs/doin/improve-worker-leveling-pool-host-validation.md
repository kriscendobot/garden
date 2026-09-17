---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-worker-leveling.sh
Before committing a replacement `config/worker-leveling`, inspect enabled calibrated Anthropic weekly-token pools and reject configurations that omit any pool host or leave its monk cap invalid. This prevents a later leveling tick from freezing the entire monk allocation indefinitely, as recurring warnings show for `anthropic:oros-studio-garden-ce242c49`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T09:21:20Z
