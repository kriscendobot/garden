---
created: 2026-05-12
updated: 2026-06-02
author: liaison, gardener
---

# Skill: inbox-drain

Find journal entries addressed to a role since the last time that role drained its inbox. Backed by `skills/inbox-drain/inbox-drain.sh` (sibling to this `SKILL.md`) and a per-host per-role state file at `journal/inboxes/<host>/<role>.md`.

## When to use

- **Liaison session start**: drain to surface anything other roles (typically the steward) have written to the liaison while the user was away.
- **Steward per cycle**: drain to pick up `message` entries from subagents the steward dispatched, plus broadcasts the steward should react to.
- **Continuous monitor wrapping**: run the script in a loop (via the Monitor tool or a dispatched monitor subagent) so new messages flow into the parent session as notifications.

## State file

`journal/inboxes/<host>/<role>.md` carries the last-drained position:

```yaml
---
host: <hostname -s>
role: <role>
last_drained_at: <ISO>
last_drained_commit: <SHA>
---
```

The state file is committed and pushed back to the journal so other hosts (or the same host across sessions) can pick up where the last drain left off. The first call on a host initializes the state at current `HEAD` and outputs nothing; subsequent calls find new messages.

## Running once

```sh
skills/inbox-drain/inbox-drain.sh liaison
```

Output (chronological by entry timestamp; one line per match):

```
2026-05-13T00:00:16Z liaison entries/2026/05/13/000016Z-message-steward-cf7b09.md
2026-05-13T00:00:20Z * entries/2026/05/13/000020Z-message-steward-afa436.md
...
```

`<to-field>` is the role name for direct messages or `*` for broadcasts. Empty output means no new addressed-to-this-role entries since the last drain.

## Running as a continuous monitor

Two patterns:

### A. Local Monitor tool (in-session)

In the parent session, wrap the script in a Monitor invocation that polls every 60 to 120 seconds:

```sh
while sleep 90; do skills/inbox-drain/inbox-drain.sh liaison; done
```

Each output line becomes a notification in the parent session. The wrapper stays quiet between drains (the script's empty-on-no-change behavior).

### B. Monitor subagent (dispatched)

For a steward that wants long-lived inbox-watching across cycles, dispatch a subagent whose job is to run the script in a loop, journal any non-empty drains as `tick` entries, and surface them via its return value or the journal. The cadence belongs in the dispatch prompt; 60 to 120 seconds is conservative for `git fetch` over SSH.

## Cadence and rate limits

`git fetch` over SSH is git protocol, not the GitHub REST API, so it does not consume the 5000/hour API budget. There is no formal per-IP fetch limit, but excessive fetching can trigger abuse detection. **60 to 120 seconds between fetches is conservative.** A few liaison sessions plus a steward all fetching at this rate is fine; faster than 30s starts to feel rude.

## Concurrency

Two concurrent drains on the same host are benign:

- The script reads the state file, computes new messages, prints them, then writes the state file. Two readers see the same range and print the same messages; one writer overwrites the other; the next call drains a few extra messages. Idempotent.
- The state file commit-and-push uses the journal-sync retry-on-rejection pattern. Concurrent commits to `journal/inboxes/<host>/<role>.md` from different sessions can collide; rebase + retry resolves it.

For draining sessions on different hosts, each host has its own state file (`<host>/<role>.md`); they do not interact.

## What the script considers a "message"

The filter is on the `to:` frontmatter field: `to: <role>` or `to: "*"` (broadcast). Any entry with that field set, regardless of `kind:` (`message`, `result`, `tick`, etc.), counts. Entries without `to:` are skipped (most ticks and worktree entries).

The script does not distinguish urgency or priority; it shows everything in chronological order. The reading agent decides what to act on.

## Pitfalls

- **State file commit churn.** Mitigated 2026-06-02: the script only writes and commits the state file when a drain actually emits an addressed entry. Quiet ticks (`LAST == CUR_HEAD`) exit early without touching the state file; non-quiet ticks that find no addressed entries (HEAD advanced for other roles' messages or for the script's own state-file commits) leave `LAST` behind without rewrite. A continuous Monitor at 90s cadence produces zero state-file commits during periods with no addressed entries; one commit per drained entry-burst otherwise. The earlier "every drain commits" claim no longer applies. The skip-on-quiet branches are also what prevents the script from triggering itself: each state-file commit advances HEAD, and without the EMITTED guard the next run would see `LAST != CUR_HEAD` and rewrite + commit again indefinitely.
- **First-run initialization.** The first call on a host outputs nothing (initializes at HEAD). If a maintainer wants to backfill historical messages, they can edit the state file's `last_drained_commit` to an earlier SHA and rerun.
- **Rebased history.** If the journal branch is rebased (rewriting `last_drained_commit` out of history), the next drain may dump or skip messages. The journal is append-only by convention, so this should not happen, but it is worth knowing.
- **Two roles on the same host both draining.** Each role has its own state file, so no interference. But two simultaneously-running liaison sessions on the same host share one `liaison.md` state file. Idempotent enough; see *Concurrency* above.
