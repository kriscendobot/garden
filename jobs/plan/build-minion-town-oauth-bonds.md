---
gate: orchestrated
orchestrated_by: orch-minion-town-oauth-bonds
priority: normal
posted_by: producer
posted_at: 2026-10-07T20:51:24Z
---

---
role: builder
arc: minion-town-ui
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: OAuth bond clarification, listing, and deletion on minion.town

Repo: https://github.com/kriscendobot/minion.town. Budget: the `minion-town-ui` arc.

Build exactly the design produced by the preceding child, `design-minion-town-oauth-bonds`
(find its PR/design file from that job's report in `jobs/tada/`). Deliver, on a DRAFT PR
based on the design's branch or merged `main` as appropriate: the clarified usage text on
the guest page, the bond list, per-bond deletion with the confirmation the design
specifies, tests (unit plus the e2e acceptance the design lists), and an automatic
production check. A DRAFT PR for a feature build is completed by the automatic gauntlet
(clean, panel, fix-loop, un-draft); the arc supervisors then carry it to merge under the
delegation. If the design is not yet merged or conflicts, weave onto the live base first.
Do not weaken a security property to make a test pass; report a gap instead.
