# weaver directive on endojs/endo-but-for-bots PR #544

Map: **weaver** → resolve the merge conflict so the PR is no longer CONFLICTING.

Source: shepherd verdict on PR #544 (`endojs-endo-but-for-bots-pr544-shepherd`).
PR: https://github.com/endojs/endo-but-for-bots/pull/544
Head: design/intra-package-plain-re-exports @ ff8e7c20cf0f3dc863fdd5e35c9f93c0971de8a5
Base: llm @ 66f0a4a244345606aa2608ea08b51493386585b5

## Why a weaver is needed

PR #544 is a design-only PR (`designs/intra-package-plain-re-exports.md` +
`CONTRIBUTING.md`). It carries **no CI matrix** (`statusCheckRollup: []`), so a
shepherd has nothing to drive to green. Its merge-blocking state is
`mergeable: CONFLICTING` / `mergeStateStatus: DIRTY`: base `llm` advanced past
the PR's merge-base (`27f53e6196590412941295969afe0b9838987522`) and is no
longer an ancestor of the head.

A clean `git merge origin/llm` onto the head conflicts in exactly one file:

- **`CONTRIBUTING.md`** — content conflict (both sides edited; likely #543's
  CONTRIBUTING.md edits landed on `llm`). `designs/intra-package-plain-re-exports.md`
  merges cleanly.

## Task

Rebase the head onto current `llm` (or merge `llm` in), resolving the
`CONTRIBUTING.md` conflict so both the base's and the PR's CONTRIBUTING.md edits
survive. After the conflict clears, the PR is APPROVED (erights LGTM) and DRAFT —
hand back so it can be un-drafted and merged (conductor).

## Context (not part of this job)

erights also asked, separately: "Please write the mechanical follow-on PR that
this PR describes." That is a builder follow-on, tracked separately from this
weave.
