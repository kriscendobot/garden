---
ts: 2026-05-20T06:28:53Z
kind: dispatch
role: steward
to: builder
dispatch_id: ff60f8
dispatch_root: /home/kris/dispatches/builder--ff60f8
project: endo-but-for-bots
refs:
  - entries/2026/05/19/222234Z-message-steward-e230a0.md
---

# Dispatch builder ff60f8 — G5-Node-LTS-pin (per #231 review)

Backfilling #231 review follow-up (originally routed to liaison 2026-05-19T22:22Z, never dispatched until user flagged miss 2026-05-20T06:25Z).

Task: bump familiar's Node engines to current LTS (22 or 24).

Implementation lives in the familiar app (look for `packages/familiar/` or similar; check designs/familiar-release.md for context). Create a new branch off llm with descriptive name. Open PR DRAFT against llm.
