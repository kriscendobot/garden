## Fix round 3 for kriscendobot/minion.town#119: done, CI green

I pushed one follow-up commit, `f993dc9`, on top of `793c89a` to `feat/claude-agent-credential-reauth` using `safe-push-pr-head.sh`. CI finished green (`ci-wait-merge` rc 0, 3 of 3 checks passing).

**Must-fix items from the round-3 panel that I applied:**
- **Dismissed agents stayed parked (assessor):** `dismiss()` now takes the agent off the reauth tracker's parked list, so it is no longer counted or woken on reconnect.
  - There is a new `ReauthTracker.releaseParked`.
  - `ChildGuestProvider.removeChild` now returns the removed child's formula id, so this still works after a restart.
- **Race while the replacement credential is being stored (wire-watcher):** `handleSetupToken` now advances the credential epoch again after `store` finishes. An inference that started during the store, and so ran under the old credential, can no longer revoke the replacement.
- **Dropped notices still being sent (saboteur):** `deliverDue` now skips any entry that was removed from the outbox while an earlier send was in progress.
- **Empty-match guard (must-fix-loop):** a seeded test over 2,000 random JSON bodies checks that a shape with an empty `match` never classifies a response.

**Should-fix items I also applied:**
- `infer` and `create` now re-check the epoch after the `status()` call at admission (breaker and wire-watcher).
- An error from `deriveCredentialExpiry` is treated as "expiry unknown", so the reauth event no longer stays open after a probe that passed (saboteur and breaker).
- Two new doc comments used the `⇒` arrow; they now use ASCII (typist).

**Tests:** I added three tests: dismissing a parked agent, an inference starting while the store is pending, and a notice dropped mid-delivery. With the fixes temporarily reverted, all three fail; with the fixes in place, they pass. Typecheck is clean and `npm test` passes (520 passed, 7 skipped).

**Declined:**
- **Archivist's must-fix (stale `handleSetupToken` reference):** not a real problem. `handleSetupToken` does exist, at `wiring.ts:463`, so the JSDoc reference is correct.

**Left for later rounds (none are must-fix):**
- stylist's objection to the `ctx` → `context` rename
- purist's type and naming suggestions: enforcing the narrowed tracker interfaces at runtime, and deduplicating `InferOutcome`
- rejecting an `http:` webhook URL when a secret is set
- `resetAt` values that are already in the past or in seconds rather than milliseconds, and dedupe on a jittery reset time
- checking the shape of the state file when it loads
- sending `onWriteError` to the operational alert
- the `setInterval` handle that is never cleared

I did not re-run the panel; the driver posts panel round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2561600 cached reads)
- Output: 17492 tokens
- Cost: $1.655576
- Wall-clock: 548s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
