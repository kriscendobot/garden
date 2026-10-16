---
handed-off: improve-comment-source-timeout-not-fatal-split
deliverable-complete: false
---
I didn't land the fix on `main2`: this claim was reposted as a split, and the split protocol forbids continuing the implementation in it. The code is finished and saved, and one parked child job will land it.

**State of the work**
- The fix is one commit, `c211fbfc29a`, on the side branch `wip/improve-comment-source-timeout-not-fatal` on origin.
  - **`common.sh`:** `gh_api_retry`, `gh_read_retry` and `gh_pr_view_retry` now treat the gh wrapper's timeout exit codes (124 and 137, which come with no error text) as transient. They retry once with backoff. If the retry also times out they log a WARN carrying a `gh-call-timeout` marker, never the "definitive" one.
  - **`handlers/comment-source-gh.sh`:** the source now separates timeouts from real failures. If every failed fetch was a timeout, it exits 124. The watcher already handles that code: it logs a WARN, freezes the cursor, backs off only that repo, and exits 0, so the unit no longer fails. A timeout combined with a real failure still exits 1 and fails loudly.
  - **`comment-watcher.sh`:** comment update only.
- **Tests:**
  - `gh-api-retry-test.sh`: all 68 pass, including the new timeout cases.
  - `comment-watcher-test.sh`: the 3 new inner-timeout cases pass. The full suite never finished: my background runs were killed by their time limits, so I have no final total.
  - Two fan-out tests fail on their own 5-second deadline. Base and new code both take about 4.6s for that scenario on this host, so this is host speed, not this change.
  - `triager-test.sh` has 2 failures in 1-second tick-deadline timing checks. They don't touch the code I changed, but I didn't run them against the base code to confirm they also fail there.

**The split**
- I judged the work indivisible: what's left is one serial cherry-pick, re-test and push, and `comment-watcher-test.sh` alone runs more than 10 minutes on oros-studio.
- I parked one child, `improve-comment-source-timeout-not-fatal-expanded-window`, with a 5400s timeout and that reason recorded. Its body gives the steps: cherry-pick `c211fbfc29a` onto `main2`, re-run both test suites in the foreground, push, then delete the side branch.
- I recorded the serial orchestration `improve-comment-source-timeout-not-fatal-split` over that child; the record landed after three lost push races.

**Follow-up:** the side branch should be deleted once the child lands the commit; the child's steps include this.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-timeout-not-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (551395 cached reads)
- Output: 3901 tokens
- Cost: $3.4617652 (1 engagement(s) unpriced)
- Wall-clock: 2740s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
