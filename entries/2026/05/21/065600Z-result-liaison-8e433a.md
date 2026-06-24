---
ts: 2026-05-21T06:56:00Z
kind: result
role: liaison
project: endo-but-for-bots
to: maintainer
dispatch: 065033Z-dispatch-liaison-8e433a
---

# Result: gauntlet on endo-but-for-bots#334 (mirror of endojs/endo#2887) — un-drafted on round 1

The autonomous-loop gauntlet for [PR endo-but-for-bots#334](https://github.com/endojs/endo-but-for-bots/pull/334) (mirror of endojs/endo#2887, "fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes") terminated cleanly on round 1. **PR un-drafted** (`isDraft: false`); CI 18/18 SUCCESS at head `c37c80134`.

## Stages

1. **Builder d7d813** — 1 conflict resolved, 1 moot hunk dropped (`src/node-modules.js` adjacency no longer exists post-refactor).
2. **Cleaner c643af** — no commits. Diff is README-only (9 ins / 9 del); 145 source `moduleSpecifier` occurrences are legitimate API terms. Cleaner-skip docs-only norm applies.
3. **Judge 8e433a** — 6-seat docs-streamlined panel (stylist / archivist / integrator / packager / pruner / curator): 3 approve, 3 comment-only. 0 must-fix-loop items; 1 summary-fix (README `node:` prefix inconsistency, separate scope); 1 follow-up (mirror title should be `docs(...)` not `fix(...)` for docs-only upstream PRs). Judge un-drafted via `gh pr ready 334`.

## Outstanding async work (not blocking)

- **Summary-fix job** at `journal/jobs/open/20260521T065435Z--8eb3d5--consistency-pr-334.md` — **already claimed by the endolinbot steward**; the steward will land the README `node:` prefix consistency fix on its next cycle.
- **Followup ledger** at `<project-root>/journal/projects/endo-but-for-bots/followups/endo-but-for-bots--334.md` records the `docs(...)` vs `fix(...)` title nit; the boatman can switch the upstream commit subject when ferrying.

## Self-improvement surfaced for gardener

The judge noted: `skills/job-board/post-job.sh` resolves `GARDEN_ROOT` via script-relative `../..` and expects `<garden>/journal/`; in dispatch-worktree triples, journal is a sibling of garden under the dispatch root. The judge worked around with a symlink. Recommend the script accept `--journal-dir <path>` or honor `GARDEN_JOURNAL_DIR`. This is a structural script gap — gardener territory.

## Status

PR #334 is in the maintainer's review queue at `endojs/endo-but-for-bots`. Upstream endojs/endo#2887 remains stalled by cross-fork PR-create. Boatman ferry available when the maintainer authorizes (credentialed host required, currently `kmkmbp2021`).

## Teardown

Dispatch roots `dispatches/builder--d7d813/`, `dispatches/cleaner--c643af/`, `dispatches/judge--8e433a/` all torn down.
