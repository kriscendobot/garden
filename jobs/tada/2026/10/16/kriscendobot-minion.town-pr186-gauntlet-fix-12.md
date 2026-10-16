Round 12 fixes are pushed to PR #186 (`a074fe7` → `ec9d050`) and CI is green on the new head, according to the Actions runs API (1 run, 0 failed). The bot token can't read the PR's status-check rollup, so commit statuses and checks from outside Actions weren't visible to me.

The two #191 must-fixes are answered in the design doc, but the main question is still open: kriskowal called the mint/refresh mechanism "an overwrought yak shave" on #191 and hasn't said whether it should stay at all. Their #191 review is still `CHANGES_REQUESTED`. The decomplector seat said to stop and get maintainer confirmation before another round changes `root-canary-mint.mjs`. I didn't ask them on the message bus; the doc and PR body now say that keeping this second step is their call on #191, and nothing here is set up or turned on until then.

**Must-fix items**
1. **#191 direction:** The Status block now records kriskowal's #191 comment and the revised #191 plan. The OCapN canary comes first, and this design is the second step. It now covers only the live MCP smoke test, because an MCP client can only present a bearer token.
2. **OCapN alternative:** §4 now lists *An OCapN guest locator*. It gives the same "only `endolin-garden1`" boundary with no Cognito client, refresh token, re-mint or revoke, and it covers the responder, mail and capability-passing checks. The one part that still needs the refresh token is the live MCP smoke test.
3. **Exit-code table:** the `root-canary-exec.mjs` row in §2.6 now matches the code. It exits 75 only for the four credential reasons, and 1 for `unreachable`, including a preflight that records no reason. I also added `mismatched` to the earlier reason list in §2.6.

**Should-fix items**
- **Mint host:** it is now fixed to `endolin-garden1` in `root-canary-common.mjs`, and the `ROOT_CANARY_MINT_HOST` override is gone. Nothing documented or tested that variable.
- **Exit codes in code:** `reasonStatus` and `reasonLine` only treat `{missing, unreadable, refused, mismatched}` as credential reasons. Anything else, including an unknown reason, exits 1 with a "failed" line. I added a unit test with six cases.
- **Ownership map:** the §5 row and closing paragraph now name the host-local credential file instead of Secrets Manager.
- **Status block:** it now says "items 1, 2, 4, and 5 are implemented (item 3 was dropped)", and the #191 design path is labelled as being in kriscendobot/minion.town.
- **PR body:** trimmed from 322 to 294 words.

**Checks:** the two root-canary test files pass (101 tests before the new cases; the scripts file passes 69 after), and the typecheck produced no output. `prettier --check` flagged nine files; I didn't reformat anything, including the test file I edited.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-fix-12.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1844571 cached reads)
- Output: 10042 tokens
- Cost: $1.1040502
- Wall-clock: 1088s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
