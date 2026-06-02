---
created: 2026-06-02
updated: 2026-06-02
author: builder
---

# scripts/watcher

Per-activity-feed watcher daemons. Each subdirectory under
`scripts/watcher/` is one feed:

```
scripts/watcher/<feed-slug>/
  watcher.sh    # the watcher entry point
  README.md     # what the feed delivers, the reactji policy, etc.
```

There is exactly one watcher per activity feed across the host, not
one per repo and not one per role. Multiple repos behind a single
webhook stream share a watcher; a repo with a dedicated poll loop is
its own watcher.

The design's full motivation, the subscription model, and the
event-routing table are at
[`designs/driver.md`](../../designs/driver.md) § systemd-managed
daemons and § Watcher subscription model and event routing. The
contract every watcher implements lives at
[`skills/activity-feed-watcher/SKILL.md`](../../skills/activity-feed-watcher/SKILL.md).

## Initial feed slugs

The design names four feeds; only the first ships a stub in this PR
(Phase 1). The others are deferred to Phase 2-5 implementation:

| Feed slug                | Source                                       | Status |
| ------------------------ | -------------------------------------------- | ------ |
| `endo-but-for-bots`      | webhook stream for `endojs/endo-but-for-bots` | stub   |
| `endo-but-for-bots-poll` | poll fallback for the same repo when webhook is unavailable | deferred |
| `review-queue`           | kriskowal's pending-review GitHub endpoint   | deferred |
| `assigned-issues`        | issues assigned to `kriscendobot`            | deferred |

Adding a new feed:

1. Create `scripts/watcher/<feed>/watcher.sh` plus a `README.md`
   that names the source, the message routing, and the reactji
   policy.
2. The script reads
   [`skills/activity-feed-watcher/SKILL.md`](../../skills/activity-feed-watcher/SKILL.md)
   on its LLM-substep paths and otherwise runs deterministic bash.
3. The maintainer (later, in Phase 4) enables
   `garden-watcher@<feed>.service` via `systemctl --user enable`.
4. Re-enabling a watcher for a repo whose surface is not gated
   against untrusted contributors requires explicit maintainer
   authorization per the [monitoring safety constraint](../../CLAUDE.md#monitoring-safety-constraint).

## Systemd integration

The templated unit at
[`scripts/systemd/garden-watcher@.service`](../systemd/garden-watcher@.service)
instantiates one watcher per feed slug. The unit instance argument
(`%i`) is the feed slug. Each watcher runs from its own long-lived
worktree (the daemon worktree pattern documented in `WORKTREES.md`).

`scripts/daemons/start.sh`, `stop.sh`, `status.sh`, and `logs.sh`
wrap the systemd verbs and accept a `--feed <slug>` filter.

## What a watcher does *not* do

- Make any LLM call by itself. Event classification, reactji
  policy, and message routing are deterministic. The watcher's
  only escalation surface is unrecoverable feed failure; that
  lands on the gardener inbox.
- Open or close PRs, post review comments, or apply labels. The
  watcher reads the feed and translates events; the driver (or a
  delegated worker subagent) is the actor.
- Coalesce events across feeds. Each feed gets its own watcher
  process; coalescence is per-feed, not per-host.
