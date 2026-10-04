Both fixes are pushed to kriscendobot/minion.town#148, and CI is green on the new head `e4fb4e7` (test, Claude harness amd64 and arm64). PR #148 is ready for the maintainer to re-review `533aabb..e4fb4e7`; the two new commits sit on top of `7c08ffa`.

**Commits:**
- **`9943545` fix(claude): require activate on every credential store**
  - `activate()` is now required in `ClaudeCredentialStore` (`types.ts`), and the wiring calls it directly instead of skipping it when absent.
  - The in-memory test store now works like the file vault: a stored token stays unusable until `activate`, and storing a replacement makes it unusable again until activated.
  - The fail-closed default store gets an `activate` that does nothing.
  - The account concierge's dependency type now leaves out `activate`, because activation belongs to the connect step after the probe passes. The concierge only ever used `status` and `revoke`.
  - New tests:
    - In `claude-credentials.test.ts`, a stored token reads `needs-auth` until `activate`, and so does a replacement.
    - In `claude-wiring.test.ts`, `handleSetupToken` shows the account reading `needs-auth` while the confinement probe runs and `connected` after.
  - Two existing tests changed `activate?.()` to `activate()`.
- **`e4fb4e7` fix(claude): share one directory create across concurrent provisions**
  - `ensureDirectory` in `claude-guest-bridge.ts` now dedupes calls that are still running. Calls for the same directory share one check-then-make, keyed by the connection's root host, the scope (`""` for the root, the caller key for a child host) and the path.
  - The shared entry is dropped once it finishes, so a later call checks the daemon again and a failure is never cached.
  - New `test/claude-guest-bridge-directories.test.ts` uses a fake daemon whose `makeDirectory` overwrites, as the real one does. It runs concurrent first provisions for one caller and across callers plus the probe, and asserts each directory is created exactly once and every child is still listed and removable.
  - With the fix reverted, the two concurrent cases fail: 3 creates instead of 1.

**Checks:** `npm run typecheck` is clean. Locally, `npm test` passes 785 tests with 1 failure: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure`. I didn't confirm that failure on the unmodified branch, but it's in code these commits don't touch and it passes in CI, so it looks like something about this host.

**Scope:** I pushed with `safe-push-pr-head.sh` (a fast-forward from `7c08ffa`), didn't start a new gauntlet, and left the #149 root-socket relay item alone.

**Follow-ups:** the maintainer re-review of `533aabb..e4fb4e7`, then a merge job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `dea0146cefdcfa28d7dba2e40c760dc79821a5fc`; this job presented `e4fb4e708da4c64af0a7a9dbde81161b59652c9c`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr148-ensuredirectory-race-fix-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1656234 cached reads)
- Output: 16105 tokens
- Cost: $1.2549708000000002
- Wall-clock: 485s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
