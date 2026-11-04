**PR #239 fix round 2: fixes pushed and CI is green at `aebfdf39`.** No pre-pass block was attached, so I worked from the latest panel verdict, the bot's `Must-fix before merge` comment review. I did not re-run the panel.

**Must-fix items**
- **Archivist (design doc):** `designs/invitation-only-guest-onboarding.md` no longer calls `invitation` the only authority in the fragment. The envelope section and route table now include `#v=1&locator=`, and it is documented as a bearer that gets scrubbed from the address bar.
- **Locksmith (attenuation):** I read the daemon at the pinned commit (`1706e632`, `acceptInvitation` in `manager.js`).
  - **Already safe:** it refuses any type other than `invitation` before touching state, so that part of the finding needed no fix. There is also no invitee binding to copy, because registry links are bearer-only too.
  - **Real gap:** a locator naming another node gets its hints registered as a peer route and dialed. That holds the daemon-wide accept queue for up to 2 minutes per stalled network step, and on this route the visitor supplies the locator.
  - **Fix:** `acceptLocal` now refuses a locator whose host isn't this daemon's node, using a new `BrowserGuestDirectory.localNode()`. The PR's claim that a foreign locator gets a 404 now holds without the daemon dialing.

**Should-fix items**
- **Locksmith, accept order:** no change needed. The name check runs before the accept, and the daemon binds the name before spending the invitation, so a name conflict doesn't burn it.
- **Purist:**
  - A body with both `locator` and `invitationIdentifier` now gets a 400.
  - The identifier route's original error order is restored.
  - A comment explains why the locator path has no `stillHolds` check.
  - The server and client patterns stay separate, but a comment now links them and says the server is authoritative. The purist preferred a shared constant or daemon-side parsing.
- **Typist:** replaced the `…` and `→` glyphs with ASCII and rewrote the `parseFragment` doc comment.
- **Pruner:** cut the narrating test comments and the unverifiable "getting-started guide" claim, and trimmed the PR body.
- **Also tightened:** `isInvitationLocator` now requires `type=invitation` rather than just any `type`.

**Verification**
- **Local:** `tsc --noEmit` passes, and 126 tests pass across the home-page, HTTP, socket-faults and local-invitations suites.
- **CI:** both workflows on `aebfdf39` succeeded. That includes "Test live-daemon guest web invite/accept acceptance", where `guest-web-daemon.test.ts` ran 6 of 6 against a real daemon. This confirms that real minted locators pass the node check and a foreign one gets a 404.
- **Limit of the CI read:** this PAT can't read `statusCheckRollup`, so `ci-wait-merge` used the Actions runs API and couldn't see commit statuses or non-Actions checks.

**Left as is**
- **Comment-only items not applied:** the `landingMode` type stays wide, `isGuestStateError` stays an allow-list, there is no `optionalField` helper, and the borderline `boot` comment stays.
- **Worth a follow-up:** the locator branch turns every error that isn't a guest-state error into a 404, so a daemon outage during `acceptLocal` looks like a dead link instead of a 503. The panel only touched on this (purist finding 4, comment-only), so I didn't widen the change. The next panel may want to weigh it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1983354 cached reads)
- Output: 24194 tokens
- Cost: $1.8289988
- Wall-clock: 797s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
