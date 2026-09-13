The PR head is my pushed commits, the working tree is clean, and CI is fully green. The fix stage is complete.

## Completion report — Gauntlet FIX round 6, endojs/endo-but-for-bots PR #1125

Applied the panel round-6 must-fix items to the PR head (`bot/build/endo-guest-invite-primitive`), pushed two review-feedback follow-up commits, and drove CI to green.

**Commits pushed** (`d91b1efe0` → `ce552357c` → `fb8618300`):
- `fix(daemon): address panel round-6 review on guest-owned invitations`
- `style(daemon): wrap long assertion line to satisfy prettier`

**Changes:**
- **Injective retention-pin key** (`packages/daemon/src/manager.js`) — the consensus must-fix (assessor, breaker, corner-prober, purist, saboteur). `guest-${guestNamePath.join('-')}` was not injective (pet names may contain `-`), so `['team-a','bob']` vs `['team','a-bob']`, and single `'a-b'` vs path `['a','b']`, shared one `@pins` key and the second `accept()` silently clobbered the first guest's retention edge. Single-segment names keep their exact `guest-<name>` key (operator-navigable, what legacy DBs hold); multi-segment paths now use a self-delimiting `<len>_<segment>` encoding. Added a two-daemon regression test asserting two colliding-under-join paths retain distinct pins (passes locally).
- **Legacy-guest fallback collision** (manager.js, breaker) — the pre-pin-directory fallback stores in the creating host's *shared* `@pins`; namespaced its key with the inviting handle's formula number so two legacy guests inviting the same name no longer collide.
- **stylist must-fix** — `dir`/`readOnlyDir` → `directory`/`readOnlyDirectory` in the two new `readOnly` tests.
- **archivist** — corrected the formula-view-registry pin-row comment (immutable formula records never gain guestPins/hostPins from reincarnation alone) and dropped the drift-prone "33 formula types" count in `designs/formula-inspector.md`.
- **releaser** — narrowed the changeset's "no network authority" claim to match `guest.js` (no dialing/peer-registration authority, but the invitation still discloses connection-hint addresses via `locate()`).

**Verification:** local eslint (0 errors), `lint:types` (rc 0), prettier `--check` clean, and the affected daemon tests pass locally (new regression test, renamed readOnly tests, and `guest invites a guest` which pins the single-segment `guest-guest-b` key). CI terminal: **all 19 non-skipped checks pass**. The one interim failure was an isolated `test (24.x, macos-15)` `hosted-agent` flake (a package with no daemon/spaces-util dependency, green on ubuntu 22/24 + macos-22 + `cover` + `sandbox-drivers` + locally); a re-run of that job concluded SUCCESS.

Follow-ups (not blocking, deferred to a later round/panel): several should-fix items were left for the panel loop — duality-auditor's larger `GuestFormula.hostAgent`→`creatingAgent` rename, corner-prober's requested `Invitation.cancel()`/double-accept tests, engine-realist/saboteur's per-delivery `reincarnateMailboxPins` fan-out cost, and scribe's consolidated PR completion-summary comment. The maintainer's own latest review also asks to follow through Chat/formula-inspector diagnostics and then retcon.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 1 host(s)
- Input: 232 tokens (15323801 cached reads)
- Output: 70288 tokens
- Cost: $11.268614500000004
- Wall-clock: 1849s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
