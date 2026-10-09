**Completion report: fix-sysop-ack-timeout**

Fixed and pushed to `main2` as `96a2b4c6141`. `scripts/jobs/test/sysop-test.sh` now passes 59/0, and the existing budget-level test still passes. I have not run the new code on a real follower; it reaches oros-studio with the next rolling deploy. The temporary drop-in there is still in place and needs a manual step (item 5).

What changed, by item in the job:

1. **One slow `restore` no longer blocks the queue** (`scripts/jobs/sysop.sh`):
   - The reaper and deadmail steps each get their own time limit, `GARDEN_SYSOP_RESTORE_STEP_TIMEOUT` (default 150 s).
   - The reaper gets only a few push attempts, `GARDEN_SYSOP_RESTORE_REAP_ATTEMPTS=3`. My decision on the follower question: the leader's own reaper is responsible for fleet requeues. A follower's `restore` only tries briefly and gives up when it loses push races; it does not retry for ~9.5 minutes as before.
   - If a step times out, the op is recorded and acked as `failed`. The queue keeps moving.
2. **A completed op is marked seen right after it is applied.** Its record and ack details are first saved locally in a new folder, `$GARDEN_STATE/sysop/pending` (`spool_result`). If the handler timeout kills a tick, the next tick sends the saved records and acks first (`flush_pending`) and does not re-run the op. A message that already has a saved local record is skipped as seen.
3. **Records are written in batches:** all of a tick's sysop-log records go into one journal commit, so the slow sync runs once per push attempt rather than once per op. Acks are sent after that commit. The deploy, local-model and maintain paths still write their records directly, as before.
4. **Leader side** (`scripts/jobs/budget-level.sh`): a new check, `pending_identical_set_workers`, stops the budget leveler from sending a `set-workers` op when an identical one (same kind and count) is still on the bus with no sysop-log record for it. This stops the flood of 11 identical ops.

**Tests:** I added two regressions to `sysop-test.sh`:
- a hung reaper is cut off by the time limit, deadmail still runs, and the op is acked `failed`;
- a record saved by a killed tick is committed and acked on the next tick, and the op is not run again.

I also fixed three existing failures in that file: it expected the worker kind `gardener` where the code now uses `monk`.

**Follow-up:**
- **Item 5 (temporary drop-in on oros-studio):** I can't do this from endolin, and no sysop op can remove a drop-in remotely. I sent the maintainer inbox the command to run on oros-studio-garden-ce242c49 once it has deployed `96a2b4c6141`: `rm ~/.config/systemd/user/garden-sysop.service.d/zz-liaison-temp-timeout.conf && systemctl --user daemon-reload`.
- `designs/sysop.md` does not yet describe the local record folder or the batched writes; that would be an optional docs update.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-sysop-ack-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1257221 cached reads)
- Output: 12264 tokens
- Cost: $1.0424681999999998
- Wall-clock: 354s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
