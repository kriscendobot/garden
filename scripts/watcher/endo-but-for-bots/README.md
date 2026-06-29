---
created: 2026-06-02
updated: 2026-06-02
author: builder
---

# scripts/watcher/endo-but-for-bots

The per-feed activity watcher for the `endojs/endo-but-for-bots`
webhook stream.

**Phase 1 stub.** This directory ships the contract documented as
code-comments in `watcher.sh` plus this README, and a stub that
exits cleanly. The substantive event-routing implementation lands
in a later phase per
[`skills/activity-feed-watcher/SKILL.md`](../../../skills/activity-feed-watcher/SKILL.md).

## Feed source

The `endojs/endo-but-for-bots` repo is the active set's only
fully bot-gated upstream as of 2026-06-02 (see the [monitoring
safety constraint](../../../CLAUDE.md#monitoring-safety-constraint)).
A webhook stream feeds events into this watcher's process; a
poll-fallback companion watcher (`endo-but-for-bots-poll`) covers
the case when the webhook is unavailable.

## Event types this watcher classifies

The eventual implementation classifies the following events into
messages or jobs, per the contract in
[`skills/activity-feed-watcher/SKILL.md`](../../../skills/activity-feed-watcher/SKILL.md):

| Event                          | Routes to                                              |
| ------------------------------ | ------------------------------------------------------ |
| New comment on a subscribed PR | per-PR event log + `:eyes:` reactji                    |
| Review submission              | per-PR event log (verdict body for a gardener to read) |
| Push to a subscribed PR's head | per-PR event log                                       |
| CI status change               | per-PR event log                                       |
| Label change                   | per-PR event log                                       |
| Assigned-issue update          | `journal/jobs/open/` with `kind: issue-response`       |
| Comment / event on an unsubscribed PR | `journal/jobs/open/` with `kind: pr-creation`   |

## Routing contract

The watcher fans events for tracked PRs into per-PR event logs at
`journal/events/<repo>--<pr>.log`; events with no tracked PR become
posted jobs on the v2 job board (`journal/jobs/open/`) for a gardener
to claim. A tracked PR is one with an existing per-PR event log;
each log line is keyed by a `repo:pr` pair (e.g.
`endojs/endo-but-for-bots#247`).

## Reactji policy

The watcher is the single program that posts the deterministic
`:eyes:` reactji on a new comment on any PR or issue under the
covered repo. The reactji posts synchronously as part of the
per-event handler, before any message routing. The reaction's
identifier (`comment id + reactji id`) is recorded in
`journal/events/<repo>--<pr>.log` so downstream agents do not
double-post.

Other reactji (`:+1:`, `:rocket:`) on resolved review comments
remain the responsibility of the gardener or fixer that resolves the
comment, gated by the specific action that resolves it.

## Self-healing

- **Transient failures** (network blips, auth-token expiry within
  a refresh window): systemd's `Restart=on-failure` policy with a
  30-second backoff. The unit comes back automatically.
- **Persistent failures** (repeated auth failure, malformed event
  payloads): a section appended to
  `journal/inboxes/<host>/gardener.md` per
  [`skills/gardener-inbox-error-reporting/SKILL.md`](../../../skills/gardener-inbox-error-reporting/SKILL.md),
  naming the feed slug, the captured transcript SHA, and a
  one-paragraph context.

## Invocation

Manual:

```sh
scripts/watcher/endo-but-for-bots/watcher.sh
```

Via systemd (Phase 4 onward, after `~/.config/systemd/user/` has
the unit file installed and `daemon-reload` has run):

```sh
systemctl --user enable garden-watcher@endo-but-for-bots.service
systemctl --user start  garden-watcher@endo-but-for-bots.service
```

`scripts/daemons/logs.sh --feed endo-but-for-bots` tails the
journal-side log for this unit.
