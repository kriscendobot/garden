---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/foreman-claude.sh
`provider_order()` (foreman-claude.sh:110-121) still accepts `local` as a valid provider token, but the hermit/local-inference lane was fleet-wide retired 2026-09-13 (`common.sh:1175-1176`, job `retire-local-qwen-hermit-lane`: scaler clamps hermit count to 0, `garden-ollama.service` disabled everywhere). This host's `garden-foreman.service` still carries a stale `Environment=GARDEN_FOREMAN_PROVIDER_ORDER=openai,local` drop-in (confirmed via `systemctl --user show`), so every idle-pump tick burns a doomed `local`/ollama probe before FATALing with "no configured foreman inference provider was available" — observed four times in 30 minutes (08:35, 08:42, 08:47, 08:52 on 2026-09-28) with zero foreman throughput. Fix: reject `local` in `provider_order()` with a clear message pointing at the 2026-09-13 retirement (mirroring the existing `Moonshot is explicit-job-only` rejection pattern already in the same case statement), so a stale drop-in fails fast and loud at parse time instead of silently looping to a guaranteed dead branch forever. Also flag the live stale drop-in to the maintainer so `openai,local` gets corrected on this host.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T09:03:11Z
