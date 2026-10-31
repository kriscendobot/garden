I applied the round-3 must-fix items to endojs/endo-but-for-bots PR #1596 and pushed. CI is green: 35 of 35 checks passed, none failed. One loose end: this host can't edit endojs PR bodies, so the PR-body trims haven't landed yet. A job pinned to the endolin host is posted to apply them.

**What I worked from:** there was no pre-pass block, so I used the latest panel verdict, the `Must-fix before merge` comment review from 2026-10-31T20:26Z. It had four request-changes seats: changeset-auditor, pruner, coverage-auditor and decomplector.

**Pushed** two commits to `build/m3-mvs-resolver-reference`, moving the head from `8526e375e` to `3eaff5678` through `safe-push-pr-head.sh --mode advance`:

1. `refactor(exo-npm): group ranges by shared satisfying version, not a slot key`
   - **decomplector #1:** I removed the `parseRangeMajor` slot key, the per-range slot map and the split-prefix keys. A range now joins the earliest group where some published version satisfies it together with that group's ranges; otherwise it starts a new group. `parseRangeMajor` is also gone from `index.js`, and nothing outside the package used it.
   - **One behaviour change to know about:** ranges that can share a version now always share one. For example, `^1.0.0 || ^2.0.0` followed by `^2.0.0` resolves to a single version, where the old code could produce two.
   - **decomplector #2:** `satisfiesRange` alone now decides when a pre-release is allowed, and the selection step no longer has its own regex filter. That means the peer and workspace-mismatch checks now reject a pre-release unless the range names one, as npm does.
   - **decomplector #3:** the module header now says why the semver code is written by hand: it depends on nothing beyond `@endo/errors` and runs under SES and XS.
   - **pruner #1–6:** I cut the comments and JSDoc that restated the code.
   - **coverage-auditor #1–3:** new tests cover pre-release identifier ordering (numeric vs. alphabetic identifiers, prefix length, alphabetic order), a union sharing one version with a later range, the `workspaceMismatches` entry with `from` stripped, and a failed optional tarball fetch landing in `unmetOptionals`.
   - The note in `designs/mvs-resolver.md` that described `parseRangeMajor` now describes the grouping.
2. `docs(exo-npm): add changeset for MVS resolver selection fixes`
   - **changeset-auditor:** new file `.changeset/exo-npm-mvs-least-satisfying.md`, `@endo/exo-npm: minor`. I chose minor rather than the auditor's suggested patch because it records the removed `parseRangeMajor` export, which counts as breaking on a 0.x package. The package is private, but the changeset config versions private packages, and the package already has a 0.1.0 changelog entry.

**Checks:** `yarn test` passes (64 tests, 35 in the resolver file) and `yarn lint` (tsc + eslint) exits 0.

**Not done here:**
- **PR body (pruner #7–10):** `gh pr edit` and a direct REST edit both got 403 from this host's bot token. I posted `endojs-endo-but-for-bots-pr1596-gauntlet-fix-3-pr-body`, pinned with `requires: host=endolin-garden-ece02cb4`, with the trimmed body included word for word. The trimmed body drops the case-by-case test list, the duplicate "Known limits" and pruning text, and the stale slot-key wording, and it names the new changeset. The PR body still shows the old text until that job runs.
- **coverage-auditor #4** (a cached offline entry with no `packageJson` snapshot) was marked `follow-up` and is not addressed.

I added a dated line to the memory note about this host's token being unable to write to endojs PRs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1596-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3831953 cached reads)
- Output: 23714 tokens
- Cost: $2.1593185999999998
- Wall-clock: 2871s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
