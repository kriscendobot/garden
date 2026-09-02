once: 2026-09-07T22:24:14Z
job_basename_prefix: restore-cleric-quota-throttle
---
---
tier: minion
fallback-tier: minion
dispatch: automatic
---
Restore the `cleric` (codex/OpenAI) worker pool that was throttled to 0 fleet-wide
on 2026-09-02 while codex's own account quota was exhausted. The maintainer's
stated reset is now due.

Do exactly this, from the garden root:

1. `scripts/jobs/send-host-op.sh endolin-garden-ece02cb4 op=set-workers kind=cleric count=3`
2. `scripts/jobs/send-host-op.sh endolin-garden2-5bcdff64 op=set-workers kind=cleric count=2`

Both are ordinary (non-destructive) sysop ops — no `authorized_by` needed. Send
both regardless of which host claims this job; each target host's own sysop
applies the op locally. After sending, confirm each host's `hosts/<host>` file on
the journal now reads `clerics: 3` / `clerics: 2` respectively (fetch/pull the
journal and check, or read the `sysop-log/<host>/` entry for the message id each
send prints) before completing.

If either send fails outright (not merely slow to ack), report the failure in the
completion body rather than silently leaving a host at `clerics: 0`; do not retry
indefinitely.

Context: the maintainer asked (2026-09-02, liaison session) to throttle codex to
zero "until the quota reset in five days and an hour" from 2026-09-02T21:19 UTC;
this one-time scheduled job is that restore.
