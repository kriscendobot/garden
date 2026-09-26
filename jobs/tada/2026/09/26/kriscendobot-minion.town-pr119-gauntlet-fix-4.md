The round-4 fixes are pushed to PR #119 and CI is green (rc 0). The only red was the live-daemon leg: its first two attempts timed out in daemon restart tests this diff doesn't touch, and the third attempt passed.

**What I changed:** one follow-up commit, `5c3cd1f`, on `feat/claude-agent-credential-reauth`, pushed with `safe-push-pr-head.sh` (fast-forward from `f993dc9`). It covers every must-fix from the request-changes seats:

- **assessor (a lapse read while a replacement is being stored):** the credential epoch is now odd while the root's replacement store is still pending. `infer` and `create` only act on a lapse if the epoch they sampled is even and unchanged. A status read that overlaps a pending store now returns a transient `unavailable` instead of reporting or parking. The second epoch bump now runs even if the store throws, so an odd epoch can't get stuck.
- **breaker (a revoke in flight clobbering the new credential):** the revoke after a rejected credential now goes through `revokeIfCurrent(epoch)`. It runs in sequence with replacement stores in `wiring.ts`. A revoke already in flight finishes before the new credential is stored, and a later one sees the epoch has moved and does nothing.
- **wire-watcher (a dismissed agent getting re-parked):** `dismiss` now records the child's formula id in a `dismissedChildren` set. A late `needs-auth` from that agent's in-flight `infer` reports without parking it. Re-creating an agent of the same name clears the entry, so it parks normally.
- **saboteur:**
  - When a usage window resets, the usage state ends but its undelivered notice now stays queued until delivered or declared undeliverable.
  - The `try` in `deliverDue` now wraps only the send.
  - Classifier reasons now name the mismatched CLI versions and give the non-JSON body length. The body text itself is left out so provider output isn't passed back to the caller.
- **stylist:** the two new `sub` locals in `wiring.ts` are now `subscription`.
- **integrator:** I rewrote the PR description to cover the epoch fencing, the serialized revoke, dismissal and the parked ledger, and the notice outbox fixes. It now gives the current counts: 46 tests in `claude-reauth.test.ts`, and `npm test` at 525 passed, 7 skipped.

**Tests:**
- Five new or extended regression tests: the status read during a pending store, the revoke in flight at reconnect, the dismissed agent's in-flight `infer`, the usage notice after a window reset, and the classifier reason strings.
- A companion test checks that a re-created agent still parks.
- All five fail on the previous head `f993dc9` and pass on the new one.
- Locally, `npm run typecheck`, `npm run build` and `npm test` all pass.

**CI:**
- Attempt 1 timed out in the live-daemon `@sites` test at 120s.
- Attempt 2 failed in a different test, the B2 restart-and-read-back.
- Attempt 3 passed.

This leg flakes on `main` too, and the earlier head `793c89a` also needed a second attempt.

**Follow-ups (not done):**
- The remaining should-fix notes are untouched:
  - curator: the `InferOutcome` union is duplicated.
  - spec-keeper: reset times go to `Date.parse` without a strict ISO format check.
  - purist: a second epoch-style fence now exists beside the quota lease token.
  - engine-realist: every state change rewrites the whole JSON state file.
- The assessor's suggested separate `test/claude-agents.test.ts` wasn't created; the new cases are in `test/claude-reauth.test.ts`.
- The confinement-probe revoke inside `handleSetupToken` is still not sequenced with the other credential writes. No test covers a race there.
- The gauntlet driver should post panel-5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr119-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3132525 cached reads)
- Output: 23677 tokens
- Cost: $2.0655889999999997
- Wall-clock: 901s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
