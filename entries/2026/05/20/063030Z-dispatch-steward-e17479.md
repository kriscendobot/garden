---
ts: 2026-05-20T06:30:30Z
kind: dispatch
role: steward
to: builder
dispatch_id: e17479
dispatch_root: /home/kris/dispatches/builder--e17479
project: endo-but-for-bots
refs:
  - entries/2026/05/19/222234Z-message-steward-e230a0.md
---

# Dispatch builder e17479 — G15-macOS-arm64-x64-matrix (per #231 review)

Backfilling #231 review followup (originally routed to liaison 2026-05-19T22:22Z; flagged missed 2026-05-20T06:25Z by maintainer).

Task: add macOS arm64 + x64 build matrix (or universal binary) per kriskowal L387.

Implementation lives in the familiar app surface; check designs/familiar-release.md for context. Create a new branch off llm. Open PR DRAFT against llm.
