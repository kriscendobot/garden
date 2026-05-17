---
slot: 1
status: in-flight
design_path: designs/filesystem-watchers.md
pr_number: null
current_stage: builder
in_flight_dispatch: 36f4cc
last_update: 2026-05-17T23:20:00Z
started_at: 2026-05-17T23:20:00Z
host: endolinbot
---

Re-dispatching builder with llm base after prior impasse. The
`packages/daemon/src/mount.js` (EndoMount) exists on llm but not on
master; daemon-mount #135 and platform-fs #122 have not yet promoted
to master. Per the precedent of slot 1's prior #276 (Rust endor), llm
is the right base when the implementation prereqs live only there.

Scope corrected: only `followNameChanges(...pathSegments)` per the
design. `followLocatorNameChanges` is referenced in the design only as
the existing EndoDirectory method (model for the new addition), not as
a second addition. The unification across NameHub interfaces is a
sibling design (Open Questions section).

Dispatch root: `dispatches/builder--36f4cc`.
