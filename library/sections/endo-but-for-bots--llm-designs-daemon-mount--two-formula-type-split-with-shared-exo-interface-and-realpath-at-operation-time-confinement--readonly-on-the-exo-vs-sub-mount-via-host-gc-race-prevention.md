---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §readOnly-on-the-exo vs §sub-mount-via-host (GC-race-prevention)
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

§Design-Decisions-2-and-3 are the §load-bearing-symmetry:

- **§readOnly()-IS-on-the-exo**: §no-new-formula-is-created;
  returns a §restricted-view-of-the-same-object. §No-GC-
  race-possible-because-no-formula-is-involved.
- **§Sub-mount-via-host-method**: §creates-a-new-formula.
  §Formulas-created-in-the-JS-heap-without-being-atomically-
  named-in-a-pet-store-are-vulnerable-to-GC-races. §Host-
  methods-with-deferred-tasks-prevent-this.

§The-axis-is: does-this-operation-create-a-new-formula.
§Creates-formula → host method with deferred-task atomicity.
§Doesn't-create-formula → exo method.

§This-is-an-invariant-not-just-a-pattern: any new daemon
capability must honor it. §Cycle-105's-daemon-capability-
bank touches this territory; cycle 161's filesystem-
watchers reuses the same exo-vs-host axis (followNameChanges
on the exo because it's an attenuated method, not a new
formula).
