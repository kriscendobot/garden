I applied fix round 3 to PR #1500 and pushed it. CI is green on the new head `da4b8ac700f` (35 checks, 0 failed, `ci-wait-merge` rc 0).

**What I worked from:** there was no pre-pass block, so I used the latest panel verdict (review 5574846179, resumed from panel record `3822e51c8144`). That verdict only shows 20 shortened items, all from the archivist, breaker and integrator seats. Five other seats also voted must-fix (locksmith, pruner, releaser, spec-keeper, wire-watcher), but their findings never made it into the record or the review. The full seat outputs were on the oros host and are gone, so those findings were **not** applied. Panel-4 will raise them again if they still apply.

**Code changes** (`packages/agent-mcp-stdio/src/http.js`, three follow-up commits pushed with `safe-push-pr-head.sh`):
- **Deleted guests are now locked out (breaker).** The server used to remember each guest forever, so a deleted guest's bearer kept working, which breaks design Decision 2. It now looks the bearer up through the daemon on every request. A new test checks that a deleted guest gets `401`.
- **Browsers in `allowedOrigins` can now use the endpoint (breaker).** Before, a listed origin was let through but got no CORS headers, and the browser's `OPTIONS` preflight got `405`. Now every reply to a listed origin carries `Access-Control-Allow-Origin`, and its preflight gets `204` with the allowed method and headers. New tests cover the preflight, a refused origin, and a bare `OPTIONS`.
- **A failure that CI turned up.** The first push failed the "413 over a real connection" test on node 22 / macOS. When a client declared an oversize body, the server sent the `413` and closed the connection while the client was still uploading. On macOS the client then got `ECONNRESET` and never saw the `413`. The server now reads such a body to its end without keeping it, as it already did for chunked bodies, and only then replies.

**Docs (archivist):**
- The README now describes the rate limiter correctly. A blocked attempt isn't counted, so one-at-a-time guessing is held to one attempt per second; only failures from parallel requests add up. It also says plainly that parallel requests can get past the limiter.
- The `400` case now reads as replies whose `id` is `null`.
- The README, the design doc's status section and the changeset now describe per-request lookup and the CORS behavior.

**PR description (integrator):**
- It now mentions the changeset instead of saying "Both packages are private, so there is no changeset".
- It now covers `ENDO_MCP_HTTP_TRUST_PROXY` and keying the limiter on the last `X-Forwarded-For` entry, `413` with `Connection: close`, CORS, and per-request lookup.
- The testing section now lists the 413, trusted-proxy and CORS tests, and the test count is updated (63).

**Not changed:** I left two comment-only breaker notes alone. One is a forged `X-Forwarded-For` (the panel already marked it mitigated). The other is a chunked body that never ends: the server waits for it, limited only by Node's request timeout.

Locally, the package's 63 tests pass (the HTTP tests ran three times in a row), and `tsc`, eslint (no errors) and prettier are clean.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (5206337 cached reads)
- Output: 25114 tokens
- Cost: $2.4903154
- Wall-clock: 5661s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
