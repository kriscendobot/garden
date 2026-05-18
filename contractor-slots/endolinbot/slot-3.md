---
slot: 3
status: in-flight
design_path: designs/daemon-retention-paths.md
pr_number: null
current_stage: builder
in_flight_dispatch: 1b1371
last_update: 2026-05-18T05:48:00Z
started_at: 2026-05-18T05:48:00Z
host: endolinbot
---

Slot 3 fourth pick this cycle. Three prior impasses:
1. base64-native-fallthrough — already shipped via upstream squash-merge endojs/endo#3216.
2. ci-no-npm-lifecycle — already implemented in panel-approved PR #250.
3. daemon-retention-paths on master — substrate (`packages/daemon/src/graph.js`) is llm-only.

Re-dispatched daemon-retention-paths on **llm base** (the substrate's home).
Precedent: PR #282 (slot 1) used llm-base when the Rust supervisor substrate
was llm-only. Maintainer's "implementations on master" rule has this
documented exception for llm-only substrate.

Phase 1 only: host daemon API + `endo paths` CLI verb. Chat UI panel
deferred to follow-up phase.

Dispatch root: `dispatches/builder--1b1371`.
