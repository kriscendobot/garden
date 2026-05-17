---
slot: 1
status: in-flight
design_path: designs/filesystem-watchers.md
pr_number: null
current_stage: builder
in_flight_dispatch: f895e0
last_update: 2026-05-17T23:08:00Z
started_at: 2026-05-17T23:08:00Z
host: endolinbot
---

Slot 1 picks up `designs/filesystem-watchers.md` — adds
`followNameChanges` and `followLocatorNameChanges` methods to EndoMount
(parity with EndoDirectory). Pure JS; daemon-side. The 3 declared deps
(daemon-mount, platform-fs, daemon-content-store-gc) are infrastructure
the design extends, not strict prerequisites.

Implementation base: master.

Dispatch root: `dispatches/builder--f895e0`.
