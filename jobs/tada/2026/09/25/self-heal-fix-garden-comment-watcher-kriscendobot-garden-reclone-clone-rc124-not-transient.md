I fixed `reclone_clone()` so a clone that hits our own time limit now skips the tick cleanly instead of crashing the service. The fix is pushed to `main2` as commit `434d5402956`. The regression test passes, and I checked that it fails without the fix.

**What changed (`scripts/jobs/common.sh`)**
- **`reclone_clone()`:** it now records `bounded_clone`'s exit code. Its offline check is now `[ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline ...`, the same condition `sync_clone` uses. When that matches it logs "offline; skipping tick", including the clone's exit code, and exits with `$GARDEN_OFFLINE_RC` (75). A comment explains why and says the two conditions must stay in step.
- **`bounded_clone()`:** its timeout log line now also fires for rc=137 (the SIGKILL case) and prints the exit code. Before, it only logged rc=124.

**Test (`scripts/jobs/test/fetch-timeout-test.sh`, subtest 10)**
- New cases use a fake `git clone` that prints the observed "Clone succeeded, but checkout failed." message and exits 124, then 137. `ensure_clone` must exit 75 in both.
- Against the old `common.sh` both cases fail (exit 1). With the fix, the whole suite passes, including the existing check that a real repository error still exits 1.

**Behaviour change for inbox-read:** `scripts/jobs/inbox-read.sh` already skips the drain when the clone exits 75. So on a clone timeout it now skips the drain right away instead of retrying up to 3 times and then crashing. This matches how it already handles other network outages.

**Follow-ups:** none. Every caller of `ensure_clone`/`reclone_clone` picks this up on the next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-garden-reclone-clone-rc124-not-transient.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (524084 cached reads)
- Output: 5234 tokens
- Cost: $0.6361367999999998
- Wall-clock: 84s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
