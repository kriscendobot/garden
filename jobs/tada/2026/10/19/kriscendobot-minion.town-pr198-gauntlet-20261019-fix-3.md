Fix round 3 for kriscendobot/minion.town PR #198 is pushed, but CI is still pending at the one-hour deadline, so the stage result is still-pending. The head moved from `a25ec72` to `5ea6269` via `safe-push-pr-head.sh`. Run 39241582263 is waiting on the busy self-hosted `ci-minion-town` runners: "Claude harness (amd64)" passed, "Claude harness (arm64)" is in progress, and the `test` job is still queued. The driver re-posts this stage.

There was no pre-pass block, so I applied the latest panel verdict (review 5569781848 on `a25ec72`).

**Must-fix (saboteur 1 and wire-watcher 1, the same bug):** a bad or already-used invitation link wiped the visitor's stored guest credential. The server answered such invitations with the same 401 as a bad credential, and `home.js` forgot the stored guest on any 401/403. Fixed in commit `d248526`:
- **Server:** `src/web/guest-web-router.ts` now answers an unknown, already-accepted or in-flight invitation with `404 {code: "invitation-unavailable"}` instead of 401.
- **Client:** `deploy/aws/www/home.js` has a new exported `credentialRejected`. The accept handler forgets the stored guest only if a plain `GET /api/guest` with the same credential is also refused with 401/403.
- **Tests:** client unit tests in `test/home-page.test.ts` (this also covers the prover's missing-test item). An HTTP test in `test/web/guest-web-http.test.ts` checks that an unknown and an already-used invitation both get 404 and both visitors' credentials still work.

**Pruner (request-changes), commit `5ea6269`:**
- Deleted the redundant JSDocs in `src/waitlist/waitlist.ts` and the narrating comments in `home.js`.
- Rewrote the "has since become public" asides in `DEPLOYMENT.md` and `designs/account-creation-open-signup.md` in the present tense.
- Cut the attribution, date and sibling-PR reference from the status line of `designs/closed-beta-waitlist.md`.
- Trimmed the waitlist section of `DEPLOYMENT.md` to the commands plus a link to the design. I kept the design's § Retention bullet because it also covers when a row is removed, which the storage table doesn't.

**Verification:** `tsc --noEmit` is clean. The affected and doc-asserting suites passed locally (9 files passed, 2 skipped; 180 tests passed, 3 skipped). I posted a summary of the round on the PR (issuecomment-6265667214).

**Not addressed:**
- Procurer's should-fix to use `@endo/http-confine`'s rate limiter instead of the local copy. That package isn't a dependency here (the archivist also found no reference), so adding it is a cross-repo dependency decision, not a fix-round change.
- Remaining should-fix and comment-only items, such as stripping the invitation from the address bar at boot.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3117623 cached reads)
- Output: 17926 tokens
- Cost: $1.7033085999999997
- Wall-clock: 3825s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
