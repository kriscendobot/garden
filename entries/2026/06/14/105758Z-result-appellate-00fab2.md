---
ts: 2026-06-14T10:57:58Z
kind: result
role: appellate
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/appellate--00fab2/project
refs:
  - entries/2026/06/14/105700Z-dispatch-appellate-00fab2.md
  - entries/2026/06/14/105230Z-result-justice-1eed16.md
  - entries/2026/06/14/095115Z-result-barrister-103358.md
---

# Appellate result: PR #440 round-2 terminating verdict (justice 1eed16)

PR endojs/endo-but-for-bots#440 (`feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439)`), branch `feat/formula-inspector`, head `93b399160`, base `llm`. Audit of justice round-2 dispositions: 0 must-fix-loop, 1 summary-fix (job `ea095b` already posted), 1 follow-up, 5 acknowledge.

## Items considered

- Follow-up: 1 (chat-side registry host `propertyList` alignment).
- Acknowledge: 5 (`formula-record.js:74-96` host case correctness; `formula-record.js:98-117` archive/from-tree case correctness; `interfaces.js:455` `getFormula` guard correctness; `formula-view-registry.test.js:19-49` canonical-list update correctness; `endo.test.js:2406-2435` `storeIdentifier` + `randomHex256` rewrite correctness).

Total: 6 items audited against the three-question rubric (small / in-context / loss-tracking risk).

## Proposals

**None.** The judge's deferrals stand.

## Rationale (silent items explained for the orchestrator's audit trail)

The conservative bias holds across all six considered items.

- **The single follow-up is a deliberate redundancy with the summary-fix item, not an independent deferral.** The verdict body's `[follow-up]` finding ends with "the alignment work belongs in the same summary-fix follow-up that closes the daemon-side per-type catalog drift," and the `[summary-fix]` finding describes the same `formula-view-registry.js` host `propertyList` edit. Justice itself flagged the duplication in the post-aggregation actions ("The ledger entry is the merge-watch belt-and-suspenders: if the summary-fix job ages out unclaimed and the PR merges, the steward's per-cycle survey will pick up the follow-up at merge time"). The work *is* in summary-fix (job `ea095b`); promoting the follow-up would be a no-op because the same artifact is already on the summary-fix path. The ledger entry serves as the merge-watch safety net the justice intended; removing it would weaken the loss-tracking surface for the case where the summary-fix job ages out unclaimed.
- **The five acknowledge items contain no pending work.** Each acknowledge is the panel certifying that an out-of-band fix the fixer already landed is correct (the `host` case rewrite per `HostFormula` shape, the new `make-archive`/`make-from-tree` cases per `formulateArchive`/`formulateFromTree`, the `HostInterface.getFormula` guard adding the missing method that was failing every daemon test, the canonical-list update with the load-bearing inline comment about `keypair`, and the `storeIdentifier`/`randomHex256` test rewrite). The appellate rubric (small + in-context + loss-track risk) requires an underlying *action* to promote; an acknowledge with no deferred work has nothing to promote into `summary-fix`. None of the five are appeal candidates.

## Outcome for the orchestrator

No amendments to the summary-fix job `jobs/open/20260614T105226Z--ea095b--endo-but-for-bots-440-r2-summary-fix.md` are warranted. No pruning of `projects/endo-but-for-bots/followups/endo-but-for-bots--440.md` is warranted; the round-2 item there is the intended belt-and-suspenders entry. The orchestrator may proceed directly: fixer claims `ea095b` (or steward claims and dispatches fixer), un-draft, conductor.

Self-improvement: nothing this time. The dispatch brief was complete; the verdict body, followup ledger, and summary-fix job were all coherent with each other. The duplication between the follow-up and the summary-fix is by design (the justice's belt-and-suspenders pattern), not a rubric misapplication, so no lesson to land.
