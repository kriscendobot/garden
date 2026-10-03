Fix round 4 for endojs/endo-but-for-bots#1407 is pushed and CI is green (33/33 checks, 0 failed; `ci-wait-merge` rc 0).

I applied all four must-fix items from the round-4 panel review (review 5399271496) as follow-up commits on `bot/build/guest-scoped-daemon-bootstrap`, moving the head from `68b86b940d` to `62ce1a11a5`. I pushed with `safe-push-pr-head.sh`.

1. **Silent fallback to full host authority** (`807b8785e3`): when the daemon serves no guest sockets, the confined turn still falls back to the root connection, but `makeGuestConnect` now warns first. The warning goes through a new `warn` option, which defaults to `console.warn` (standard error), and names the formula id. The fallback test now checks the order: issue, then warn, then connect to root. The changeset mentions the warning. I did not add the opt-in flag the reviewer also suggested ("consider"), so the default behaviour is unchanged.
2. **Daemon shutdown logged as an error** (`58e0b9c9ca`): an ordinary daemon shutdown no longer logs an error for each open guest socket. Two tests are new in `serve-guest-path.test.js`:
   - One fires the daemon's shutdown and expects nothing reported. It fails without the fix and passes with it.
   - The other checks that a real listener failure is still reported.
3. **Guest collected while its socket is being issued** (`1399fceedd`): after issuing, `guestBootstrapPath` in `manager.js` checks that the guest's formula still exists. If the guest was collected in the meantime, it revokes the new socket and throws. A new real-daemon test runs the issue and the removal at the same time and asserts that no socket outlives the guest.
4. **Re-export policy** (`62ce1a11a5`): `packages/claude/index.js` now carries the `reexport-policy-exempt` marker, because it is the package's public entry point and not a compatibility shim. This follows the panel's supervisor note and matches `packages/agent-mcp-stdio/index.js`. I did not deprecate the new `makeGuestConnect` export.

I did not change the minor 24-digit slicing note, since the daemon only ever passes 64-hex formula numbers.

**Local checks:** the suites I touched pass: `serve-guest-path` (14 tests), `guest-bootstrap-path` (4, against a real daemon) and claude `confined-turn` (13). Type checks pass for daemon and claude. eslint shows no errors, and prettier is clean.

**Environment problem (for a follow-up):** the shared dependency cache for endojs/endo-but-for-bots has better-sqlite3 built for Node 24, but this host runs Node 22.23.2, so every real-daemon test fails to start locally. To run them, I replaced the module file in this job's worktree only, unlinking the hard link first so the shared cache was not modified. The cache key or the host's Node version probably needs fixing.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2662265 cached reads)
- Output: 16129 tokens
- Cost: $1.5446970000000002
- Wall-clock: 3532s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
