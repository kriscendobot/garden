---
ts: 2026-05-20T06:30:30Z
kind: dispatch
role: steward
to: builder
dispatch_id: 233e5c
dispatch_root: /home/kris/dispatches/builder--233e5c
project: endo-but-for-bots
refs:
  - entries/2026/05/19/222234Z-message-steward-e230a0.md
---

# Dispatch builder 233e5c — G8-consolidated-stop-purge (per #231 review)

Backfilling #231 review followup (originally routed to liaison 2026-05-19T22:22Z; flagged missed 2026-05-20T06:25Z by maintainer).

Task: implement the consolidated stop/purge solution via CapTP (deferred but reviewable per kriskowal L275).

Implementation lives in the familiar app surface; check designs/familiar-release.md for context. Create a new branch off llm. Open PR DRAFT against llm.
