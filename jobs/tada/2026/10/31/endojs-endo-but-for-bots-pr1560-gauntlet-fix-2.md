I applied panel round 2's must-fix items to PR #1560 and pushed them, but CI had not finished when the one-hour wait ran out. Four full-suite test jobs (Node 22.x and 24.x on ubuntu-latest and macos-15) were still running; the other 32 checks were passing or skipped, and none had failed. `ci-wait-merge.sh` returned rc 4.

**Pushed to `build/exo-agent-factory-core`** (`d8fb029efd..bccc126f77`, via `safe-push-pr-head.sh`), two follow-up commits:

1. **`fix(exo-agent-factory): prove fresh responders and rebind recovered lifecycles`**
   - **Responder check** (raised by locksmith, saboteur, breaker, spec-keeper and wire-watcher): a responder the maker has just returned now goes through the same check as an adopted one before the child is committed. If it is not an unconfined caplet over its driver guest, the coordinator cancels it and rolls the child back. New tests cover this without a crash, plus a maker that returns something that isn't a caplet at all.
   - **Lifecycle after restart** (assessor, engine-realist): on recovery the coordinator now replaces each driver guest's `agent-lifecycle` entry with its own facet before starting any runner. New tests restart the coordinator, then remove or revoke, and check the revived lifecycle reports inactive.
   - **Recovery errors** (saboteur): recovery no longer hides every failure. It still tolerates recorded faults and children that were cleaned up, but if a cleanup fails part-way, startup now fails. New test covers it.
   - **Types** (typist, curator): public types moved to `src/types.ts`, including a new `RootPolicy` with every field required. They are exposed through `types-index.js`, `types-index.types.d.ts` and `package.json` `types`/`exports`.
   - **Smaller items:**
     - Abbreviated names spelled out (`nsId`→`namespaceId`, `op`→`operation`, `seq`→`sequence`, `ref`→`formulaId`, `ctx`→`context`; stylist).
     - `Crash` and `makeToken` are hardened (warden).
     - The test imports `LIFECYCLE_NAME` from `../index.js` (integrator).
     - The README now documents every export (surfacer).
   - **Tests** (prover):
     - The fake guest now has a real `@pins` entry, and the test actually deletes it before checking recovery.
     - The handle-leak test now lists the handle's methods and compares against a fake guest that has real methods.
   - **Edge cases** (corner-prober): new tests for UTF-8 limits (a 4-byte emoji, a lone surrogate), number edge cases (zero, fractions, NaN, infinities, `-0`, `MAX_SAFE_INTEGER`) and name edge cases.
   - **Test bug exposed:** the new responder check caught a test that bound a maker from a different fake daemon. I fixed the test.

2. **`docs(exo-agent-factory): release as 1.0.0 and split the implementation plan`**
   - **Changeset:** changed from `minor` to `major` with a short one-sentence-per-line summary, and added the bare `CHANGELOG.md` (packager, migrator, changeset-auditor, releaser, curator).
   - **Design plan** (integrator): `designs/endo-child-agent-factory.md` § Implementation plan now says the work lands as two PRs, with this one first. A real follow-up job now owns the second PR (below).

**Checks run locally:** 33 ava tests pass, and the package's eslint and `tsc` are clean. The repo-root `tsc` shows no errors in this package, and `build:types:check` and the package-uniformity tests pass. As a sanity check, I removed the three coordinator fixes and the five new regression tests failed.

**PR body edited:**
- The two headings that aren't in the template are gone; their text now sits under Description (integrator).
- The "cheap" performance claim is replaced by an explicit reason for not benchmarking yet (benchmarker).
- The test list is updated.

**Not done:**
- **Purist should-fix:** I didn't import `isPetName` from `@endo/daemon`. It would add a heavyweight dependency, and the daemon wiring planned for the next PR would likely create a dependency cycle.
- **Successor job posted:** `build-endo-child-agent-factory-slice-2`, a builder job for design steps 2–6. It is parked and only becomes work once #1560 merges or closes.
- **Next step:** this stage reports still-pending so the driver reposts it to check CI again.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (8628484 cached reads)
- Output: 40934 tokens
- Cost: $3.781808800000001
- Wall-clock: 4712s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
