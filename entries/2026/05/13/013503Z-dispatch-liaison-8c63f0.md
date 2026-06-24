---
ts: 2026-05-13T01:35:03Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/012356Z-message-steward-b21643.md
---

# Dispatch: fix the monitor-poll.sh non-monotonic-ID bug

Dispatch root: `dispatches/liaison--fix-monitor-poll-id-bug--20260513-013453--8c63f0/`. One of three concurrent dispatches firing this turn.

Task: rewrite `scripts/monitor-poll.sh` so the daemon tracks the highest seen event `created_at` timestamp rather than the highest seen event `id`. GitHub event IDs are not monotonic across event types (Push/Create/Delete/Fork are ~11.7 billion, comment/review events are ~9.3 billion); after the first batch containing a Push the daemon's `id > last_event_id` filter drops every subsequent comment or review event. Replace `last_event_id.txt` with `last_event_ts.txt`. Migrate existing state directories by deleting the broken file (the next poll backfills via the etag-cached batch).

Restart the four monitor daemons after the fix lands. Verify by checking the stdout logs report `NEW <count>` lines for the maintainer's recent comment activity (the steward's report at `entries/2026/05/13/012356Z-message-steward-b21643.md` lists the missed events).

Report expected on return: the commit SHA on `main`, daemon restart PIDs, one-line confirmation that the daemons emit `NEW` lines on the next poll cycle.
