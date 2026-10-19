I fixed the Firefox "storage works inside the frame" failure in kriscendobot/minion.town and opened PR [#207](https://github.com/kriscendobot/minion.town/pull/207) (draft, head `fix/browser-gate-firefox-storage-race`). All three browser-gate legs pass on it, Firefox 30/30.

**Not specific to push runs.** The job assumed the check only failed on push to `main`, but the same failure hit the pull_request run for fca3abb (39192533437, attempt 1). That run passed on rerun, and so did a feat/clip-live-frame run (39052339545). The supervisor's failed-leg rerun of 39198787628 also passed on attempt 2. So this is a race in the test, not a runner or concurrency difference between push and PR runs.

**Root cause.** The shell (`deploy/aws/www/shell.js`) auto-selects the first listed clip (LIVE) when the listing loads. The gate then clicks LIVE again, and `selectClip` always reloads the frame at the same URL.
- The "has the clip script run" wait could pass on the auto-selected page.
- The storage read then hit the newly loaded page before its script had run, so `window.__storage` was `undefined`.
- The WSS check never hit this because it polls until the value appears.
- Firefox loses this race now and then; Chromium and WebKit evidently haven't.

**Fix** (only `test/browser/clip-frame-gate.ts` changed):
- Before the click, the test waits for the auto-selected page to run and marks it (`window.__superseded = true`).
- It then takes "script ran" and the storage value from a single read of an unmarked page, which can only be the one the click loaded.
- The check now reports what it read (`{ran, superseded, storage, href}`, or the evaluate error) instead of `undefined`. On #207 it shows `{"ran":true,"superseded":false,"storage":"ok",...}`.
- The shell and the gate's assertions are unchanged, and `tsc` reports no errors in the file.

**Not yet verified:**
- One green Firefox run doesn't prove the flake is gone, since it only failed some of the time before. Later push runs on `main` will show it.
- The "test (typecheck + vitest)" run on #207 was still queued when I finished. The self-hosted runner has a single busy runner working through a backlog.

**Other notes:**
- `ensure-pr.sh` refuses a floating base, so I pushed a frozen base branch, `main-d082131`, at the current `main` tip and targeted the PR at it.
- The gauntlet and proxy carry the PR from here under the screen.
- I didn't commit anything to the garden repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-browser-gate-firefox-storage-main.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2424792 cached reads)
- Output: 16437 tokens
- Cost: $1.4697543999999996
- Wall-clock: 3893s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
