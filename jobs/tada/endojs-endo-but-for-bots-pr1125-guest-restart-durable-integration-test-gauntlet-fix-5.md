CI is terminal and green on the pushed head `d91b1efe0` (19 SUCCESS, 15 SKIPPED, none failing or pending).

## Completion report — FIX round 5, endojs/endo-but-for-bots PR #1125

Applied the three request-changes must-fix items from the round-5 panel verdict to the PR head (`kriscendobot:bot/build/endo-guest-invite-primitive`), pushed as follow-up commit `d91b1efe0`, and drove CI to green.

**Changes (all in `packages/daemon`):**
- **corner-prober (must-fix-loop) — retention-pin key collision** (`src/manager.js`): the accepted-invitation retention pin is now keyed on the *whole* guest name path (`guest-${guestNamePath.join('-')}`) instead of only the leaf. Two invitations sharing a leaf under different directory paths (`team-a/bob` vs `team-b/bob`) no longer collide on one `guest-bob` slot where the second accept would clobber the first's retention edge and orphan the first guest. A single-segment name still yields exactly `guest-<name>`, preserving the operator-navigable `@pins/guest-<name>` contract the multiplayer suite depends on; the key is a pure function of the path, so the documented crash-retry-overwrites-its-own-pin cleanup is preserved.
- **prover (must-fix) — missing regression test** (`test/endo.test.js`): added `guest with read-only networks locates through the attenuated view`, which provisions a guest with a read-only `networks` attenuation, seeds it with the host's live loopback network, and drives `E(guest).locate('@self')` — the only path reaching `getAllNetworkAddresses` for a guest. It asserts locate() succeeds (would throw a `provide(id,'directory')` type mismatch if the `readable-directory` unwrap were reverted) and that the read-only view computes the same advertised addresses as a plain writable directory. Test passes locally.
- **locksmith (must-fix) — undocumented shallow attenuation** (`src/types.d.ts`, `src/directory.js`): documented on `ReadableNameHub.lookup`/`maybeLookup`, `EndoDirectory.readOnly?()`, and the implementation that `readOnly()` attenuation is SHALLOW — nested capability-bearing values (sub-directories, handles, workers) are returned live, not re-attenuated — so callers don't mistake it for recursive narrowing (the seat's explicit accepted alternative to implementing recursion).

**Verification:** `tsc` + `tsc --project tsconfig.test-types.json` clean; eslint clean (only pre-existing warnings); `mail-pins.test.js` (4) and the `readOnly`/`provideGuest` subset of `endo.test.js` (16) plus the new test all pass locally (via a temporary short-sockPath patch, reverted before commit, to work around this worktree's long-unix-socket-path limit). Final CI on head `d91b1efe0`: 19 SUCCESS / 15 SKIPPED / 0 failing.

**Follow-ups (not must-fix this round, left for a later pass):** breaker/engine-realist should-fix items — `provideGuest({networks})` accepting a plain writable directory (shared-mutable-state channel; doc or narrow the type), `reincarnateMailboxPins` structural `throw`s that violate its own best-effort invariant, the full-`@pins` walk on every delivery and per-call `formulateReadableDirectory` formula mint (perf/memoization); and corner-prober's summary-fix test gaps (pre-migration-guest fallback branch, reincarnate error branches, and an accept()-of-a-nested-path regression test for the collision fix just landed).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 186 tokens (9312137 cached reads)
- Output: 51366 tokens
- Cost: $7.315322500000001
- Wall-clock: 1507s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
