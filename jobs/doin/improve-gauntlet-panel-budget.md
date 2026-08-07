---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Give staged panel jobs a bounded CI-sized `handler-timeout` (with a dedicated configurable default below the claim-TTL ceiling). A single panel round can exceed the default 2400s, as the re-panel deadline overrun shows; the driver should budget that known long-running scripted stage explicitly rather than doom it after one deterministic wall hit.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-07T05:51:04Z
