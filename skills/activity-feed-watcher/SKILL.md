---
created: 2026-06-02
updated: 2026-06-24
author: builder, gardener
---

# Skill: activity-feed-watcher

The contract a per-repo activity producer implements: event classification,
deterministic reactji posting, job posting, and error escalation. This is the v2
**triager-handler** contract — the playbook the
[triager](../../roles/triager/AGENT.md) follows on the few LLM-substep paths it
has (most paths are deterministic and skill-free).

In v1 this skill described a per-feed `scripts/watcher/<feed>/watcher.sh` that
fanned events out to *driver lanes* via a subscription union. The driver and its
lanes are retired; in v2 there are no per-lane subscriptions. A triager simply
posts a **job** to the board for each actionable event and any eligible gardener
races to claim it. The classifier, reactji, and error-escalation discipline carry
verbatim; the routing collapses from "fan out to subscribed lanes" to "post one
job."

## When to use

When implementing or extending a per-repo triager (a webhook stream, a poll
loop, the review-queue endpoint, an assigned-issues feed). The skill is the
contract; the triager script (`scripts/jobs/triager.sh`) is the implementation.

## Inputs

- A feed source the triager polls or subscribes to (a webhook endpoint, a
  `gh api` poll loop per [github-activity-poll](../github-activity-poll/SKILL.md),
  a kriskowal-side endpoint, etc.).
- Write access to the journal board (`jobs/todo/` on `journal2`) via
  `post-job.sh` (see [job-board](../../skills/job-board/SKILL.md)).
- The message bus for unrecoverable feed failures (a directed message to a
  gardener inbox, or a `broadcast`; see
  [message-bus](../../skills/message-bus/SKILL.md)).

## State

- **Last-seen marker** (per-feed, under `GARDEN_STATE`, never a shared journal
  worktree): `$GARDEN_STATE/triager/<feed>/last-seen-id`. Read on every tick to
  know what is new; advanced only **after** the tick's events are posted.
- **ETag cache** (for `If-None-Match`-honoring HTTP feeds): one ETag per polling
  endpoint, under the same `GARDEN_STATE` path. Shape per
  [github-activity-poll](../github-activity-poll/SKILL.md).

There is no subscription union to read: the v2 board is a single shared queue,
not a set of per-lane subscription files.

## Procedure

A triager's loop per tick:

1. **Poll the feed.** Fetch the new events since `last-seen-id` (or
   `If-None-Match` against the cached ETag). On a transient error (network
   failure, 5xx), log and skip the tick; the systemd timer and the next tick's
   poll resolve the case.

2. **Classify each event.** A deterministic classifier keyed on the feed's
   event-type field:

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

   Classification is regex / structural; no LLM is involved. The classifier's
   escalation surface is empty by design.

3. **Map the directive to a job (deterministically).** A triager prefers a fixed
   directive→job mapping over open-ended reasoning (per
   `roles/triager/AGENT.md`):

   | Directive on PR #N | Job posted |
   | --- | --- |
   | **rebase** #N | rebase the PR branch on its base |
   | **retcon** #N | reset + restage per-package, separate `chore: Update yarn.lock` |
   | **refresh** #N | re-sync branch / regenerate derived artifacts |
   | **shepherd** #N | drive CI to green |
   | **run the gauntlet** #N | the full PR-creation chain end to end |

   The idiom is **gauntlet** — v1's "gamut" was erroneous and is not used.

4. **Post the job.** For each classified, actionable event, `post-job.sh` with a
   basename derived deterministically from the change identity
   (`<slug>-pr<N>-<shorthash>`) so re-triage across ticks is idempotent (a
   duplicate collides with an existing `todo/doin/tada` basename and is skipped).
   An `other` event is logged and dropped. Any eligible gardener races to claim
   the posted job; there is no per-lane routing.

5. **Post the deterministic reactji.** For every `comment` event on any watched
   repo, post the `:eyes:` reactji synchronously, *before* posting the job in step
   4. Record the `(comment_id, reaction_id)` pair in the job body so a downstream
   gardener does not double-post. See
   [reactji-acknowledgment](../reactji-acknowledgment/SKILL.md).

6. **Advance the marker.** Update `last-seen-id` only after this tick's jobs are
   posted, so a failure mid-tick re-surfaces the events next tick.

7. **Sleep until the next tick.** The cadence is per-feed (a webhook stream may
   have no sleep; a `gh api` poll has a 30- to 60-second tick budget). The
   systemd timer owns the cadence for the standing case.

## Output

- Posted jobs at `journal2:jobs/todo/<base>` for actionable events.
- Reactji on PR comments (the `:eyes:` deterministic acknowledgment).
- Updated per-feed `last-seen-id` / ETag caches under `GARDEN_STATE`.

## Error escalation

On an unrecoverable feed failure, the triager escalates via the message bus
rather than the v1 gardener-inbox markdown append:

- A `-x` subshell captures the per-tick transcript; an `EXIT` / `ERR` trap
  discriminates on `$?`.
- On unexpected exit, hash the transcript via `git hash-object -w --stdin`, then
  send a directed message (or `broadcast`) naming the feed slug, the transcript
  SHA, and a one-paragraph context, and exit non-zero.
- The systemd timer brings the triager back on the next tick.

Persistent crash loops accumulate messages on the bus; the maintainer's next pass
(surfaced via the liaison's maintainer-watch) sees the pattern and triages.

## Notes

- **One triager per repo.** The watch set is the journal's `repos/` directory,
  reconciled to systemd units by the repo-watcher (per
  `roles/triager/AGENT.md`).
- **No LLM in the routing path.** The triager is deterministic: classification,
  the directive→job mapping, reactji posting, and job posting are all bash /
  regex. The directive mapping replaces v1's per-PR event-log fan-out.
- **No subscription union.** v1 routed events to subscribed driver lanes; v2 has
  no lanes. Every actionable event becomes a job on the shared board; the claim
  race resolves which gardener does it.
- **Monitoring safety constraint.** Adding a new repo whose comments and PRs are
  not gated against untrusted contributors is gated on explicit maintainer
  authorization, per `roles/triager/AGENT.md` § Monitoring safety. The triager is
  an event-level surveillance surface and inherits the rule; content-level
  surveillance (comment-body @-mentions) is
  [at-mention-surveillance](../at-mention-surveillance/SKILL.md).

## Notes from the field

- _2026-06-02_: authored as the per-feed watcher contract under the v1 driver
  model (subscription-union routing to driver lanes).
- _2026-06-24_: migrated into v2. Re-homed onto the triager-handler contract:
  removed the driver-lane subscription union and the per-PR event-log fan-out;
  every actionable event is now a single posted job any gardener claims. Moved the
  last-seen / ETag markers from `~/.garden-watchers/` to `GARDEN_STATE`; rewired
  error escalation from the gardener-inbox markdown append to the message bus;
  folded in the triager's deterministic directive→job mapping. The v1 sibling
  executable `scripts/watcher/<feed>/watcher.sh` is superseded by
  `scripts/jobs/triager.sh`; not reproduced.
