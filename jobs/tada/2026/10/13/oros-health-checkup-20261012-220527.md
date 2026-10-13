**Verdict: degraded, now fixed.** oros is deployed and its pushes are landing again. One leftover (the sysop ack backlog) clears at oros's next self-deploy.

**What I found (2026-10-12, 22:58–23:45Z)**
- **Pushes kept failing:** every journal completion and inbox read from oros failed on every retry.
  - One completion reached attempt 26 over 55 minutes, and one inbox read reached attempt 39 over 89 minutes.
  - Two monks sat stuck for an hour in a graceful restart after the deploy.
- **Root cause:** each retry first reset a working copy of the whole journal (about 68k files) and tried to deepen it from the shallow root repo. That took about 90 seconds, so by the time the push went out, other hosts had already moved the journal on.
  - The deepen can never finish, because the root repo is itself shallow at `1fa90b4f`. It still logged "completed" on every sync.
- **Stale deploy record:** the 21:53 deploy of `0411ed9f` itself worked. But the old process's "deployed" record lost every push until its 2400s timeout, and the idle ticks after it never republish. The leader kept seeing "roll-drained @ f9b279f6".

**What I changed**
- I republished oros's fleet/health record as "deployed @ 0411ed9f" (it landed in 47s).
- `bdc2943c` on main2: after a failed push, `commit_and_push` can now redo the commit on top of the latest journal without touching the working copy (`journal_replay_head`).
  - It refuses if a peer changed any of the same paths.
  - It is opt-in, because callers that check the journal before writing (dedups, claims) must re-read it after every failed push. The first draft had it on for everyone, and the post-gauntlet dedup test caught that.
  - `complete-job` and `inbox-read` opt in, since every path they write belongs to their own job.
  - The pointless deepen is now skipped once the clone already matches the root's shallow history.
  - New test `commit-replay-test.sh` fails on the old code and passes on the new.
  - fleet-health-publish, land-journal-edit, sync-clone-reset-retry, seed-from-root, post-gauntlet-dedup, cursor-set and the budget-snapshot tests pass.
  - Four suites fail: budget-live-percent-label, foreman-edge-kick, outage-doom-pause and repo-locks. They fail the same way on unmodified origin/main2.
  - completion-signal timed out under host load: 20 checks passed and none failed before the limit.

**After the requeue (2026-10-13, about 05:00Z)**
- **Deployed:** self-deploy put `bdc2943c` on oros at 04:02, and fleet/health reads "deployed @ bdc2943c".
  - All 8 monks are running, no units have failed, and the host is not drained.
  - Load is 3.6, disk is at 51%, and inodes at 1%.
  - The claude-oros budget record updates every 15 minutes: spend 59.0M of 180M, status ok.
  - Since the deploy there have been no failed-push retries, and one inbox read landed on its first replay.
  - There were 29 timeouts (rc=124) in the last 3 hours.
- **Sysop wedged:** every sysop run hit its 600s timeout, and 10 replies have been waiting to go out since 22:31Z. They go through `send-msg.sh` on the same contended clone, and since 05:11Z the sysop also failed to start or hit its timeout.
  - `855ba4b6` on main2 opts `send-msg` into the replay too, since each message is added at its own unique path. sysop-test passes 62/62. It takes effect at oros's next self-deploy.
- **Health log:** the entry plus an addendum are in `projects/garden/oros-health-log.md`.
  - `land-journal-edit.sh` timed out twice waiting for the busy shared clone (its holder was live, not stale), so I wrote the entry directly with the same no-working-copy method.
  - My first write put it between the watcher's newer 05:05Z entry and that entry's heading; I fixed the order in a second write.

**Still open (maintainer)**
- The idle self-deploy tick should republish a fleet/health record that disagrees with the deployed sha. This is the second time I've fixed it by hand; it's a follow-up I didn't post as a job.
- Other writers that check the journal before writing (`post-job`, `land-journal-edit`, `inbox-send`) still pay the slow reset on the shared clone.
- The root repo is still shallow, and running `git fetch --unshallow` needs your decision.
- Nothing needs a person at the machine.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-220527.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 48 tokens (3177993 cached reads)
- Output: 11915 tokens
- Cost: $4.5005826 (1 engagement(s) unpriced)
- Wall-clock: 5725s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
