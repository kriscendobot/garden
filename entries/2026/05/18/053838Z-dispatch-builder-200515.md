---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 200515
dispatch_root: dispatches/builder--200515
repo: endojs/endo-but-for-bots
branch: master
pr_number: null
slot: 3
---

Slot 3 third pick after two impasses on already-shipped designs
(base64-native-fallthrough → upstream squash-merge endojs/endo#3216;
ci-no-npm-lifecycle → PR #250 open and panel-approved).

Stuck-PR pre-flight: none cleanly adoptable. #134 (docker-selfhost)
maintainer-deferred on Endo Gateway. #262/#239 intentional draft
probes. #242 (syrups-ocapn-framing) stacked-PR with conflicts.

New pick: `designs/daemon-retention-paths.md` (Status: Not Started;
design PR #181 already merged; no implementation PR). Scope: Phase 1
only (host daemon API `listRetentionPaths`/follow-stream + `endo paths`
CLI verb). Defer Chat UI panel to a follow-up phase.

Implementation base: master.

Contractor pick-algorithm note: cross-checked candidate slug against
open-PR list before dispatch. Builder is instructed to do its own
open-PR + design-status pre-flight as a redundant gate.
