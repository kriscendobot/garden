FIX round 1 for PR #249 is done: all panel-1 findings are addressed except one that no longer applies, and CI is green on the new head `b1863c6a`. The `ci-wait-merge.sh` result was rc 0 (total=2, failed=0). The bot token can't read `statusCheckRollup`, so it used the Actions runs API, and commit statuses and non-Actions checks weren't visible to it.

**Commits pushed with `safe-push-pr-head.sh` (`79216d72..b1863c6a`, confirmed with `ls-remote`):**
- **`c47627ec` (packager, changeset-auditor):** restores the base changeset and adds `.changeset/api-key-agent-move-fixes.md`, a patch note describing the fixes.
- **`eac7eb98` (saboteur, integrator, corner-prober):**
  - After an unknown outcome, the reattach dialog now shows only the pending provider, with a "Check again" action.
  - That retry no longer fetches options, so a committed move whose reply was lost can still be confirmed. The factory replays by idempotency key before any freshness check.
  - A fixed refusal returns to fresh choices with a new key.
  - The fake factory now replays reattaches and can report non-active agents.
  - New browser tests cover the lost reply, the unknown-then-refused path, and a creating agent shown as in progress.
- **`7f07821e` (breaker, spec-keeper, prover, corner-prober, fast-checker):**
  - Replacement now refuses a grant or agent id for an agent still being created, with the new code `agent-creation-in-progress`, before superseding.
  - `dailyDollars` no longer has a `MAX_SAFE_INTEGER` bound.
  - New or stronger tests cover stray tombstone fields, non-active join exclusion, stale-grant refusal through the CapTP adapter, the creating-agent projection, non-finite limits, and raw-JSON sentinel limits.
  - Two new `fast-check` properties cover replacement canonicalization and cap acceptance.
- **`b1863c6a` (prover):** removes `test/agent-service.test.ts`, since no runtime change in this PR distinguishes it.

**PR description (pruner):** I removed the test tallies and the mutation-by-mutation narrative, and it now reflects the fixes above.

**Verification:**
- `pre-push-gates.sh` passed all 10 stages, with one non-blocking warning about a 3-line comment in `provider-ui.js`. I kept that comment because it explains why the retry skips fresh options.
- Targeted Vitest passed 80 of 80, and the Chromium browser suite passed 21 of 21. Firefox and WebKit were not run locally.
- I reverted each server-side fix in turn (tombstone projection, lifecycle join, prevalidation, creating-agent refusal, dollar bound, non-finite projection), and each time the matching tests failed. Restoring the old `provider-ui.js` failed all three reattach retry tests.

**Panel items that differ from what was asked:**
- **Pruner's test comment:** the comment it cited at `test/agent-ui-browser.test.ts:728-729` isn't in that file, so there was nothing to delete.
- **Fast-checker vs spec-keeper:** fast-checker's proposed property bounded `dailyDollars` by `MAX_SAFE_INTEGER`, which contradicts spec-keeper's finding. I followed spec-keeper, because the factory accepts any finite positive amount.
- **Corner-prober's `NaN` case:** JSON can't carry `NaN`, so the test sends its serialized form (`null`) and also checks that a raw `NaN` body gets a 400 and never reaches the factory.
- **Creating-agent refusal limits:**
  - It needs the registry attachment to name the `agentId`, because a creating record has no grant id. A grant-only attachment for a creating agent would still move as a legacy grant.
  - The endojs factory source at the pinned revision has no `attachedAgents` reporting, so I could only test this with fake attachments, not against real registry output.
  - A replacement with that agent selected, which is the default, is refused until creation finishes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1614674 cached reads)
- Output: 36561 tokens
- Cost: $2.0903548
- Wall-clock: 990s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
