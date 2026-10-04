Fix round 1 for kriscendobot/minion.town PR #157 is pushed and CI is green: 3 of 3 checks passed, and `ci-wait-merge` returned 0. I pushed one follow-up commit, `657e73f`, on top of `7353060`, using `safe-push-pr-head.sh` in advance mode.

**Must-fix items from the panel (assessor, breaker, purist, curator):**
- **Identity mismatch:** this was the one outcome of a form submission that still sent a plain-text "Forbidden". It now gets an HTML "Wrong account" page (403) with the link back to the account page. The existing test now checks the content-type, the page text and the back link.
- **Duplicate `escapeHtml`:** the local copy is gone; the file now imports the one already exported from `src/auth/privilege-page.ts`.

**Should-fix items, also applied:**
- **Cross-site posts (breaker):** a POST that a browser marks `Sec-Fetch-Site: cross-site` or `same-site` is now refused with 403. A test covers this and also shows the connect link is not used up, so a later same-origin submit still connects.
- **Response format (corner-prober):** a form submission now gets HTML unless it sends `Accept: application/json`, in which case it gets JSON. A form with no `Accept` header still gets HTML. A test covers the JSON case.
- **Bad timestamps (engine-realist):** a reset or expiry time that isn't a valid date now shows as "an unknown time" instead of throwing inside the handler. A test covers this.
- **Docs and comments (archivist, pruner):** added JSDoc to the page-building helpers, noted the cross-site check in the module's header comment, and removed a comment that only repeated the code.
- **PR description (pruner):** shortened it. It also said identity-mismatch handling was unchanged, which is no longer true, so I corrected that, added the cross-site check, and removed the test count.

Locally, `npm run typecheck` is clean and all 17 tests in `test/claude-account-endpoint.test.ts` pass. I did not re-run the full suite.

**Not done (left as follow-ups):**
- The gate and subject checks still answer in plain text on the HTML routes; the assessor flagged this as out of scope.
- The new pages don't use the shared page style from `privilege-page.ts`, a comment-only note from the curator.
- The tests are split across two commits, a comment-only note from the packager.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-account-html-page-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1310978 cached reads)
- Output: 8582 tokens
- Cost: $0.9990916
- Wall-clock: 338s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
