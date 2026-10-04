Round-2 fixes for kriscendobot/minion.town PR #157 are pushed as commit `ae9b939` (fast-forward from `657e73f`), and CI is green (3 of 3 checks passed).

**Fixes, from the round-2 panel review:**
- **Content negotiation** (duality-auditor, corner-prober, the only must-fix besides the rename): the two routes used opposite defaults when a client stated no preference. They now share one `wantsHtml` check, and the POST route checks for a form body separately. A form POST with no `Accept` header now gets JSON, the same as the GET routes. There's a new test for this.
- **Dark mode** (integrator): the account pages now use the same light/dark color convention as the other minion.town pages. A new `renderAccountPage` export lets `test/dark-mode.test.ts` check them.
- **Missing diagnostic** (purist, typist, assessor): the HTML page now shows the `diagnostic` flag, so it matches the JSON response. There's a new test for this.
- **Cross-site refusal** (purist): a browser form refused as cross-site now gets the HTML error page, like every other failure.
- **`Sec-Fetch-Site` header** (corner-prober): the header is now compared case-insensitively, with tests for `none`, `Same-Origin` and `Cross-Site`. The file's header comment now calls this check best-effort; the single-use connect link is what actually blocks other sites.
- **Form size limit** (corner-prober): new tests at the 16 KiB limit. Exactly 16 KiB is accepted; one byte more is rejected with 413.
- **Naming** (stylist): the five new `res` variables in the tests are now `response`.
- **PR description** (pruner): removed the sentence about an unrelated failing test.
- **Summary comment** (scribe): posted on the PR, covering rounds 1 and 2 and what was declined: https://github.com/kriscendobot/minion.town/pull/157#issuecomment-5985726061

**Verification:** the typecheck is clean, and the two affected test files pass (29 tests).

**Not done:** there's still no test for two simultaneous submissions of the same connect link. That race is in the existing `handleSetupToken` code, which this PR doesn't change.

As instructed, I didn't re-run the panel; the driver posts round 3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-html-page-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1376138 cached reads)
- Output: 11701 tokens
- Cost: $1.1433676
- Wall-clock: 418s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
