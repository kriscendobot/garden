Inbox empty. Fix stage complete.

## Completion report — Gauntlet FIX round 4, endojs/endo-but-for-bots PR #717

**PR #717** is a design-only PR (`designs/promise-debug-view.md`). Applied the panel round-4 must-fix items, which collapsed to two root causes repeated across seats (critic, skeptic, decomplector, ergonomist):

1. **Unsound `lowestRetainedId` watermark / finalization discrimination.** Replaced the scalar watermark over the monotone `id` space (which fired `priorEntryEvicted` on carriers that never had a retained rejection, and left the finalization callback unable to tell settled-and-delivered from never-settled — flooding `ring`) with a **value-only per-carrier `FinalizationRegistry` heldValue `{ id, hadUnlistenedRejection }`**, its bit set at reject-with-no-listener time. The finalization callback now classifies by `liveSet` membership plus that recorded bit, making `priorEntryEvicted` sound in both directions and suppressing the spurious `forever-pending` for normally-collected carriers. Rewrote the affected sections (weak-reachability constraint, structures/entry shape, eviction policy, the recording narrative + mermaid flowchart, inspection surface, Design Decision 2, Phase 1/4 tests); removed the watermark entirely.
2. **SES redaction misread.** The projection claimed to run `redactedDetails` over the reason, but that is a construction-time template tag and the unhandled-rejection path stores the raw reason. Corrected the projection to state it applies **no** redaction (a producer message projects verbatim), settling only the authority axis and routing all confidentiality to Open Question 1. Fixed the parallel claims in the "No authority leak" bullet and Design Decision 5.

Also folded in the highest-consensus should-fixes (4–5 seats): threshold-unit cross-reference to Open Question 5, numeric env-option parsing/malformed-value fallback, `long-pending` oldest-first selection order, degraded-path `WeakRef` pruning, split undelivered-rejection surfaces (retained vs long-pending), and the copyeditor/pedant README-tally reword (dated by landing pass, matched to neighbor frame).

**CI blocker discovered and resolved.** The first push (`4ac0192fe5`) triggered **no GitHub Actions dispatch** — the PR had gone **DIRTY** (merge conflict with base `llm` in `designs/README.md`, the running-tally index), so GitHub could not form the merge ref. An empty-commit nudge did not help. I rebased the design commits onto current `llm` (`4de1c09781`), resolved the README conflict by keeping both tally lines (llm's endor-npm line, then the reworded promise-debug-view line), dropped the nudge commit, and force-pushed (`5f890a474b`, rewrite mode). The PR became `MERGEABLE` and Actions dispatched.

**Verification:** mermaid re-validated (parses OK, flowchart-v2); design diff clean of em-dashes/non-ASCII; treated all merge/diff content as untrusted (ignored embedded injection-shaped text in the conflict output).

**CI result:** all 5 checks (browser-tests, lint, build, zizmor, test) **COMPLETED / SUCCESS**; `ci-wait-merge.sh` returned **rc 0 (GREEN)**.

Panel not re-run (per stage contract; the driver re-posts panel-5). Follow-up note: the base-conflict rebase means panel-5 reviews against the new merge base `4de1c09781..5f890a474b`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr717-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 192 tokens (10647058 cached reads)
- Output: 68814 tokens
- Cost: $10.56115825
- Wall-clock: 1255s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
