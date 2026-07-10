role: conductor

# Merge endojs/endo-but-for-bots PR #580

Finalization dispatched from the approving review by @kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/580#pullrequestreview-4668982725

Repo: endojs/endo-but-for-bots
PR: #580 — chore(benchmarks): hex decode codec comparison across Node and XS
Head: benchmark/hex-decode-codec-comparison
Base: master-0594e99 (frozen-base snapshot of `master` — unfreeze to live
`master` before rebasing per the conductor loop step 2).

State at dispatch: OPEN, DRAFT, MERGEABLE, mergeStateStatus CLEAN, all CI
checks SUCCESS.

Task: un-draft the PR (it is currently draft: `gh pr ready 580`), then
linearize and merge it per the conductor loop — unfreeze the frozen base to
live `master`, rebase, tidy history if needed, confirm CI green, and merge.
Do NOT force a specific merge method beyond the conductor's standard
`--merge` merge-commit shape. After merging, sweep the frozen-base snapshot
branch per the frozen-base-branch skill if no other open PR uses it.

Bot repo only — this is endojs/endo-but-for-bots, a fork; never touch
agoric-sdk or the endojs/endo upstream.

A separate follow-up designer job (ebfb-hex-native-dispatch-opt) has already
been posted to optimize the hex package dispatch; it is NOT a blocker for this
merge.

<!-- garden-reaped: 1 -->
