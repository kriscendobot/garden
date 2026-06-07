---
ts: 2026-06-07T06:07:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--df145e
refs:
  - https://github.com/endojs/endo/pull/3226
  - https://github.com/endojs/endo-but-for-bots/pull/57
---

# dispatch: researcher — duplicate endo#3226 onto bot llm branch

User directive (2026-06-07): *"Please create a duplicate of
https://github.com/endojs/endo/pull/3226 except based on the llm
branch."* The bot fork already has a master-based mirror (PR #57,
branch `kriskowal-marshal-binary` at upstream tip 0b55322 + fixup
abc1010); the user wants a separate llm-based duplicate.

The downstream builder will be dispatched with the prompt below.
Your task is to walk `journal/library/` and
`journal/projects/endo-but-for-bots/` for any context that would
help the builder do this work well and return your standard
`## Library and project references` section.

## Proposed downstream builder prompt

> User directive: duplicate `endojs/endo#3226`
> (`feat(marshal,pass-style): admit immutable ArrayBuffer through
> codecs`, branch `kriskowal-marshal-binary`, head `abc1010` from
> 2026-05-12) onto the bot fork's `llm` (roadmap) branch.
>
> Upstream PR has 2 commits (`0b55322` feat + `abc1010` fixup
> squash candidate) and touches 16 files. The bot fork already has
> a master-based mirror at PR #57 (branch
> `kriskowal-marshal-binary`); the user wants a parallel
> duplicate based on `llm`.
>
> Open a new PR on the bot fork with base `llm`, head a fresh
> branch like `kriskowal-marshal-binary-llm` (or `feat/marshal-
> binary-on-llm`), DRAFT, cherry-pick or merge the 2 upstream
> commits onto current llm, resolve conflicts, push, open PR.

## What you should look for

- Past mirror-into-llm vs mirror-into-master patterns — when has
  the maintainer asked for a parallel duplicate on the roadmap
  branch?
- The 2026-05-15 / 2026-05-21 / 2026-06-03 / 2026-06-06 master-
  into-llm sync precedents (the conflict surface, the merge-not-
  rebase rule for an 1290-commits-ahead branch) — relevant if
  the 2 upstream commits hit similar conflict surfaces.
- Whether the bot fork's PR #57 (the master-based mirror) carries
  any branch-specific commits or feedback that should NOT travel
  to the llm-based duplicate (per the user's "based on the llm
  branch" framing — the duplicate should be of upstream, not of
  PR #57).
- The standard PR-shape constraints on PRs targeting `llm`
  (frozen-base-branch convention? labels? draft discipline?).
- Whether the project has a convention for naming "duplicate
  PRs against a different base" (the master-based mirror is
  `kriskowal-marshal-binary`; what's the llm-based variant's
  naming convention?).
- Whether there's a precedent for using `frozen-base-branch`
  (the dependent's base would be `llm-<sha>` of the moment) vs
  the live `llm` directly — the prior researcher's finding on
  the 2026-06-06 master-into-llm sync was that frozen-base does
  NOT apply to sync-into-llm PRs; check whether the same logic
  applies here.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section. The
steward will inline that section verbatim into the builder's
dispatch brief.

Keep your dispatch under three minutes wall time. No project
worktree was prepared (journal-and-library work only).
