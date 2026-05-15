---
created: 2026-05-12
updated: 2026-05-15
author: gardener, liaison, monitor
---

# Skill: monitor-endo-but-for-bots

Per-event-class reaction rules for the [monitor](../../roles/monitor/AGENT.md) when dispatched against `endojs/endo-but-for-bots`. The base role and its polling discipline live in `roles/monitor/AGENT.md` and `skills/github-activity-poll/SKILL.md`; this skill is consulted on each `NEW`-line wake to decide whether and how to react.

This skill handles **event-level** surveillance (who acted, when, on what). Its sibling [`skills/at-mention-surveillance/SKILL.md`](../at-mention-surveillance/SKILL.md) handles **content-level** surveillance (what the comment body said, specifically scanning for `@kriscendobot` and `@kriskowal` routing intent). The two compose; rules below that mention "the comment body" describe an event-level decision (e.g. "does the body match an authorization-grant pattern?") and do not subsume the content-level @-mention scan, which runs as the steward's third parent-context Monitor per `roles/steward/AGENT.md` § Parent-context Monitor invariants.

## Recognized maintainers

The maintainer set on this repo is `kriskowal` and `jcorbin`. A review or comment from either routes the same way: maintainer-equivalent authority on every PR in this repo, no topic scope. Wherever a rule row below names `kriskowal`, read it as "any recognized maintainer" and substitute either login. Recognition of `jcorbin` was added 2026-05-13 per kriskowal's directive at `endojs/endo-but-for-bots#148` ("Josh is a maintainer on endo-but-for-bots"); the recognition is repo-scoped and does not extend to `endojs/endo` absent explicit maintainer confirmation. Maintainer authority is distinct from senior-contributor authority (see the *Senior contributors* subsection below): maintainers carry repo-wide authority across every topic, while senior contributors carry topic-scoped authority that meets or exceeds maintainer weight on the technical question within their topic set.

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

- `PullRequestReviewEvent/created|submitted` — **loud** with `state` (`APPROVED`, `CHANGES_REQUESTED`, `COMMENTED`) and actor. The steward routes (where "recognized maintainer" = `kriskowal` or `jcorbin` per the *Recognized maintainers* section above):
    - recognized maintainer + `CHANGES_REQUESTED` => fixer (per `roles/COMMON.md` § fixer);
    - recognized maintainer + `COMMENTED` with non-trivial body => fixer with the per-action authorization the maintainer pre-stages (otherwise journal-only);
    - recognized maintainer + `APPROVED` => clear the bulletin row;
    - other reviewers => journal only, no role dispatch (subject to the *Senior contributors* subsection below for topic-matching senior-contributor events).

- `PullRequestReviewEvent/edited|dismissed` — **quiet**. Edits to a prior review are typically maintainer-side polishing; dismissals are rare and the steward will see the next review-state transition.

- `PullRequestReviewCommentEvent/created` — **quiet**. The parent `PullRequestReviewEvent` (when the review is submitted with the comments) carries the routing signal. Standalone inline comments without a containing review are rare on this repo and the steward picks them up via the review-queue daemon's *Pending kriskowal reviews* bulletin section anyway.

