## Completion report: improve-mentor-paused-project-posting

The mentor handler no longer fails when `post-job.sh` refuses an improvement because its project is paused. The fix is pushed to `main2` as `95c94cd4340`.

**The defect:** the handler runs under `set -e`. When `post-job.sh` exited with `GARDEN_PAUSED_RC` (78) for a paused project, the whole handler stopped. That caused the mentor FATALs at 04:51:33 and 05:21:39 and dropped every JOB block after the refused one. The failure digest also stayed active, so self-heal could keep re-firing on it.

**What changed:**
- **`scripts/jobs/handlers/mentor-claude.sh`** (the posting loop): the handler now checks the exit code of each post.
  - **Paused project (rc 78):** it logs the skip once for that block and moves on to the remaining blocks. `post-job.sh` already sends the maintainer one combined pause notice per project, so the handler adds no alert of its own. If any blocks were skipped, it logs one summary line at the end. It then exits 0.
  - **Any other posting failure:** it still stops, now with a `FATAL` log line, and exits with that same code.
- **`scripts/jobs/test/mentor-provider-order-test.sh`**: new subtest 27. It writes a pause record into the test journal, then feeds the handler one JOB block for the paused project and one ordinary block. It checks that:
  - the handler exits 0;
  - the paused job is not posted;
  - the later job is posted;
  - the skip is logged exactly once;
  - no FATAL is logged.

**Verification:** the full test file passes (59 passed, 0 failed). With the old handler swapped back in, subtest 27 fails three of its checks (exit code 78, later block dropped, no skip log line), so the test does catch the bug.

**Follow-ups:** the FATALs will keep appearing until the root checkout is deployed past `95c94cd4340`. After that, the stale self-heal digest should clear by itself.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-mentor-paused-project-posting.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (731558 cached reads)
- Output: 5385 tokens
- Cost: $0.7460035999999999
- Wall-clock: 170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
