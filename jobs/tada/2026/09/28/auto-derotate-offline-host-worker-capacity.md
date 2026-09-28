I built the automation and pushed it to `main2` as `7438d06ba1f`. oros-studio's row is **still `0 0`**: I neither restored it nor marked it for auto-restore, because its heartbeat never actually went quiet.

**Why oros-studio wasn't restored or marked.** Its `budget/live` heartbeat has kept publishing every ~15 minutes: at my last check it was 564 seconds old, with spend flat at 447868. It also answered sysop ops as recently as 14:20Z. By the liveness signal the job said to reuse, it is PRESENT; what stopped is its job claims, and its deploy canary is stuck. Neither of the job's two options fit:
- Option (a), writing a "prior value was `4 0`" marker, would have restored it on the very next tick.
- Option (b), restoring it now, would have undone your zero while it still isn't claiming.

So I left it as an operator zero, which the mechanism never touches. I asked you about this via message-user at 14:35Z and polled my inbox for about 20 minutes with no reply. Once oros-studio is fixed, either of these puts it back:
- `scripts/jobs/worker-derotate.sh adopt oros-studio-garden-ce242c49 4 0`: the next fresh heartbeat restores `4 0`, which with its current heartbeat means the next tick.
- Setting the row by hand.

**What it does.** `scripts/jobs/worker-derotate.sh` is deterministic and leader-only. It runs inside the scheduler's existing 15-minute leader tick, just before `budget-level.sh`, so leveling sees the updated caps; there is no new timer. It never touches `hosts/<host>`.
- **Liveness:** I moved `host_heartbeat_epoch` from `rolling-deploy.sh` into `common.sh`, next to a new `host_liveness`, and rolling-deploy now calls the shared version. Both rotations use the same `GARDEN_HOST_OFFLINE_AFTER` test.
- **Going offline:** a host seen offline on 2 ticks in a row (so one late sample doesn't cause churn) has its row set to `0 0`. The same journal commit writes `worker-derotate/<host>` recording the reason and the exact prior caps. I put this record in the journal, not host-local state, so a leader handoff doesn't lose it.
- **Coming back:** it restores only rows that have that record and are still `0 0`. It restores the saved values exactly and deletes the record.
- **Rows it leaves alone:** a row someone zeroed by hand is never taken over. If someone changes a derotated row by hand, the record is dropped and their value stands.
- **Unclear readings:** a missing or unparseable heartbeat neither zeroes nor restores, and raises one notice. If the leader's own heartbeat looks stale, the whole tick freezes and says so.
- `budget-level.sh` now skips its usual "missing physical cap" freeze notice for a row this mechanism zeroed, so each outage produces one notice, not two.

**Notice dedup, before and after (from the test).** Offline tick 1 only confirms, with no change and no notice. Tick 2 zeroes the row and posts one `worker-derotate-<host>` notice. Three more ticks still leave the count at 1. A fresh heartbeat restores `4 0` and posts one `RECOVERED: heartbeat resumed for <host>…` on the same key. Two further present ticks post nothing. Before this change there was no notice at all, and the row sat at its cap until someone noticed by hand.

**A bug the new test caught.** The old heartbeat reader treated an empty `sampled_at:` as today's midnight (`date -d ""`), so a broken record could read as a fresh heartbeat. That affected rolling-deploy too; it's fixed in the shared helper.

**Tests:**
- The new `worker-derotate-test.sh` passes 16/16. It covers everything the job asked for, plus the takeover (`adopt`) command and a check that a follower host does nothing.
- `rolling-deploy` 100/0, `proportional-worker-leveling` 9/0 (one new case), and the 6 scheduler suites, set-worker-leveling, set-budget-pool and alert-maintainer-edge all pass.
- `live-budget-admission` picked up the new controller's notices in its alert sink; I turned derotation off in those scheduler runs. It still shows 3 failures, identical on unmodified `main2`.
- `kimi-credit-exhaustion-routing` fails 4/5, also identically on unmodified `main2`.

**Follow-ups:**
- A host that keeps heartbeating but doesn't claim (drained, stuck workers, a stuck deploy) still keeps its allocation. That is oros-studio right now, and I recorded it as the remaining known gap in `context/operations/cybernetics.md`. Closing it would need a signal based on claims.
- Two pre-existing test failures predate this change: `kimi-credit-exhaustion-routing` (4 of 5 checks) and `live-budget-admission` (3).
- `inbox-read.sh` timed out every time on its cold journal clone, so I read my inbox directly from `origin/journal2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/auto-derotate-offline-host-worker-capacity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (5895538 cached reads)
- Output: 44179 tokens
- Cost: $3.2663436
- Wall-clock: 1920s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
