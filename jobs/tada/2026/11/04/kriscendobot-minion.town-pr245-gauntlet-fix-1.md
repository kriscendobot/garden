I applied the round-1 fixes to kriscendobot/minion.town#245 and pushed them, and CI came back green on all 7 checks (`ci-wait-merge` rc 0).

**What the panel asked for (comment review "Must-fix before merge"):**
- **corner-prober finding 1 (must-fix-loop):** fixed in commit `e57de5c9`, pushed to `feat/api-key-agent-responder-ui` with `safe-push-pr-head.sh`. The change is in `deploy/aws/www/provider-ui.js`:
  - `retryTime` used to throw a `RangeError` when `retryAt` was missing, empty or unparseable. It now returns "soon", so the row reads "retrying soon" instead of "retrying at …".
  - `refusalReason` used to throw when `code` was missing or not a string. It now returns "held".
  - The reason lookup is now a `Map`, so a code like `constructor` shows as its own text instead of as `function Object()…`.
  - Before this fix, one bad row stopped the whole mail list from rendering, which took Dismiss and Delete away from every message.
- **Test change:** the browser test in `test/agent-ui-browser.test.ts` now has a deferred row with an empty `code` and `retryAt`, and a refused row with `code: "constructor"`. I updated its expected counts and row assertions to match. That file's 9 tests pass locally in Chromium, and `tsc --noEmit` is clean.
- **pruner findings 1–3 (PR body):**
  - I cut the `src/endo/claude` sentence down to "The legacy #165 responder is unchanged."
  - I removed the "Known gaps" text that repeated the evidence ledger, leaving only the line that no deployment creates the factory or launcher yet.
  - I dropped "Nothing decides the parent design's open questions."
  - I added one bullet describing the new fallback.
  - The body is now about 240 words before the ledger, under the 300-word limit. The ledger and the `garden-job` marker are unchanged.

**Left for later:** corner-prober findings 2–5 were rated summary-fix only, not must-fix, so I didn't act on them in this round:
- `retryAt` edge cases: a time in the past, yesterday's date, and exactly midnight UTC.
- Fixing the test clock, since a run that crosses midnight UTC can flake.
- What happens when the counts and the listed rows disagree.
- Error handling for Retry, and double-click races, since the buttons aren't disabled while a request is in flight.
- Message-number edge cases at the endpoint, like `0`, `007` and numbers past 2^53.

Running prettier rewrote unrelated lines across `provider-ui.js`, and both changed files already failed `prettier --check` before my edits. So I left formatting alone and kept the commit to my own changes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr245-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1199588 cached reads)
- Output: 8246 tokens
- Cost: $0.9078456
- Wall-clock: 437s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
