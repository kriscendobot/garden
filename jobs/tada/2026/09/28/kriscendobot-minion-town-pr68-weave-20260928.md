I rebased PR kriscendobot/minion.town#68 onto current main (frozen as `main-b32291d`). The new head is `ee2682c` and CI is green on it. Nothing was merged or deployed.

**What changed:**
- **Rebase:** the PR's 4 commits moved from `adfca73`, which was 92 commits behind main, onto `main-b32291d` (main's tip at `b32291d`). I force-pushed with a lease on `adfca73` and changed the PR's base field to `main-b32291d`. Main had not moved when I pushed.
- **`daemon-site-registry.ts`:** I kept main's `evaluateRegister` exactly as it is: `createDirectory` picks the worker, then `guestRegisterSource(directory.formulaId)` runs on `directory.workerName`. The PR's older single-evaluate version (with `freshDirectoryPetName`) is dropped. The PR only wanted one shared way to choose between `@main` and `MAIN`, so main's inline `selectWorkerName` now calls the PR's `resolveGuestMainWorker`, and behavior is the same.
- **`guest-tools.ts`:** main now registers tools through a tool-name list in `mcp-tool-names.ts`. `publishNamedContent` is registered the same way: I added `sites.publishNamedContent` to that list. The imports and doc block combine both sides.
- **Tests:** in the clip-tools test I kept main's check, which reads the expected tool names from that list. In the tool-names test, the two fixed name lists now include `publishNamedContent` and the expected count goes from 23 to 24.
- **Lockfile:** `package-lock.json` was regenerated from main's copy with `npm install --package-lock-only` and stays in its own commit. The only change is adding `@endo/bytes`.
- **No design gap:** main's current registration design can express the feature, so nothing main had replaced was reintroduced.

**Checks:** typecheck, build and `npm test` pass locally with `GARDEN_YARN=npm` (49 test files passed, 3 skipped; 567 tests passed, 8 skipped). On GitHub, the test and both Claude harness checks pass, and the PR shows as mergeable with no conflicts.

**PR comment:** I posted a summary of how each conflict was resolved for the maintainer: https://github.com/kriscendobot/minion.town/pull/68#issuecomment-5879249324

**Next steps:**
- The maintainer's approval was on `adfca73`, so they need to re-review and re-approve `ee2682c`.
- After that, the conduct, deploy and production-validation job needs re-posting. It is the one that stalled on `needs weave` (`kriscendobot-minion-town-pr68-conduct-deploy-validate-20260928`).
- The PR's base is now the frozen `main-b32291d`, so the merge job has to merge against that base (or retarget to `main`), like the other minion.town PRs on `main-*` bases.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `50245566`; this job presented `ee2682c37ad634c2b7ecdf12df536373e82e3044`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-weave-20260928.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2129281 cached reads)
- Output: 11502 tokens
- Cost: $1.3212561999999999
- Wall-clock: 426s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
