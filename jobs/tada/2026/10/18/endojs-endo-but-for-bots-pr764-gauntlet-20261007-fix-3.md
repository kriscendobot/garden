# PR #764 gauntlet fix round 3 (endojs/endo-but-for-bots): fixes pushed, CI green

I applied the three must-fix items from the latest panel review (5563999555, 2026-10-18T17:09Z), plus two cheap review items. The work is one follow-up commit, `5525a25d69`, pushed with `safe-push-pr-head.sh` as a fast-forward from `8db80529de`. CI finished green: 15 checks, 0 failed (`ci-wait-merge` rc 0).

## Must-fix items
- **prover:** nothing tested that `read()` no longer looks up `Function.prototype`. I added a test that replaces the global `Function` while `powers.read()` starts. I put the old `Function.prototype` line back, and only that test failed; with the fix, all 8 tests pass.
- **breaker and integrator:** the changeset claimed more than the change does. `mapNodeModules` (`node-modules.js`), `search.js`, `url.js` and other modules still use whatever `URL`, `Promise`, `Map` and `Set` are global at call time. Saving copies at module load in all of them would have been a much larger change for a mirror PR, so I took the reviewers' other option and narrowed the changeset instead. It now names only the paths this PR protects (the import hooks, the CommonJS export wrapper, and the read powers from `makeReadPowers`). It also says outright that `mapNodeModules` and other paths still use the current globals.

## Other items
- **stylist:** renamed `noop` to `doNothing` in `node-powers.js` (lines 45 and 101).
- **corner-prober (partly done):** added a test where two reads start while `Promise` is replaced, then checks both finish with the same bytes.
- **releaser:** the changeset rewrite leads with what users see, as the reviewer asked.

ESLint and Prettier pass on the changed files.

## Not done (left for maintainer or later rounds)
- **Commit history cleanup (packager and integrator, should-fix):** the two `fixup!` commits and the CI add/revert/reapply sequence are still in the history. Cleaning them up means rewriting history, which this stage doesn't do; it can happen when the PR is ferried upstream.
- **corner-prober's other fallback paths:** tests for `makeReadNowPowers`, `makeWritePowers` and the deprecated `makeNode*Powers` were not added.
- **fast-checker's property test (follow-up):** a fast-check property test was not added.
- **scribe's summary comment:** I did not post the requested summary comment on the PR.
- **coverage-auditor:** it had no coverage report, so new-line coverage is still unchecked.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1556436 cached reads)
- Output: 8239 tokens
- Cost: $1.0523472000000003
- Wall-clock: 595s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
