I fixed all four must-fix items from the round-6 panel on kriscendobot/minion.town#86 and pushed them. CI finished green (3/3, no failures).

**Pushed:** three follow-up commits on `git-remote-capability-increment-1`, taking the head from `099e9b3` to `eed124c`. I pushed with `safe-push-pr-head.sh` in its default mode, which only adds commits.

**Must-fix items:**
1. **Revoke by hash.** `revoke(tokenHash)` now takes the `tokenHash` that `mint` returns, so an operator can revoke a leaked token without the one-time secret. Passing a raw token revokes nothing. I updated the Revoke / rotate runbook and the module description in `designs/git-remote-capability-increment-1.md`.
2. **Missed revokes from an unchanged directory mtime.** The token index uses two checks now:
   - An index built within 2 s of the partitions directory's mtime is not trusted and is rebuilt on the next lookup (git's "racy index" rule).
   - Before an index hit authorizes a request, it is re-checked against that partition's sidecar file. A revoke made by another process is therefore refused even if the mtime never changed.
   - New tests use `fs.utimes` to force equal mtimes for both a revoke and a mint.
3. **JSDoc** added to `mintPartitionId`, `mintToken`, `loadGitRemoteConfig`, `makeGitRemoteApp` and `makeGitRemoteRouter`.
4. **TLS-floor test.** A fast-check property test replaces the nine hand-picked examples: every string except `"0"` keeps TLS required. There is also a test that exactly `"0"` turns it off. This adds `fast-check@^3` as a devDependency, which changes `package.json` and `package-lock.json`.

**Should-fix items also done:**
- A sidecar with the wrong shape (`{}`, `tokens: null`, a null binding, or an `id` that doesn't match its filename) is refused and logged instead of crashing the service.
- A store error during authorization now returns a 500 instead of an unhandled rejection that would end the process.
- `authorize` and `mint` return frozen records.
- The router now gets a restricted view of the store without `create`, `mint` or `revoke`. `makeGitRemoteApp` still returns the full store for the operator process and tests.
- `x-forwarded-proto` must be a single `https`; a comma-joined value is refused.
- The Basic auth scheme name now matches case-insensitively.

**Checks:** `tsc --noEmit` is clean, and `npm test` gave 624 passed and 8 skipped. I posted a summary comment of this round on the PR.

**Not done (should-fix only):** re-running projection after a client disconnects mid-push, switching projection to `git cat-file --batch`, and the doc trims the pruner asked for. Panel round 7 may raise these again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2087041 cached reads)
- Output: 21702 tokens
- Cost: $1.6064242
- Wall-clock: 533s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
