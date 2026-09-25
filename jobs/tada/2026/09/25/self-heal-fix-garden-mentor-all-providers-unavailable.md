**Completion report: self-heal-fix-garden-mentor-all-providers-unavailable**

When every mentor provider is unavailable, `garden-mentor` now logs a transient outage and exits 0 instead of dying. The fix is pushed to `main2` as `7bc429da759`.

**Background:** the commit just before this job, `ce8eecf4c47`, already made the "is at high water" / "at its high-water mark" lines count as transient, so the exact failure in the job was already handled at HEAD. That commit did not cover a tick where the providers failed for other reasons, such as the local-inference curl connect failure with no high-water line. That case still fell through to `die`.

**What I changed:**
- **`scripts/jobs/mentor.sh`:** the transient branch now also matches mentor-claude.sh's own FATAL text, `no configured mentor inference provider was available`. When it appears, the tick calls `note_transient_outage` and exits 0, leaves the input markers in place, and retries next tick. I put the check in `mentor.sh` rather than the shared `is_transient_claude_signature`. The gardener uses that shared check too, and its test deliberately says a bare no-provider death is a real failure, so I left it alone.
- **`scripts/jobs/test/mentor-transient-backoff-test.sh`:** new test case. The handler prints a local curl connect failure, the per-provider "unavailable" lines and the all-providers FATAL. The test checks that `mentor.sh` exits 0, logs a transient outage, and does not advance the seen marker.

**Tests:**
- `mentor-transient-backoff-test.sh`, `mentor-rejection-backstop-test.sh` and `mentor-provider-order-test.sh` (40/40) all pass.
- `claude-session-limit-classifier-test.sh` shows 42 passed and 5 failed, and the result is the same with my change reverted. The failing subtests are the gardener/session-cap ones, which `mentor.sh` doesn't touch.

**Follow-ups:**
- **Tradeoff to decide on:** a permanent setup problem where every provider looks unavailable (for example, `claude` not on PATH and the OpenAI source not mapped) is now treated as an outage. The mentor will retry quietly forever, with backed-off warnings but no escalation to the maintainer. If that matters, `note_transient_outage` could alert the maintainer after N ticks in a row.
- The 5 classifier-test failures above need their own look.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-all-providers-unavailable.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (545106 cached reads)
- Output: 5480 tokens
- Cost: $0.6548612
- Wall-clock: 96s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
