---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# weave directive on endojs/endo-but-for-bots PR #987

Map: **weave** → rebase the PR head onto its base and resolve conflicts so CI can dispatch.

PR: https://github.com/endojs/endo-but-for-bots/pull/987
Title: design(endor): bind libgit2 with Zig cross-builds
Head: design/endor-git-bindings-zig  Base: llm  Head SHA: f265f98c10253fda22114ae91a8fc1c31fc19a4a

## Why

The PR is `mergeable: false` / `mergeable_state: dirty` (no merge ref, `statusCheckRollup: []`).
While a `pull_request` PR conflicts with its base, GitHub creates no synthetic merge
ref and dispatches no workflow runs, so CI can never turn green. A shepherd cannot
push its way out of this (per roles/shepherd/AGENT.md § "Conflicting PRs block CI
dispatch"); resolving the conflict is a weaver's job.

The PR touches only two design markdown files — `designs/README.md` and
`designs/endor-git-bindings.md` — so the conflict is almost certainly the
`designs/README.md` index (a file many PRs append to). Expect a mechanical
rebase/weave onto `llm` resolving the index ordering.

## Done when

Head no longer conflicts with `llm` (`mergeable_state != dirty`) and CI dispatches
on the rebased head. After the weave clears the conflict, CI should be re-verified
(a fresh shepherd) — but the immediate blocker is conflict resolution.

Source: shepherd handoff from endojs-endo-but-for-bots-pr987-shepherd
(review https://github.com/endojs/endo-but-for-bots/pull/987#pullrequestreview-4968601303, [APPROVED]).
