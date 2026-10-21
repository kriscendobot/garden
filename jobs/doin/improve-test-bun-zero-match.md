---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/test-bun.mjs
`scripts/test-bun.mjs:22-33,55-64,128` exits successfully when a selected package is missing, option-shaped, or has no AVA suite, allowing CI to pass without tests. Reject invalid package selectors and fail unless each requested package produces at least one test run; add subprocess coverage for these zero-match cases.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-21T08:35:49Z
