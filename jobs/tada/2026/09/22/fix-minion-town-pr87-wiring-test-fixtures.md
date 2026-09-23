Inbox empty. The job is complete.

## Completion report

**Task:** Address kriskowal's PR #87 review comment "Keep test fixtures under test" on `src/endo/claude/wiring.ts` — the production Claude-wiring module was defining and defaulting to in-memory test doubles.

**What I did** (on the PR head branch `build/claude-agents-capability`, commit `8a0bf2b`):

1. **Moved the child-host double out of production.** `makeInMemoryChildHost` is removed from `src/endo/claude/wiring.ts` and now lives in the test tree at `test/helpers/claude-child-host.ts`. It is no longer exported from the production module; tests inject it via the existing `childProviderFor` seam.

2. **Child provider fails closed in production.** When `childProviderFor` is absent, `makeClaudeDeployment` now defaults to a new `makeUnavailableChildProvider` whose `provideChild` throws (mirroring `makeUnavailableProvider`). It is never reached in the shipped fail-closed build — a flag-on `create` returns `needs-auth` first (credentials fail closed) — but a misconfigured deployment surfaces the fault instead of silently spawning in-memory children.

3. **Credential store is now an injectable seam.** Added `makeCredentialStore` to `ClaudeDeploymentSeams`, replacing the hardcoded `makeInMemoryCredentialStore()` in `subscriptionFor`. Its default is a new `makeUnavailableCredentialStore` (in `credentials.ts`): permanently `needs-auth`, holds no token, so a live deployment never silently persists a credential in memory. Tests inject `makeInMemoryCredentialStore` explicitly.

4. **Tests updated & extended.** `test/claude-wiring.test.ts` and `test/claude-account-endpoint.test.ts` inject the doubles (via a shared `memorySeams()` helper); added cases proving the credential-store default holds nothing even when the probe passes, and that child provisioning fails closed when only the child provider is left default.

**Verification:** `npm run typecheck` clean; `npm test` green (428 passed, 5 skipped). Flag-off behavior is byte-for-byte unchanged — everything stays behind `ENDO_CLAUDE_ENABLED`.

**Handoff/scope notes:**
- Pushed to `build/claude-agents-capability` (fast-forward `330fec4..8a0bf2b`); the branch base was already current so no rebase was needed. I did **not** rebase onto `main` (out of scope; avoids colliding with the in-flight `minion-town-claude-inference-exploration-20260922` tracks).
- Replied on the review thread: https://github.com/kriscendobot/minion.town/pull/87#discussion_r4067792020
- PR #87 left as **draft and unmerged** per the maintainer's "close that gap before we commit." No un-draft or merge performed.

**Follow-ups:** None. The "connect to reality / real inference backend" work remains owned by the separate inference-exploration orchestration, untouched here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-pr87-wiring-test-fixtures.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4546220 cached reads)
- Output: 29105 tokens
- Cost: $4.3254790000000005
- Wall-clock: 552s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
