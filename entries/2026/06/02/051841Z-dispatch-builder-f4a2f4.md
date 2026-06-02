---
ts: 2026-06-02T05:18:41Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--f4a2f4
short_id: f4a2f4
prs:
  - repo: endojs/endo-but-for-bots
    pr: 395
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/395
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 8 (Feature 1 chat hosting + payment tokens, stacked on #395)

Base design/gateway-package-phase-7 (PR #395 head). Head
design/gateway-package-phase-8. Implements Feature 1 (chat hosting
with payment-token enhancement): `ResourceLedger` exo (compute /
storage / network counters), `purchaseTokens(tokens, proof)`
interface, gateway-owned resource accounting surface that the
Chat weblet's purchase UI consumes. Payment-processor is
contracted via the interface and is out of scope.
