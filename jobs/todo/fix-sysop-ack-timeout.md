---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: sysop applies ops but its ack/record write can't finish within SELF_HEAL_HANDLER_TIMEOUT, so the leader re-sends forever

Repo: kriscendobot/garden, branch main2 (direct push, no PR).

## What happened (host oros-studio-garden-ce242c49, 2026-10-08)
1. **Head-of-line block.** A `restore` op (msgid 20261003T060846Z-c94b33) runs reaper.sh synchronously. On a follower, the reaper lost push races until GARDEN_REAP_PUSH_ATTEMPTS ran out (~9.5 min), so the op failed. self-heal-run then killed the sysop at SELF_HEAL_HANDLER_TIMEOUT=600 s before it could record or ack. The same message was retried every tick, and nothing behind it was processed. It cleared only after a temporary host-local drop-in raised the timeout to 840 s (~/.config/systemd/user/garden-sysop.service.d/zz-liaison-temp-timeout.conf).
2. **Slow acks.** write_sysop_log uses the shared producer clone. Each CAS retry does sync_clone → `git reset --hard origin/journal2`, which takes 26–53 s there (64,555-file worktree, 9 MB index). One tick handles 1–2 ops and then hits the 840 s cap, often after applying an op but before mark_seen or the ack lands.
3. **Echo flood.** The leader's budget leveler re-sends `set-workers count: 4` every ~15 min while no ack is seen. That produced 11 identical unacked ops, even though the value was already applied and monks=4 was running.

## Wanted
1. Run `restore`'s reaper and deadmail steps asynchronously, or with their own bounded budget, so one slow op cannot block the queue. Also decide whether the reaper should do fleet requeues when invoked on a follower.
2. Mark a message seen and ack it promptly after the apply (or record locally first and push in batches), so the handler timeout cannot drop a completed op.
3. Batch sysop-log writes per tick (one commit for N records), or use a sparse or lighter clone for these appends.
4. Leader side: do not re-send an identical set-workers while an unacked identical one is still pending, or let the sysop collapse duplicate idempotent ops.
5. When fixed, remove the temporary drop-in on oros-studio.
