Retro for #1125: I recorded this as a **review miss**, not a dismissal. I also found and fixed a bug in the review-miss writer that was blocking the record.

**Verdict.** The comment is kriskowal's inline comment on #1125 at `formula-record.js`, 2026-09-12. Paraphrased: adding `planes` suggests a latent defect, so make sure there's test coverage. I checked the world rather than the primary job's claims:
- The primary found a real defect of the same kind. #1125 added the `planes`/`networks` references to the host and guest inspector records but still left out the host `registry` reference.
- The primary's fix commit (4ca79d80d) exists on the PR, and the `registry` reference is now on `llm`'s `formula-record.js`.
- Six panel rounds had cleared the PR without anyone checking the other references in that family.

That fits the existing `incomplete-sibling-transformation` cluster (a change fixes some members of a family of related code sites and misses another). The miss is recorded at `review-misses/misses/endojs-endo-but-for-bots-pr1125-aff3b059.md`: severity minor, `missed_by` breaker.

**Discrepancy.** An earlier retro (`pr1125-review-35c43da7`) dismissed this same inline comment as a new design direction. That call was made without the primary's finding that the defect was real. I left that record alone and wrote the finding into this record's grounds.

**Cluster and threshold.** The writer reported `count=5 prs=475,1099,1125 status=closed recurrence=0 drain_reopen=1`. The review came before the cluster's fix landed on 2026-09-17 (8107ace005), so the fix didn't fail here and nothing escalates. No new improvement job was posted: the cluster was already improved and closed.

**Writer bug, fixed and pushed to main2 (f5c8ccf55ae).** `scripts/jobs/review-miss-record.sh record` exited 1 with no output whenever a miss joined a closed cluster whose fix date couldn't be worked out. It should fall back to reopening the cluster instead. This will now happen routinely, for two reasons:
- Clusters name their fix by a main2 commit, and the journal-only clone the writer uses never has main2 commits.
- The 2026-09-23 journal history truncation removed the commits that marked when each fix was dispatched.

The function now always returns 0, and it looks up main2 commit dates through `gh api` on the garden repo. New subtest 12 covers both paths; the suite passes 52/52.

**Probe gap, closed on main2 (96afc615ee5).** The cluster's existing check (the `B-sibling-family` probe, which prompts the breaker juror) only knew three hard-coded file families. It would not have fired on #1125's diff. I added `packages/daemon/src/formula-record.js` as a known family and cited #1125 as an example in the breaker's brief. I also added a #1125 case to `sibling-family-probe-test.sh`, which passes 7/7.

**Follow-ups:**
- The fixed writer only takes effect on hosts once the deploy reaches f5c8ccf55ae. Until then, any retro that joins a closed cluster will fail the same way.
- Consider re-judging the 35c43da7 dismissal in light of this record.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-aff3b059-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 54 tokens (2039132 cached reads)
- Output: 14284 tokens
- Cost: $1.3901944000000002 (2 engagement(s) unpriced)
- Wall-clock: 196s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
