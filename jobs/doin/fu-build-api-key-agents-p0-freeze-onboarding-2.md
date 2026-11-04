---
posted_at: 2026-11-04T02:59:21Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In kriscendobot/garden (main2), fix `scripts/jobs/phase-evidence-gate.sh` so it can read a design that lives in another repo, such as the minion.town design cited by the #1543 URL. It should resolve the design from a referenced URL or filename, or from a fetched copy, instead of blocking the PR when the body names a cross-repo path. This comes from the report of build job build-api-key-agents-p0-freeze-onboarding, where the gate blocked the PR and the builder had to hand-write a ledger. Jobs p1–p5 will likely hit the same gate.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T03:25:26Z
