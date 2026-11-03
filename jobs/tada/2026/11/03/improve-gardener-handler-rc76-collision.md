---
handed-off: improve-gardener-handler-rc76-collision-split
deliverable-complete: false
---
The fix is not landed yet. As the split protocol requires, I stopped implementing and handed the remaining work to a single child job. The patch is written but uncommitted, and it's stored in full in that child's job body, because this worktree gets torn down.

**Split decision: indivisible, with a 7200s timeout.** What remains is one patch whose helper, return-code (rc) constant and tests only pass together. The 2400s overrun came from test suites running long on a loaded host, not from the size of the work.

**Posted to `journal2` and checked on a fresh clone:**
- **Child job:** `improve-gardener-handler-rc76-collision-expanded-window` is parked with `gate: orchestrated`, and `handler-timeout: 7200` and the reason are both set. The patch in its body matches the worktree diff byte for byte.
- **Orchestration:** `improve-gardener-handler-rc76-collision-split` is serial with one child and halts on failure, and it records the same reason and timeout.

**The job's premise is wrong:** complete-job's rc=76 never collided with anything.
- **Handler status:** the weave handler exited 0 with its completion signal.
- **Where the 76 came from:** `review-docket.sh` exits 76 when it spools an upsert instead of committing it (`GARDEN_REVIEW_DOCKET_SPOOLED_RC`). Here that upsert was the stale-panel notice.
- **What went wrong:** `gardener.sh` treated that durable spool as a failure and threw away a finished job's report. The retry then died at rc=75 after 18s (cause unknown, no capture kept), and the job was doomed.
- **Frequency:** this accounts for 6 of the 10 completion-step failures on oros from Oct 25 to Nov 3. A seventh rc=76, from the fixer re-entry path, was fixed separately by `d45a2d77f58`.

**What the patch does:**
- **Notices:** a spooled docket request now counts as landed in the stale-panel and draft-guardrail notices, matching the fixer path. The report says the action is spooled rather than received.
- **Constant:** the spool rc is now defined once, in `common.sh`, and the literal 76 is gone from `gardener.sh`.
- **Failure records:** they now say when the handler exited 0 and a later completion step set the rc.
- **Not renumbered:** the job's alternative of a distinct rc would fix nothing, because `crc` and `hrc` are compared separately and nothing was misrouted.
- **No head-SHA check:** no expected SHA is recorded anywhere, and a pushed head doesn't prove the job finished, so this check risks false completions. The worker's own completion signal is the stronger check, and it was present in this incident. This departs from what the job asked for, so the job owner may want to review it.

**Test status:**

| Suite | Result |
|---|---|
| `panel-head-freshness-completion-test.sh` | Passes; fails with `gardener.sh` reverted, so it catches the bug |
| `draft-guardrail-terminalization-test.sh` | Passes; fails with `gardener.sh` reverted, so it catches the bug |
| `fixer-docket-spooled-completion-test.sh` | Passes |
| `completion-signal-test.sh` | Inconclusive: 28 passes and no failures, then killed at the 1500s timeout |
| `review-docket-test.sh` | Failed once with `a hung push was not bounded per attempt`; host load is only a guess |

The child must resolve the last two suites before landing, and must not land the patch if it turns out to be the cause. The `claude-md-inventory-drift` gate also fired during a `scripts/checks/run-all.sh` run, which launched a nested `claude -p`. The child will use `--dry-run` only and check whether the gate also fires without the patch.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gardener-handler-rc76-collision.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 10 tokens (804827 cached reads)
- Output: 7518 tokens
- Cost: $2.3403646000000005 (1 engagement(s) unpriced)
- Wall-clock: 3210s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
