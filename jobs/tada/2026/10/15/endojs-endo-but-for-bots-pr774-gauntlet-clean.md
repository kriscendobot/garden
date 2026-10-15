---
orchestration-failed: true
---
PR #774's clean stage failed: CI on the new head finished red. The one failure looks like a flaky test unrelated to my change, but I couldn't re-run it because the bot token doesn't have permission (HTTP 403).

**Coverage pass (done and pushed):**
- The PR was already all green at head `98a09fa`. A coverage run on the new `@endo/parcel` package found these gaps:
  - `src/parcel-pony.js` lines 29–33: the `locate` wrapper.
  - `src/parcel-shim.js` lines 186–189: the error when installing after lockdown.
  - `index.js` and `no-shim.js`: no test imported them (0%).
- I added three tests in `packages/parcel/test/`:
  - `parcel-pony.test.js` imports the public `index.js` and checks `makeParcel`, `open`, `isParcel` and `locate`.
  - `parcel-shared-locate.test.js` checks that `locate` refuses when the global constructor is the shared form, which has no `locate`.
  - `parcel-postlockdown-missing.test.js` checks that `selectParcel()` throws after lockdown when no constructor is visible.
- With these, `@endo/parcel` has 100% statement, branch, function and line coverage, and all 18 tests pass. Lint and the type check report 0 errors; the new warnings are the same kinds the existing tests already have.
- I found no dead code left behind by the change. Every changed module, including `E.open` and the `pre.js` shim import, is used and tested.
- I committed `501a4f42d` ("test(parcel): cover ponyfill entry, shared locate, and post-lockdown install") and pushed it with `safe-push-pr-head.sh`. It fast-forwarded `build/sturdyref-shim-first-wins` from `98a09fa5f`.

**CI result (red):**
- `ci-wait-merge.sh` hit its 3500s deadline (rc 4) with three test jobs still running. I kept polling until they finished, then ran it again, which returned rc 3 (red).
- 24 checks passed, 8 were skipped, and 1 failed: **`test (24.x, macos-15)`** (job 116208148557). The failing test is `packages/daemon` › `daemon-teardown › an orphaned daemon shuts itself down instead of lingering` ("daemon recorded its pid before its launcher exited"). It was the only failure in that package's run.
- **It looks unrelated to this push.** The commit only adds files under `packages/parcel/test/`. The same check passed on the previous head `98a09fa`, and it passed on macOS / Node 22 and on both Ubuntu runs. It looks like a macOS timing flake in the daemon teardown test.
- **The re-run failed:** `POST /actions/jobs/116208148557/rerun` returned HTTP 403 "Resource not accessible by personal access token". The bot token on this host can't re-run Actions jobs.

**Follow-up:** Someone with Actions write access needs to re-run `test (24.x, macos-15)` on head `501a4f42d`. If it passes, the gauntlet can resume from this stage. If the daemon-teardown test keeps failing on macOS, it needs its own fix job.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr774-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1907335 cached reads)
- Output: 11033 tokens
- Cost: $1.1709670000000005
- Wall-clock: 5461s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