- `IssueCommentEvent/created` — **conditionally loud**.
    - On an open PR: journal a `tick` if the actor is a recognized maintainer (`kriskowal` or `jcorbin`) and the comment body matches one of the authorization-grant patterns (currently: identity switches, write-access grants, "do not open a PR upstream" constraints, maintainer `/<command>` directives that route to a role). The [endojs/endo-but-for-bots#109#issuecomment-4436075344](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4436075344) grant is the prototype. Surface to the bulletin's *Pre-staged authorizations* section per the steward's existing pattern.
    - On an open PR by any other actor, or by a recognized maintainer without the authorization-grant shape: **quiet**. Maintainer comments are GitHub-notification-covered; others' comments rarely drive role dispatch (subject to the *Senior contributors* subsection below for topic-matching senior-contributor comments).
    - On a closed PR or an issue: **quiet** unless the issue number matches a row in the bulletin's *PR backlog* or *Awaits maintainer decision*, in which case a one-line `tick`.

- `IssuesEvent/opened` — **loud**. New issues may need a role dispatch (a designer for a design issue, a scout for a benchmark, a fixer for a bug repro request). The steward decides; the monitor's job is to make sure the steward sees it.

- `IssuesEvent/reopened|closed` — **conditionally loud**. Surface if the issue matches a backlog row; otherwise quiet.

- `IssuesEvent/edited|assigned|labeled|unlabeled` — **quiet**.

- `CreateEvent` / `DeleteEvent` (branches/tags) — **quiet**. These are the natural byproducts of merges and feature-branch cleanup. Rare exception: a `DeleteEvent` for a branch that the bulletin records as the head of an open PR is loud, because that means the PR is about to be closed (or the actor made a mistake the maintainer needs to see).

- `ReleaseEvent` — **loud**. Releases on this repo would be a significant signal; none are expected at this stage of the project, so a tick gives the steward a chance to surface to the maintainer.

- `ForkEvent`, `WatchEvent`, `MemberEvent` — **quiet**.

- Other event classes — surface as a `message` to `liaison` with the raw type and a one-line context; do not silently drop.

### Senior contributors (erights et al.)

The endo-but-for-bots project README's *Authority structure* section (`journal/projects/endo-but-for-bots/README.md` § Authority structure on the `journal` branch) names erights as a senior contributor whose authority meets or exceeds kriskowal's on a defined topic set. The monitor surfaces accordingly:

- A `PullRequestReviewEvent`, `PullRequestReviewCommentEvent`, or `IssueCommentEvent` from `erights` (login matches the GitHub account, verified by `gh pr view` if ambiguous) on a **topic-matching PR** is **loud** and routes a `message` to `liaison`. Do not auto-dispatch a fixer; that remains a kriskowal-directive privilege per `roles/COMMON.md` § External-repo etiquette.
- On a PR that is **not** topic-matching, an erights event downgrades to the row that would otherwise apply (typically quiet for review events from non-maintainer reviewers; see the `PullRequestReviewEvent` row above).
- The rule defers to the project README's *Authority structure* section for the canonical topic list and the practical-rule framing; do not duplicate the list here.

**Topic-match heuristic (keyword-first with file-path fallback):**

1. **Keyword check (cheap, daemon-payload-friendly).** On wake, look at the PR title (for `PullRequestEvent`-derived rows the daemon line carries it; otherwise `gh pr view <N> --json title,labels`). The PR is topic-matching if the title or any label contains any of: `pass-style`, `ses`, `hardened`, `harden`, `marshal`, `pattern`, `eventual-send`, `captp`, `ocapn`, `capability`. Case-insensitive substring match.
2. **File-path fallback (if keyword check is inconclusive).** Run `gh pr view <N> --json files --jq '.files[].path'`. The PR is topic-matching if any path is under `packages/{pass-style,ses,marshal,patterns,eventual-send,captp,hex}/`.
3. **Result.** Topic-matching if either step matches; otherwise not.

The keyword step works from the daemon-line payload alone; the file-path step covers PRs whose title is generic (a refactor, a typo fix) but whose diff touches a topic package. If a real event reveals the heuristic is wrong, capture the fix in the *Notes from the field* row below.

This rule supersedes the prior baseline where non-maintainer reviews were silent regardless of reviewer. The 2026-05-13 baseline that silently swallowed an erights `PullRequestReviewEvent/updated#69` (recorded in `journal/entries/2026/05/13/062434Z-result-steward-0a91d5.md` on the `journal` branch) is the precipitating example. Per the dispatch that landed this rule, prior swallowed events are not re-processed; the rule takes effect for future events.

## Notes from the field

(append dated entries as reaction rules are learned)

- 2026-05-13 — Initial reaction rules landed from the monitor's first proposal (`journal/entries/2026/05/13/023053Z-message-monitor-b8bb4a.md`), following a backfill tick that surfaced seven event classes against an all-`(unset)` skill. The framing turns on the repo being the active bot-evolution surface: the maintainer already sees GitHub notifications, so the monitor's job is to detect events that change which role the steward should dispatch next, not to mirror review activity into the bulletin. PR review state routes to fixer / clear-backlog / fixer-with-authorization per kriskowal's `CHANGES_REQUESTED` / `APPROVED` / `COMMENTED`. `IssueCommentEvent` from kriskowal with an authorization-grant shape (identity switches, write-access grants, no-PR-upstream constraints) surfaces to *Pre-staged authorizations*; the endo-but-for-bots#109 grant is the prototype, and the pattern waits for more examples before factoring out into its own skill.
- 2026-05-13 — `jcorbin` added to the recognized-maintainer set per kriskowal's directive at `endojs/endo-but-for-bots#148` ("Josh is a maintainer on endo-but-for-bots"). The `PullRequestReviewEvent` and `IssueCommentEvent` rule rows now resolve "recognized maintainer" as either `kriskowal` or `jcorbin` rather than `kriskowal` alone. Recognition is repo-scoped; the parallel `skills/monitor-endo/SKILL.md` was deliberately not changed, because the maintainer's directive named endo-but-for-bots specifically and no journal evidence places `jcorbin` as a maintainer on `endojs/endo`. The distinction between maintainer authority (repo-wide, every topic) and senior-contributor authority (topic-scoped; erights on the listed subsystems) is preserved: jcorbin's recognition is the former, not the latter.
