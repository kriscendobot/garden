PR #81 now pairs two local guests through the real `EndoGuest.invite` / `EndoGuest.accept` instead of writing into their directories with `storeIdentifier`. Everything passes locally against a real daemon at the pinned commit, and CI is green.

- **Branch:** `build/invitation-only-guest-onboarding`, new head `842ac61`.
- **PR state:** kriscendobot/minion.town#81 is still a draft and is now `MERGEABLE` (it was `CONFLICTING`). I did not run the gauntlet.
- **CI:** `test`, both Claude harness builds (amd64 and arm64), and dependabot all pass.

**Precondition:** `origin/main:src/endo/captp-client.ts` pins `f9cbcfc426f726858a671bcb09f7c2c774cc659e` (landed by #112). That commit carries `EndoGuest.accept` (#1310) and the registry migration (#1329).

**What I did:**
1. **Rebased the PR's 6 commits onto `main` (`df2277e`).** The only conflict was in `.github/workflows/test.yml`, where both sides had added CI. I kept both the new real-daemon invite/accept test step and main's Claude harness image job. I also fixed that step's comment, which described the old mechanism, and a test file listed twice in its `run:` line.
2. **Replaced the pairing code** in `src/web/guest-web-socket-service.ts`:
   - `connectLocal` now does `E(inviter).invite(name)`, then `locate()`, then `E(invitee).accept(locator, name)`.
   - The `has()` checks still run first, so a taken pet name is rejected before any invitation is minted.
   - I added `accept` to the `DaemonGuest` interface and added a small `DaemonInvitation` type with `locate` and `cancel`.
3. **Added one cleanup step for a failed accept.** I read the daemon's code at `f9cbcfc`:
   - A failed accept undoes the invitee's side.
   - It deliberately leaves the invitation unused under the inviter's pet name, so it can be redeemed on a retry.
   - Since `connectLocal` is the only holder of the locator, a failed accept now calls `cancel()` on the invitation. Otherwise the inviter's name would stay taken and the router's retry (it puts the app invitation back to `pending`) would fail on a name conflict.
   - The daemon makes `cancel()` wait its turn behind any `accept()` on the same invitation, and it does nothing to an invitation that is already used.
4. **Updated the comments** in `test/web/guest-web-daemon.test.ts` (the header and the step-3 comment) to describe the invite/accept flow.
5. **Updated the design doc:**
   - Rewrote the local-invitation bullet in § 11.
   - Changed the remote-invitation reference from #1125 to the #1304/#1306/#1305 stack that replaced it.
   - Added § 13 describing the new mechanism and the contract checks below.
   - Removed "expired" from § 2's list of failed invitation states, since Endo invitations have no expiry.

**Contract checks:**
- **Expiry/TTL:** the PR's diff adds no expiry logic in `invitation-session.ts`, `invitation-envelope.ts` or anywhere else.
- **`hostAgent`/`hostHandle`:** no matches in the PR's diff.
- **`provideGuest(name, {agentName})`:** still fits the pinned daemon. `pins` and `networks` are optional, and the default empty `@nets` still accepts guests on the same daemon.

**Verification** (`ENDO_CHECKOUT` = the Endo checkout at `f9cbcfc`):
```
npm run typecheck                                   → tsc --noEmit, clean
npm test                                            → Test Files 47 passed | 2 skipped (49); Tests 479 passed | 7 skipped (486)
npx vitest run test/endo-daemon-integration.test.ts → Tests 5 passed (5)
npx vitest run test/web/guest-web-daemon.test.ts    → Tests 2 passed (2)
  ✓ two fresh guests introduce locally and exchange mail with no OAuth and no host introduction
  ✓ rejects mail to a pet name the sender never acquired
```
The committed tests never trigger a failed accept, so I checked the cleanup path with a throwaway real-daemon test (not committed). It confirmed:
- `cancel()` frees the inviter's pet name.
- Cancelling an invitation that was already accepted leaves both names in place.
- Accepting a used locator a second time throws "Invitation has already been accepted, canceled, or superseded" and binds nothing.

**Follow-ups:**
- Pairing no longer uses host authority. The only `storeIdentifier` left is the host-side lookup that turns a guest's bearer token into its object, which this job didn't cover.
- Two concurrent `connectLocal` calls that use the same invitee pet name can both pass the `has()` check. The daemon's accept then silently replaces the earlier binding. This is a possible issue I noticed in passing; I did not change it.
- PR #81 is ready for **run the gauntlet #81** whenever the maintainer wants it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-guest-web-invite-accept-fallback-fix-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2618003 cached reads)
- Output: 15857 tokens
- Cost: $1.5483645999999998
- Wall-clock: 384s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
