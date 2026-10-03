## PR #1404 macOS failure: a known flake, not a regression

The red macOS check on endojs/endo-but-for-bots#1404 is a flake in a daemon test that already fails the same way on the base branch. Nothing in the PR's code caused it. It just needs a CI rerun, but the bot can't rerun it itself (see below).

**What I read:** run 37021265628, job 110885259733, leg `test (22.x, macos-15)`. That run is on the PR's current head `c6857a2b52`.

**Failing test:** `@endo/daemon`, `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. It is the only failure in the leg (1 failed, 5 skipped).

**Error from the log:**
```
daemon recorded its pid before its launcher exited
Value is not `true`:
false
  at packages/daemon/test/daemon-teardown.test.js:196:11
```
The test starts a daemon from a short-lived launcher process. As soon as the launcher exits, it reads `endo.pid`, and `readPid` returns 0 if the file isn't there yet. So the assertion fails whenever the pid file hasn't been written in time. On slow macOS runners this is a timing problem in the test itself. The check fails before any guest code or name-lookup path runs.

**Why it's a flake:**
1. **#1404 doesn't touch this code.** The PR changes the guest side: `guest.js`, `directory.js`, the guest facets registered in `manager.js`, and redaction. It doesn't touch daemon startup, pid-file writing, the orphan watch, `daemon-teardown.test.js` or `_orphan-daemon-launcher.js`. The test file was last changed in #1309 (2026-09-22).
2. **The same head passes everywhere else.** On that run, `test (24.x, macos-15)`, `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)` and all the other test jobs are green.
3. **It fails on the base branch too.** I checked about 40 recent failed CI runs. This exact failure and message appear on:
   - the `llm` branch itself: runs 36886282492 (head `e8f14037`) and 36837442037, both on Node 24.x macOS;
   - about 12 unrelated branches, on both Node 22.x and 24.x macOS, including `bot/build/guest-scoped-daemon-bootstrap`, `build/pet-name-path-only`, `build/sturdyref-*` (four branches), `build/endo-inference-seam-1357`, `codex/thixotrope-daemon-features`, `claude/kind-turing-xt1m7m`, `claude/sleepy-wozniak-8pz7xa` and `llm-ironhorse-panic-live-handle-reseat`.

It isn't the "Failed to exit" teardown flake from the sibling PRs. It's a different pre-existing macOS flake that is just as unrelated to this PR.

**What I changed:** nothing. No code, no pushes, no PR.

**Follow-ups:**
- **Rerun the failed `test (22.x, macos-15)` job on #1404**, then resume the `ebfb-guest-no-identifiers-locators-gauntlet`. Someone with permission has to do this: `gh run rerun` returns 403 for the bot on this repo. I didn't try any workaround.
- **Fix the test itself.** It's failing across about 13 branches and the base branch, so it will keep stopping gauntlets. The fix would make the test wait for `endo.pid` to appear, with a deadline, instead of reading it once right after the launcher exits. I couldn't find an open issue or PR for this. I recommend posting a `fix` job against `llm` for `packages/daemon/test/daemon-teardown.test.js`; I didn't post one because that call belongs to the liaison.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `91a851e20216114c06dd1b5e019af927e35d2a3b`; this job presented `c6857a2b52442324d5eac6cd5604462d32a9bd91`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1404-investigate-20261002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 26 tokens (692255 cached reads)
- Output: 5538 tokens
- Cost: $0.724539
- Wall-clock: 523s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
