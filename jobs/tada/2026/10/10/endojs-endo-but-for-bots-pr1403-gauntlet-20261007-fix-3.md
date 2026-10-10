I applied both round-3 must-fix items to PR #1403 and pushed them. CI is green on the new head `e59b07369f`: 25 checks pass and 8 are skipped. The macOS legs failed on the first run and passed when re-run.

**Fixes** (two follow-up commits on top of `d4c2a27186`):
1. **`7ee2373846` — `makeProcessGroupKiller` removed** (decomplector). It repeated the process-group kill that `@endo/host-spawner` already provides, with a different error policy. I deleted it from `packages/inference/src/limits.js`, along with its five tests and its README mention. The README now says a process-spawning plugin uses `makeHostSpawner({ killProcessGroup: true })` and passes `terminate: () => proc.kill('SIGKILL')`.
2. **`e59b07369f` — `0.1.0` with a `major` changeset** (changeset-auditor). `packages/inference/package.json` went from `0.0.0` to `0.1.0`, and `.changeset/add-endo-inference.md` from `minor` to `major`, so the first publish is `1.0.0`. This follows the rule text in `skills/changeset-discipline/SKILL.md` § New-package initial release, which comes from the maintainer's directive on #513. No `yarn.lock` change was needed.

**Decision for the maintainer:** fix 2 undoes the round-2 curator must-fix, which asked for `0.0.0` + `minor` to match sibling packages such as `exo-shell`. The two jury seats disagree, and I followed the written rule. I said this in the summary comment on the PR (issuecomment-6096019352). If they want a release below 1.0, the version shape needs to be reverted.

**Verification:**
- **Local checks in `packages/inference`:** `ava` passes all 61 tests, `tsc` passes, `eslint` reports 0 errors, and `prettier --check` is clean.
- **First CI run:** both macOS test legs failed on the same `@endo/daemon` test, `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. `@endo/daemon` doesn't depend on `@endo/inference`, and both macOS legs passed on the previous head, so I treated it as a flake and re-ran the failed jobs once. Both passed. The daemon test may be flaky on macOS and could hit other PRs.
- **CI waiter:** after the re-run, `ci-wait-merge.sh` reported green while the two re-run legs were still pending, apparently because it read the check list before the re-run showed up. I polled `gh pr checks` directly until both passed. This looks like a waiter bug, and a follow-up job for it would make sense.

**Not addressed this round:** the should-fix items, which are `reportTerminateError`, the throwing `now()` in `usage-recorder.js`, and `exports` pointing into `src/`. The comment-only spelling notes are also untouched. The driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3866300 cached reads)
- Output: 12652 tokens
- Cost: $1.8244039999999995
- Wall-clock: 4954s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
