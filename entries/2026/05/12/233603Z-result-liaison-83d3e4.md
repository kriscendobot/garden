---
ts: 2026-05-12T23:36:03Z
kind: result
role: liaison
to: "*"
refs:
  - entries/2026/05/12/231322Z-result-steward-a28ec7.md
---

Stood up the standing-monitor and review-queue infrastructure on `endolinbot`. Five long-lived poll daemons are running and the supporting roles, skills, scripts, and journal index are committed.

What landed on `main` (commit 3e186fe):

- `roles/monitor/AGENT.md` rewritten around the daemon-plus-LLM-wake architecture: bash daemon polls /events with conditional GETs, only the `NEW` lines wake an LLM monitor agent. Per-project reaction rules now load from `skills/monitor-<slug>/SKILL.md` on dispatch.
- `roles/review-queue/AGENT.md` (new): same shape, polls `gh search prs --review-requested=kriskowal --state=open` and reconciles the journal bulletin section.
- `roles/steward/AGENT.md`: new "Standing monitors" section enumerating the five daemons + per-cycle liveness/respawn discipline; dispatch step updated to scan logs since the prior cycle's close.
- Four per-project skill placeholders: `skills/monitor-endo/SKILL.md`, `skills/monitor-endo-but-for-bots/SKILL.md`, `skills/monitor-agoric-sdk/SKILL.md`, `skills/monitor-cosgov/SKILL.md`. Reaction rows are all `(unset; propose via message to liaison)` today; rules accumulate as the monitors encounter event classes.
- `skills/review-queue-poll/SKILL.md`: the daemon's contract and the LLM-side reconcile procedure. Today's daemon implements tier (3) (fresh request) of the priority rule; tiers (1) and (2) (`CHANGES_REQUESTED` then pushed, explicit re-request) need a follow-up timeline query and are flagged in the skill's notes.
- `scripts/monitor-poll.sh`, `scripts/review-queue-poll.sh`: the daemons.

What landed on `journal` (commit bc9c849):

- Four worktree index entries under `journal/worktrees/endolinbot/` for the `watch-<slug>--monitor--<ts>` worktrees.
- New "Pending kriskowal reviews" bulletin section in `journal/README.md` with stable delimiters for idempotent rewrites.
- Worktree-index table and *Active worktrees* / *Open monitors* sections updated to reflect the five active daemons.

Daemons live (PIDs as of this entry):

| Slug              | PID  | Cadence | Log                                                            |
| ----------------- | ---- | ------- | -------------------------------------------------------------- |
| endo              | 1238 | 60s     | /tmp/garden-monitor-endojs-endo.log                            |
| endo-but-for-bots | 1240 | 30s     | /tmp/garden-monitor-endojs-endo-but-for-bots.log               |
| agoric-sdk        | 1243 | 60s     | /tmp/garden-monitor-agoric-agoric-sdk.log                      |
| cosgov            | 1248 | 60s     | /tmp/garden-monitor-dcfoundation-cosmos-proposal-builder.log   |
| review-queue      | 1256 | 120s    | /tmp/garden-review-queue.log                                   |

Initial state notes:

- Each monitor daemon's first poll returned a 200 with the 30 most recent events (the etag was empty); these are now seeded into `last_event_id.txt`, so subsequent ticks should mostly 304. The next steward cycle's log-tail-since-prior-close will surface these 120-ish events as `NEW` lines and will dispatch a monitor agent per repo to react. With every reaction row in the per-project skills marked `(unset)`, that first dispatch will generate a flood of "propose a rule for X event class" messages to the liaison. If that flood is unwanted, the operator can either truncate the daemon logs before firing the next steward cycle or have me pre-fill the most common rules now.
- The review-queue's first canonical set holds **100 PRs**, which is the `gh search --limit=100` ceiling. The real pending count may be higher; pagination is a follow-up I'll note in `skills/review-queue-poll/SKILL.md` if 100 turns out to be a real cap rather than an upper bound.

Open follow-ups for me (next time I'm acting as liaison):

1. Land the timeline-query refinement so tiers (1) and (2) of the review-queue priority actually populate.
2. Add pagination to `review-queue-poll.sh` if the queue genuinely exceeds 100.
3. Sweep the stale `/Users/kris/garden/...` Mac paths in `roles/COMMON.md` and `skills/journal-sync/SKILL.md` (still open from the steward's earlier follow-up message, `entries/2026/05/12/225552Z-message-steward-580af9.md`).

Self-improvement: roles/monitor/AGENT.md and roles/review-queue/AGENT.md now codify the daemon-plus-LLM-wake architecture as a reusable shape — any future role that watches a long-poll feed and only wakes the LLM on change can copy this layout (one bash daemon writing `NEW`/`ADD`/`REMOVE` lines, role reads since prior cycle's close, journal holds durable transcript). If a second such role lands, that pattern should be extracted into its own skill rather than restated in each role file.
