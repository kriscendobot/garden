Inbox empty. The fix stage is complete: must-fix items applied, pushed, and CI is green.

## Completion report

**Stage:** Gauntlet FIX round 1 — kriscendobot/minion.town PR #79 (`feat(mcp): reserve reconciled tool names`).

**Panel must-fix items applied** (surfacer's three `[must-fix-loop]` findings, echoed by corner-prober, fast-checker, releaser, pruner):

1. **Manifest↔advertised-surface coherence, now enforced.** The mounted-surface test in `test/endo-clip-tools.test.ts` pinned `tools/list` as a hardcoded literal, so a tool registered with an off-manifest name passed every test while falsifying the maximal-surface premise. Added an exported `REGISTERED_MCP_TOOL_NAMES` (baseline ∪ sites) and rewrote that assertion to compare the mounted `tools/list` against it — drift in either direction (off-manifest registration, or a manifest name that stops being registered) now fails.

2. **Refiled the capability-exchange methods.** `request`/`identify` widen the *composed `GuestFacet`* (per `designs/git-remote-capability.md`) — they are baseline, not an optional facet. The former `capabilityExchange` group read as an optional facet and mis-stated rule-3 precedence. Moved them to a `baselineReserved` group and documented in-file that the top-level keys are documentary (name origin + registration status), **not** facet identities or precedence tiers — precedence is judged flat per README rule 3.

3. **Docstring no longer overclaims coverage.** The header now states the manifest is maximal-among-*reconciled*, not maximal-among-*designed*: `reminders` fixes only its two collision-qualified names and defers `create`/`set_period`/`events`; `credit_*` is unreconciled.

**Panel-consensus summary-fixes also folded in** (cheap, multi-seat): froze the outer manifest object (`Object.freeze`) so a post-load graft can't evade the load-time guard; extracted `assertNoDuplicateToolNames` so the throw path is testable and replaced the two tests that could-not-fail with real throw-path + synthetic coverage; added empty/singleton/minimal-duplicate and case-sensitivity cases for `findDuplicateToolNames`; added the `credit_` prefix assertion; cross-referenced the manifest from README § Naming convention.

**Verification:** `npm run typecheck` clean; full suite `308 passed | 5 skipped`. Pushed as one review-feedback follow-up commit `8617942` to the PR head via `safe-push-pr-head.sh`. CI watched to terminal → **GREEN** (rc 0).

**Follow-ups (deferred, not blocking):** F1/F4 fast-checker's fast-check property test for `findDuplicateToolNames` needs `fast-check` as a devDependency; coverage-auditor could not read a c8 report (no JSON produced) — surfaced, not resolved here.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2147196 cached reads)
- Output: 25240 tokens
- Cost: $2.4695959999999992
- Wall-clock: 429s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
