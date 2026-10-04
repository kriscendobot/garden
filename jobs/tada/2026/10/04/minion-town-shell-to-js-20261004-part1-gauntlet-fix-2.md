## Fix round 2: kriscendobot/minion.town PR #151

Both must-fix items from the round-2 panel (review 5407638671) are done, the fix is pushed, and CI is green (3/3 checks).

**Must-fix**
1. **Writability check could pass on any error (saboteur, breaker, assessor):** fixed in `47e0fab`. In `tools/claude-harness/inspect-image.js`, the check that the Claude binary is read-only had a rethrow that could never run, because `fail()` exits instead of throwing. So any `accessSync` error counted as "not writable" and the check passed. Now only `EACCES`, `EPERM` and `EROFS` mean read-only; any other error aborts, as the shell original did under `set -eu`.
2. **Missing summary comment (scribe):** posted at https://github.com/kriscendobot/minion.town/pull/151#issuecomment-5983246905. It lists what rounds 1 and 2 fixed with their commits, what was deferred, and the verification status at head `11fc6bb`.

**Should-fix, also done in `11fc6bb`**
- `tools/vendor-endo-claude.js` now runs inside a `main()` that only starts when the file is executed directly, like its sibling scripts. Importing it no longer clones a repo or rewrites `vendor/endo-claude`; I checked that `import()` exposes only `main`.
- The new `repoRoot` names are now `repositoryRoot` in the two `tools/` scripts. The unused `repoRoot` export is removed from `deploy/aws/scripts/lib/common.js`.

Both commits were pushed with `safe-push-pr-head.sh`, moving the PR head from `7cb1b76` to `11fc6bb`.

**Local checks:** `tools/check-javascript-only-scripts.js` passes and `npm run typecheck` is clean. `npm test` had one failure out of 831 (830 passed), in `test/git-remote/capability.test.ts`. This PR doesn't touch that file, and CI is green.

**Follow-ups (should-fix, not done here):**
- Property tests asked for by fast-checker: the `makeSsmCommand` round-trip, `parsePollTries`, `collectAllowedEmails`, and prefixed/suffixed names in `findCredentialEnvironment`.
- Purist's request to keep paths as URLs in `vendor-endo-claude.js` until the `path.relative` calls.
- Pruner's heading restructure in `AGENTS.md`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part1-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (934363 cached reads)
- Output: 7515 tokens
- Cost: $0.9128206
- Wall-clock: 341s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
