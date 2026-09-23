---
ts: 2026-05-20T06:30:30Z
kind: dispatch
role: steward
to: gardener
dispatch_id: 3231ab
dispatch_root: /home/kris/dispatches/gardener--3231ab
project: garden
refs:
  - entries/2026/05/19/222234Z-message-steward-e230a0.md
---

# Dispatch gardener 3231ab — LTS-motion-sensing-mechanism (per #231 review)

Backfilling #231 review followup (originally routed to liaison 2026-05-19T22:22Z; flagged missed 2026-05-20T06:25Z by maintainer).

Task: design and propose a mechanism for sensing Node LTS supported-versions window motion and automatically updating the pin/CI versions; shepherd the upgrade PR through CI per kriskowal L227.

Gardener edits live in the garden repo; the LTS-motion-sensing mechanism likely lands as a new skill or as additions to existing CI/dependabotany skills. Read `designs/familiar-release.md` on endojs/endo-but-for-bots for the source of the ask.
