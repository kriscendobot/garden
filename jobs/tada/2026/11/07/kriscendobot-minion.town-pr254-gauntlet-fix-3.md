# Gauntlet fix round 3 for kriscendobot/minion.town#254: fix pushed, CI green

I applied the fixes from the latest panel verdict (review 5814702535, "Must-fix before merge") as one follow-up commit, `f9db0f8`, and pushed it to `fix/recovery-outcome-screen` with `safe-push-pr-head.sh` (advance from `27ff5fb`). `ci-wait-merge.sh --no-merge` returned rc=0: all 7 checks passed (test, the three browser gates, both Claude harness legs, and changes).

**The must-fix (assessor and breaker): a remembered failed recovery could hide a working guest.**
- In `deploy/aws/www/home.js`, the failed recovery saved in sessionStorage is now held apart from failures seen on the current load. A guest that checks out now ranks above it, and an open invitation does too.
- Starting the guest view (after a successful landing or an accepted invitation) clears the saved record.
- "Try again" now also resets the stale provider label (assessor, comment-only).
- New unit tests in `test/home-page.test.ts` cover this ranking and the clearing.
- Locally, vitest passed (home-page, caddy-account-routes and guest-web-http: 83 tests), `tsc` typecheck was clean, and the chromium landing-outcome browser gate passed.

**Smaller items also addressed:**
- **Evidence screenshots (integrator):** removed the `.evidence/*.png` files from the tree. The PR body's images still render because they link to an earlier commit.
- **Comments (pruner):** cut the outdated "Until the landing is wired…" sentence and the inaccurate CSS sentence about the heading carrying the announcement.
- **Spelling (orthographer):** "cancelled" is now "canceled" in `index.html`.
- **Provider header (assessor, breaker, integrator):** the changeset now says the header comes from oauth2-proxy's `injectResponseHeaders` (claim `idp`) in `alpha-config.yaml`. It also says that only the recovery route reads it, and that the prod probe now POSTs to the wait list on every run.
- **PR body:** added a "Review notes" section explaining the screenshots, where the header comes from, why only one Caddy route forwards it, and why the wait-list probe is in this PR.

**Not addressed (should-fix items, left for the next panel or a follow-up):**
- **401/403 from the recovery route (assessor #3):** it still shows the "temporarily unavailable" card. A redirect back to sign-in risks a redirect loop, so I didn't add one.
- **Wait-list probe:** it stays in this PR and is now documented rather than split out. Nobody has yet checked whether the probe's signup sends any email or notification.
- **Breaker comment-only items:** the 4xx `error` text rendering and the undocumented failure-over-guest case when a stored guest gets a transient 5xx were not looked at.

**Environment problem:** `ensure-project-worktree.sh` failed with a read-only file system error (the known monk-sandbox issue), so I worked in a clone under `$TMPDIR` instead.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2903037 cached reads)
- Output: 13024 tokens
- Cost: $1.5271114000000001
- Wall-clock: 4368s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
