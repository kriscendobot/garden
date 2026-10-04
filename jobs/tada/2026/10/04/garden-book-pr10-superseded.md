I closed kriscendobot/garden-book#10 as superseded by #11, and left a comment on it pointing to #11. None of #10's art or build changes were merged.

**Overlap check:**
- **#11 is merged:** merge commit 636a80f, merged 2026-10-04T06:05Z. Its placement table, `build/illuminations.mjs` on `main`, places 25 `illumination-ch*.svg` plates.
- **#10's art set:** #10 adds 25 `illus-ch*.svg` files. Each one matches one of #11's plates by chapter and subject; for example, `illus-ch1-market` matches `illumination-ch1-bidding-market` and `illus-ch10-tiers` matches `illumination-ch10-inference-tiers`.
- **Not approved:** none of #10's filenames appear in `art/MANIFEST.md` or in the placement table, and there are no `illus-ch*` files on `main`.
- **Duplicate wiring:** #10 placed its art by editing `build/assemble-book.mjs`, `build/render-book.mjs` and `build/styles.css` directly, which repeats the placement that #11's table now does.

**Follow-up:** #10 also changed `art/title-garden.svg` (+31/−83), and that change is not in #11. The closing comment says that if the title-plate edit is still wanted, it should be proposed on its own against current `main`. Nothing else is needed for this job, and I made no commits to the garden repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-pr10-superseded.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158623 cached reads)
- Output: 1869 tokens
- Cost: $0.38371259999999996
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
