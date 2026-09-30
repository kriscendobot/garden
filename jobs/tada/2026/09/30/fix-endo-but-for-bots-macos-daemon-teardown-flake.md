I fixed the flake that is actually macOS-only and opened draft PR endojs/endo-but-for-bots#1401. The endo.test.js failure turned out not to be macOS-specific: I fixed the likely cause but never reproduced it, so that part is unproven. All four `test` legs pass on the PR's first CI run, and so does everything else that ran (lint, cover, viable-release).

**The job's report mixed two separate flakes.** I checked every failed `test (…)` job since 2026-09-20:

| Failure | Count | Legs |
|---|---|---|
| `daemon-teardown › an orphaned daemon shuts itself down…` ("daemon recorded its pid…") | 10 | macOS only (7× Node 22, 3× Node 24) |
| `Unhandled rejection in test/endo.test.js` … `Termination requested` | 7 | all four legs, including 3 on Ubuntu |

**1. Orphan-daemon failure: real race, fixed and proven.** The daemon told its launcher it was ready (which makes `start()` return) before it wrote `endo.pid`, and ran the `ENDO_EXTRA` setups in between. `src/manager-node.js` and `src/bus-manager-node.js` both did this. The consequences:
- On slower runners the orphan test read pid 0.
- In real use, a `stop()` issued right after `start()` couldn't find the pid, skipped the kill, and leaked the daemon.

Both managers now write the pid before signalling ready. A new test, `start() resolves only after the daemon records its pid`, uses a deliberately slow setup to widen the gap. It fails on the old code and passes on the new, locally and on the macOS legs.

**2. endo.test.js unhandled rejection: likely cause fixed, plus logging.**
- **Likely cause:** the rejected value is the daemon's shutdown reason (`Termination requested`), arriving on a promise nobody was watching. In `@endo/exo-stream`, `iterateReader` and its three siblings create a promise up front but only watch it on the first `next()`. If nobody reads before the daemon disconnects, that rejection goes unhandled. Each now marks that promise handled when it creates it; a caller that does read still gets the error. A new exo-stream test fails before this change and passes after. I added a patch changeset.
- **Unproven:** I couldn't reproduce the endo.test.js failure locally, so this may not be its only source.
- **Logging:** AVA only reports these rejections after the whole file finishes, which is why every report lands after the last test and names nothing. `test/endo.test.js` now logs each one as it happens, with the running test's title and whether it was in teardown. If it recurs, the CI log will name the test.

**Not changed: the affected-set trigger.** A `yarn.lock` change can change the daemon's dependencies, so skipping the daemon suite for root-config changes would give up real coverage just to hide the flake.

**Local results (Node 22):** `daemon-teardown` 4/4, `extra-setups` + `socket-lifecycle` 10/10, all 265 tests in endo.test.js, and all 156 exo-stream tests pass. eslint, prettier and exo-stream's type check are clean.

**Follow-ups:**
- The PR is a draft against `llm-825c598`, a new frozen snapshot of the `llm` branch that I pushed, and is waiting on the review gauntlet.
- If the `Termination requested` failure shows up again after this merges, the new log line will name the test to look at.
- Local environment: the dependency store is shared between worktrees, and another job's rebuild left `better-sqlite3` compiled for Node 24, so daemons failed to start on Node 22. I rebuilt it for Node 22 inside this job's worktree only; the shared copy wasn't touched. Other Node 22 jobs in their own worktrees may hit the same "compiled against a different Node.js version" error.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-but-for-bots-macos-daemon-teardown-flake.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 278 tokens (21584756 cached reads)
- Output: 68142 tokens
- Cost: $7.454807200000001
- Wall-clock: 6508s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
