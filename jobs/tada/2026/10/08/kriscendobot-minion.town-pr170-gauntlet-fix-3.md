Fix round 3 for kriscendobot/minion.town PR #170 is done: two commits pushed to `feat/locator-fragment-scrub` (c3bc2f4 → fa8973b), PR description rewritten, and CI is green on fa8973b (`test`, plus Claude harness amd64 and arm64).

I applied the four must-fix items from the round-3 panel review:

1. **Hostile link hiding the stored guest (saboteur).** Fixed on both the server and the browser.
   - I first checked what the real pinned daemon throws. An ID for something that isn't a guest (an invitation, a handle, the host's `@self`) fails with `target has no method "list"`. An ID from another node fails with `No peer found for node identifier`. Both used to come back as 503, which is what let the lockout happen.
   - **Server:** `open()` now checks that the looked-up object has every method the service calls and returns `GuestCredentialError` (401) if not. `isUnknownCredentialError` also matches the foreign-node message.
   - **Browser (`guest.js`):** on startup, a pending link that fails its check with anything other than 401 is now dropped when a stored guest exists, and the stored guest is shown. With no stored guest it stays for a retry. The link's credential is also passed only to its own verify request instead of temporarily replacing the shared `guestId` (a should-fix).
2. **Tests that didn't pin the changes (prover).**
   - **Fake-daemon tests:** a new `test/web/guest-web-socket-service.test.ts` goes through `makeSocketGuestWebService`, not a stub. It covers 401 for unknown and non-guest IDs, 503 for a disconnect, one shared connection for concurrent first requests, and reconnecting after a close or a failed connect.
   - **Connection handling:** to make that testable, the service now accepts an injected `connect` option. It also now shares the in-flight connection, which fixes the connection-leak race (a should-fix).
   - **Real daemon:** a new case in `test/web/guest-web-daemon.test.ts` pins the daemon's wording for an unknown ID, a foreign node, a handle and an invitation.
   - **Mutation checks:** reverting each of the three changes (the error-mapping catch, the reconnect, the guest-method check) makes the test aimed at it fail.
3. **PR description (integrator).** It now covers:
   - the 401/503 split and reconnect
   - the switch prompt
   - the parser move with the Playwright dependency and CI step, and the reasoning for the `src/` → `deploy/` import direction
   - a "For maintainer confirmation" section on reversing #56's choices and on rewriting acceptance criterion #7 in the same PR
   - a narrower claim about what the AES-GCM storage actually protects
4. **`#recover=1` matched exactly (corner-prober).** The bootstrap now resumes recovery when the fragment has `recover=1` in any order and beside other parameters, as long as it carries no guest or invitation. I updated the CSP hash in Caddy, added browser tests for the trailing, reordered and wrong-value cases, and documented the rule in the design.

**Local results:**
- Browser suite: 13/13 pass, including the new lockout test, which fails without the fix.
- Real-daemon suite, against a pinned Endo checkout I built locally: 3/3 pass.
- Typecheck is clean.
- `npm test`: 944 pass and 1 fails, in `test/git-remote/capability.test.ts` ("propagates a git failure…"). That file wasn't touched here and its failure on this host predates this PR; CI's `test` job, which includes it, passed.

**Left for later** (non-blocking should-fixes I didn't do):
- Merging the two consent checks into one compare-and-set step.
- Retiring the unused `src/web/invitation-session.ts`.
- Defining the fragment grammar constants and invalid-link reasons in one place.
- Regrouping the earlier fix-up commits.
- Adding Firefox and WebKit to the Playwright runs.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4778502 cached reads)
- Output: 32282 tokens
- Cost: $2.5880604000000007
- Wall-clock: 599s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
