PR #1560's CI is now green: 26 checks passed and 10 skipped at head `b647776d73`, and the PR is mergeable. I didn't change any code. I moved the PR and its design base onto the current `llm`.

**Cause:** All three failing jobs were in packages this PR doesn't touch (it only changes `packages/exo-agent-factory`, a changeset, `tsconfig.composite.json` and `yarn.lock`). They came from the base being 31 commits behind `llm`, which has since fixed each one:
- **`build`:** `scripts/graph.sh` failed with `tred: command not found`. `llm` fixed its CI toolchains in 0fc7e16c45.
- **`test`/`cover` on Ubuntu, and `sandbox-drivers`:** two `@endo/sandbox` bwrap tests failed (`ulimit -u` is not supported by the runner's `/bin/sh`, and one test finished without any assertions). Fixed on `llm` by 27705a4cdf.
- **`test (24.x, macos-15)`:** `@endo/floot` `factory-system-prompt.test.js` died on an unhandled rejection (`ClientDestroyedError`). Fixed by the floot changes on `llm`, including 9dde54249f.

**What I did:**
1. Rebased the 4 commits of the design PR #1558 (`design/endo-child-agent-factory`) onto `llm-9a14ddf`, the frozen snapshot of the current `llm` tip. Force-pushed it, giving head `dcf4d6034e`, and moved #1558's base from `llm-d5ac419` to `llm-9a14ddf`.
2. Created a new frozen snapshot of the design branch, `design/endo-child-agent-factory-dcf4d60`.
3. Rebased #1560's 3 commits onto that snapshot with no conflicts. Force-pushed `build/exo-agent-factory-core` and moved #1560's base from `design/endo-child-agent-factory-8e67003` to the new snapshot.
4. Before pushing, checked locally: `yarn install --immutable` passed, so the lockfile is unchanged, and `exo-agent-factory`'s tests (23 passed) and lint (`tsc` and eslint) passed.
5. #1558 is also green (26 passed, 10 skipped) and mergeable.

**Follow-up:** The PRs stacked on #1560 (#1561 and #1563) are still based on the old snapshot `build/exo-agent-factory-core-8c4a87e`, so they still sit on the old `llm` with the same unrelated failures. #1562 and #1564 sit on top of those. Weaving that stack onto a new snapshot of `build/exo-agent-factory-core` (`b647776`) would bring them current. I left the old snapshot branches in place.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1560-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2187220 cached reads)
- Output: 9848 tokens
- Cost: $1.275708
- Wall-clock: 4524s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
