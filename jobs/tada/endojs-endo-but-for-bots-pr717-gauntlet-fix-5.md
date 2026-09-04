Fix round 5 complete. CI green.

## Completion report

**Job:** endojs/endo-but-for-bots PR #717 gauntlet — FIX round 5 (design document `designs/promise-debug-view.md`).

**Panel round-5 disposition:** must-fix. Applied the panel's must-fix items in one commit (`c4f3fc500`), pushed as a review-feedback follow-up to the PR head `design/promise-debug-view`, watched CI to green.

**Headline must-fix (critic + decomplector, concurring) — the `undeliveredRejection` soundness bug:**
- `fin.hadUnlistenedRejection` was a write-once bit set at reject-with-no-listener time and never superseded when the rejection was later delivered, so a delivered rejection whose carrier was later GC'd was misclassified `forever-pending` + `undeliveredRejection: true` (and spuriously `priorEntryEvicted: true`), falsifying the design's "sound in both directions" claim for the common delivered-then-finalized case.
- Fix applied throughout the design: added a value-only `fin.delivered` bit (record is now `{ id, hadUnlistenedRejection, delivered }`), written at the first-listener transition via the hook's closure over `fin` (so the write lands even after the reject prunes `liveSet`); gated the finalization classification on `hadUnlistenedRejection && !delivered`; routed the delivered-then-collected case to no-entry; updated the entry-shape table, eviction-policy soundness argument, mermaid diagram, the makePromise/first-listener/finalization prose, and the first-listener plumbing section.
- Added the delivered-then-finalized test to Phase 4 (the test-plan gap the critic flagged).

**Should-fix items also applied (to converge):** inline qualification of the "highest-signal" claim re Open Question 6 (skeptic); malformed-env-option fallback test in Phase 1 (skeptic); env rename `ENDO_PROMISE_DEBUG_VIEW_RETAINED` → `_RETAINED_CAPACITY` (ergonomist); two tangled-sentence splits (copyeditor); bolded the "Note on the term *settled*" lead-in (pedant); added `authority` / `cap boundary` to the Borrowed vocabulary list (novice).

**Verification:** mermaid diagram re-validated (parses OK, flowchart-v2); scanned for em-dashes/curly quotes/arrows and removed the ones I introduced (design forbids them). CI: `pending=5/5` → all green, `rollup-terminal total=5 failed=0 → CI GREEN`, rc 0.

**Follow-ups:** none from this stage; driver re-posts panel-6. Ergonomist's broader restructurings (cross-category `delivered`/`undeliveredRejection` polarity, `entries`→`recordedEntries` renaming) were left as-is — contestable design-taste calls whose reshaping risked introducing new inconsistency at round 5; they can be revisited if a later panel insists.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 122 tokens (5300333 cached reads)
- Output: 31316 tokens
- Cost: $4.5545665
- Wall-clock: 995s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
