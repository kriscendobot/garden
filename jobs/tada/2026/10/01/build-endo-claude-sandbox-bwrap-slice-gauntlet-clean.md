# Clean stage for endojs/endo-but-for-bots#1408: CI green on the rerun, no code changes

The PR is still a draft, and its head is `2d05ca3ef2`.

**Coverage:** I ran c8 + ava on `packages/claude` in an isolated checkout of the PR head.
- `src/bwrap-slice.js` is fully covered.
- `src/confined-turn.js` is at 93.5% lines. The only new lines left uncovered are the sandbox launch's "no broker or spawn files" guard (lines 220–222), which can't be reached in normal use. The other uncovered lines were already there before this PR (the default `connect`, the argument checks, the missing-credential throw).
- One test failed locally: `confined-turn › the confined process has no daemon socket…`. That's because c8 adds `NODE_V8_COVERAGE` to the environment, and the test checks that the environment is clean. It only happens under a local coverage run; the PR code itself is fine, and the CI `cover` jobs passed.

**Dead code:** The change orphaned nothing. The old inline `makeSpawnFilesPreparer`/`makeLaunch` code was moved, not left behind. I pushed nothing.

**CI:** The first wait came back red. `test (24.x, macos-15)` failed one test, `@endo/daemon` `daemon-teardown › an orphaned daemon shuts itself down instead of lingering`. This PR doesn't touch that package. I took it for a flake and reran the failed job once (run 36853185170). After the rerun, `ci-wait-merge` exited 0 with all 35 checks green.

**Follow-up (not required):** The `daemon-teardown` test on macOS / Node 24 looks flaky: it hung for about 30 minutes and then failed. It's worth tracking separately if it fails on other PRs too.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-sandbox-bwrap-slice-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1363065 cached reads)
- Output: 5949 tokens
- Cost: $0.914137
- Wall-clock: 3472s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
