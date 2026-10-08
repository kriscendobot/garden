# Fix round 5 for kriscendobot/minion.town PR #166

All four must-fix items from the round-5 panel are fixed. The commit is pushed as `501b1e1` with `safe-push-pr-head.sh` (fast-forward from `a06e631`), and CI is green. The first CI run went red in `test/endo-daemon-integration.test.ts` › "reincarnates a guest-pinned Claude inbox responder after restart". This PR doesn't touch that code, the same suite passed on `a06e631`, and it passed when I reran only the failed job. `ci-wait-merge` then returned rc 0.

**Must-fix items:**
1. **decomplector (shared session cache):** I removed `sessionPromise`, `session()`, `closeSession`, `resettingSession` and `checks.close`, plus the `try/finally` in `runProbe`. A new scoped `withSession(env, mcpUrl, body)` gets the token, connects, runs the body, and always calls `terminateSession()` and `close()` in a `finally`. Both cleanup calls give up after `TIMEOUT_MS`, which also fixes the saboteur/breaker should-fix: a server that never answers the DELETE can no longer hang the run. The lifecycle test now asserts that every session gets a DELETE, including the one whose check failed.
2. **integrator (stale Evidence):** I re-ran the probe against production at `501b1e1` with `--strict`. All 7 checks passed on the first attempt (`overall: pass`, exit 0). The PR body's Evidence section now cites that run, and the "panel round 1" wording is gone.
3. **stylist:** `prm`/`prmText` are now `protectedResourceMetadata`/`protectedResourceMetadataText`.
4. **stylist:** `MINION_PROBE_CC_CLIENT_{ID,SECRET}` is now `MINION_PROBE_CLIENT_CREDENTIALS_CLIENT_{ID,SECRET}` in the script, the workflow, the tests and DEPLOYMENT.md. I set the new Actions secrets on the repo from Secrets Manager `minion/test-cc-client`, so the strict scheduled run still has its credential. The PR's operator note is updated.

**Should-fix items also done:**
- `daemon-unit-healthy` is split into `mcp-endpoint-answers`, which needs no credential, and `daemon-guest-status`, which does.
- The durability check now reads the nonce back in a new session with a new token.
- `WS_GUID` is now `WEBSOCKET_ACCEPT_GUID`, `base` is now `baseUrl`, and the local `get` that shadowed the module-level fetch helper is now `header`.
- The claim that failure reasons "never quote response text" is narrowed in the code comment, DEPLOYMENT.md and the test name. Reasons can contain the header values a check compares, but never a response body or tool text.
- Unit tests pass, 18/18.

**Not done (left for the next panel or the maintainer):**
- **locksmith:** the probe still uses the full-surface `minion-mcp-test-cc` guest. A dedicated or attenuated probe guest and branch-scoped environment secrets would need new infrastructure and a maintainer decision.
- **saboteur:** `hardCacheViolations` still accepts `no-store, immutable` and doesn't check that `max-age` is at least the gateway's declared value.
- **decomplector:** the probe still keeps its own copy of `ISOLATION_FLOOR` instead of importing it.
- **stylist:** the `prod-` → `production-` file renames.
- **integrator:** squashing or regrouping the commits.
- **pruner:** trimming the PR body.
- **Cleanup:** the old `MINION_PROBE_CC_*` Actions secrets are no longer read but are still set. I didn't delete them; the PR body says they can be.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2153465 cached reads)
- Output: 14678 tokens
- Cost: $1.422909
- Wall-clock: 688s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
