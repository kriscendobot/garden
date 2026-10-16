The regression test is exactly right: it drives the real gutter/refresher/trigger wiring, models hit-testing (a hidden element is not a target), covers the hide-before-mouseup path, and passes `windowTarget` so it re-fails if the focus wiring is ever restored — not a synthetic focus on a bare EventTarget.

Everything this job asked for is already committed and pushed to `origin/clip-gutter-live-refresh` by a prior attempt (before the reaper requeue), and I've verified it holds up on a clean checkout.

## Completion report

**State found:** The PR branch HEAD (`b445544`) already carries the complete fix from a prior attempt of this job. My worktree was a fresh checkout, so I re-derived the state from committed history and re-verified it.

**The two commits that land this fix:**
- `927047c` *fix(shell): bound clip reads, drop the focus trigger, restore the view on throw* — removes the window-`focus` refresh trigger at the old `deploy/aws/www/shell.js:375` (the window `focus` listener is gone; line 381 is now a comment documenting *why* focus is not a trigger). `wireClipRefreshTriggers` now fires only on `visibilitychange` and the manual refresh control. Also gives each read a 10 s deadline and un-conceals in a `finally`. Includes the design-file update (`designs/clip-shell-framework.md`): the refresh contract moved into § 2 and the open-questions item trimmed — resolving the listing mismatch.
- `b445544` *test(shell): pin that a frame-to-window focus mid-click keeps the gutter click* — the regression test. It drives the real gutter/refresher/trigger wiring through a gutter click whose `mousedown` coincides with the frame→window `focus` events, models hit-testing (a hidden element is not a target), and passes a `windowTarget` so the test re-fails if the focus wiring ever returns. This is the hide-before-mouseup path, not a synthetic focus on a bare EventTarget.

**PR body:** already states the user-visible behavior — "Window focus is not a trigger, because it fires mid-click when focus leaves the clip frame."

**CI-equivalent checks (local):**
- `npm run typecheck` — passes.
- `test/shell-clip.test.ts` — 56/56 pass (console errors there are intentional fail-closed-path logging).
- Full `npm test` — 1145 pass, 11 skipped, **1 failure in `test/git-remote/capability.test.ts`** that is **unrelated and pre-existing**: it fails identically on the base commit `ad0257e` (git-version/environment behavior; expects an `exited 128` that this container's git does not produce). Nothing in this PR touches git-remote code.

**Pushed state:** HEAD == `origin/clip-gutter-live-refresh`; working tree clean. Nothing new to commit — the deliverables were already on the remote.

**Remaining panel findings I saw but did not fix:** none beyond scope. Per the job, I did not restart the gauntlet, grant panel rounds, un-draft, or merge — the supervisor `minion-town-carry-eight-prs-to-merge-20261016` owns merge sequencing. The one real defect from the final panel (engine-realist, should-fix) is fixed; the design listing mismatch and PR-body note are also done.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr188-focus-gutter-fix-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 64 tokens (1774642 cached reads)
- Output: 17037 tokens
- Cost: $1.9218266000000002
- Wall-clock: 1168s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
