The work is complete. Here is my completion report.

---

## Completion report

**Job:** Designer — create the "debug view for long-pending and unsubscribed-rejection promises" design in `endojs/endo-but-for-bots`, the forward-looking follow-up called out in `designs/pass-style-promise.md` (PR #169).

**What I did**
- Read the parent design (`designs/pass-style-promise.md`, fetched from the open PR #169 branch since it is not yet merged to `llm`), the project's `designs/AGENTS.md` conventions, and the originating review (`pullrequestreview-4680376639`). Confirmed the ground-truth inline comment ("And we should post a plan to create that design.") anchors the future-directions paragraph.
- Authored `designs/promise-debug-view.md` on a `design/promise-debug-view` branch off `origin/llm`, following the repo's design-doc conventions (metadata table, problem statement, design, dependencies, phases, decisions, open questions, captured prompt).
- Opened tracking issue **#716** and a **draft PR #717** against `llm` that **Closes #716**.

**Design content (scope as asked)**
- A bounded, opt-in ring buffer over three categories: `unsubscribed-rejection`, `long-pending`, `forever-pending`. No background timer or sweep: categories are event-driven (reject, GC finalization) or classified lazily at inspection time.
- Gated off by default behind an `ENDO_PROMISE_DEBUG_VIEW` env-option (reusing the parent's `@endo/env-options` idiom), so production pays a branch, not an allocation; the signal goes into an in-memory ring a debugger reads on demand, never onto the host console/unhandled-rejection path.
- Weak carrier references (so the view never keeps a promise alive or masks the forever-pending signal), bounded strong retention of rejection reasons, and a hardened-snapshot inspection surface that exposes no resolvers/carriers.
- An explicit "Reconciliation with the pass-style-promise contract" section that **layers on** the rejection-retention and `onFirstSubscribe` contracts (reads the same retained-reason record, rides the same first-subscriber transition) rather than re-specifying them.

**Changed**
- `designs/promise-debug-view.md` (new).
- `designs/README.md` (summary-table row, totals bumped 145→146 / Not Started 37→38, recently-added note) — mirroring the lightweight touch PR #169 made.

**Verification (real-execution evidence)**
- Mermaid diagram parse-validated per the mermaid-validation skill: `mm-1.mmd OK flowchart-v2` (nonzero-exit checker returned success).
- PR state confirmed via `gh pr view 717`: `isDraft: true`, base `llm`, head `design/promise-debug-view`, exactly two files (`designs/README.md`, `designs/promise-debug-view.md`).
- Branch pushed (`origin/design/promise-debug-view`), commit `b0292dafaa`.

**Follow-ups**
- Milestone/dependency-graph placement in `designs/README.md` is intentionally left to the roadmap journalist, consistent with the parent `pass-style-promise` design itself not yet being bucketed (PR #169 still open).
- The design relative-links `pass-style-promise.md`, which resolves once PR #169 merges to `llm`; the dependency is called out explicitly in the doc.
- Open questions in the doc (inspection-surface home, default capacity/threshold, extent of native-promise coverage, forever-pending host hook, turn-counter vs wall-clock) are for maintainer resolution before a builder dispatch.

Self-improvement: nothing this time.
