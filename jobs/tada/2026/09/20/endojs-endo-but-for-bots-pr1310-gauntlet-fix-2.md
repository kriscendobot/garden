All fixes are present at head and CI is fully green (17 SUCCESS, 15 SKIPPED, 0 pending/failed). The fix stage is complete.

## Completion report

**Stage:** FIX round 2 — endojs/endo-but-for-bots PR #1310 (gauntlet `endojs-endo-but-for-bots-pr1310-gauntlet`).

Applied the panel-2 must-fix items in one pass and pushed them as follow-up commits to the PR head (`bot/build/guest-native-accept`). My commit `12a16f532` landed; a peer added `a801b5d22` (pure prettier reformat of the same change) on top — my logic is intact at head.

**What changed (`packages/daemon` + `packages/cli`):**
- **Speculative-write rollback in `acceptInvitation`** (assessor / warden / breaker / saboteur must-fix): the peer-route registration and the correspondent pet-name bind are both written from the unverified locator before `E(invitation).accept()` proves it (the route so `provide` can dial the peer; the bind so a bad name path can't strand a spent invitation). Both are now rolled back if the accept rejects, so a forged/unspent/replayed locator can neither squat a not-yet-known peer's dialing addresses nor clobber a pre-existing correspondent bound under the reused pet name. `bindCorrespondent` now returns a restore thunk; `host.js`/`guest.js` snapshot the prior binding via `directory.locate` and restore-or-remove on failure. Updated the JSDoc invariant claim and the `DaemonCore.acceptInvitation` type.
- **`makeInvitation` inviter-side guard** (purist must-fix): registers the acceptor's peer route only when the node is not already known, matching `acceptInvitation`'s guard, so an acceptor can't redirect an existing trusted peer's route via bearer locator data.
- **CLI rename** (integrator must-fix): `invite`/`accept` positional + params `guest-name` → `correspondent-name`.
- **`MULTIPLAYER.md`** (surfacer must-fix): the Accept step now names `EndoHost.accept`/`EndoGuest.accept`, symmetric with the invite step.
- **Changeset** (changeset-auditor + integrator must-fix): sentence-per-line rewrap, narrowed the "end to end" rename claim to the facet signatures + CLI (persisted `InvitationFormula.guestName` keeps its internal name), corrected the routing-invariant wording to speculative-write-plus-rollback, and added the `@endo/cli` patch bump.
- **Regression test**: a same-daemon case proving a rejected accept leaves a pre-existing correspondent binding intact.

**Verification:** daemon `tsc` + `tsc --project tsconfig.test-types.json` clean, CLI `tsc` clean, eslint clean (pre-existing warnings only); same-daemon guest-accept + new rollback test + transitive chain pass, cross-daemon "invite, accept, and send mail" and "EndoGuest accepts an invitation into itself across daemons" pass. PR CI terminal: **all green** (17 SUCCESS, 15 SKIPPED, 0 pending, 0 failed).

**Follow-ups (not must-fix; left for panel-3 to weigh):** wire-watcher's cross-check of the persisted formula type against the locator's self-declared `type=` marker, assessor's `from`/`fromNode`-vs-`invitingHandle` cross-check, and integrator's optional security/rename commit split — all should-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1310-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 216 tokens (10356375 cached reads)
- Output: 69921 tokens
- Cost: $9.3953205
- Wall-clock: 2543s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
