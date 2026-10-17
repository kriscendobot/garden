Fix round 1 for kriscendobot/garden-book#16 is done. Both must-fix items from the panel are applied and pushed, and the CI wait returned green (rc 0). That green comes from passing `GARDEN_CI_ALLOW_NO_CHECKS=1`, because the repo has no CI at all.

**What changed**, in follow-up commit `9c98898`, pushed with `safe-push-pr-head.sh` (fe9ece3 → 9c98898):
1. **corner-prober:** `build/render-book.mjs` now fills `{{PROVENANCE}}` with a function replacer (`() => table`). Before, a `$&` or `$$` in a chapter title or its metadata would have been rewritten. The colophon test in `test/units.test.mjs` now uses a chapter titled `Chapter 2: Costs: $$ and $&` with author `gardener $$ $&`, and checks that both come out unchanged.
2. **pruner:**
   - Deleted the comment at `build/render-book.mjs:458-459` that described the change rather than the code.
   - Cut the "grounded on" clause from `build/colophon.html:15`, since the table below it already has that column.
   - Shortened the provenance sentence in `build/README.md` to "Each chapter's provenance is a row of the colophon's table."
   - Rewrote the PR body from 758 to about 250 words. The "Moved" table and the test tally are gone. I kept the authorization line, the orchestration-merge sentence, the three left-in-place items, and the title-page question for the maintainer.

**Verification:** `npm test` passes locally (85 pass, 0 fail, 1 skipped).

**CI:** without the opt-in, `ci-wait-merge.sh` keeps waiting for checks until its deadline and then reports still-pending, so the driver would re-post this stage forever. I added the opt-in because the repo has no `.github/workflows` and its merged PRs #13–#15 also have zero checks.

**Follow-ups:**
- The driver should pass `GARDEN_CI_ALLOW_NO_CHECKS=1` for garden-book in later stages, or they will stall the same way.
- corner-prober's other findings were marked as summary-level, not must-fix, and I did not address them: empty provenance cells, zero chapters or a missing placeholder, `h3` headings containing markup, links to the colophon that break when there is no colophon, and ordering across multiple chapters.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr16-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1383510 cached reads)
- Output: 6772 tokens
- Cost: $0.93099
- Wall-clock: 709s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
