---
posted_at: 2026-11-04T05:05:23Z
role: builder
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the phase 2 gap PR on endojs/endo-but-for-bots

Repo: endojs/endo-but-for-bots. Relay from `build-api-key-agents-p2-provider-adapters`: the oros-studio PAT gets a 403 on createPullRequest to endojs, so this host-pinned job only opens the PR. The code is already pushed, so write no code.

Head: `feature/api-key-provider-adapters-acceptance` (e037713894ab2ed5638d1ae3766b36db5dea0d22)
Base: `feature/api-key-provider-adapters-0b8d24a` (frozen snapshot of #1575's head 0b8d24a114)

1. Get a checkout with `ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-provider-adapters-acceptance` and run the next step from it.
2. Save the body between the markers below to a file and run:
   `ensure-pr.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-provider-adapters-acceptance feature/api-key-provider-adapters-0b8d24a --title 'fix(hosted-agent,lal): complete phase 2 tests; report upstream refusals and settle cut-short streams' --body-file <file>`
3. Name the draft PR number in your report. If #1575 has merged or moved by then, still open against the frozen base; the parked re-weave job `weave-api-key-p2-acceptance-after-pr1575` restacks it.

----- PR BODY -----
Refs: #1543, #1575

## Description

Stacked on #1575's frozen head. It completes phase 2's listed tests and fixes the two defects they found on the real path.

Tests through the real Anthropic issuer with a faked network showed two faults that the fake-issuer tests hid. An upstream 401, 429, or 404 reached the caller as `Provider request failed`, so `model-not-available` and Lal's authentication and rate-limit messages could not fire. A cancelled stream settled at the partial usage it had reported, rather than its full reservation as the design requires.

The Anthropic issuer now opts into bare refusal classifications, the registry records and reports them by fixed code (`provider-authentication-failed`, `provider-rate-limited`, `model-not-available`), and Lal maps those codes to its messages. A settlement with `complete: false` now charges the larger of its reservation and its reported usage, marked `estimated`.

New tests cover these items from the phase 2 list:

- Discovery failure, where only a well-shaped typed model is accepted and recorded `unverified`.
- The first successful turn marking a model `verified`.
- Same-turn admissions across two providers against the owner's concurrency and budget.
- The request rate at agent, provider, and owner scope.
- A harness abort reaching upstream and releasing the slot.
- Log redaction across console, audit, ledger, journal, and errors.

Critical review areas are `failDispatch` and `settle` in `inference-provider-registry.js`, and `revealUpstreamRefusal` in `provider-broker.js`.

### Security Considerations

The refusal classifications carry a status class only; no upstream body or header crosses. `revealUpstreamRefusal` defaults off, so existing grants still mask every failure. The redaction test plants the key in the upstream's error body and checks console, audit, ledger, journal, and error stacks.

### Scaling Considerations

None. Settlement and refusal each add one bounded row, as before.

### Documentation Considerations

No reader-facing documentation changes; the changesets describe the new refusal codes.

### Testing Considerations

Regression evidence: before the fix, the new Lal test failed with `Provider request failed` for a 401 and a 429, and with `disposition: 'reported'` for an aborted stream.

`packages/hosted-agent` passes except for two `dev-image` tests, which cannot execute their stand-in `docker` on this host's noexec `/tmp` and are unrelated to this diff. Fae's focused provider tests pass. The new tests are `packages/lal/test/brokered-messages-broker.test.js` and the additions at the end of `inference-provider-registry.test.js`.

### Compatibility Considerations

The transport's message for a refused 404 or 429 changes from `Provider transport failed` to a bare classification. Only the broker reads it, and the broker still masks it unless the new option is set.

A refused upstream turn is still charged its full reservation, so a bad key can use up a daily budget through retries. The design's "ends without usage" rule asks for this, and it is worth a maintainer's look.

### Upgrade Considerations

No migration. See the two changesets.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Governing design: endojs/endo-but-for-bots#1543
Disposition: orchestrated-slice
Successor: orchestrate-build-api-key-agents-20261104
Phase 1: satisfied | #1573
Phase 2: satisfied | #1575 plus this diff's tests and fixes
Phase 3: delegated | owned by orchestrate-build-api-key-agents-20261104
Phase 4: delegated | owned by orchestrate-build-api-key-agents-20261104
Phase 5: delegated | owned by orchestrate-build-api-key-agents-20261104
Phase 6: delegated | owned by orchestrate-build-api-key-agents-20261104
Phase 7: delegated | owned by orchestrate-build-api-key-agents-20261104
Acceptance: deferred | browser, daemon, and live deployment evidence is owned by orchestrate-build-api-key-agents-20261104
<!-- /garden-phase-evidence-ledger -->

<!-- garden-related-design:1543 -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
