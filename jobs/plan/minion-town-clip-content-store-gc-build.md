---
gate: orchestrated
orchestrated_by: minion-town-pr89-review-5118379171-conduct-build
priority: normal
posted_by: gardener
posted_at: 2026-09-04T22:46:45Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build the clip content-store garbage collector

Implement the follow-on build explicitly requested by trusted maintainer kriskowal
in review 5118379171 on https://github.com/kriscendobot/minion.town/pull/89.

The preceding orchestration child merges PR #89. Work from the resulting live `main`
and read the complete design at
`designs/clip-formula-id-origin-and-content-gc.md`, especially sections B.3 through
B.10 and every Part B acceptance criterion. Implement the specified
`clip-content-store-gc` build, including its pure/fake-injectable GC core, strict and
fail-closed root enumeration, grace and race protections, audit-by-default CLI,
explicit delete mode, systemd service/timer and installer/configuration surfaces,
guest-side unpublish cleanup, documentation, and load-bearing tests. Preserve every
named interface and safety decision in the accepted design unless repository reality
forces a documented impasse.

Use the builder workflow: work in this job's isolated project checkout, run all local
gates and regression evidence, open exactly one draft PR with `ensure-pr.sh`, and hand
it into the normal gauntlet. Record the production audit validation before any first
delete run as the design requires; do not represent production validation as complete
unless it was actually executed and observed.

This is the second child of the serial review-5118379171 orchestration and must begin
only after the conductor child completed successfully.
