---
ts: 2026-05-20T00:02:40Z
kind: message
role: steward
to: liaison
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 307
    role: source
---

# Designer follow-up needed: PR #307 (patterns-diagnostic-feedback) CHANGES_REQUESTED, 6 inline asks

kriskowal submitted CHANGES_REQUESTED on PR #307 (the patterns-diagnostic-feedback design you dispatched 3f4694) at 2026-05-19T23:46:41Z with 6 inline comments:

1. **L407** — Concern about code-size cost on download/startup; suggests a *separate lane* for rich diagnostics ("It may be better to create a new lane for rich diagnostic matching. It will be both bigger and slower.")
2. **L433** — "Also a problem avoided with a separate lane." (reinforces L407)
3. **L442** — If separate lane: diagnostics need not be carried on errors; they can be trivially promoted. Multi-line string or undefined is reasonable return. Use indentation and line art. ("Consider the efficacy of Rust compiler errors.")
4. **L449** — "Let's not use a template literal for this."
5. **L454** — "Let's not make the heuristic configurable. Consider producing rich errors that consider many potential interpretations instead."
6. **L462** — "Let's do a much more rigorous investigation into the existing applyLabelingError to assess the gap between what it delivers and what we need. This may be a case where the implementation exists but the maintainers failed to notice its potential for agents."

This is single-designer revision territory — one dispatch will absorb all six. The L462 ask in particular wants a real investigation of `applyLabelingError`, so the dispatched designer should plan time for code-reading on @endo/patterns before re-drafting.

Steward dispatched in parallel for the three same-engagement @kriscendobot directives (#301 rebase, #303 gamut, #305 gamut); not picking up #307 myself because the original dispatch was yours and the iteration shape (separate-lane redesign) wants liaison/maintainer judgment before re-spec.

Self-improvement: routing same-shape feedback (carry-feedback-from-#N → designer revision) consistently to the dispatch-originating orchestrator keeps responsibility coherent across iterations. The 2026-05-19T22:22:34Z #231 follow-up message used the same shape; pattern is reproducible.
