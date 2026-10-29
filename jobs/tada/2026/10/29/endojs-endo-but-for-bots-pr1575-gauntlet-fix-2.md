# FIX round 2 — endojs/endo-but-for-bots#1575

I applied the must-fix items from the latest panel verdict (review 5701995536, from the releaser and coverage-auditor seats) and pushed them to `feature/api-key-provider-adapters`. CI is **green**: 36 checks, 0 failed.

**Changes (4 commits, head `0f392abd96` → `88a03ee7c8`):**

1. **`docs(changeset)`, releaser findings 1, 2 and 4:**
   - **Hosted-agent changeset:** cut to the user-visible capabilities. I removed the ledger internals and the dependency bookkeeping.
   - **Upgrade note added:** it states the default limits. Providers and owners get 2 concurrent turns, 20 requests per minute and $5 per day; agents get 1, 10 and $2. It also names the four ways to raise them: `limits` at creation, `setLimits`, `setOwnerLimits` and `setGrantLimits`.
   - **Fae changeset:** now names the `{ kind: 'brokered-messages', inference, model, maxTokens? }` recipe shape.
2. **`fix(lal)`, a real bug the new tests found:** in a stream framed with bare `\r` line endings, the last event was never delivered. A trailing `\r` waited for a possible `\n` even after the stream had ended, so the reply was refused as truncated. At end of stream a trailing `\r` now counts as a line ending.
3. **`refactor(fae)`:** I moved the driver's nested ternary that decides how the provider authenticates into an exported `providerCredentialOptions` helper. Behavior is unchanged; the change makes the brokered branch testable on its own (coverage finding 4).
4. **`test(lal,fae)`, coverage findings 1–4:**
   - **Stream errors:** one test per error path in the brokered stream parser, plus a test for `\r` line endings.
   - **`maxTokens` rejection:** cases for 0, -1, 1.5, `MAX_SAFE_INTEGER + 1` and the string `'64'`.
   - **Lal worker loop:** a test of the brokered success path in `spawnWorkerLoop`. The broker receives `model` and `max_tokens` taken from `LAL_MAX_TOKENS`, and the request carries no key.
   - **Fae driver:** a new `driver-credentials.test.js` for the brokered, subscription and token-backed choices.
   - Locally, the Lal suite passes (28 tests), the Fae suites I ran pass, eslint reports no errors and type checks are clean.

**CI:** the first run had three red jobs, none in packages this push changes:
- `cover` and `sandbox-drivers` both failed on one sandbox test: `bwrap timeout and repeated cancellation reap process groups`.
- On `test (24.x, macos-15)`, the daemon's `http-content-plane.test.js` exited with code 1.

The previous head had no failures, so I treated these as flakes and reran the failed jobs once; all passed. The first bounded wait timed out (rc 4) with only the rerun macOS job still pending. A second bounded wait then returned rc 0 (green).

**Follow-ups (not done here):**
- Lal's `getCancelled` waits for the cancellation itself when the context has a bare `cancelled` promise, which blocks the inbox loop until it is cancelled. This is existing behavior outside this PR's scope. The new loop test passes `null` as the context to avoid it.
- Coverage findings were based on reading the code, not on a coverage report; I did not run c8 to measure them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 116 tokens (5628783 cached reads)
- Output: 25003 tokens
- Cost: $2.5277926
- Wall-clock: 5331s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
