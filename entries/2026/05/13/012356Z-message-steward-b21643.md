---
ts: 2026-05-13T01:23:56Z
kind: message
role: steward
project: garden
subject_matter:
  - monitor-poll
  - deployment-bug
to: liaison
---

# Bug in `scripts/monitor-poll.sh`: silently drops every comment / review event after the first batch with a Push

The maintainer flagged that I missed
endojs/endo-but-for-bots#109#issuecomment-4436075344 (kriskowal,
2026-05-13T00:54:05Z, grants `kriscendobot` write access to a fork
and constrains how to use it). Diagnostic trace below; the missed
comment is also surfaced separately in the bulletin and in the
companion entry `012356Z-result-steward-da0309.md`.

## Symptom

All four repo-monitor daemons (`endojs/endo`, `endojs/endo-but-for-bots`,
`agoric/agoric-sdk`, `dcfoundation/cosmos-proposal-builder`) have
written *nothing* to their stdout logs since the startup batch at
2026-05-12T23:35:07Z, even though substantial maintainer + contributor
activity has happened on each in the intervening ~2 hours. The
daemon stderr does receive per-event detail; the bug is specifically
the `print(f"[{ts}] NEW {len(events)} on {repo}: ...")` line never
firing.

Concretely, on the `endo-but-for-bots` cache directory at
`worktrees/endojs-endo-but-for-bots/watch-...--monitor--20260512-233307/.garden-monitor/endojs-endo-but-for-bots/`:

- `etag.txt` ctime is 00:54:05 (so the daemon IS polling and IS
  getting 200 OK with fresh events).
- `last_event_id.txt` is still `11774819337`, set at startup.

## Root cause

GitHub `events` API IDs are not monotonic across types:

| Event type family | ID range |
|---|---|
| `IssueCommentEvent`, `PullRequestReviewEvent`, `PullRequestReviewCommentEvent`, `PullRequestEvent`, `IssuesEvent` | 9.3 to 9.4 billion |
| `PushEvent`, `CreateEvent`, `DeleteEvent`, `ForkEvent` | 11.7 billion and up |

The daemon's filter at line ~82 of `scripts/monitor-poll.sh`:

```python
events = [e for e in events if int(e['id']) > last_id]
...
max_id = max(int(e['id']) for e in events)
```

stores the single maximum ID seen across all types. If any Push or
Create event lands in the page (very common; pushes are frequent),
the cursor jumps into the 11.7 B range, and every subsequent
IssueComment or Review event arrives with an ID in the 9.3 B range
and is filtered as "already seen". Pushes themselves keep advancing
the cursor and keep getting through; comment-class events silently
disappear.

The bug is dormant only on a quiet repo with no pushes. On any
repo with a mix of push and comment activity, the daemon's stdout
becomes useless within minutes of a single Push.

## Fix options

Three reasonable shapes, listed by intrusiveness:

1. **Per-type cursor.** Replace `last_event_id.txt` with
   `last_event_id-<type>.txt` and track a max per event type.
   Filter is `id > last[event.type]`. Pros: minimal diff, accurate
   filtering. Cons: now N cursors per repo, slightly more state to
   manage.

2. **Created-at cursor.** Use `created_at` rather than `id` for
   ordering. Filter is `created_at > last_created_at`. Pros: single
   cursor; semantically clearer. Cons: `created_at` is only
   second-resolution; two events in the same second on a busy repo
   could collide. Mitigation: combine with `id` as a tiebreaker
   within a `created_at` value.

3. **Bounded seen-set.** Track a rolling window of seen IDs (say
   the last 200) in the state file. Filter is `id not in seen`.
   Pros: handles non-monotonicity by construction without needing
   to model the ID structure. Cons: more state per poll, more I/O.

Recommend **option 2 with id tiebreaker** as the simplest correct
fix. The patch is single-digit lines in the Python block of
`monitor-poll.sh` plus a one-time migration of the state file.

## Stopgap until the patch lands

The steward will manually poll the four repos' events feeds at
each cycle's survey step (in addition to reading the daemon logs,
which currently contribute nothing), using a `created_at`-cutoff
filter against the prior cycle's close timestamp. This is exactly
the work the daemon is supposed to obviate, so it should be
short-lived. Adding to my cycle-survey checklist for now.

This is not the deployment-bug surplus-authority case
(`roles/steward/AGENT.md` § Authority enforcement); the steward
has the right authority bounds, the operational infrastructure
just has a bug. So I do not stop work; I work around it.

## Self-improvement

Today's lesson: when arming a Monitor that filters daemon logs,
verify with a probe that the underlying daemon actually emits the
target signal before relying on it. The Monitor `brfryz067` is
correctly listening; the daemon below it just doesn't speak.
Adding to the field notes for `skills/autonomous-loop-pacing/SKILL.md`
or wherever monitor-arming gets a recurring discipline.

Self-improvement: nothing for `roles/steward/AGENT.md`; this is a
script bug, not a role gap.
