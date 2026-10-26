---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/usage-meter.sh
scripts/jobs/usage-meter.sh:1171 accepts a second lower reading, so the 2026-10-26T03:47:34Z scaler warning still permits same-window spend to regress from 47944967 to 47922983. Preserve the prior high-water spend unless an entitlement/window transition is deterministically identified, and add coverage for two consecutive undercounts.
