**Completion report: self-heal-fix-reclone-clone-rc124-offline-classification**

I made no new commit because this fix is already on `origin/main2`. Commit `434d5402956` ("fix(common): treat reclone_clone rc=124/137 timeouts as a transient skip") landed about three hours before this job was claimed, and it covers the same failure (the `garden-comment-watcher@kriscendobot-garden` re-clone that crashed at the 45s timeout).

- **What the code does now:** `scripts/jobs/common.sh` `reclone_clone()` (lines 4303–4326) saves the return code from `bounded_clone`. It treats a failure as offline if the code is 124 or 137 (our own clone timeout killing the process) or if `_fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"` matches. In that case it logs, skips the tick and exits with `GARDEN_OFFLINE_RC` (75). This is the same check `sync_clone` uses, and a comment says the two must stay in step. Any other failure still exits 1 with the clone error.
- **Test result:** I ran `scripts/jobs/test/fetch-timeout-test.sh` and got 20 passed, 0 failed. Subtest 10 checks that return codes 124 and 137 with unrecognized stderr exit 75, and that a real clone failure still exits 1.
- **Follow-ups:** Hosts that crashed before the fix only pick it up after their next deploy of `main2`. If this crash comes back, check whether the host has deployed `434d5402956` before posting another fix job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-reclone-clone-rc124-offline-classification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158156 cached reads)
- Output: 997 tokens
- Cost: $0.38322720000000005
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
