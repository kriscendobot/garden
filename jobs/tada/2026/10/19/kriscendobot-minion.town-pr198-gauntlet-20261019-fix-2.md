Fix round 2 for PR #198 is pushed and CI is green on `a25ec72c`: `test`, Claude harness amd64 and Claude harness arm64 all pass.

The head I started from, `f18f25ec` ("accept invitations only with a guest credential"), was newer than the commit the panel reviewed (`e8e73598`). It had already removed the unauthenticated creating branch of `POST /api/guest/invitations/accept`. That cleared these must-fix items:
- **decomplector:** the reversal of the maintainer's decision on #56.
- **curator:** two routes creating a guest and disclosing a credential.
- **migrator:** the 401 contract change.
- **assessor:** the lost-201 stranded guest.
- **locksmith and saboteur:** their lost-201 notes.
- **archivist:** the `GUEST_ADMISSION` claim. `designs/closed-beta-waitlist.md` now says guest admission stays open on this branch and that the setting is not in this tree. The `.env.example` banner and the "Signed-in accounts with no bond" heading were also fixed.

I added one commit, `a25ec72c`, pushed with `safe-push-pr-head.sh`:
- **`deploy/aws/www/home.js`:** if an accept is rejected with 401 or 403 and the browser holds a stored guest, the accept handler now forgets that guest and re-describes the card. A dead guest no longer blocks every retry (assessor's should-fix 1).
- **`dev/guest-web-demo.ts`, `src/waitlist/waitlist.ts`:** removed the duplicated body-parser ordering comments (pruner item 1). The mount-site comment in `src/http.ts` remains.

`npm run typecheck` is clean. I ran the home-page, waitlist and web tests (131 passed, 2 skipped) but not the full suite.

I did not touch the pruner's other nine doc and comment trims, packager's PR-split and squash suggestions, procurer's `@endo/http-confine` limiter (not published), or typist's `GuestState` typedef. All are should-fix and none block merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 130 tokens (5371658 cached reads)
- Output: 24448 tokens
- Cost: $2.3872601
- Wall-clock: 7407s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
