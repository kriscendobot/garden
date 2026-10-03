## ebfb-daemon-test-flakes-20261003: completion report

All four flaky `@endo/daemon` signatures are accounted for. Two were already fixed on `llm` and two are fixed in draft PR **https://github.com/endojs/endo-but-for-bots/pull/1418** (base `llm-e4fcd7b`, head `fix/daemon-test-teardown-leaks-20261003`). CI on the PR passed all four test cells (22.x/24.x × ubuntu/macos-15), plus lint, cover and viable-release. None of the old signatures appear in those logs.

**What each failure was** (from the six PRs' failed-job logs plus about 25 other failing runs from 2026-10-01/02):

1. **Orphan test, "daemon recorded its pid before its launcher exited" (macos):** already fixed on `llm` by 892683f957 / f77cb413e0, where the daemon now writes `endo.pid` before signaling ready.
   - Every failing head I checked predates that fix, including #1392, #1396, #1404 and #1408.
   - The PRs only need a rebase onto current `llm`.
2. **`Termination requested` unhandled rejection in `endo.test.js` (ubuntu and macos, Node 22 and 24):**
   - **Cause:** the test helper `makeHost` never handled the promise returned by `host()`. The "retention table supports write, list, replace, delete" test never awaits `host`, so it can finish before the daemon answers. Teardown then terminates the daemon, and that promise rejects with nobody listening.
   - **Not the readOnly test:** the job named `EndoHost/EndoGuest do not carry readOnly()` only because ava reports the rejection at the end of the file. Both CI runs with the newer per-test logging blame the retention test's teardown.
   - **Not the exo-stream fix:** one of those runs already included e2f6abf54c, so that fix doesn't cover this case.
   - **Fix (654bdbcad4):** the promise is now marked handled in all 11 copies of the helper across the daemon tests. A test that awaits `host` still sees any error.
   - **Evidence:** a standalone repro that forces the race leaked 5/5 times without the fix and 0/5 with it. The retention and readOnly tests ran 20/20 clean.
3. **`ClientDestroyedError` "Cannot assign to read only property 'message'" (every Node 24 run):** this does not affect the production daemon. It only happens under the test-only debug lockdown.
   - **Cause:** `@endo/init/debug.js` freezes `Error.prototype.message`, and Node 24's built-in `fetch` sets `this.message` inside that error's constructor, so the assignment throws.
   - **Why only the test:** the daemon itself runs under `@endo/init`, which allows that assignment.
   - **Not a fatal failure:** ava never counted it; SES only logged it.
   - **Fix (cb6c8e0778):** `http-content-plane.test.js`, the only daemon test that uses the real `fetch`, now loads `@endo/init` like the daemon does.
   - **Evidence:** the error appeared on every Node 24.21 run before the fix; after it, 10/10 clean on Node 24 and 5/5 on Node 22.
4. **ws-relay "connect fails gracefully":** already fixed on `llm` by 5e6f81fa14. It didn't fail in any test job I sampled.

**Other verification:**
- `daemon-teardown.test.js`, which includes the orphan test, passed 8/8 on Node 22. I couldn't run it on Node 24 locally because the sqlite native module here is built for Node 22; the PR's CI covered that leg.
- The full daemon suite on Node 22 had 1333 passing and 6 failing:
  - The 5 `git.test.js` failures happen identically on unmodified `llm` on this host, so they come from the environment.
  - The `git-remote` push timeout passed 4/4 on rerun and also flakes on `llm` CI.
- `yarn lint:types`, the repo-root `tsc`, eslint and the pre-push gates are all clean.

I didn't touch the six gauntlet PR branches, and I removed my scratch checkouts.

**Follow-ups:**
- The halted PRs need a rebase onto `llm` at or after 892683f957 for the orphan fix (the sibling gauntlet job's lane), and onto #1418 once it merges.
- `git-remote › GitRemote push round-trips to an independent fetcher over file://` is a separate timeout flake that slows down under load; I didn't address it.
- Several PR branches, but not `llm`, fail lint with an ESLint `parserOptions.project` error on `ws-relay.test.js`; this needs its own investigation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-daemon-test-flakes-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 212 tokens (14674182 cached reads)
- Output: 49367 tokens
- Cost: $5.3682324
- Wall-clock: 8581s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
