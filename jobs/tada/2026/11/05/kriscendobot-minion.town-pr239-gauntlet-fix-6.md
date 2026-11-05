**PR #239 fix round 6 is pushed and CI is green, but I deliberately left one must-fix unapplied: the decomplector's request to remove the raw-locator route.** The head is `778d38cf`. CI's real-daemon job ran `guest-web-daemon.test.ts` against the pinned Endo and all 9 tests passed.

**The unapplied must-fix:** the route is the purpose of this PR, and the later removal of `invite` and `cancelInvite` depends on it. I recorded the reasoning in the PR body and asked the maintainer through `message-user.sh`; no reply has arrived. The seat may raise the finding again in panel 7.

**Must-fixes applied:**
- **Locksmith, purist, wire-watcher (arbitrary formula invocation and existence oracle):** the locator check now reads the formula's record through `E(host).diagnostics().getFormula` and calls `locate()` only if the type is `invitation`. Any other type, or an unknown formula, gets the same 404.
- **Wire-watcher (memory backend):** a new `acceptLocator` handles locators a visitor supplies, and the memory backend refuses all of them. The socket backend keeps its verified path.
- **Breaker, integrator (`home.js` parser):** credentials are now counted by presence, so an empty or repeated `guest` or `invitation` beside a locator is refused, with regression tests.
- **Prover (untested card path):** `test/home-page-locator-card.test.ts` boots `home.js` against a minimal DOM. It covers the stored-guest card and the `{ locator, petName }` request. Breaking either path by hand made the test fail.
- **Benchmarker:** the PR body now says no benchmark is being pursued, and the code comment no longer claims the unmeasured queue benefit.

**Other findings applied:**
- **Fast-checker:** added generated accept and reject properties for the locator grammar.
- **Changeset-auditor:** split the changeset line so each sentence has its own line.
- **Stylist:** made the requested renames.
- **Integrator:** reconciled the design doc and envelope header with the HTTP accept route.
- **Purist (partly):** the exact grammar now lives in one parser, `src/endo/invitation-locator.ts`. `guest-locator.ts` keeps its own parser for guest locators, and `home.js` and the envelope keep their coarse pre-filter.

**Commits:** `2e0d00b2`, `7276b8ce`, `240f2c5e`, `778d38cf`. The first push failed CI on the real daemon because `getFormula` is on the host's diagnostics facet, not the host; `778d38cf` fixes that.

**Known limits:**
- **Fault reporting:** at the Endo pin, `getFormula` words an unreadable record the same as an unknown one, so a persistence read failure at that step returns 404 instead of 503. This is noted in the PR body.
- **Local testing:** the full vitest run hit my 500-second limit on this host. Locally I ran typecheck and the web, home-page and invite-tool tests, which passed; the full suite passed only in CI.
- **Still unverified, as before:** a Playwright run of the card against a real daemon, and a production run.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (3404853 cached reads)
- Output: 44490 tokens
- Cost: $2.862906599999999
- Wall-clock: 1695s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
