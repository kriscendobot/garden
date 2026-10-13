Fix round 6 for kriscendobot/minion.town#183 is pushed and CI is green (3 of 3 checks passed). I applied both must-fix items from the round-6 panel and left the should-fix items for later.

**Must-fix items applied** (commit `f8cf901`, pushed on top of `8415af6` to `build/inference-phase3-secrets`):

1. **The prompt-origin refusal now happens in one place.** Only the gated exo refuses now; I deleted the second copy in `agents.ts`, along with the `gatedExos` WeakSet and `isPromptOriginGated`. `makeClaudeAgent` treats a `needs-containment` result as a non-provider outcome: it returns it straight after the call and skips outcome bookkeeping, so refusals don't add to the unclassified-failure count. A new `isNeedsContainment` helper recognizes the refusal, and `refuseNeedsContainment` is now private to the gate module.
2. **Root authorship is now a separate capability instead of a hidden WeakMap.**
   - `makeClaudeAgent` takes the prompt origin as a parameter, defaulting to `guest-influenced`.
   - New `makeRootAuthoredInfer(context, rootFormulaId)` in `agents.ts` is a host-only function, never exposed across CapTP. The deployment provides it through `rootAuthoredInferFor(subject, guestFormulaId)` (root subjects only), and the root session receives it as `ClaudeHandles.inferRootAuthored`.
   - It creates a root-authored agent for each child on first use and runs only when the caller's handle is still that child's current one. A stale or foreign handle now gets `unavailable` instead of silently falling back to the guest path.
   - The root MCP session's `infer` tool (`guest-tools.ts`) uses this handle and no longer imports `agents.ts` dynamically.
   - `inferRootAuthored`, the WeakMap and the incorrect "module-private" comment are gone.

**Tests:**
- I updated the handle fixtures and replaced the old `inferRootAuthored` test with one for `isNeedsContainment`.
- I rewrote the inference-slot test. A refused call now takes the slot like any other call, so it answers `subscription-busy` while the slot is held. Repeated refusals release the slot each time.
- I added a test that a stale handle (kept across a dismiss and re-create) or a handle from a different child gets `unavailable`.
- The typecheck is clean. Locally, 1069 tests pass and 1 fails: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That file is not in this PR's diff, and CI passed.

**Not done:** none of the panel's should-fix items:
- the inbox responder re-delivers a refused message every scan and spends a rate-limit slot each time
- `status()` reports `connected` after the secret blob is revoked
- `/_internal/claude/infer` and `inbox-watch` don't handle the new refusal result
- `ClaudeAgent` has no InterfaceGuard
- the vault receives the whole root host instead of an attenuated view
- the credential is split across a blob and a state file with no justification in the PR body

They will likely come back in panel 7, which the driver posts next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2931321 cached reads)
- Output: 20231 tokens
- Cost: $1.7905322000000004
- Wall-clock: 1000s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
