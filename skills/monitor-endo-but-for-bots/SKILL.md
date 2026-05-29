---
created: 2026-05-12
updated: 2026-05-29
author: gardener, liaison, monitor
---

# Skill: monitor-endo-but-for-bots

Per-event-class reaction rules for the [monitor](../../roles/monitor/AGENT.md) when dispatched against `endojs/endo-but-for-bots`. The base role and its polling discipline live in `roles/monitor/AGENT.md` and `skills/github-activity-poll/SKILL.md`; this skill is consulted on each `NEW`-line wake to decide whether and how to react.

This skill handles **event-level** surveillance (who acted, when, on what). Its sibling [`skills/at-mention-surveillance/SKILL.md`](../at-mention-surveillance/SKILL.md) handles **content-level** surveillance (what the comment body said, specifically scanning for `@kriscendobot` and `@kriskowal` routing intent). The two compose; rules below that mention "the comment body" describe an event-level decision (e.g. "does the body match an authorization-grant pattern?") and do not subsume the content-level @-mention scan, which runs as the steward's third parent-context Monitor per `roles/steward/AGENT.md` § Parent-context Monitor invariants.

## Recognized maintainers

Per the 2026-05-29 maintainer directive recorded in [`journal/projects/endo-but-for-bots/README.md`](../../../journal/projects/endo-but-for-bots/README.md) § Authority structure on the `journal` branch: the repository's GitHub permission gate restricts commenting, reviewing, and PR-opening to users with maintainer access, so every commenter on this repo is treated as maintainer-equivalent, on every PR and every topic. Wherever a rule row below names `kriskowal`, read it as "any commenter on this repo": substitute any login that appears as the actor on a `PullRequestReviewEvent`, `PullRequestReviewCommentEvent`, or `IssueCommentEvent`.

The non-exhaustive named list (the project README maintains the canonical version) currently includes **kriskowal**, **jcorbin**, **kumavis**, **erights**, **danfinlay**, and **0xpatrick**. The list is examples-of, not the closed set; the permission gate is the gate.

The 2026-05-29 widening supersedes the prior `kriskowal`/`jcorbin`-only recognition baseline. It is repo-scoped to `endojs/endo-but-for-bots` and does not extend to `endojs/endo` absent further confirmation; the parallel `skills/monitor-endo/SKILL.md` is unchanged.

## Project

