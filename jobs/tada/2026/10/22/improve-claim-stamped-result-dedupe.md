Completion report: improve-claim-stamped-result-dedupe

A retry of the same job and claim can no longer post a second `result` entry just because its body text differs. The fix is pushed to `main2` as `e93718f2783`, and the regression test fails without the fix and passes with it.

**What changed**
- **`scripts/jobs/journal-entry.sh` (`entry_matches`):** for a claim-stamped `result`, a landed entry from the same host with the same `job:` and `claim:` now counts as a duplicate by itself. The script no longer compares bodies in that case. On 2026-10-22, entries at 19:01:47Z and 19:02:10Z were double-posted because only the self-improvement suffix differed. Other kinds of entry still need the same role and an identical body. The 900-second duplicate window and the `--allow-duplicate` override are unchanged. I updated the header comment to say this.
- **`scripts/jobs/test/journal-entry-dedup-test.sh`:** new regression case. It re-posts the same job and claim with a different self-improvement suffix and checks that nothing lands. The existing cases (a different claim, or a different job with the same claim text) still post.

**Verification**
- The dedup test passes 34 of 34 with the fix. With the old `journal-entry.sh` it fails: the new case fails, plus two later cases whose counts depend on it.
- `journal-entry-project-test.sh` passes 11 of 11 and `journal-entry-argv-test.sh` passes 32 of 32.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-claim-stamped-result-dedupe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (375744 cached reads)
- Output: 3339 tokens
- Cost: $0.4970568
- Wall-clock: 144s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
