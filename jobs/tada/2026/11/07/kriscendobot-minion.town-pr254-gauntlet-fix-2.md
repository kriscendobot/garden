I pushed fixes for the panel's findings on PR #254, but CI never started within the one-hour deadline. Both runs for the new head `27ff5fb` sat queued the whole time, so the stage result is **still-pending**.

**Pushed to `fix/recovery-outcome-screen` (608b3d6 → 27ff5fb, three follow-up commits via `safe-push-pr-head.sh`):**

1. **`49e497b` fix(web)** — the three assessor items in `deploy/aws/www/home.js`:
   - "Try again" now re-runs the guest lookup from the link parsed at page load instead of reloading. A reload came back without the `#recover` / `guest=` link, which had already been cleared from the address bar. The button is disabled while the retry runs.
   - The leftover failure screen is now cleared on decline, on "continue to my guest", and after a successful accept, so a stale "No guest is attached" card no longer comes back.
   - A failed invitation now shows the server's message for 4xx errors (such as a bad or duplicate pet name). Generic "try again" text is kept for 5xx and network failures. Tests added in `test/home-page.test.ts`.
2. **`bc3c806` test(web)** — a new test in `test/web/guest-settings-http.test.ts` covers the deleted-guest 404 path, checking `identityProvider: "GitHub"` and that the bond gets removed. The router now passes the `x-auth-request-provider` header back only if it is printable ASCII and at most 64 characters, with a test for that.
3. **`27ff5fb` chore** —
   - Added `.changeset/guest-recovery-outcome.md` as a `patch` (the only must-fix). It describes the landing-page change and the additive `identityProvider` field, and tells operators to reload Caddy.
   - Added a comment to the wait-list probe in `prod-objectives.mjs` saying it depends on the wait-list policy.
   - Removed the screenshot `.evidence/recovery-outcome-real-daemon-chromium.png`, which was byte-for-byte the same as the desktop one.

**Local checks:**
- `npm run typecheck` passes, and the prod-objectives tests pass 36/0.
- In `npm test`, 1862 tests pass and one fails: `test/git-remote/capability.test.ts`, which this diff doesn't touch. I believe it's the git-wrapper test that already fails falsely in this sandbox, but I didn't rerun it on the old head to confirm.

**Not done, deliberately:** the packager asked to squash commits and to move the probe change into its own commit or PR. Both mean rewriting history on the PR head, which a follow-up-commit fix round doesn't do. They're left for the maintainer to decide.

**CI:** `ci-wait-merge.sh` returned rc 4 after 3060s with all 5 checks pending. About 11 runs were still queued across the whole repo, so this looks like the ci.minion.town runner stalling, possibly the known rate-limit issue. A stall longer than an hour doesn't fit the usual hourly self-recovery, so the runner may need someone to look at it.

**Workaround used:** `ensure-project-worktree.sh` failed with a read-only filesystem error (EROFS) under the monk sandbox, the issue already reported. I cloned into `$TMPDIR` instead.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2650554 cached reads)
- Output: 13695 tokens
- Cost: $1.4890108
- Wall-clock: 3892s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
