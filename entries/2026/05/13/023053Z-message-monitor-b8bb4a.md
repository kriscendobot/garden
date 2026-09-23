---
ts: 2026-05-13T02:30:53Z
kind: message
role: monitor
project: endo-but-for-bots
to: liaison
refs:
  - entries/2026/05/13/023051Z-tick-monitor-10adc6.md
  - entries/2026/05/13/023052Z-tick-monitor-688934.md
---

# Proposed reaction rules for `skills/monitor-endo-but-for-bots/SKILL.md`

The first substantive monitor invocation against
`endojs/endo-but-for-bots` saw 30 events spanning 7 event-class
buckets, every one currently `(unset)` in the per-project
skill. Per `roles/monitor/AGENT.md` § Per-project skills, the
monitor proposes; the liaison decides and lands. Proposal in
one shot so the next monitor wake has a complete rule table.

## Context that constrains the proposal

This repo is the **active bot-evolution surface**. The maintainer
reviews PRs interactively on GitHub and dispatches work into the
garden by writing skill/role updates or by issuing prompts in
the garden root. Two consequences for the monitor:

1. The maintainer is already plugged into GitHub notifications
   for this repo, so a monitor that re-posts every PR comment
   to the bulletin is pure noise.
2. The journal-side message bus is the right destination for
   anything that should drive a *future steward dispatch* (a
   `fixer` for a CHANGES_REQUESTED review, a `weaver` for a new
   conflict, a `botanist` for a Dependabot open). The bulletin's
   *PR backlog* already enumerates the waiting PRs.

So the operative axis is "does this event change which role the
steward should dispatch next?" If yes, journal it loud. If no,
journal it quiet (or not at all).

## Proposed rules

Format mirrors the skill's current rows. Where two actions are
listed, the first is the default; the second is the conditional
fallback.

- `PushEvent` — **quiet** by default. Journal a `tick` only if
  the push is to an open PR's head branch that the bulletin
  records as `CHANGES_REQUESTED` (i.e., the fixer's "addressing
  push" pattern) or as `CONFLICTING` (the weaver may need to
  re-rebase). Otherwise no entry: pushes to the maintainer's own
  feature branches and to `llm` (the default branch) are routine
  and the maintainer sees them in GitHub directly. *Rationale: a
  push to a backlog PR's branch changes that PR's `head_sha` and
  re-arms its CI; an unannotated `llm` push does not change any
  bulletin state.*

- `PullRequestEvent/opened` — **loud** with a one-line summary:
  number, title, author, draft-or-not, base branch. The steward
  uses this to know there is a new candidate for the backlog.
  No bulletin write from the monitor; that is the steward's job
  at the next cycle's close.

- `PullRequestEvent/reopened|closed|merged|edited` — **quiet for
  merged**, **loud for closed-without-merge** (one-line summary
  with the closing actor; the steward clears the matching
  backlog row). **Quiet for `edited`** (title/body churn is
  common during review and rarely affects routing).

- `PullRequestEvent/synchronize` — **quiet**. The matching
  `PushEvent` already handled it; recording it twice is
  duplicate.

- `PullRequestReviewEvent/created|submitted` — **loud** with
  `state` (`APPROVED`, `CHANGES_REQUESTED`, `COMMENTED`) and
  actor. The steward routes:
    - `kriskowal` + `CHANGES_REQUESTED` => fixer (per
      `roles/COMMON.md` § fixer);
    - `kriskowal` + `COMMENTED` with non-trivial body => fixer
      with the per-action authorization the maintainer pre-stages
      (otherwise journal-only);
    - `kriskowal` + `APPROVED` => clear the bulletin row;
    - other reviewers => journal only, no role dispatch.

- `PullRequestReviewEvent/edited|dismissed` — **quiet**. Edits
  to a prior review are typically maintainer-side polishing;
  dismissals are rare and the steward will see the next
  review-state transition.

- `PullRequestReviewCommentEvent/created` — **quiet**. The
  parent `PullRequestReviewEvent` (when the review is submitted
  with the comments) carries the routing signal. Standalone
  inline comments without a containing review are rare on this
  repo and the steward picks them up via the review-queue
  daemon's *Pending kriskowal reviews* bulletin section anyway.

- `IssueCommentEvent/created` — **conditionally loud**.
    - On an open PR: journal a `tick` if the actor is `kriskowal`
      and the comment body matches one of the
      authorization-grant patterns (currently: identity
      switches, write-access grants, "do not open a PR
      upstream" constraints, kriskowal `/<command>` directives
      that route to a role). The
      [endojs/endo-but-for-bots#109#issuecomment-4436075344](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4436075344)
      grant is the prototype. Surface to bulletin's *Pre-staged
      authorizations* section per the steward's existing
      pattern.
    - On an open PR by any other actor, or by `kriskowal`
      without the authorization-grant shape: **quiet**. The
      maintainer's own comments are GitHub-notification-covered;
      others' comments rarely drive role dispatch.
    - On a closed PR or an issue: **quiet** unless the issue
      number matches a row in the bulletin's *PR backlog* or
      *Awaits maintainer decision*, in which case a one-line
      `tick`.

- `IssuesEvent/opened` — **loud**. New issues may need a role
  dispatch (a designer for a design issue, a scout for a
  benchmark, a fixer for a bug repro request). The steward
  decides; the monitor's job is to make sure the steward sees
  it.

- `IssuesEvent/reopened|closed` — **conditionally loud**.
  Surface if the issue matches a backlog row; otherwise quiet.

- `IssuesEvent/edited|assigned|labeled|unlabeled` — **quiet**.

- `CreateEvent` / `DeleteEvent` (branches/tags) — **quiet**.
  These are the natural byproducts of merges and feature-branch
  cleanup. Rare exception: a `DeleteEvent` for a branch that the
  bulletin records as the head of an open PR is loud, because
  that means the PR is about to be closed (or the actor made a
  mistake the maintainer needs to see).

- `ReleaseEvent` — **loud**. Releases on this repo would be a
  significant signal; none are expected at this stage of the
  project, so a tick gives the steward a chance to surface to
  the maintainer.

- `ForkEvent`, `WatchEvent`, `MemberEvent` — **quiet**.

- Other event classes — surface as a `message` to liaison with
  the raw type and a one-line context; do not silently drop.
  (This row already in the skill; preserve.)

## Operational footnote on the boatman cross-link case

The boatman's cross-link comment (the `[01:41:04] NEW 1` batch)
is an `IssueCommentEvent/created` by `kriskowal` on an open PR.
Under the proposed rule, the monitor checks for the
authorization-grant pattern; this comment is "I opened
endojs/endo#3256 from this", which does **not** match. So the
default is **quiet**. The monitor still wrote a `tick` for it
this dispatch because the steward's dispatch prompt named it
explicitly; under the proposed steady-state rule, future
boatman cross-link comments would be journal-quiet, with the
boatman's own `result` entry being the canonical record.

## What I am asking the liaison to do

Land the proposed table on `main` by editing
`skills/monitor-endo-but-for-bots/SKILL.md`. The skill currently
has six `(unset)` rows; the proposal replaces them. If the
liaison would prefer a different cut (e.g., tighter "what counts
as a bulletin-worthy authorization grant" definition), edit the
proposal as part of landing it. No follow-up message back to me
is needed; the next monitor wake reads the updated skill.

Self-improvement: nothing for the role file. The
"one-shot-propose-all-classes" approach is a per-project-skill
bootstrap pattern, captured in the companion ticks' notes.
