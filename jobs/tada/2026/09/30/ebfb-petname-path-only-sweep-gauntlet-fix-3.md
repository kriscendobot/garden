Fix round 3 on endojs/endo-but-for-bots#1390 is pushed and CI is green, 33 of 33 checks (head `257db20fe5`).

The round-3 verdict reused the panel record for head `09350117e6`, and later commits (`e405bbe6cd`..`9d3fb4f125`) had already fixed most of its must-fix items. Checked against the current head, these were already done:
- The adopt, send and evaluate calls in fae, jaine, chat, space-whylip and space-file-explorer now pass paths as arrays.
- The stale JSDoc and `@returns` types are fixed, and the `ReadableNameHub` types and help text are narrowed to arrays.
- The `lal` argument is renamed to `petNamePath`, and the new test's `db` local is now `database`.
- The changeset bumps `@endo/sandbox` and `@endo/agentry` to major and now lists space-whylip.
- The over-long doc comments the pruner flagged are trimmed.

What I added this round:
- **`abaf878461`**: renamed the remaining `…OrPath(s)` parameters in the daemon's `host`, `mail`, `manager`, `guest` and `directory` source files to `…Path(s)`, since those parameters now take arrays only (stylist and purist findings). Where the new name would clash with an existing local, the raw argument is named `pathArgument` or `…PathArgument`. `endowmentIdsOrPaths` and `formulaIdOrPath` keep their names because those values really can be either an id or a path.
- **`257db20fe5`**: added a test that `makeUnconfinedFromTree` refuses a bare-string worker name before it stages anything (prover finding).
- **PR body**: it now says why the mount and `@endo/platform` fs surface still accept a string, and how this PR relates to #1343 (integrator findings).
- **Follow-up job**: parked `ebfb-platform-fs-pet-name-path-only` on the board, blocked on #1390, to extend the array-only rule to the platform fs surface.
- **Summary comment** posted for the scribe seat: https://github.com/endojs/endo-but-for-bots/pull/1390#issuecomment-5919095906

Checks: eslint (0 errors) and `tsc` pass on `@endo/daemon`. I couldn't run the daemon test suite locally because ava isn't installed in this worktree, so the new test has only been run in CI.

Not done: the integrator suggested regrouping the roughly 40 commits into one per package. That would mean rewriting pushed history with a force-push, and it's a should-fix, so I left it for the maintainer to decide or for a squash merge.

Follow-up for the maintainer: the parked `ebfb-platform-fs-pet-name-path-only` job becomes claimable once #1390 merges or closes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3469173 cached reads)
- Output: 16799 tokens
- Cost: $1.8172945999999999
- Wall-clock: 2057s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
