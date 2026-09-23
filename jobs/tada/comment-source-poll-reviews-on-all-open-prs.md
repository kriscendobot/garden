Work complete. Report follows.

---

## Completion report: `comment-source-poll-reviews-on-all-open-prs`

**Root cause confirmed and fixed.** `comment-source-gh.sh` section 3 enumerated open PRs with `gh pr list --state open --json number` (no `--limit`), which returns only gh's default **30 most-recent-by-number** open PRs. With endo-but-for-bots at 169 open PRs, every PR below the cutoff — including **#284** — was never polled for review bodies, so kriskowal's COMMENTED "Please refresh." review (4587189118) was silently lost.

**The fix** (commit `2ecd4ca49`, on `origin/main2`):
- Replaced `gh pr list` with the authoritative paginated REST list: `gh api repos/<r>/pulls?state=open&sort=updated&direction=desc&per_page=100 --paginate`, enumerating **all** open PRs sorted by most-recent activity.
- Added the recommended **activity bound**: stop iterating once a PR's `updated_at` predates the cursor `since` (any PR with new review/comment activity has a fresh `updated_at`, so all candidates sit at the top). Bounds per-tick work without dropping any PR with new activity.
- Captured the list to a variable first so the early-stop is a plain bash `break` (no SIGPIPE tripping pipefail on the paginating gh).
- **No silent cap:** the handler now `log`s "polled N of M open PR(s) … activity-bounded at since=…" to stderr (info-level; the watcher ignores a 0-exit source's stderr).

**Audit (same anti-pattern elsewhere):** clean. `mention-source-gh.sh` and `issue-source-gh.sh` already use paginated `gh api`; `comment-watcher.sh`'s `per_page=1` self-test and `mirror-closer-test.sh`'s `--head`-filtered list are bounded by construction. No other unbounded-default list gates which PRs/issues are surveilled.

**Tests:** Added **EE** to `comment-watcher-test.sh` — stubs >30 open PRs with a trusted body-only review on a low-numbered but recently-active PR (#284) and asserts the source emits its `pr-review-body` row, that the row is keyed on the review id, and that the scan-bound is logged. Regression-pins #284. The full suite is **95 passed / 0 failed**.

**Bonus fix (proactive):** Q and Z were *already failing on pristine main2 today* — a latent date-bomb: their hardcoded `2026-06-25` fixtures had drifted outside the handler's 24h `floor` clamp. I made the Q/Z/EE source-level fixtures time-relative (timestamps derived from `date`, injected via env into the gh stubs), so they no longer rot. This took the suite from a pre-existing 2-red to fully green.

**Live smoke test** against the real repo: the new paginated query worked, polled 7 of 8 open PRs (early-stopped past the older one, logged), and surfaced a `pr-review-body` row for **#284** — the previously-invisible PR.

**Follow-ups:** none. Worktrees torn down; inbox empty.
