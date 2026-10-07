## Fix round 6: endojs/endo-but-for-bots PR #1398

I fixed every panel-6 must-fix item and most of the should-fix items. The PR head moved from `87c7516d4b` to `afc5c25c1f`, and CI is green: 33 checks, 0 failed (`ci-wait-merge` rc 0).

**Commit grouping (integrator).** I reset the branch onto the frozen base `0e0b333c19` and regrouped it into the three commits the integrator asked for. The `collection-tombstones.js` module that was added and later deleted no longer appears in the history. Because this rewrites history, I pushed with `safe-push-pr-head.sh --mode rewrite`, which leases against a freshly fetched head.
1. `fix(daemon): reject a lookup of an unknown or collected formula instead of reading it back` holds the `getFormulaForId` change, the `formulaGraphSeeded` gate, the git-remote fix, the tests and the changeset.
2. `feat(daemon): layer 8 — a SturdyRef for a formula without incarnation` holds the SturdyRef kit and its wiring, the `package.json` dependency, `tsconfig.composite.json` and the `types.d.ts` update.
3. `chore: Update yarn.lock`.

**Tests (prover; also asked for by breaker and assessor).** Three daemon-level tests in `endo.test.js`:
- **Collected formula:** looking up a collected formula's id rejects, and the error does not contain the id's number. This pins the redaction claim breaker raised.
- **Record still on disk:** a collected formula whose record is written back into the store is still refused, and refusing does not read the record back into memory. I restored the old read-back temporarily and confirmed this test then fails.
- **After restart:** a formula persisted before a restart still resolves by id after it.

There is no test of a lookup that arrives while seeding is still running. Nothing outside the daemon process can call `getFormulaForId` before seeding finishes, so I covered the gate with the restart test and a code comment instead.

**Code fixes (breaker, integrator, assessor):**
- **Git-remote revival path:** `persistGitRemoteState` no longer falls back to the formula it captured earlier. If the formula has been collected, it refuses instead of writing it back into memory and storage. I removed the `currentFormula` variable that made the fallback possible.
- **Seeding failure:** if seeding fails, the seeding gate now rejects, so a lookup waiting on it fails too instead of hanging. A comment says seeding must not call `provide` or `getFormulaForId`.
- **Types:** `DaemonCoreExternal` in `types.d.ts` now lists `sturdyRefForFormula` and `formulaIdOf`, typed from the kit.

**Changeset (packager, changeset-auditor, releaser).** It is renamed to `.changeset/daemon-collected-formula-lookup.md` and stays `patch`. It now covers only the user-visible fix, one sentence per line, and says a caller that looks up an id the daemon no longer holds will now get that rejection. I dropped the paragraph about the internal kit. `patch` holds because `manager.js` and `DaemonCoreExternal` can't be reached from any package export.

I also updated the PR body to match: the changeset scope, the three tests, and the git-remote fix.

**Local checks:**
- The full `endo.test.js` run passed (268 tests), as did `formula-sturdyref.test.js` and `git-remote.test.js` (50 tests).
- `tsc --noEmit` and eslint report no errors.
- To run the daemon tests locally I had to rebuild better-sqlite3 for Node 22 (it was built for Node 24). That change is only inside this job's project worktree's node_modules store; I broke the hardlink first so no other copy changed.

**Follow-ups:**
- breaker's comment-only note is still open: formulating writes the record before setting `formulaForId`, so a lookup in that gap now rejects. I found no caller that can know the id that early.
- There is still no test that mints a SturdyRef through the real daemon core (prover's should-fix #3). Nothing in the tests can reach `DaemonCoreExternal`, so this fits better with layer 9, which is the first consumer.
- The driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3938471 cached reads)
- Output: 19832 tokens
- Cost: $1.9629101999999998
- Wall-clock: 3574s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
