---
ts: 2026-05-13T21:05:50Z
kind: result
role: groom
project: endo-but-for-bots
worktree: dispatches/groom--raise-gateway-to-m1--20260513-210114--6113f3/project
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/13/203419Z-message-steward-2480ee.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 236
    role: authored
  - repo: endojs/endo-but-for-bots
    pr: 134
    role: source-directive
---

# Result: raise Endo Gateway to M1 in roadmap

PR: https://github.com/endojs/endo-but-for-bots/pull/236
Commit on `roadmap/gateway-m1`: `2ea1230b6019d5510e6fc6c459b9f72aef0458b7`

Source directive: kriskowal at `endojs/endo-but-for-bots#134#issuecomment-4444987124` (2026-05-13T20:33:17Z): "Please propose a change to the roadmap to raise the Gateway concern to M1 if it is not already there."

## Diff summary

Three sites in `designs/README.md`, one new row each plus a counter bump:

1. **§ Milestone 1 table**: added `endo-gateway | Proposed | Per-host system-service HTTP virtual host for OCapN; lifts hosting out of per-user Daemon; closes issue #173, unblocks PR #134`. Inserted between `gateway-bearer-token-auth` and `daemon-docker-selfhost` (the design it unblocks).
2. **§ Per-Design Estimates table**: added `endo-gateway | L | 1.5-3 weeks | 1 | <notes citing the directive>`. The row's milestone column is **1**, satisfying the directive. Size set conservatively at L pending a per-phase backfill; this is the row the directive targeted.
3. **§ Summary by Milestone**: M1 "Items" bumped 12 → 13, Total remaining 50 → 51. Effort range and review-queue range left as-is (taste call to recalibrate M1 effort to absorb a new L-sized item; out of scope for a targeted post-event reconciliation).

"Last updated" header bumped to 2026-05-13.

## Before / after

Before this pass, `endo-gateway` was present in the § Summary table only (line 139, Proposed, added 2026-05-10) and was absent from every milestone table and from § Per-Design Estimates. The directive's "raise to M1" therefore resolved to "add the row at milestone column = 1", not "change a column from 0 → 1".

## Commit identity

Author and committer: `kriscendobot <279080640+kriscendobot@users.noreply.github.com>`. No `Co-authored-by` / `Generated with [Claude Code]` trailers (verified with `git interpret-trailers --parse`).

## Self-improvement

The dispatch brief framed the work as "flip the milestone column to 1" but the row did not exist at all. The targeted sub-mode of `groom` does not have explicit guidance for "row missing entirely" (it assumes the disturbed-row case). One-line addition to `roles/groom/AGENT.md` would help: under § Sub-modes for the targeted case, note that "raise X to M" may resolve to an *add a row at column M* edit when X is in § Summary but absent from § Per-Design Estimates; the directive's intent is satisfied by the new row at the named milestone.
