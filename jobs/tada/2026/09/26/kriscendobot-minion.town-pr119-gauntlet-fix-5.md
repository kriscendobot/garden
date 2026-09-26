Fix round 5 for kriscendobot/minion.town PR #119 is done. I pushed one commit, `22157b4`, to `feat/claude-agent-credential-reauth` (it builds on `5c3cd1f`), and CI is green on it: 3 of 3 checks passed, `ci-wait-merge` rc=0. Locally, `npm run typecheck` is clean and `npm test` passes 534 with 7 skipped. As instructed, I did not re-run the panel.

**What changed (round-5 must-fix items):**
- **Credential "epoch" race** (raised by assessor, saboteur, breaker, corner-prober and locksmith): the odd/even epoch in `wiring.ts` and `agents.ts` could land on a "settled" value while a store was still pending. It is replaced by two things:
  - a generation number that only advances when a credential change actually completes;
  - a count of pending stores, taken as soon as the store is requested.

  An outcome now counts as current only if no store is pending and its generation still matches. This also covers wire-watcher's point: a store that fails leaves the generation alone, so an inference still running under the old credential still reports `needs-auth`.
- **Unserialized revokes** (assessor): `disconnect`'s revoke now goes through the same queue as stores and advances the generation. The revoke after a failed probe in `handleSetupToken` now only revokes the credential its own request stored, so it can't revoke one a second submission stored.
- **Ever-growing `dismissedChildren` set** (purist, engine-realist, locksmith, wire-watcher): replaced by a `liveChildren` map that only holds children still retained; `dismiss` marks the entry dismissed and drops it.
- **`classify.ts`** (spec-keeper, plus a saboteur note): a reset date-time must carry an explicit `Z` or `±HH:MM` offset, otherwise it fails closed rather than being read in the host's local time. Pinned-shape matching now reads only the body's own properties.
- **Smaller items:** `makeWebhookNotifier` now returns a named function (spec-keeper), and I cut the caller-side "STALE OUTCOMES" paragraph from `recordOutcome`'s doc (pruner).
- **Test names** (stylist): in `test/claude-reauth.test.ts`, `h` is now `harness` (the factory is `makeHarness`) and `g` is now `gatedHarness`.
- **New tests:**
  - two replacements stored at once, including one whose probe fails;
  - a disconnect during a store;
  - a store that fails;
  - a reset time of 0;
  - date-times with and without an offset;
  - no reading of inherited properties;
  - both edges of the pre-expiry advisory window.

  The reauth test file now has 55 tests.

**Scribe's missing-summary item:** I posted one PR comment covering all three fix pushes, rounds 3 to 5 (`f993dc9`, `5c3cd1f`, `22157b4`): https://github.com/kriscendobot/minion.town/pull/119#issuecomment-5844447197

**Declined or deferred** (reasons are also in that comment):
- **Declined — archivist's "§ step 1" item:** those citations point at the numbered steps in `claude-agents-capability.md` § User-driven authentication, which is the intended target.
- **Deferred — corner-prober:** a test where both timeout ceilings are reached in the same tick.
- **Deferred — fast-checker:** property tests, which need `fast-check` added as a new devDependency.
- **Kept — duality-auditor:** the `replaceCredential` / `revokeIfCurrent` naming.

I made no garden (main2) changes. The journal inbox could not be read at the start because the clone timed out, so any messages sent to this job went unread.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3532781 cached reads)
- Output: 27581 tokens
- Cost: $2.1875201999999994
- Wall-clock: 630s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
