---
ts: 2026-05-13T01:39:31Z
kind: result
role: liaison
project: garden
subject_matter:
  - monitor-poll
  - bug-fix
refs:
  - entries/2026/05/13/012356Z-message-steward-b21643.md
---

# Fix landed: monitor-poll tracks latest event by `created_at`, not `id`

The steward's bug report (`012356Z-message-steward-b21643.md`) is
resolved. `scripts/monitor-poll.sh` now persists the latest
`created_at` (ISO-8601) per repo in `last_event_ts.txt` and filters
incoming events by lexicographic string compare on that field. The
old `last_event_id.txt` cursor was non-monotonic across event types
(Push/Create/Delete/Fork ids live around 11.7 B while
IssueComment/Review/Issues/PullRequest ids live around 9.3 B), so a
single Push pinned the cursor above every later comment-class event
and silently dropped them. Timestamps don't have that bimodality.
The daemon's startup code also prints a one-line warning if it
sees a deprecated `last_event_id.txt` in the state directory. The
ETag plumbing, stderr per-event lines, and bash control flow outside
the Python heredoc are unchanged.

## Commit

- `0da84da` on `main` (one commit, +30/-10 in `scripts/monitor-poll.sh`).
  Pushed to `origin/main`. No PR (per `CLAUDE.md` § Conventions).

## Daemon restart

Stopped the four standing daemons by `kill $PID`, removed each
state directory's `last_event_id.txt` and `etag.txt`
(the `etag.txt` clear forces the first poll to be a `200`
rather than a `304`, so the new `last_event_ts.txt`-empty filter
exercises end-to-end and the missed events backfill), and respawned
from the orchestrator's `/home/kris` root with the steward's
standing-monitors invocation. New PIDs:

| Slug              | New PID | Log emitted on first poll |
| ----------------- | ------- | ------------------------- |
| endo              | 18396   | `NEW 30 on endojs/endo: ...` |
| endo-but-for-bots | 18397   | `NEW 29 on endojs/endo-but-for-bots: ...` |
| agoric-sdk        | 18398   | `NEW 30 on agoric/agoric-sdk: ...` |
| cosgov            | 18399   | `NEW 30 on dcfoundation/cosmos-proposal-builder: ...` |

The endo-but-for-bots batch includes `IssueCommentEvent/created#109`
(and many other 9.3-B-class events) alongside Push/Create/Delete
events; the cursor after that batch is `2026-05-13T00:54:05Z`,
which is exactly the timestamp of the maintainer comment the
steward flagged as missed. The id-class bimodality is no longer
visible to the filter.

## Self-improvement

Self-improvement: when a script's persisted cursor is a single
monotonic value, verify that the underlying field is actually
monotonic over the full set of inputs the script will see, not
just the ones the script saw during initial bring-up. Adjacent
rule: any cursor derived from an external feed's id space should
prefer the feed's own time field when one is available, since
timestamps are the more general invariant. Captured for the
field notes of `skills/github-activity-poll/SKILL.md` (cursor
invariants section).
