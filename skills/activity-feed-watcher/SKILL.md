---
created: 2026-06-02
updated: 2026-06-02
author: builder
---

# Skill: activity-feed-watcher

The contract every per-feed activity watcher implements: event
classification, subscription-union routing, deterministic reactji
posting, and error escalation. Each
[`scripts/watcher/<feed>/watcher.sh`](../../scripts/watcher/README.md)
consults this skill on the LLM-substep paths it has (most paths are
deterministic and skill-free).

See [`designs/driver.md`](../../designs/driver.md) § Watcher
subscription model and event routing for the design rationale; this
skill is the playbook the implementation follows.

## When to use

When implementing a new feed watcher (a per-repo webhook stream, a
poll-fallback loop, the review-queue endpoint, an assigned-issues
feed). The skill is the contract; the watcher script is the
implementation.

## Inputs

- A feed source the watcher polls or subscribes to (a webhook
  endpoint, a `gh api` poll loop, a kriskowal-side endpoint, etc.).
- Read access to the union of all driver subscription files at
  `journal/drivers/<host>/<lane>.subscriptions`.
- Write access to the journal for:
  - per-PR event logs at `journal/events/<repo>--<pr>.log`;
  - jobs posted to `journal/jobs/open/` for events with no
    subscribed driver;
  - gardener-inbox messages for unrecoverable feed failures.

## State

- **Last-seen-id cache** (per-feed, outside the dispatch root):
  `~/.garden-watchers/<feed>/last-seen-id` (or analogous
  per-feed-name path). The watcher reads it on every tick to know
  what events are new; updates it after the events for one tick
  are routed.
- **ETag cache** (for `If-None-Match`-honoring HTTP feeds): same
  shape as the existing standing-monitor daemons'
  `/tmp/garden-monitor-*` caches; one ETag per polling endpoint.
- **Subscription union**: read fresh from
  `journal/drivers/<host>/<lane>.subscriptions` on every tick; the
  watcher does not cache the union because subscriptions change
  with driver lifecycle.

## Procedure

A watcher's loop per tick:

1. **Refresh subscriptions.** Read every
   `journal/drivers/<host>/<lane>.subscriptions` file. Build the
   union: a map from `<repo>:<pr>` to the set of subscribing
   lane numbers. The watcher uses this map for the routing
   decision in step 4.

2. **Poll the feed.** Fetch the new events since
   `last-seen-id` (or `If-None-Match` against the cached ETag).
   On a transient error (network failure, 5xx), log and skip the
   tick; systemd's `Restart=on-failure` and the next tick's poll
   resolve the case.

3. **Classify each event.** Each watcher implements a deterministic
   classifier keyed on the event-type field of its feed:

   | Event kind                       | Classification             |
   | -------------------------------- | -------------------------- |
   | New comment on a PR              | `comment`                  |
   | Review submission                | `review`                   |
   | Push to a PR's head ref          | `push`                     |
   | CI status change                 | `ci-status`                |
   | Label change                     | `label`                    |
   | Assigned-issue update            | `assigned-issue`           |
   | Issue body mention of the bot    | `issue-mention`            |
   | Other                            | `other` (logged, not routed) |

   Classification is regex / structural; no LLM is involved. The
   classifier's escalation surface is empty by design.

4. **Route the event.** For each classified event, decide its
   destination:

   - If the event names a `<repo>:<pr>` that appears in the
     subscription union, append a message to
     `journal/events/<repo>--<pr>.log` for every subscribed lane
     (a single append is enough; per-lane fan-out happens via the
     driver's read).
   - If the event names a `<repo>:<pr>` *not* in the subscription
     union, post a job to `journal/jobs/open/` with `kind:
     pr-creation` (so any eligible driver lane can claim and bind).
   - If the event is an `assigned-issue` event, post a job with
     `kind: issue-response`.
   - If the event is `other`, log to the watcher's transcript and
     drop.

5. **Post the deterministic reactji.** For every `comment` event
   on any covered repo (subscribed PR or not), the watcher posts
   the `:eyes:` reactji synchronously, *before* the route in step
   4 lands. The `(comment_id, reaction_id)` pair is recorded in
   the destination event log so downstream agents do not
   double-post.

6. **Persist last-seen.** Update the per-feed `last-seen-id` cache
   so the next tick starts from this point.

7. **Sleep until the next tick.** The polling cadence is per-feed
   (a webhook stream may have no sleep; a `gh api` poll has a 30-
   to 60-second tick budget).

## Output

- Per-PR event log entries at `journal/events/<repo>--<pr>.log`
  (one append per routed event).
- Posted jobs at `journal/jobs/open/<...>.md` for unsubscribed
  events.
- Reactji on PR comments (the `:eyes:` deterministic acknowledgment).
- Updated per-feed `last-seen-id` / ETag caches outside the journal.

## Error escalation

The watcher inherits the uniform error-reporting pattern from
[`skills/gardener-inbox-error-reporting/SKILL.md`](../gardener-inbox-error-reporting/SKILL.md):

- A `-x` subshell captures the per-tick transcript.
- An `EXIT` / `ERR` trap discriminates on `$?`.
- On unexpected exit, the trap hashes the transcript via
  `git hash-object -w --stdin`, appends a section to
  `journal/inboxes/<host>/gardener.md` naming the feed slug, the
  transcript SHA, and a one-paragraph context, and exits non-zero.
- systemd's `Restart=on-failure` (30-second backoff) brings the
  watcher back automatically.

Persistent crash loops accumulate sections in the gardener inbox;
the maintainer's next pass sees the pattern and triages.

## Notes

- **One watcher per feed, not per repo.** Multiple repos behind one
  webhook stream share a single watcher process; a repo with its
  own poll cadence runs its own watcher.
- **No LLM in the routing path.** The watcher is fully
  deterministic. Classification, subscription union, reactji
  posting, and per-PR event-log appends are all bash / regex.
  Routing decisions are not gated on judgment.
- **Subscription-union freshness.** A driver lane that just took
  on a new subscription must write its `.subscriptions` file
  *before* the watcher's next tick. The watcher does not lock or
  serialize; the race is "the driver missed this tick's event,
  the next tick will pick it up."
- **Monitoring safety constraint.** Adding a new feed for a repo
  whose comments and PRs are not gated against untrusted
  contributors is gated on explicit maintainer authorization
  recorded in a journal `message` entry, per
  [the constraint in CLAUDE.md](../../CLAUDE.md#monitoring-safety-constraint).
  Watcher daemons are an event-level surveillance surface and
  inherit the same rule.
- **Coalescence with existing standing monitors.** Phase 1 ships
  one stub feed (`endo-but-for-bots`). Phase 4-5 of the migration
  plan in `designs/driver.md` retires the per-repo standing
  monitors (`/tmp/garden-monitor-*.log` poll daemons) on a per-
  feed basis after observed equivalence.
