---
ts: 2026-05-19T02:40:09Z
kind: message
role: steward
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/19/023710Z-result-fixer-b9833b.md
  - entries/2026/05/19/023450Z-dispatch-steward-80d79d.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: target
---

# Two follow-ups from PR #288 second-directive engagement

## (1) Gardener directive: revise fixer standing instructions

kriskowal on PR #288 at `02:33:50Z`: *"Please revise your standing
instructions as a fixer to always check the PR description and title
match the changes."*

This is meta-evolution (role-file edit) and outside the steward's
authority bounds. Routing to liaison for the gardener to land. Proposed
shape:

- Add a bullet to `roles/fixer/AGENT.md` § Operating norms (or
  `skills/review-feedback-followup-commits/SKILL.md` § Followup
  commits, whichever is the better home) along the lines of:
  *"When a follow-up commit changes the PR's package name, file paths,
  exported identifiers, or other surface attributes, confirm the PR
  title and description still describe the post-commit state. Update
  via `gh pr edit ... --title/--body` if they drift, and cite the
  edit in the reply on the addressing comment."*
- Reference the precipitating incident: the renamed-cbors engagement
  (`8dd58b` fixer result for the rename; `b9833b` follow-up fixer
  result for the title/description).
- The PR-creation-flow's `pre-pr-checklist` skill might also want a
  parallel rule on the *opening-side* (cleaner / judge confirm title +
  body match the diff before un-drafting), since the gap can also
  arise at PR-open time.

The maintainer's framing is general ("always check") so the rule
applies to every fixer dispatch where a commit changes naming
surface. Wording details belong to the gardener.

## (2) Branch-drift on changeset file (PR #288, in-scope follow-up)

The fixer dispatch (`e3d95e`) on the title/description edit surfaced
that the changeset file on the branch is still
`.changeset/add-endo-cbors.md` with inner YAML key
`'@endo/cbors': minor` and prose referencing the old names. The PR
description now describes the post-rename state, but the changeset
file itself is stale — a real source-of-truth drift the prior rename
fixer (`8dd58b`) missed (despite renaming `add-endo-cbors.md` to
`add-endo-cbor-frame.md` per its own report; possible the rename was
incomplete or got reverted; worth a quick git-log diff).

This is a clear fixer-stage cleanup. Liaison should post one of:

- `verb: fix target: pr=288` job with the diagnosis inlined (rename
  `.changeset/add-endo-cbors.md` to
  `.changeset/add-endo-cbor-frame.md`, update inner YAML key from
  `'@endo/cbors': minor` to `'@endo/cbor-frame': minor`, update
  prose).

This composes nicely with (1): if (1)'s rule had been in place, the
prior fixer would have caught the changeset drift during the rename
engagement.

Self-improvement: the gap pattern from (1) and (2) is consistent —
fixer-stage edits whose surface changes aren't propagated to all
satellite artifacts (PR description, changeset file, related design
docs). A single rule covers both. The fixer that just ran (`b9833b`)
also surfaced the syrup-design-doc cross-references on the `llm`
branch that still reference `@endo/cbors` as predating-this-PR; the
rule should distinguish "PR's own surface" from "neighbouring artifacts
on other branches" so the rule doesn't push every fixer to chase wide
ripples beyond the PR's scope.
