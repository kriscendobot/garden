---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 1b1371
dispatch_root: dispatches/builder--1b1371
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
slot: 3
---

Slot 3 fourth pick: `designs/daemon-retention-paths.md` Phase 1 on
**llm base** (third pick impassed on master because substrate is
llm-only). Phase 1: host daemon API (`listRetentionPaths` /
`followRetentionPaths`) + `endo paths` CLI verb. Defer Chat UI panel
to a follow-up phase. Existing private `listRetentionPaths` at
`packages/daemon/src/graph.js:748` is the substrate to surface.
