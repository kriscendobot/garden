The clean stage for kriscendobot/garden-book PR #8 is done with no changes: there was nothing to run coverage on, and the CI wait passed only because the repository has no CI at all.

- **PR state:** open, draft, mergeable, head `2d0cc322d6c`, base `main-e6f2790`.
- **Coverage and dead code:** the PR only touches prose — nine `chapters/ch*.md` files plus a new `editorial/reader-exposure-map.md`. There is no code, so the coverage pass has nothing to cover and nothing can be orphaned. I made no edits, pushed nothing, and didn't create a project checkout.
- **CI:** the repository has no `.github/workflows`, and the head commit has 0 check runs and 0 statuses. My first `ci-wait-merge.sh --no-merge` run waited the full 600s on the empty check list, which it treats as pending by default. I reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, the script's own setting for repos with no checks. It returned `total=0 failed=0 → CI GREEN`, rc 0.

**Follow-up:** every later gauntlet stage on this repo will hit the same empty-checks wait unless `GARDEN_CI_ALLOW_NO_CHECKS=1` is set. Consider having the gauntlet set it automatically for repos with no workflows, or adding a small CI workflow to `garden-book`.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (339429 cached reads)
- Output: 1958 tokens
- Cost: $0.46946979999999994
- Wall-clock: 626s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
