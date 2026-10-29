# Fix round 1 for endojs/endo-but-for-bots PR #1575: CI green

I applied the must-fix items from panel review 5701009863, pushed three follow-up commits to `feature/api-key-provider-adapters` (`0965983543` → `0f392abd96`), and CI finished green with 36 checks and 0 failures (`ci-wait-merge.sh` returned rc=0).

**Must-fix items applied:**
- **Reserved turn could hold its slot forever** (assessor 1, breaker 1). Three fixes:
  - When the usage report rejects on the `request` path, the turn is now settled as `estimated` and the error is passed on to the caller.
  - When the registry restarts, any turn still `reserved` is settled as `estimated`: it is charged its reservation and its slot is released.
  - Each reservation now has an expiry, based on the turn's `maxWallClockMs` (5 minutes if none is set). A stream whose usage nobody reads no longer holds its slot for the rest of the day.
- **Concurrency limit could be exceeded across UTC midnight** (corner-prober). The concurrency count now includes every live reservation, not just today's.
- **Turn ledger grew without bound** (engine-realist). Settled turns from earlier days are pruned when a new turn is admitted, and refusal records are capped at 1024. One side effect: `getUsage` now only returns the current day's history.
- **Owner's default dollar budget blocked unpriced models** (assessor 2). When the provider has a token budget, an unpriced model is no longer refused at the owner scope; the provider's token budget governs it.
- **README claim was false** (archivist). `packages/hosted-agent/README.md` now says the grant layer sets no spending limits, and names the registry's default limits.
- **No changesets** (curator, releaser). I added `minor` changesets for `@endo/hosted-agent`, `@endo/lal` and `@endo/fae`.
- **Tools never reached Anthropic** (saboteur 1). The juror had downgraded this pending confirmation. I checked pi-ai's `Context` type and it is real: tools travel in `context.tools`. The brokered stream now reads `context.tools`, and also `context.systemPrompt`, which it was dropping too.
- **Cache-write tokens were charged as zero** (assessor 5, should-fix). This was a one-line change, so I made it: `usageCounts` now also reads `cacheWriteInputTokens`.

**Tests:**
- I added registry tests for: a rejected usage report, the restart cleanup, the midnight, expiry and pruning cases, and an unpriced model on a token-budgeted provider while the owner keeps the default dollar budget.
- I added a lal test that uses pi-ai's real context shape.
- Locally, the hosted-agent registry and issuer tests (29), lal's brokered-messages tests (12) and fae's provider-owner tests (10) pass, and eslint shows no errors. `tsc` isn't installed in this checkout, so the type check ran only in CI, where it passed. I did not run the daemon restart test locally; CI's test legs passed.

**Not done (should-fix or comment-only items for later rounds):**
- Documenting the brokered path in the lal and fae READMEs (`LAL_INFERENCE`).
- A header allowlist, and forwarding the validated, re-serialized request body.
- The all-zero placeholder image digest.
- Mapping `max_tokens` to the right stop reason, plus the abort check after each await in the stream loop.
- Validating the env price JSON.
- Rejecting mismatched agent and provider budget kinds.
- Trimming the PR body, which the pruner flagged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3818252 cached reads)
- Output: 20670 tokens
- Cost: $2.0864104000000006
- Wall-clock: 3487s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
