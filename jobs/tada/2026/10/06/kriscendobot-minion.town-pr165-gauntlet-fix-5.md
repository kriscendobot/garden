# Fix round 5 report: kriscendobot/minion.town PR #165

I fixed the round-5 must-fix items and pushed three commits, moving the head from `96e1b18` to `5116eb3`. CI is green (3 of 3 checks). The PR still cannot get past the phase gate at the next panel, because the gate rejects a probe-labelled PR and a deliverable label would be false (details below).

## Must-fix items
- **Only the root can turn on inbox watching (locksmith).** In commit `fcfda7a`, `create` now returns `unavailable` when anyone other than the root's facet passes `watchInbox: true`. That covers delegated peers and re-introduced children.
- **Tests for that check and for admission-window pruning (locksmith, prover).** Commit `a4de761` adds a test that a delegated facet is refused. It also adds a test that an idle bearer's admission-window entry is pruned while a fresh bearer's entry is kept, made possible by a new optional `inboxResponderAdmissions` seam in `wiring.ts`. I reverted each fix and confirmed its test fails.
- **Ledger said "deliverable" while earlier phases are open (integrator, phase-evidence pre-pass).** The PR body ledger is now `Disposition: non-deliverable-probe` with a `Probe-reason:`. Phase 2 is now `open` because the per-child rate cap is deferred. `phase-evidence-gate.sh author` accepts it (`verdict=probe`, rc 0). The body is down to 125 words of prose.
- **No summary comment after the last push (scribe).** I posted one: issuecomment-6025008954. It covers what this round's commits close, what round 4 closed, and what is still open.

## Also fixed (should-fix)
- **Breaker #1, commit `5116eb3`:** the responder store now writes to disk before it updates memory. Before, a failed `remove` left the record on disk, and a retry silently did nothing. A new file-store test covers the retry. The same commit drops a comment that only restated a type name (pruner #3).

## Not addressed (should-fix or comment-only)
- Narrowing the responder's powers and running it confined (locksmith, purist).
- Deleting the per-message effect entries; this has been raised in every round.
- Purist items #1, #2, #3, #5 and #6. #6 would contradict a test the prover called load-bearing.
- Unifying the "responder" and "inbox-watch driver" names.
- Pruner #1, removing the ledger from the body. The gate requires the ledger, so it stays.

## Verification and follow-ups
- Locally, typecheck is clean and `npm test` passes 936 tests with 1 failure. The failure is `test/git-remote/capability.test.ts`, the known host-environment git-remote failure, which this diff doesn't touch.
- **For the gauntlet driver or maintainer:** panel-6 will refuse this PR whichever label it carries. A probe is rejected by design. "Deliverable" can't be claimed truthfully until the Phase 1 Endo substrate lands and the production canaries are recorded. More fix rounds won't unblock it, so the gauntlet should be parked rather than looped until those gates exist.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2819146 cached reads)
- Output: 14631 tokens
- Cost: $1.5550091999999995
- Wall-clock: 437s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