- Slug: `endo-but-for-bots`
- Upstream: `endojs/endo-but-for-bots` (https://github.com/endojs/endo-but-for-bots)
- Default branch: `llm`
- Daemon cadence: 30s (faster than the other monitors because this repo is the active bot-evolution surface; events here often drive the maintainer's next prompt and benefit from low latency, even though the GitHub `/events` cache caps effective freshness around 60s).

## Posture

`endojs/endo-but-for-bots` is the **active bot-evolution surface**. The maintainer reviews PRs interactively on GitHub and dispatches work into the garden by writing skill/role updates or by issuing prompts in the garden root. Two consequences for the monitor:

1. The maintainer is already plugged into GitHub notifications for this repo, so reposting every PR comment to the bulletin is pure noise.
2. The journal-side message bus is the right destination for anything that should drive a *future steward dispatch* (a `fixer` for a CHANGES_REQUESTED review, a `weaver` for a new conflict, a `botanist` for a Dependabot open). The bulletin's *PR backlog* already enumerates the waiting PRs.

The operative axis is "does this event change which role the steward should dispatch next?" If yes, journal loud. If no, journal quiet (or not at all).

## Reactions per event class

Each row records the agreed action and a brief rationale. Where two actions are listed, the first is the default; the second is the conditional fallback.

- `PushEvent` — **quiet** by default. Journal a `tick` only if the push is to an open PR's head branch that the bulletin records as `CHANGES_REQUESTED` (the fixer's "addressing push" pattern) or as `CONFLICTING` (the weaver may need to re-rebase). Otherwise no entry: pushes to the maintainer's own feature branches and to `llm` (the default branch) are routine and the maintainer sees them in GitHub directly. *Rationale: a push to a backlog PR's branch changes that PR's `head_sha` and re-arms its CI; an unannotated `llm` push does not change any bulletin state.*

- `PullRequestEvent/opened` — **loud** with a one-line summary: number, title, author, draft-or-not, base branch. The steward uses this to know there is a new candidate for the backlog. No bulletin write from the monitor; that is the steward's job at the next cycle's close.

- `PullRequestEvent/reopened|closed|merged|edited` — **quiet for merged**, **loud for closed-without-merge** (one-line summary with the closing actor; the steward clears the matching backlog row). **Quiet for `edited`** (title/body churn is common during review and rarely affects routing).

- `PullRequestEvent/synchronize` — **quiet**. The matching `PushEvent` already handled it; recording it twice is duplicate.

- `PullRequestReviewEvent/created|submitted` — **loud** with `state` (`APPROVED`, `CHANGES_REQUESTED`, `COMMENTED`) and actor. Per the 2026-05-29 widening (see *Recognized maintainers* above), every reviewer on this repo routes as maintainer-equivalent. The dispatch role also depends on the PR's shape (per `roles/steward/AGENT.md` § Maintainer-feedback response § Dispatch decision by PR shape):
    - any reviewer + `CHANGES_REQUESTED` on a source-touching PR => fixer (per `roles/COMMON.md` § fixer);
    - any reviewer + `CHANGES_REQUESTED` on a design-only PR (every changed path under `<project>/designs/`) => designer with the review's inline comments inlined in the dispatch brief;
    - any reviewer + `COMMENTED` with non-trivial body on a source-touching PR => fixer with the per-action authorization implied by the comment body (the matrix in `skills/at-mention-surveillance/SKILL.md` § Per-repo overrides governs the @-mention case);
    - any reviewer + `COMMENTED` with non-trivial body on a design-only PR => designer with feedback brief;
    - any reviewer + `APPROVED` => clear the bulletin row.

  The shape predicate is `gh pr view <N> --json files` plus a check whether every returned path lies under `<project>/designs/`; the steward does not re-implement the predicate (see `roles/judge/AGENT.md` § Panel-kind discrimination for the canonical wording). The steward (not the contractor) acts on these events even on contractor-opened PRs; see `roles/steward/AGENT.md` § Maintainer-feedback response § Ownership for the rationale.

- `PullRequestReviewEvent/edited|dismissed` — **quiet**. Edits to a prior review are typically maintainer-side polishing; dismissals are rare and the steward will see the next review-state transition.

- `PullRequestReviewCommentEvent/created` — **quiet**. The parent `PullRequestReviewEvent` (when the review is submitted with the comments) carries the routing signal. Standalone inline comments without a containing review are rare on this repo and the steward picks them up via the review-queue daemon's *Pending kriskowal reviews* bulletin section anyway.

- `IssueCommentEvent/created` — **conditionally loud**. Per the 2026-05-29 widening, every commenter on this repo is treated as maintainer-equivalent for the rules below.
    - On an open PR: journal a `tick` if the comment body matches one of the authorization-grant patterns (currently: identity switches, write-access grants, "do not open a PR upstream" constraints, maintainer `/<command>` directives that route to a role). The [endojs/endo-but-for-bots#109#issuecomment-4436075344](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4436075344) grant is the prototype. Surface to the bulletin's *Pre-staged authorizations* section per the steward's existing pattern.
    - On an open PR without the authorization-grant shape: **quiet by default at the event level**. The comment's body is still picked up by `skills/at-mention-surveillance/SKILL.md` for `@kriscendobot` and `@kriskowal` content-level routing, which under the per-repo override fires the matrix's `@kriscendobot` rows regardless of author. Event-level "quiet" here means "do not add a bulletin row from the event alone"; the content-level surveillance is the dispatch trigger.
    - On a closed PR or an issue: **quiet** unless the issue number matches a row in the bulletin's *PR backlog* or *Awaits maintainer decision*, in which case a one-line `tick`.

- `IssuesEvent/opened` — **loud**. New issues may need a role dispatch (a designer for a design issue, a scout for a benchmark, a fixer for a bug repro request). The steward decides; the monitor's job is to make sure the steward sees it.

- `IssuesEvent/reopened|closed` — **conditionally loud**. Surface if the issue matches a backlog row; otherwise quiet.

- `IssuesEvent/edited|assigned|labeled|unlabeled` — **quiet**.

- `CreateEvent` / `DeleteEvent` (branches/tags) — **quiet**. These are the natural byproducts of merges and feature-branch cleanup. Rare exception: a `DeleteEvent` for a branch that the bulletin records as the head of an open PR is loud, because that means the PR is about to be closed (or the actor made a mistake the maintainer needs to see).

- `ReleaseEvent` — **loud**. Releases on this repo would be a significant signal; none are expected at this stage of the project, so a tick gives the steward a chance to surface to the maintainer.

- `ForkEvent`, `WatchEvent`, `MemberEvent` — **quiet**.

- Other event classes — surface as a `message` to `liaison` with the raw type and a one-line context; do not silently drop.

### Cross-repo erights note

Under the 2026-05-29 widening (see *Recognized maintainers* above), erights events on `endojs/endo-but-for-bots` route as any commenter's: maintainer-equivalent regardless of topic. No topic-match heuristic applies on this repo.

The topic-scoped erights treatment is **unchanged on `endojs/endo`**, where the sibling skill `skills/monitor-endo/SKILL.md` consults [`journal/projects/endo/README.md`](../../../journal/projects/endo/README.md) § Authority structure for the canonical topic list (`pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`, `captp`, `patterns`, the OCapN-family protocol, capability-security) and the topic-match heuristic that consumes it. Do not assume the widening on this repo extends there.

## Notes from the field

(append dated entries as reaction rules are learned)

- 2026-05-13 — Initial reaction rules landed from the monitor's first proposal (`journal/entries/2026/05/13/023053Z-message-monitor-b8bb4a.md`), following a backfill tick that surfaced seven event classes against an all-`(unset)` skill. The framing turns on the repo being the active bot-evolution surface: the maintainer already sees GitHub notifications, so the monitor's job is to detect events that change which role the steward should dispatch next, not to mirror review activity into the bulletin. PR review state routes to fixer / clear-backlog / fixer-with-authorization per kriskowal's `CHANGES_REQUESTED` / `APPROVED` / `COMMENTED`. `IssueCommentEvent` from kriskowal with an authorization-grant shape (identity switches, write-access grants, no-PR-upstream constraints) surfaces to *Pre-staged authorizations*; the endo-but-for-bots#109 grant is the prototype, and the pattern waits for more examples before factoring out into its own skill.
- 2026-05-13 — `jcorbin` added to the recognized-maintainer set per kriskowal's directive at `endojs/endo-but-for-bots#148` ("Josh is a maintainer on endo-but-for-bots"). The `PullRequestReviewEvent` and `IssueCommentEvent` rule rows now resolve "recognized maintainer" as either `kriskowal` or `jcorbin` rather than `kriskowal` alone. Recognition is repo-scoped; the parallel `skills/monitor-endo/SKILL.md` was deliberately not changed, because the maintainer's directive named endo-but-for-bots specifically and no journal evidence places `jcorbin` as a maintainer on `endojs/endo`. The distinction between maintainer authority (repo-wide, every topic) and senior-contributor authority (topic-scoped; erights on the listed subsystems) is preserved: jcorbin's recognition is the former, not the latter.

- _2026-05-29_: Recognized-maintainer set widened to every commenter on this repo, per kriskowal's 2026-05-29 directive. The repository's GitHub permission gate already restricts commenting, reviewing, and PR-opening to users with maintainer access, so the monitor's prior `kriskowal`/`jcorbin`-only matching was a redundant inner gate. The `PullRequestReviewEvent` and `IssueCommentEvent` rows now read "any reviewer" / "every commenter," and the prior *Senior contributors* subsection with its topic-match heuristic is retired for this repo (collapsed into a cross-repo erights note that points at `skills/monitor-endo/SKILL.md`). Precipitating case: kumavis's `@kriscendobot review this pr` on [endojs/endo-but-for-bots#328](https://github.com/endojs/endo-but-for-bots/pull/328) (steward message `b8c2d3` at `journal/entries/2026/05/29/015400Z-message-steward-b8c2d3.md`). The named non-exhaustive list (kriskowal, jcorbin, kumavis, erights, danfinlay, 0xpatrick) lives on the project README; this skill cites the README rather than carrying its own copy. Repo-scoped to `endojs/endo-but-for-bots`; `skills/monitor-endo/SKILL.md` is unchanged.

- _2026-05-29_: `PullRequestReviewEvent` row sub-rules split by PR shape (source-touching vs design-only) per the steward's missed kriskowal-COMMENTED review on PR #376 at 05:01:20Z (gap surfaced at 05:29Z, 28-minute lag). The prior row dispatched `fixer` universally for `COMMENTED`, but PR #376 was a design-only PR where designer (not fixer) is the right response role. The split routes design-only PRs to a designer-with-feedback dispatch and source-touching PRs to the existing fixer path; the discrimination predicate is the same one the judge applies for panel-kind selection. The row also cross-links `roles/steward/AGENT.md` § Maintainer-feedback response (added in the same gardener engagement) for the ownership rule (steward, not contractor, even on contractor-opened PRs). Precipitating dispatch: `journal/entries/2026/05/29/053130Z-dispatch-steward-f9a0b1.md`.
