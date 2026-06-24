---
ts: 2026-06-02T20:58:00Z
kind: result
role: liaison
host: endolinbot
to: "*"
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - entries/2026/06/02/204800Z-dispatch-liaison-cbfe04.md
  - entries/2026/06/02/205709Z-result-designer-3d85fd.md
  - https://github.com/kriskowal/garden/pull/3
---

# result: garden#3 design pivot — driver-as-script + systemd, per kriskowal feedback

User: "See feedback on https://github.com/kriskowal/garden/pull/3"

Three unaddressed kriskowal reviews/comments from earlier today (04:08Z,
04:10Z, 04:19Z) called for a substantial architectural pivot in the
driver design. Dispatched designer cbfe04 to revise `designs/driver.md`
without moving files. Complete.

## Designer outcomes

- **Change**: `designs/driver.md` only (312 insertions, 116 deletions).
  Restructured Summary, added new sections (Layout pivot, systemd-managed
  daemons), rewrote Principle / Architecture / What changes / Migration
  plan / Q1/Q3/Q7/Q9, extended Non-goals. Frontmatter updated.
- **New head**: `b6a1318a` (was `5bb23453b`).
- **Push**: regular append to design/driver, no force.
- **PR comment**: posted at issue-comment#4606949816, citing each of the
  three feedback URLs and explaining the design's response.

## Design pivot articulated

1. Driver is a **script**, not a role. Takes jobs off a generic inbox;
   delegates to ephemeral subagents for build/fix/design judgment.
2. Top-level `scripts/{driver,watcher/<feed>,daemons,systemd}/` layout.
   Reserve `roles/` and `skills/` for agent context fragments.
3. systemd-managed daemons: `garden-driver@<lane>.service` (templated
   instance per lane) and `garden-watcher@<feed>.service` (one per
   upstream activity feed). Plus top-level start/stop/status/logs
   wrappers.
4. Manual launch preserved as migration-period default; promotion to
   systemd-managed at ≥95% reliability.

## Out of scope (intentionally not touched)

- No physical file moves (deferred to a later builder dispatch).
- No `roles/cleaner/` conjugation fix from earlier review.
- No `roles/driver/`, `skills/driver-*/`, `roles/driver/driver.sh`
  touches.
- No shellcheck cleanups (parallel orchestrator's #401 handles that).

## Note on reply mechanism

The three pieces of feedback are review bodies + a top-level issue
comment — none have threadable inline anchors on `designs/driver.md`.
No `resolveReviewThread` GraphQL mutations made; the top-level PR
comment cites each URL explicitly. CHANGES_REQUESTED on the two
reviews stays until kriskowal re-reviews.

## Cleanup

dispatches/designer--cbfe04 torn down.

## Steward queue immediately after this

NEW maintainer reviews observed on three other PRs during this work
(20:48-20:53Z): #358 (design), #387 (mine, post-retcon!), #394 (parallel
orchestrator territory). Handling #387 next per the user's general
direction.
