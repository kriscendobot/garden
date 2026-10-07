I applied round 3's one must-fix to kriscendobot/minion.town#166, pushed it, and CI is green on the new head.

**The must-fix:** the decomplector seat asked that the probe stop using its own hand-written MCP client. Rounds 1 and 2 had both patched that same client.

**Changes** (follow-up commit `2b7381a`, pushed to `feat/prod-objectives-probe` with `safe-push-pr-head.sh`):
- **`deploy/probe/prod-objectives.mjs`:**
  - Removed `McpSession`, `parseMcpResponse` and the `MCP_PROTOCOL_VERSION(S)` constants.
  - The shared `session()` now does the client-credentials grant and the scope check, then connects with `@modelcontextprotocol/sdk` (`StreamableHTTPClientTransport` plus `Client`). The repo already depends on that package. If connecting fails, the client is closed.
  - `closeSession()` now uses the SDK's `terminateSession()` and then `client.close()`.
  - A small `callTool` helper reads the text result and turns a tool error into a check failure.
  - `unexpectedReason` now also keeps numeric error codes (an HTTP status or JSON-RPC code). SDK error messages, which can quote response text, still stay out of the public reason.
  - Removed "dependency-free" from the file's header comment.
- **`deploy/probe/prod-objectives.test.mjs`:** removed the `parseMcpResponse` test. Updated the fake-production stub to match how the SDK sends requests. The test that a failed check closes its session and retries on a fresh one still passes unchanged. Added an assertion that an error message quoting response text is reduced to its name and status code.
- **`.github/workflows/prod-probe.yml`:** added an `npm ci` step (with the npm cache) before the probe runs.
- **`DEPLOYMENT.md`:** the probe section now says the probe uses the SDK client and needs `npm ci`, including in the local-run recipe.
- **PR body:** replaced "dependency-free" with the same SDK note.

**Verification:**
- All 18 unit tests pass.
- I ran the probe live against production with `--strict`, using the `minion/test-cc-client` credential from Secrets Manager. All six checks passed on the first attempt, including the authenticated `writeText`/`readText` round trip, so the SDK path works against the real server.
- CI on head `2b7381a`: the `test` check and both Claude harness checks (amd64, arm64) passed; `ci-wait-merge.sh` returned 0.

**Follow-ups:** I didn't take up the should-fix and comment-only items from round 3, such as renaming `prm`, the timeout case where no tracking issue gets filed, the dedicated probe credential, and pinning `--strict` with a test. They are for the driver to handle in panel-4. Since the SDK now picks the protocol version, the spec seat's exact-version check no longer applies.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1586060 cached reads)
- Output: 11552 tokens
- Cost: $1.19394
- Wall-clock: 475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
