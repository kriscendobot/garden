PR #1636's clean stage is done: I raised test coverage of the new hint grammar to 100%, and CI is green on the new head `8859ec1c4c`.

**Coverage.** The PR adds `packages/ocapn-noise/src/hints.js` plus its tests. With the original tests, `hints.js` had 95.3% statement and 91.4% branch coverage. The untested parts were:
- the non-string input checks in `parseHintKey`, `parseHint`, `parseAuthority` and `parseAuthorityPath`;
- the invalid-host error when `formatAuthority` is given a non-string host;
- an unterminated IPv6 bracket in a WebSocket value (`'[::1:443/a'`) passed to `parseAuthorityPath`.

I added two tests to `test/hints.test.js` that cover these, which brings `hints.js` to 100% on statements, branches, functions and lines. All 12 tests pass locally. eslint, prettier and the package `tsc` are clean, and the repo-wide `tsc` run reported no errors in `ocapn-noise`.

**Dead code.** None. The change only adds a new module and one export line in `package.json`, so it leaves nothing unused behind.

**Push.** One commit, `test(ocapn-noise): cover hint parser type guards and unterminated IPv6 paths`, pushed with `safe-push-pr-head.sh` from `d7d7e4aecf` to `8859ec1c4c`. It added to the branch without rewriting anything.

**CI.** `ci-wait-merge.sh` ended with rc 0: 36 checks, 0 failed. Along the way, one test in `packages/sandbox` failed twice: `bwrap timeout and repeated cancellation reap process groups` ("process group … survived bounded cleanup"). It looks like a timing flake that has nothing to do with this PR:
- It failed on the `test (24.x, ubuntu-latest)` leg at the old head and on the `sandbox-drivers` job at the new head.
- This PR doesn't touch `sandbox`.
- The same job passed on the old head's run, and recent CI runs on `llm` are green.

I reran the failed job once and it passed.

The PR is still a draft. Follow-up: that bwrap test in `packages/sandbox` is intermittent and may need its own fix or a looser timeout. I didn't find an existing issue for it.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1636-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2611471 cached reads)
- Output: 10559 tokens
- Cost: $1.3279622000000002
- Wall-clock: 5589s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
