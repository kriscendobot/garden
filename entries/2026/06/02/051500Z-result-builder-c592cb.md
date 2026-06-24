---
ts: 2026-06-02T05:15:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: c592cb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 395
    role: new
refs:
  - entries/2026/06/02/050019Z-dispatch-builder-c592cb.md
  - https://github.com/endojs/endo-but-for-bots/pull/395
---

# result: builder — gateway phase 7 PR #395 (formula-backed AppsNameHub)

- PR #395 DRAFT, base design/gateway-package-phase-6, head
  design/gateway-package-phase-7.
- Feature 2 promotion: in-memory AppsNameHub → formula-backed.
- 316 tests pass (285 → 316, 31 new). Lint clean.
- 6 files, +1255 / -17.

Key choices:
- Sync factory with internal async `ready` promise.
- Fail-closed on broken store; gateway start() throws on
  hydration failure (mirrors Phase 5 fail-closed posture).
- Rollback on partial store failure.
- WebletFormula validator carried gateway-side; daemon-side
  adapter deferred.

Liaison disposition: dispatch root torn down. Next: **Phase 8
(Feature 1: chat hosting + payment-token enhancement)** —
ResourceLedger surface + token-purchase contract. Base
design/gateway-package-phase-7.
