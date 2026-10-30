I applied the panel-3 must-fix items on PR #231 (review 5709002401) and pushed them as four commits, which moved the head from `37fb8153` to `33e5d30d`. CI is green on the new head: 7/7 checks pass, including the browser gate on chromium, firefox and webkit, and `ci-wait-merge` returned rc 0.

**Changes, by reviewer**
- **locksmith (a):** opening and using the owner facet now depends only on holding the locator, not on who is logged in on the socket. Revocation and expiry still apply. The test that refused a different subject now asserts that a second subject can open the facet with the locator.
- **locksmith (b), purist, engine-realist (diagnostics):** the production service no longer exposes live locators and no longer keeps per-subject mint/info counts (the memory leak). Tests now get that information from an observer they inject (new file `test/shell-session-recorder.ts`). `app.locals` now holds only the attach step.
- **saboteur and engine-realist (client):** `facet()` now fails immediately after the session has closed for good, instead of hanging. When the browser puts the page in the back/forward cache, the session suspends and resumes when the page is restored.
- **breaker:** sign-out now waits for any in-flight mint and its late revocation, then revokes all of the user's locators. If any revocation fails, sign-out fails and the settings menu shows "Could not log out" rather than continuing to OAuth logout.
- **spec-keeper:** `home.js` loads the SES/CapTP bundle first, so `lockdown()` runs before any other shell module.
- **prover:** Caddy now serves `/shell-session.js` and `/shell-captp.js` publicly. The browser gate serves exactly the files Caddy lists. I also updated the route-admission record.
- **typist:** the CapTP loader, `E` and the mint grant now have concrete JSDoc types, and the client validates a grant before using it.
- **archivist:** the design doc (Status and § 8) and the JSDoc on `makeShellSessionService` now describe the session.
- **integrator:** the PR ledger now says `orchestrated-slice`, with rung 0a partial and acceptance open. I parked a successor job, `minion-town-shell-captp-session-rung0a-deploy` (deferred). It owns settling design #230's open question (j), per-tab vs per-browser sessions, plus the deployment and the production evidence. The PR stays draft.
- **scribe:** I posted one summary comment covering this round and the two earlier rounds that had none.
- **corner-prober and fast-checker:** added tests that invalid locator caps are rejected, plus property tests for eviction and for the gate-token check.
- **stylist (partial):** renamed `env` to `environment`, `*_MS` to `*_MILLISECONDS`, and `all` to `revokeAllSessions`.

**Declined**
- **decomplector** asked to remove the locator entirely. That conflicts with the locksmith finding and with design #230, so it goes to the successor job.
- **packager** asked to split the bundle and lockfile into separate commits. That means rewriting reviewed history; it can be done at retcon time.
- **transplanter** flagged `openssl` in the browser test. CI runs it only on Linux.
- **stylist** asked to rename `app`. I left it because it would mean renaming a test file.

**Local checks:** typecheck is clean, and the shell-session, client, app and home-page suites pass (90 tests). The chromium shell-session and clip-frame browser gates pass. The full `npm test` run had one failure, `test/git-remote/capability.test.ts`. It is outside this PR's diff, and I'm treating it as a local-only failure because the same suite passed in CI.

**Still open:** the successor job above. Integrator also asked to keep this PR draft until design #230's open question (j) is settled. The gauntlet's own un-draft step would bypass that, so the driver should hold the un-draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (6523079 cached reads)
- Output: 40982 tokens
- Cost: $3.2359117999999993
- Wall-clock: 1853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
