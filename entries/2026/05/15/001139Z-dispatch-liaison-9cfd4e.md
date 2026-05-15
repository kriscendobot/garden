---
ts: 2026-05-15T00:11:39Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: groom recalibrates and updates the roadmap

Dispatch root: `dispatches/groom--9cfd4e/`. Project worktree on `endojs/endo-but-for-bots@llm` (the roadmap lives at `designs/README.md`).

Maintainer directive (2026-05-15): *"Please dispatch a groom to recalibrate and update the roadmap."* Per the liaison's vocabulary section landed today, "groom the roadmap" → dispatch groom; "recalibrate" implies a velocity recalibration step alongside the standard roadmap update.

## Per-action authorization

Standing on endo-but-for-bots: push roadmap edits.

## Task

Run the groom role per `roles/groom/AGENT.md`:

1. **Survey today's roadmap movement.** A heavy day (2026-05-14): many designs landed (TLA, import-attributes, exo-import, exo-npm-registry, package-uniformity, Noise session-reconnect), Cut 5 of the devDep-cycle factoring opened (#247) and panel-approved, the 12-seat code panel and 5-seat design panel started running in production, the syrup-frame rename completed (#109), the SECURITY.md uniformity check landed (#228, #245), the Node-18 drop landed (#232, #246 master mirror), and multiple new builder mirrors opened (#226, #244, #248, #249, #251, #252, #253, #255). The groom catalogs these against `designs/README.md`'s table.

2. **Velocity recalibration** per `skills/velocity-recalibration/SKILL.md`. Today's throughput is higher than the prior baseline (estimated ~6-8 substantive PRs/day vs. recent days at 2-4). The recalibration updates per-design size/duration estimates if any have aged out.

3. **Update the milestone bins** if any designs have moved between milestones based on today's progress. Cut 5 of #206 closes a milestone-relevant item; the resilience design (#82 / iter II in #255) may bump milestone alignment.

4. **Run `skills/design-queue-drift-check/SKILL.md`** if any designs in the queue are stale or no longer eligible.

5. **Update the dependency-graph subsection** if cross-design dependencies changed.

6. **Add summary-table rows** for any new designs that landed today and don't yet have rows (the builders' "append a row" instruction may have left gaps for the broader integration the project's `designs/CLAUDE.md` describes).

## Out of scope

- No new design authoring (the groom maintains the roadmap; the designer authors).
- No PR opened for the roadmap edit (the groom commits directly to `llm`).
- No fork-side close of any PR.
- No upstream ferry.

## Commits

- One commit per substantive section update (velocity recalibration, milestone moves, drift check, dependency graph). The groom batches into a single commit when the updates are small (gardener's call per `pr-formation`).

Push at end. Journal result entry.

## Report

≤ 500 words: summary-table additions (one line each), velocity-recalibration deltas (one line per milestone), drift-check outcome, dependency-graph deltas, one-line `Self-improvement: ...`.
