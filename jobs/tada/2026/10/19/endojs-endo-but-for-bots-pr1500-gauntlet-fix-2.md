Fix round 2 for endojs/endo-but-for-bots PR #1500 is pushed, and CI is green: 35 checks, 0 failed, `ci-wait-merge.sh` returned rc 0.

**The panel feedback was only partly readable.** The panel-2 verdict (review 5572190941, run record `f1fd2c9ed8be`) cut each item off at about 120 characters and listed only 20 items. Those 20 came from just two seats, the archivist and the breaker. Ten other seats also voted must-fix, but none of their text is in the review or the journal, and the scratch files with each seat's full text were deleted with the panel's worktree. I fixed the archivist and breaker items as far as the cut-off text made them clear. I also added a changeset, guessing from their names that that is what the changeset-auditor and releaser seats wanted. The other eight must-fix seats are unaddressed (corner-prober, engine-realist, locksmith, pruner, purist, saboteur, spec-keeper, wire-watcher). Panel-3 will re-judge everything.

**What changed:** two commits on `build/endo-gateway-mcp-termination`, taking the head from `1dcbf0120d` to `59e07be822`. I pushed them with `safe-push-pr-head.sh` in advance mode, so the branch only moved forward.

- **`9cbfac0f43`, fix(agent-mcp-stdio):**
  - **Oversize bodies now get their 413.** Before, the body reader stopped reading as soon as a request passed the size limit, and that cut the connection before the 413 could be written. It now reads to the end and throws the excess away. A request that declares a too-large `Content-Length` is refused straight away, and the rest of its upload is read and discarded. Both refusals carry `Connection: close`.
  - **One client can no longer lock out everyone behind the proxy.** The rate limiter keyed on the socket's peer address, which behind the required reverse proxy is the proxy itself. A new opt-in setting, `trustProxy` (`ENDO_MCP_HTTP_TRUST_PROXY=1`), keys it on the last `X-Forwarded-For` entry instead.
  - **Tests:** two new tests over a real connection, one for the 413 (with and without a declared length) and one for the per-client keying behind a proxy. I also fixed the mock-socket test's comment, which had said a real connection could not deliver the 413.
- **`59e07be822`, docs(agent-mcp-stdio):**
  - The README and `designs/endo-gateway-mcp.md` now say the rate limiter belongs to this listener and is built with the daemon gateway's `makeRateLimiter`; it is not the gateway's own limiter.
  - The README explains the proxy keying and when not to turn it on, lists every reply status (200, 202, 400, 401, 403, 404, 405, 413, 415, 429), and says how to start `endo-mcp-http` against a running daemon.
  - The design now calls `gateway-mcp.js` a proposed file, since it does not exist.
  - The `http.js` comment that said "(transport § POST)" now names the MCP 2025-06-18 transport section it means.
  - New changeset `.changeset/agent-mcp-stdio-http-termination.md`: minor for `@endo/agent-mcp-stdio` and `@endo/daemon`.

**Local checks:** all 63 package tests passed in each of 3 runs. eslint shows 0 errors; its warnings are the same kind as before my change (2 in `src/http.js`, 2 in the test file). Both the package's tsc and the repo-root `tsc -p tsconfig.json` passed.

**Follow-up:** `panel.sh` should keep each seat's full must-fix text somewhere that outlasts the job. Otherwise the next fix round on a resumed panel will again have only cut-off text to go on. As instructed, I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2624368 cached reads)
- Output: 18995 tokens
- Cost: $1.6420136
- Wall-clock: 2552s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
