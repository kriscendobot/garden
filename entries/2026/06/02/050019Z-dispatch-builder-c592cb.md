---
ts: 2026-06-02T05:00:19Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--c592cb
short_id: c592cb
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 7 (Feature 2 formula-backed AppsNameHub, stacked on #394)

Base design/gateway-package-phase-6 (PR #394 head). Head
design/gateway-package-phase-7. Promotes Phase 1's in-memory
`AppsNameHub` exo to formula-backed (per `@apps` NameHub
convention; survives gateway restarts).
