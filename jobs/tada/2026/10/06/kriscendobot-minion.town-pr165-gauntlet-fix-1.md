Fix round 1 on kriscendobot/minion.town#165 is done. I pushed one commit (`94a3689`) and CI is green (3 of 3 checks).

**Must-fix items from the panel, and what I did:**
1. **assessor — failed install left a live child:** if `create(name, { watchInbox: true })` creates a new child and then fails to install its responder, it now tears that child down and frees its quota slot before failing. A child that already existed before the call is left alone. The facet reports the failure as `{type:"unavailable"}` rather than throwing.
2. **stylist — abbreviated names:** renamed `maxPerWindow`/`windowMs` to `maximumPerWindow`/`windowMilliseconds` on the new `enableInboxResponder` surface: `types.ts`, `claude-guest-bridge.ts`, the call in `agents.ts`, and the integration test. I left the older `InboxWatchRate` type alone because this PR did not add it.
3. **prover — no test through the production guard:** `test/claude-guards.test.ts` now calls `create` with `{ watchInbox: true }` through the guarded exo, and checks that a non-boolean `watchInbox` is rejected.
4. **saboteur / wire-watcher — de-rooted subject kept inference:** `inferForInboxResponder` now checks that the subject is still a root subject, and treats the bearer as unknown (403) if not. The restore loop skips stored responders for subjects that are no longer root.
5. **saboteur — bare `catch {}` in the endpoint:** errors are now logged with `console.error` before the 503.
6. **breaker — the child could pass around an uncapped `infer` handle:** the 1-per-60s limit is now enforced in `inferForInboxResponder` itself, per bearer token. Anyone holding the agent proxy is held to the same limit as the responder.
7. **integrator — the "completes item 6" claim was unbacked:** I reworded the PR body to "delivers the provisioning slice of item 6". I also added an "Outstanding acceptance evidence" section listing the slot-contention and flooding observations that have not been made yet. Making the limit adjustable per child is noted as out of scope.

**Also fixed (should-fix):** two simultaneous inbox requests can no longer create two agent handles for the same child.

**New tests** in `test/claude-inbox-responder.test.ts` cover the endpoint rate limit, a de-rooted subject's bearer being refused, and cleanup after a failed install. All 268 tests in `test/claude-*.test.ts` pass and `tsc --noEmit` is clean.

**Not done (for the next round or a follow-up):**
- **Proxy still in the child's namespace:** breaker's preferred fix was to move the agent proxy out of the child guest's own namespace into one only the responder can reach. I did not; the endpoint limit closes the uncapped path, but the child can still look up and use the proxy.
- **Panel should-fix items left open:**
  - The proxy only checks that the reply's `type` is a string.
  - There are two copies of the `ClaudeAgent` interface guard.
  - Child records are restored in two places.
  - A crash at the wrong moment during install or teardown can leave the stored token record out of step with the actual responder or child.
  - Delegated facets can turn on `watchInbox`.
  - The `/_internal/claude/infer` endpoint is described as loopback-only but is mounted on the main app with no loopback check.
- **Unrelated test change:** the test-file diff is bigger than the change needs. Prettier rewrote existing lines in `test/claude-inbox-responder.test.ts` even though the repo doesn't use Prettier. I reverted the same noise in the source files.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1989141 cached reads)
- Output: 16663 tokens
- Cost: $1.4029042
- Wall-clock: 481s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
