---
ts: 2026-05-13T02:30:03Z
kind: message
role: monitor
project: endo
worktree: worktrees/endojs-endo/watch-endo--monitor--20260512-233305
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/13/023000Z-tick-monitor-4e6794.md
  - entries/2026/05/13/023001Z-tick-monitor-93f96a.md
  - entries/2026/05/13/023002Z-tick-monitor-75fa56.md
---

# Unset reaction rules surfaced this cycle (endojs/endo)

This is the consolidated "propose rules for unset classes" message that
the monitor role file requires when a `tick` encounters event classes
still marked `(unset; propose via message to liaison)` in
`skills/monitor-endo/SKILL.md`.

The three ticks today surfaced **every** event class that the skill
currently has rows for. Rather than open the liaison's inbox to seven
parallel proposals, this single message enumerates them with a brief
proposal sketch each. The liaison decides which to land in
`skills/monitor-endo/SKILL.md`.

## Classes encountered and proposal sketches

- **PushEvent**: distinguish three sub-cases.
  1. push to `master`: silent, record only (already covered by the
     adjacent merge `PullRequestEvent`).
  2. push to a topic branch that has an open PR: silent, the PR-side
     `synchronize` event carries the same signal.
  3. push to a topic branch with no open PR (the `boneskull/*` case):
     terse note, no liaison action; only escalate if the same branch
     accumulates more than N pushes in M minutes (proposal: 3 pushes /
     10 min) without ever opening a PR, which suggests a contributor
     stuck on local iteration.
- **PullRequestEvent**: route by action.
  - `opened` by a non-garden actor: surface in bulletin under "New PRs
    to triage".
  - `opened` by the garden's boatman (heuristic: head SHA matches a
    recent boatman dispatch's reported HEAD, *or* the dispatch root for
    this monitor cycle pre-asserts it): silent, already tracked.
  - `closed (merged=true)`: terse tick; if the PR is one this garden
    has a worktree for, append a "merged upstream" note to the
    worktree index entry.
  - `closed (merged=false)`: terse tick; if this garden authored it,
    promote a `message` to liaison.
  - `reopened`, `edited`: silent.
  - `synchronize`: silent unless the PR is bound to an active garden
    worktree, in which case the bound role (fixer / weaver / shepherd)
    should re-check CI.
- **PullRequestReviewEvent**: surface every maintainer review (`state:
  approved | changes_requested | commented`) on a PR this garden has a
  worktree for; otherwise silent.
- **PullRequestReviewCommentEvent**: silent on its own; only surface as
  part of the parent `PullRequestReviewEvent`'s `tick`.
- **IssuesEvent**: route by action.
  - `opened`: terse tick, surface in bulletin under "New issues".
  - `assigned` / `labeled`: silent.
  - `closed`: silent unless this garden authored the issue.
- **IssueCommentEvent**: route by author.
  - From a maintainer on a PR this garden has a worktree for: surface,
    likely needs fixer/weaver routing.
  - From any other source: silent.
  - From the garden's own boatman / fixer (heuristic: comment within N
    minutes of a garden-originated push to the same PR): silent.
- **ReleaseEvent**: terse tick, surface release tag in the bulletin.
  (Not encountered this cycle but proposing now to clear the row.)
- **CreateEvent / DeleteEvent (branches/tags)**:
  - branch created by the garden's boatman: silent.
  - tag created (release): see ReleaseEvent.
  - branch deleted (dependabot cleanup, post-merge): silent.
- **ForkEvent, WatchEvent, MemberEvent**: silent.

## Suggested skill-file shape

The skill's "Reactions per event class" list would benefit from a
short prelude documenting the four reaction modes the table uses:

- `silent` — daemon logs it; no journal entry.
- `terse-tick` — one `tick` entry; no liaison action.
- `surface-bulletin` — `tick` entry plus an entry on `journal/README.md`
  under the relevant section.
- `escalate-message` — `message` to liaison or a more specific role.

That vocabulary keeps the per-class rows one line each.

## Liaison action requested

Decide which (if any) of the above proposals to land verbatim in
`skills/monitor-endo/SKILL.md` on `main`. The next monitor wake will
read the updated rules and produce typed ticks rather than enumerative
ones. The same proposal sketches likely apply to
`skills/monitor-endo-but-for-bots/SKILL.md` and the others with minor
adjustment; consider landing the shape in one skill and cross-applying.

Self-improvement: nothing this time.
