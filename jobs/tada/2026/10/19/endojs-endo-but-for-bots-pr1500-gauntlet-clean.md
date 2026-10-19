# Clean stage report: endojs/endo-but-for-bots PR #1500

**Result:** CI is green at head `751935e1ca3`: `ci-wait-merge` returned rc 0 with 35 checks and 0 failures. The PR is still a draft.

**Starting state:** CI at `e7e63160d` was red across the board. `yarn install` failed in hardened mode because the PR added an `endo-mcp-http` bin to `packages/agent-mcp-stdio/package.json` without updating `yarn.lock`. Every lint, test, cover and build job died at install.

**Commits pushed to `build/endo-gateway-mcp-termination`** (all with `safe-push-pr-head.sh` in advance mode, so only added on top of the existing head):
1. `b9ce55e1f chore: Update yarn.lock`: adds the missing `endo-mcp-http: ./bin/endo-mcp-http.js` bin line. `yarn install --immutable` now passes locally.
2. `20c45e603 test(agent-mcp-stdio): cover the endo-mcp-http request-body limit`: the coverage pass found the 413 oversized-body branch of `src/http.js` had no test, so I added one over a real connection. It crashed on Node 24 in CI; the next commit replaces it.
3. `953681872 test(agent-mcp-stdio): drive the body-limit refusal without a socket`: the 413 test now calls the exported `makeMcpHttpHandler` directly with an in-memory request and response.
4. `751935e1c test(agent-mcp-stdio): request the HTTP gateway without keep-alive`: fixes a bug in the PR's own tests that CI had never reached before. On Node 24, `test/http.test.js` failed with an unhandled `ClientDestroyedError` when teardown closed the gateway: the global `fetch` keeps connections open, and under SES its error can't be modified. The tests now use a `node:http` client with `agent: false`, the same approach `endo-fs-asset-server`'s tests already use.

**Coverage and dead code:**
- I ran the `agent-mcp-stdio` suite on Node 22 with V8 coverage (60/60 passed) and merged the coverage data by hand.
- After the new test, the only uncovered lines in `src/http.js` are small error branches: the 500 fallback, the listener with no port, and the daemon-connect and listen failure logs in `mainHttp`.
- The rate-limiter extraction (`daemon/src/rate-limiter.js` out of `ws-gateway.js`) moved the code cleanly and left nothing orphaned.
- ESLint reports 0 errors and `tsc` passes on the touched files.

**Notes:**
- When `agent-mcp-stdio`'s broker tests run with TMPDIR on the virtiofs scratch mount, they fail with `EINVAL` on `chmod` of a socket. That's a local environment issue, not the PR; they pass with TMPDIR on tmpfs.
- I couldn't reproduce the Node 24 failure locally because this host only has Node 22. CI at the final head is green on both 22.x and 24.x.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (3864937 cached reads)
- Output: 19087 tokens
- Cost: $1.8541434
- Wall-clock: 5092s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
