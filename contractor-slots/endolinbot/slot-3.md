---
slot: 3
status: in-flight
design_path: designs/daemon-retention-paths.md
pr_number: null
current_stage: builder
in_flight_dispatch: 200515
last_update: 2026-05-18T05:40:00Z
started_at: 2026-05-18T05:40:00Z
host: endolinbot
---

Slot 3 re-dispatched after two impasses (base64-native-fallthrough,
ci-no-npm-lifecycle — both already shipped/in-flight). Stuck-PR pre-flight:
#134 maintainer-deferred (Endo Gateway prereq); #262/#239 intentional
draft probes; #242 stacked-PR conflict needs weave on its base #109. No
clean adoption available.

New pick: `daemon-retention-paths` — Phase 1 only (daemon host API + CLI
`endo paths` verb). Defer the Chat UI panel to a follow-up phase. Design
#181 already merged; no implementation PR open. Builder must do
**open-PR pre-flight** check on `daemon-retention-paths` slug before
opening a worktree.

Dispatch root: `dispatches/builder--200515`.
