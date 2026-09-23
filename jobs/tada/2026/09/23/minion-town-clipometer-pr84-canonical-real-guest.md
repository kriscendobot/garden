CLIPOMETER's canonical publish from the real maintainer guest passed every live check. PR #84 is still a DRAFT and the published clip is still up.

**Session check:** this host (`endolin-garden-ece02cb4`) has the `mcp__minion-town__*` tools, and `list` shows the real guest's `odometer-visit-count` and `rt58-designated-power`. The PR head is unchanged at `723631d2c34730e7a1934d14dcf46405570bd4b2`.

**Build:** I built the exact PR head in an isolated checkout with `npm ci && npm run bundle`. The lockdown check passed and `npm test` passed 27 of 27.

**Publish:**
- **Counter directory:** I created `clipometer-canonical-count-20260923`, a new, empty directory in the real guest, and used it as `powers`.
- **How:** calling the MCP `publish` tool directly would have meant pasting about 210 KB of base64 into the call, so I ran the package's `scripts/publish.mjs --skip-build` instead. It authenticated with this host's saved `minion-town` session token for the real guest, passed through an environment variable and never printed or written anywhere.
- **Wrong-guest attempt:** my first run looked for the token in the wrong place and fell back to the disposable `minion-mcp-test-cc` guest. That guest does not have the counter directory, so the publish was rejected with "Unknown name" and nothing was published. The retry checks that a token was found before running.
- **Result:** clip URL https://tc2nqino7y6hjnyfhva5fupf5rzna77k3olepu26k4ziyn4qnroq.ocap.site/ (hash `tc2nqino7y6hjnyfhva5fupf5rzna77k3olepu26k4ziyn4qnroq`), reporting `serving: true`. It appears in the real guest's `listSites`. The 4 files total 159,862 bytes and went through under the new 2 MB `/mcp` limit.

**Browser check (headless Chromium via Playwright):**

| Check | Result |
|---|---|
| a. First window loads | HTTP 200, title `CLIPOMETER`, status reaches `live — updates as other windows visit…` |
| b. First window increments the counter | count = **1** |
| c. Second window increments it again | HTTP 200, `live`, count = **2** |
| c. First window updates without a reload | changed to **2** on its own |
| Console errors / page errors | **0 / 0** in both windows |

From the guest side, the counter directory holds only `count`, with value `"2"`.

I posted this evidence as a PR comment: https://github.com/kriscendobot/minion.town/pull/84#issuecomment-5803082220

**Next:** promote the parked child `minion-town-clipometer-primer-esbuild-update`, and after it, the issue-report child. I did not promote either one.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clipometer-pr84-canonical-real-guest.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1243450 cached reads)
- Output: 7487 tokens
- Cost: $0.8822220000000001
- Wall-clock: 115s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
