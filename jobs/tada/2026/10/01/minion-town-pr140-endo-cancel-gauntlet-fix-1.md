I applied all three must-fix items from the round-1 panel review on kriscendobot/minion.town#146 in one follow-up commit (`7c6a302..1258647`). CI on the new head came back green (3/3 checks).

**Changes**
1. **Hardening (warden):**
   - `src/endo/cancel-kit.ts` now returns `harden({ cancelled, cancel, isCancelled })` using `@endo/harden`, which works without `lockdown()`, so the `cancelled` token is now deeply frozen too.
   - `agents.ts` now passes `context.harden({ cancelled })` to `exo.infer`.
   - I corrected the "WHAT IS TRIMMED" doc note.
   - I also took warden's comment-only point: the kit now wraps a parent token in `Promise.resolve`, so a foreign thenable's `then` is never called synchronously.
2. **Reject-only token contract:**
   - The `cancelled` option on `ClaudeInferExo.infer` in `src/endo/claude/types.ts` now documents that the token never fulfills and rejects on teardown. If a provider lets that rejection escape `infer`, the caller's `infer` resolves as `unavailable` (the existing `tagged` wrapper does this), not as a thrown error.
   - A new test pins that behaviour and checks that the inference slot is freed afterwards.
3. **Boundary tests:**
   - In `test/claude-delegation.test.ts`: teardown before the provider reads the token, teardown after `infer` settles (the token is never rejected), and a double teardown (cancels once, frees the slot).
   - In `test/endo-cancel-kit.test.ts`: falsy reasons become `"Cancelled"`; a parent cancelled only through its token is seen after a microtask, not synchronously; a child's own reason wins over a later parent cancel; and the kit, token and functions are all frozen.

**Checks**
- Typecheck is clean.
- The three affected test files pass (56 tests).
- The full local suite had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). This PR doesn't touch that suite and CI passed, so it is probably caused by the local environment.

**Follow-ups:** none. The driver re-posts panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1097822 cached reads)
- Output: 10035 tokens
- Cost: $0.9734644000000002
- Wall-clock: 425s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
