---
role: fixer
---
# fixer on kriscendobot/agoric-sdk PR #14 — regenerate chain-info baggage snapshots

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-33
issue_url: https://github.com/kriskowal/garden/issues/33#issuecomment-4910381116
submitter: kriskowal
----- END ISSUE NOTE -----

**Fork only — never touch upstream Agoric/agoric-sdk.** All work stays on
`kriscendobot/agoric-sdk`.

PR: https://github.com/kriscendobot/agoric-sdk/pull/14
Head branch: kriskowal-park-on-upgrade-failure (bot-pushable)
Head SHA at posting: 5ca9d1253 (run 29084779242, completed/failure)

## Root cause (already diagnosed — same class as PR #13)
The PR #14 shepherd cleared the red `test-codegen` check by committing a
`yarn codegen` refresh of `packages/orchestration/src/fetched-chain-info.js`
(commit 5ca9d1253, additive IBC data: injective-1, cosmoshub-4, celestia, ...).
That data flows into every chainHub-using contract's baggage, but the
downstream AVA snapshots were NOT regenerated, so the next matrix run failed
with `t.snapshot()` diffs (verified in the log of `test-portfolio-contract
(node-old)`: `- 'agoric-3_injective-1': Object {…}` in "initial baggage").

Genuine failures on run 29084779242 (the other 8 are fail-fast cancellations):
- test-quick (node-old)
- test-quick2 (node-old)
- test-portfolio-contract (node-old) — `portfolio.contract › initial baggage`
- test-boot (xs, 2, 4)

## The work
Regenerate the chain-info-dependent snapshots on the PR #14 head branch
(`yarn test --update-snapshots` in each affected package, then commit the
updated `test/snapshots/*.md` + `*.snap` and push). Expected suite list (same
family as PR #13's diagnosis — re-grep the live run for the full set):
- packages/fast-usdc-contract — `fast-usdc.contract` baggage
- packages/portfolio-contract — `portfolio.contract` initial baggage
- packages/orchestration / send-anywhere example — `send-anywhere › baggage`
- packages/boot — `vstorage-chain-info › config`

A peer fixer is doing the IDENTICAL regen on PR #13's branch
(`kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots`, in doin/ as of this
posting). Check its state before starting: if it has a tada/ report, reuse its
verified procedure (and note whether snapshot content is branch-specific — PR
#14 carries SwingSet park-on-fail changes, PR #13 the xsnap variant split, so
regenerate on THIS branch rather than cherry-picking snapshot files). Its
inbox key is `kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots` if you need
to coordinate while it is still alive.

NOTE — out of scope, do NOT try to fix: `test-ymax-planner-build` fails with
`permission_denied: Invalid token` on `depot build` (missing DEPOT_TOKEN on the
fork). Fork infrastructure limitation, expected-red on any fork PR. Leave it.

After pushing, watch CI to convergence on the new head: the four suites above
green (plus their cancelled siblings), no new regressions.
