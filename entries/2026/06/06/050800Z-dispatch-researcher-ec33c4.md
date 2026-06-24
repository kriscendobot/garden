---
ts: 2026-06-06T05:08:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--ec33c4
refs:
  - https://github.com/endojs/endo
  - https://github.com/endojs/endo-but-for-bots
---

# dispatch: researcher — sync upstream master into bot llm branch via PR

The downstream builder will be dispatched with the prompt below. Your
task is to walk `journal/library/` and `journal/projects/endo-but-for-bots/`
for any context that would help the builder do this work well and
return your standard `## Library and project references` section the
steward will inline into the builder's brief.

## Proposed downstream builder prompt

> User directive (2026-06-06): *"Please dispatch a subagent to merge
> actual/master into bots/llm for a PR to merge the branches, then
> shepherd that PR through CI."* "actual" = `endojs/endo`; "bots" =
> `endojs/endo-but-for-bots`; "llm" is the bot fork's roadmap branch.
>
> State at dispatch time:
> - **Upstream master** (`endojs/endo@master`): `4a04d078`.
> - **Bot master** (`endojs/endo-but-for-bots@master`): `5865ff10`
>   (behind upstream by some commits; a fixer earlier this cycle
>   synced it but upstream has moved since).
> - **Bot llm** (`endojs/endo-but-for-bots@llm`): `2bd9e0cb`,
>   1290 commits ahead of bot master, 7 commits behind in the other
>   direction (the standard llm-vs-master divergence for the
>   roadmap branch).
> - Twenty-plus open PRs target `llm` as their base.
>
> Task: produce a PR on the bot fork whose base is `llm` and whose
> head is a sync branch carrying the merge of `endojs/endo@master`
> into `llm`. Open the PR DRAFT; CI will be driven by a follow-on
> shepherd dispatch.

## What you should look for

- Any past `journal/projects/endo-but-for-bots/` entries about
  master-into-llm merges, sync PRs, or the llm branch's general
  hygiene discipline.
- Any conflict-resolution patterns the maintainer has documented for
  the master/llm boundary (which side wins for which file kind).
- Any `journal/library/` keywords on "llm branch", "roadmap branch",
  "sync PR", "merge commit", "branch hygiene" worth surfacing.
- Whether the bot fork has a convention for the sync-branch naming
  (e.g., `sync/master-into-llm-YYYY-MM-DD`).
- Any standing PR-shape constraints on PRs targeting `llm`: frozen-
  base-branch convention, `gh pr create --draft` discipline,
  particular labels or templates.
- Whether the project has a recurring cadence or single-shot
  treatment of this merge (so the builder can name the PR in the
  established pattern rather than inventing one).

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the standard
`## Library and project references` section. The steward will inline
that section verbatim into the builder's dispatch brief, before the
*Acceptance* and *Report* sections.

Keep your dispatch under three minutes wall time. No project
worktree was prepared (journal-and-library work only).
