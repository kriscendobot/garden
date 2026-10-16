---
role: orchestrator
split_eligible: true
split_reason: deadline-overrun
split_source_role: ordinary
split_source_handler_timeout: 2400
split_orchestration: endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split
reposted_by: reaper:endolin-garden-ece02cb4
reposted_at: 2026-10-16T05:03:22Z
---

# Deliberate overrun decomposition for `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin`

This ordinary job hit its applied 2400s handler wall once without productive progress. That one deterministic overrun is sufficient cause to split; do **not** continue implementing the original work in this claim.

Read `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`. Your first and only substantive act is to decide whether the original work genuinely decomposes, then use the existing journal primitives:

- **Divisible:** create at least two self-contained child jobs, declare each child execution budget with `--role`, leading `role:` / `handler-budget-role:`, or a positive `handler-timeout:`, park every child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split`, then record `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split` with `post-orchestration.sh`.
- **Indivisible:** choose a concrete reason and a timeout strictly greater than 2400 and no greater than 14339; park exactly one child with `post-plan.sh --orchestrated --orchestrated-by endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split --split-indivisible-reason REASON --split-indivisible-handler-timeout SECONDS endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-expanded-window BODY-FILE` so both child fields land atomically. Record the same reason as `split-indivisible-reason:` and the same timeout as `split-indivisible-handler-timeout:` in the orchestration description, then record the single-child orchestration. Do not hand-author the child fields; a generic "too large" assertion is not a reason.
- In either case, finish only after the parked child set and orchestration record exist durably. Declare the exact handoff `<<<GARDEN-JOB-HANDED-OFF: endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split>>>` immediately before the completion signal so completion verifies the successor.
- Do not apply this split protocol to any gauntlet stage; gauntlet retries belong exclusively to its driver.

## Original job specification

---
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Finish the endojs/endo-but-for-bots PR #1396 Parcel restack: base move, CI, summary

Wear the shepherd role. Successor of `endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-r5527149922`,
which ran on oros-studio, where the bot PAT gets 403 on every endojs PR write.

Already done (do NOT redo):
- Froze #1394's head `6f3185b487c9ac92974533e9f50054d544db0f26` as
  `build/sturdyref-captp-wire-6f3185b` (pushed).
- Rebased #1396's only commit with `git rebase --onto 6f3185b build/parcel-captp-wire-6d089a6`.
  The conflict in `packages/ocapn/test/parcel.test.js` kept both #1394's "OCapN carries a
  Parcel it did not mint" test and #1396's cross-instance forwarding test. The
  cross-instance test now also reads the parcel back through the second instance and
  checks that it gets back a distinct Parcel whose details are intact.
- Force-pushed with lease `build/sturdyref-captp-construct` = `609821f7118d0633132a5df973ae1f789f696066`.
- Locally: `packages/ocapn` `yarn test` passes (parcel + bytewise suites clean) and
  `yarn lint` (tsc + eslint) has 0 errors.
- Design check: #1394's head already does the layer-6 part of the #1460 Parcel design
  (commit 6973c078 + designs/parcel.md). Received Parcels are built with the receiving
  client's open hook (`makeParcelTracker(locator, openDetails)`). Forwarding goes
  through the initial `locate`, so there is no minting-client restriction. No source
  change was needed in #1396.

Remaining:
1. `gh pr edit 1396 -R endojs/endo-but-for-bots --base build/sturdyref-captp-wire-6f3185b`
   (or REST PATCH pulls/1396 base=...). Confirm the PR diff is now just the one commit.
2. Drive CI green on head 609821f. As of 2026-10-15T18:50Z the repo had started NO
   Actions runs since 16:12Z, including none for this push. If runs are still missing,
   close and reopen the PR or push an empty commit to re-trigger, then fix any failures.
3. Post the required PR completion summary comment (skills/pr-completion-summary-comment).
   Cover the new base, the one rebased commit, the conflict resolution, the test
   strengthening, and the design-conformance note above.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T05:03:52Z
