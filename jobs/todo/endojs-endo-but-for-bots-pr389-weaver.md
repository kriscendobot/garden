# weaver on endojs/endo-but-for-bots PR #389

Rebase the CONFLICTING stacked design PR onto its moved base so CI can re-dispatch.

PR: https://github.com/endojs/endo-but-for-bots/pull/389
Title: feat(gateway): admin daemon (#343 phase 3)
State: OPEN, DRAFT
Head: design/gateway-package-phase-3 @ d9cd2808151345760ceb06592085071c69b47e9d (unchanged since 2026-06-03)
Base: design/gateway-package-phase-2 @ 590cad28edfdd1444ddb45df35951e20d14b76ef (force-updated 2026-06-29)

## Diagnosis (from the shepherd auto-dispatch on red CI)

`gh api repos/endojs/endo-but-for-bots/pulls/389 --jq '{mergeable, mergeable_state}'`
=> `{"mergeable": false, "mergeable_state": "dirty"}`  ==> CONFLICTING.

The base branch (phase-2) was force-updated on 2026-06-29 while this PR's head
has sat since 2026-06-03. The branches now conflict, so GitHub creates no merge
ref and no `pull_request` workflow dispatches on new pushes. The only CI on the
board is the stale 2026-06-03 run (run 26912516832). A shepherd cannot drive CI
green through a conflict — pushing nudge commits does nothing while dirty. This
is a weaver task per roles/shepherd/AGENT.md "Conflicting PRs block CI dispatch".

## Weaver task

Rebase design/gateway-package-phase-3 onto the current design/gateway-package-phase-2
tip (590cad2), resolve conflicts, and push the head. Once the PR is no longer
dirty, CI re-dispatches and a follow-up shepherd can drive any remaining red green.

## Note for the follow-on shepherd (after the rebase)

The stale run showed one real test failure worth watching post-rebase:
`@endo/cache-map#test` — `TypeError: results.values(...).filter is not a function`.
It may already be resolved on the moved base, or may need a fixer if it persists
in this diff. Do not act on it until CI re-runs on the rebased head.

## Context caveat (surface to the maintainer, do not block on it)

The base PR (#388, phase-2) is CLOSED unmerged, and phase-1's PR is also closed.
The whole stacked gateway-package design series appears reorganized/abandoned.
The rebase gets CI green, but whether this DRAFT should ultimately live is a
liaison/maintainer call, not a weaver/shepherd one.

next: weaver
