# Fix round 1 for endojs/endo-but-for-bots#1407: fixes pushed, CI green

The panel's round-1 verdict (review 5386654561, must-fix) had two must-fix items. An earlier attempt at this job had already pushed fixes for both in `063af9bdb6`; I checked them against the diff:
- **stylist:** the new `sockPath`/`guestSockPath` names are now spelled out as `socketPath`, `guestSocketPath` and `daemonSocketPath`. The few `sockPath` uses left in the diff are references to the existing `config.sockPath` / `sockPath` names, which the rule doesn't cover.
- **corner-prober:** the default `connect` path in `runConfinedTurn` is now factored into `makeGuestConnect` and has tests. That commit also added the daemon-restart note the migrator asked for to the changeset.

This attempt pushed `a729d67db7` with three more fixes from comment-only and summary-fix findings:
- **Guest sockets could stop working until a daemon restart** (saboteur and engine-realist): in `makeGuestPathIssuer`, if creating the private directory failed once, that failure was cached and every later request, for any guest, failed with it. The cached failure is now cleared, so the next request tries again. A new test covers this.
- **Socket path limit at its exact edge** (corner-prober): new tests check that a 103-character path is served and a 104-character one is refused.
- **Malformed formula id** (corner-prober): `resolveScopedGuest` now reads the id inside its error handling, so a bad id raises the `invalid-formula-id` error rather than the daemon's raw parse error. A new test in `broker.test.js` covers it.

**Checks:**
- Locally, the daemon `serve-guest-path` tests (9) and the agent-mcp-stdio `broker` and `exports` tests (9) pass.
- Prettier is clean, and eslint reports no errors on the changed files.
- `tsc` passes in `packages/daemon` and `packages/agent-mcp-stdio`.
- On the PR, `ci-wait-merge.sh` returned rc 0 with all 33 checks green.

**Follow-ups I left alone** (all should-fix or comment-only):
- pruner wants the PR body and the claude README shortened.
- purist wants the socket path-length limit shared with `manager-node-powers.js`, and a narrower `GuestPathIssuer` type.
- fast-checker suggests property-based tests, which would need fast-check added to the daemon package.
- migrator noted that `bus-manager-node` doesn't pass `marshalSaveError`.
- transplanter flagged the `/tmp` literal in the claude tests.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 154 tokens (6344277 cached reads)
- Output: 28515 tokens
- Cost: $3.3248913999999994
- Wall-clock: 5998s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
