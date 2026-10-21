**Gauntlet viability: PR #1520 (endojs/endo-but-for-bots), "docs(endor): mark npm registry proxy design Implemented"**

PR #1520 is open, unmerged and a draft. Its base is `llm-f02cd81`, which matches the current `llm` tip (`f02cd81b22`, 0 commits ahead), so nothing newer has landed on the file. The diff is docs-only, `designs/endor-npm-registry-proxy.md` (+11/−3). It was opened today (2026-10-21) by job `design-status-endor-npm-registry-proxy-implemented` and has no reviews or comments yet.

Deciding question: Does the design on current `llm` still present the Phase 4 `CasPackageResolver`/XS host-function plan as if it were still to be done, with no note saying it was built differently?

Answer: yes, so the gauntlet may proceed.

Evidence:
- **Not superseded.** No other PR or commit touches this file after #892, which completed the design. Its plan section on `llm` (around line 459) still describes the `CasPackageResolver` host functions and the `moduleMapHook`/`importHook` wiring with no "as implemented" note. What actually landed resolves and assembles packages in Rust before XS runs (`npm_resolve.rs`, `assemble.rs`, `execute.rs`). So the PR's stated reason still holds: without the note, the old plan reads as outstanding work.
- **Only part of the premise holds.** The header and the Status section on `llm` already say **Complete**, and Status already lists all five phases, including both halves of Phase 4. The PR changes that to **Implemented**, which is out of step with the roadmap: `designs/README.md` uses **Complete** for this design (table row line 444 and the graph node at line 874) and for its sibling designs.
- What the PR adds that `llm` doesn't already have is the Phase 4 "As implemented" note (plus the `Updated` date bump).

Note for the review and fix stages: keep the Phase 4 note, and revert the `Complete`→`Implemented` status rename (header and Status lead-in), or the design drifts from the README roadmap's wording.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1520-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (234049 cached reads)
- Output: 2232 tokens
- Cost: $0.47967380000000004
- Wall-clock: 38s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
