I applied the round-5 panel's must-fix items to endojs/endo-but-for-bots#1403 and pushed them. CI on the new head `6be2a3cbdb` is green: 33 checks, 0 failed (`ci-wait-merge` rc 0).

**What changed:** five single-concern commits on top of `aef833b9c0`, pushed with `safe-push-pr-head.sh --mode advance`:
- **`085db2f743` — byte counting goes back to `TextEncoder`** (benchmarker must-fix; also purist and fast-checker #1). I measured both on Node 22:
  - 1 KB ASCII: the hand-rolled loop took 1.6 µs per call, `TextEncoder` 0.65 µs.
  - 1 MB ASCII: 1.47 ms vs 0.40 ms.
  - 1 MB mixed text: 1.75 ms vs 0.89 ms.

  The round-4 reason for the loop ("count without encoding, avoid the allocation") was wrong, so I removed the loop instead of adding a property test for it.
- **`4c40717301` — a throwing `reportSinkError` can no longer escape** (saboteur should-fix). Without this, the throw became an unhandled rejection. A test covers it.
- **`19ff953f58` — two new tests** (prover):
  - The must-fix: a retry delay of `Number.MAX_SAFE_INTEGER + 100`. It is the only tested value that the old `isFinite` check and the new bound treat differently.
  - The should-fix: three out-of-shape `describe()` returns each make `infer` reject before the turn starts.
- **`446e36e08e` — `makeProcessGroupKiller` now refuses a missing `platform`** (engine-realist). Before, it silently took the POSIX branch, which is wrong on Windows. Its doc now also mentions that the OS can reuse the pid (saboteur #2).
- **`6be2a3cbdb` — documentation** (purist, surfacer):
  - The types now say `buildMcpServer` and `release` must be made with `Far`, and `cancelled` must be a real promise.
  - The README now says `MAX_TIMER_DELAY_MS` comes from `guards.js`.
  - `cancelled` stays typed `PromiseLike<unknown>`: `M.promise()` infers that type, and `Promise<unknown>` breaks the `makeExo` typing.

**PR body and comments:**
- The PR body now has the missing Scaling, Documentation and Upgrade Considerations headings (integrator must-fix), and the test count is updated to 62.
- I posted the round summary as comment 5966304293. It opens with a loop-status line (scribe) and lists what happened to each finding.

**Checked locally:** 62 AVA tests pass. `tsc` passes for the package and the repo root, eslint reports no errors, and prettier is clean.

**Not done:**
- **integrator #2:** I did not split the old `aef833b9c0` commit, because that means force-pushing over a reviewed head; this round's commits are split instead.
- **fast-checker #2–#4:** no property tests and no `fast-check` devDependency. Adding the dependency changes `yarn.lock`, which belongs in its own follow-up.
- **integrator #3:** the `garden-related-design: 1102` marker still points at the closed #1102. It should be repointed at #1343 when that work lands.

The driver posts panel round 6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3404118 cached reads)
- Output: 20089 tokens
- Cost: $1.8965236
- Wall-clock: 3885s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
