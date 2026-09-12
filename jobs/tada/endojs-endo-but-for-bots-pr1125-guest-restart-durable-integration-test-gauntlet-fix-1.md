Fix stage complete. CI is green on my pushed fix commit.

## Completion report — FIX round 1, endojs/endo-but-for-bots PR #1125

**Panel must-fix items applied (one commit, `d9297be49`, pushed to PR head `bot/build/endo-guest-invite-primitive`):**

1. **Invitation `accept()` TOCTOU race (must-fix; assessor, saboteur, breaker, wire-watcher).** The single-use guard read the `guestName` slot via `identify()` but only rebound it (trailing `storeLocator`) ~12 awaits later, after `networkBroker.addPeerInfo` and other side effects — so two concurrent/replayed `accept()` calls could both pass the check and each redeem the invitation (two guests, two peer registrations). Fix: serialize `accept()`/`cancel()` per invitation through a new per-invitation `makeSerialJobs()` mutex, and **consume the invitation first** (rebind the `guestName` slot to the accepted remote handle, then cancel the controller) *before* any externally visible side effect. I deliberately used a per-invitation lock rather than `withFormulaGraphLock` alone, because that lock's reentrancy depth-guard bypasses its serial queue for concurrent top-level calls — documented in the code comment.

2. **`cancelInvitation` shared check-then-act gap (should-fix, same root cause; saboteur/breaker/wire-watcher).** Routed through the same per-invitation lock and wrapped the bare `withFormulaGraphLock()` in a real `withFormulaGraphLock(async () => {...})` callback, so a `cancel` racing a mid-flight `accept` can no longer un-name a just-accepted guest.

3. **Changeset `@endo/spaces-util` entry missing (must-fix; changeset-auditor).** Added `'@endo/spaces-util': minor` (private, but versioned per `.changeset/config.json`).

4. **Changeset body not sentence-per-line (must-fix; changeset-auditor).** Reflowed to one sentence per line per AGENTS.md; also updated the single-use prose to match the now-atomic behavior.

**Verification:** `node --check`, package `tsc` (lint:types), and `eslint` all pass with 0 errors locally (unrelated `packages/floot/package.json` warm-cache churn reverted). First CI run had one red leg — `test (22.x, ubuntu-latest)` — where **all 1287 daemon tests passed** but a teardown-time `SES_UNHANDLED_REJECTION: "Termination requested"` (the known exit-leak/daemon-shutdown flake) forced exit 1; the other three `test` legs were green on identical code. That all invitation tests passed also confirms the new lock nesting does not deadlock. Re-ran the failed leg; it passed. **CI is now fully GREEN (34/34).**

**Follow-ups (non-blocking, deferred to panel-2 / maintainer):** the numerous should-fix/comment-only panel items not in scope for a single fix round — `nets`→`networks` option rename (stylist), legacy `?? hostAgent` coercion in `extractLabeledDeps` + optional typedefs (typist), `GuestFormula.hostAgent`→`invitingAgent` downstream rename (duality-auditor), `getAllNetworks` readable-directory unwrap (purist), `reincarnateMailboxPins` per-message hot-path & `Promise.allSettled` isolation (engine-realist/assessor), `readOnly()` memoization, and doc/taxonomy touch-ups (packager/archivist/integrator). A concurrent-accept regression test (wire-watcher should-fix) was not added this round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 122 tokens (7124523 cached reads)
- Output: 49054 tokens
- Cost: $6.5106505
- Wall-clock: 2909s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
