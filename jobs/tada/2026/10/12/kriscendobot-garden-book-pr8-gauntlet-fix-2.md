Fix round 2 for kriscendobot/garden-book#8 is done: the panel's must-fix is applied and pushed, and the CI check passed.

**Panel's must-fix (pruner seat)**
- **PR body trimmed** from about 1,000 words to 298. It now covers the editorial strategy, what the new `editorial/reader-exposure-map.md` file is and why it can't become a book page, and four items that need the maintainer's call (the old five minus the accountant item, which round 1 already fixed). I removed the chapter-by-chapter tour.
- **"Likely conflicts" note removed.** It asked for no action, and #8 is now the only open PR in the repo.

**Pruner's lifecycle question (finding 3)**
- New commit `b044f89` adds a sentence to the "Open items" section of the exposure map saying it is a living ledger: each pass adds what it left for a later call and removes what it settled. It is not a list of unfinished work in the book.

**Push and CI**
- `safe-push-pr-head.sh` moved the PR head from `8304543` to `b044f89` as a fast-forward.
- The repo has no Actions workflows, and no commit on the PR has ever had a check. I therefore ran `ci-wait-merge.sh kriscendobot/garden-book 8 --no-merge` with `GARDEN_CI_ALLOW_NO_CHECKS=1`. It returned rc 0 (green, no checks). `npm test` in the project checkout passes 21/21.
- The first `ci-wait-merge` run, without that flag, waited on checks that never attach. It ran in the background and was stopped when the earlier session ended, so it changed nothing.

**Not changed (comment-only items):**
- The corner-prober seat asked for a source for the "5M-token cap" figure in ch8 § 8.3. The ch8 intro already links `designs/cybernetics-audit.md`, so I added nothing.
- The same seat flagged lines that don't wrap at the chapter's usual width; those are cosmetic and still as they were.

**Follow-up:** the job's own CI step fails on repos with no CI. Run without `GARDEN_CI_ALLOW_NO_CHECKS=1`, `ci-wait-merge` waits the full hour and returns still-pending on garden-book. The gauntlet driver should set that flag for this repo.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (143121 cached reads)
- Output: 958 tokens
- Cost: $0.8170026000000001 (1 engagement(s) unpriced)
- Wall-clock: 678s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
