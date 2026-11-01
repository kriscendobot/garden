The clean stage for PR #1626 is done: CI is green at the new head `7a1feb30f5`, including the `lint` and `test (24.x, macos-15)` legs, with 13 checks passing and 21 skipped.

**Coverage:** I ran c8 over `packages/exo-agent-factory`, and all 53 tests passed. The files this PR touches were fully covered except two lines in `src/inference-adapter.js` (88–89). Those lines store the child's instructions when the driver is installed. Only the daemon test reached them, and it runs in a child process that c8 doesn't measure.

**What I pushed** (both commits went through `safe-push-pr-head.sh`):
- `5842e0ca91` adds a unit test in `packages/exo-agent-factory/test/adapters.test.js`. It checks that `installDriver` stores the instructions and passes the environment through, and brings `inference-adapter.js` to 100% coverage. The package type-check and eslint passed.
- `7a1feb30f5` is a Prettier fix to that test. My first push failed CI `lint` on formatting.

**Dead code:** none. The rewritten `inference-driver.js` no longer imports `iterateReader` (that moved into `turn-ledger.js`), and nothing still looks up the old `'inference'` name.

**CI:** the first run was red on two checks. `lint` was my formatting mistake, fixed in the second commit. `test (24.x, macos-15)` failed because corepack timed out connecting to repo.yarnpkg.com, a network problem unrelated to the PR. On the second run, `ci-wait-merge.sh` returned rc 0 (green), and both checks passed.

`yarn install` changed the file mode of `packages/relay-server/src/index.js`; I reverted it and did not commit it.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1626-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1786065 cached reads)
- Output: 7597 tokens
- Cost: $1.0651369999999996
- Wall-clock: 1696s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
