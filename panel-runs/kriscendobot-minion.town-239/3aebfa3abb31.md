---
kind: panel-run
repo: kriscendobot/minion.town
pr: 239
panel_kind: code
provider: anthropic
base_ref: 919689231495f6b62fd5a7a80c712acd667881a2
pr_body_hash: 44e153d46c52cbffc36dc8d667d86d20fb437f5337c907c8dc29c98bba1cbeed
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 9b22457d9da49eee326ee2a1a296e94c3823f487
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 3aebfa3abb31
recorded_by: endolin-garden-ece02cb4
---

# Panel run — kriscendobot/minion.town #239 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `9b22457d`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=must-fix decomplector=must-fix duality-auditor=pass engine-realist=comment fast-checker=comment gateway=pass integrator=comment locksmith=comment migrator=comment orthographer=comment packager=comment procurer=comment prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=pass typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- archivist: **must-fix**: `.changeset/web-accept-locator.md:5` tells users to "paste an invitation locator … into the web invit...
- archivist: **should-fix**: `src/endo/root-host-socket.ts` (the `BrowserGuestDirectory` JSDoc, about lines 572-583) says the dire...
- archivist: **should-fix**: `designs/invitation-only-guest-onboarding.md` (the locator-form paragraph) and the matching `src/web/...
- archivist: **comment-only**: `src/web/invitation-envelope.ts` (header comment, about lines 7-9) has an awkward reflow ("…and d...
- curator: **should-fix: the locator shape is defined in three places.** [rule: roles/jurors/curator/AGENT.md § cross-package o...
- curator: `deploy/aws/www/home.js` defines `LOCATOR_PATTERN` as `/^endo:\/\/[^\s]{1,4089}$/`.
- curator: `src/web/invitation-envelope.ts` defines `LOCATOR_SHAPE` as `/^endo:\/\/\S{1,4089}$/`.
- curator: `src/web/guest-web-router.ts` defines `INVITATION_LOCATOR`, which is exact.
- curator: The comments in the first two say they mirror each other, but nothing enforces it. Nothing ties the 4089 cap to the s...
- curator: Fix: export one browser-safe constant and import it in both places, or add a test that fails when they diverge.
- curator: `invitation-envelope.ts` already duplicates `home.js`'s `parseFragment`, which is an older instance of the same problem.
- curator: **should-fix: the accept-request body is a new public shape with no named type.** [rule: roles/jurors/curator/AGENT.m...
- curator: `POST /api/guest/invitations/accept` now takes either `{invitationIdentifier, petName}` or `{locator, petName}`, and ...
- curator: The union exists only as inline `fields` handling in `guest-web-router.ts` and as a `@type` comment in `home.js`.
- curator: The router checks `locator !== undefined` before it reads `invitationIdentifier`. A request that sends `locator: null...
- curator: Fix: add one exported request type that both the router and the client use.
- curator: **comment-only: `BrowserGuestDirectory` gains a method.** [rule: roles/jurors/curator/AGENT.md § primary surface]
- curator: `isLocalInvitation(locator)` is added to the exported interface in `src/endo/root-host-socket.ts`. Any other implemen...
- curator: I found no other implementer in the diff. `GuestWebService.acceptLocal`'s signature is unchanged.
- curator: The semantic change is that `acceptLocal` now throws `InvitationUnavailableError` for a locator that is not local. Th...
