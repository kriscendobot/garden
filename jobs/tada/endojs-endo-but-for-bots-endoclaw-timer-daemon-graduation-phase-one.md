The work is complete. I performed the mandatory builder pre-flight (verify no open PR already implements the issue) and found the deliverable already exists, green and merge-ready.

## Completion report

**Outcome: already implemented — no duplicate PR opened.**

The job asked to graduate the EndoClaw interval scheduler from the `@endo/genie` prototype (`packages/genie/src/interval/`) into `@endo/daemon` as a real capability (formula type + `extractDeps` + maker table, with tests, base `llm`). The mandatory pre-flight (builder role: *"Verify no open PR already implements the issue before opening a worktree; skip and surface the existing PR"*) found this exact work already delivered:

**PR endojs/endo-but-for-bots#609** — *"feat(daemon): interval-scheduler formula (endoclaw-timer Phase 1 remainder)"* (base `llm`, head `build/endoclaw-timer-daemon-formula-integration`).

Verified directly against the branch content, not just the PR body:
- **Formula type** — `formula-type.js:17` registers `'interval-scheduler'`; `types.d.ts:685` defines `IntervalSchedulerFormula` (`{ agent, maxActive, minPeriodMs, paused }`) plus `IntervalEntry`/`IntervalStatus` typedefs.
- **`extractDeps` integration** — `daemon.js:809` `case 'interval-scheduler':` with the strong `agent` GC edge.
- **Maker-table entry** — `daemon.js:3918` `'interval-scheduler': async (formula, context, …)` plus `formulateIntervalScheduler` (`daemon.js:4577`), per-formula persistence dir keyed by formula number, `thisDiesIfThatDies(agent)` + `onCancel` disarm.
- **Additive reconciliation vs genie** — a 737-line SES-safe port in `packages/daemon/src/interval-scheduler.js` (injected id-gen / clock / `setTimeout`, `filePowers` write-then-rename persistence); the genie prototype is left in place, so it extends rather than duplicates.
- **Host wiring** — `host.js`/`interfaces.js` `makeIntervalScheduler(petName, opts?)` command + `HostInterface` guard.
- **Tests + changeset** — `interval-scheduler.test.js` (571 lines, 7 cases), `formula-type.test.js` registry update, `.changeset/daemon-interval-scheduler.md`.

**PR state:** OPEN, **non-draft** (already through the panel/gauntlet), **MERGEABLE / CLEAN**, **all CI checks SUCCESS** (test matrix 22.x/24.x on ubuntu+macos, lint, build, cover, test262, hermes, etc.). Diff: 9 files, +1601/−1.

Opening a competing PR would have duplicated a merge-ready branch and risked the same-branch working-tree collision the pre-flight norm exists to prevent, so I opened nothing.

**Changes made:** none to the garden repo and none to the project repo (no worktree needed beyond read-only inspection of the bare clone).

**Follow-ups:**
- Recommend the liaison treat this job as a duplicate; #609 is ready for the conductor/merge path.
- The later design phases already have stacked PRs, out of this job's scope: **#617** (Phase 2 — tick delivery as mail + `TickResponse` exo) and **#619** (Phase 3 — startup recovery / missed-tick coalescing).
- Sent a `message-user` note to the maintainer/liaison summarizing the above.
