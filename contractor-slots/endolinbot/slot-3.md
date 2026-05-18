---
slot: 3
status: in-flight
design_path: designs/ci-no-npm-lifecycle.md
pr_number: null
current_stage: builder
in_flight_dispatch: 6420a8
last_update: 2026-05-18T05:36:00Z
started_at: 2026-05-18T05:36:00Z
host: endolinbot
---

Slot 3 re-dispatched after base64-native-fallthrough impasse: implementation
already shipped via upstream squash-merge `endojs/endo#3216`. The shipped
code matches the design's stated Problem Being Solved. Builder routed a
message to liaison; design status update is a separate designer/groom task.

New pick: `ci-no-npm-lifecycle` — disable npm/yarn lifecycle scripts in
CI workflows to close the supply-chain-via-postinstall vector. Focused
workflow-files change on master.

Dispatch root: `dispatches/builder--6420a8`.
