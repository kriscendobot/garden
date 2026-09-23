---
title: "patterns-diagnostic-feedback — opt-in @endo/patterns/explain-mismatch.js submodule"
source-slug: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/patterns-diagnostic-feedback.md
authors: [Kris Kowal (prompted by kriskowal)]
repo: endojs/endo-but-for-bots
path: designs/patterns-diagnostic-feedback.md
total-lines: 704
status: Proposed (2026-05-19 created; 2026-05-20 round-3 reshape)
ingest-cycle: 198
ingest-date: 2026-06-06
lane: designs
---

# patterns-diagnostic-feedback.md

A 704-line proposed design for `@endo/patterns/explain-mismatch.js` — an opt-in submodule that renders rich diagnostics for failed pattern matches without modifying the production matcher path. Visible in source as §three-revision-pivots that shrank scope at each round.

## Pivot history (visible in the Prompt section)

| Revision | Date | Pivot |
| --- | --- | --- |
| Original | (per the Prompt section) | Three-axis "carry-on-error" design threading structured payloads through the matcher. |
| Round 1 (CHANGES_REQUESTED) | 2026-05-19 | **§the-data-is-already-there-just-locked** discovery: `applyLabelingError` already records the chain via SES `annotateError`. Reshape to "build a sibling package that reads what is already there and renders it richly". §Text-source parse path deferred as separable. |
| Round 2 (kriskowal round-2 review) | 2026-05-20 | `diagnose(err, options)` error-post-processor reshaped into `diagnose({ specimen, pattern })` non-throwing matcher. Renderer split into compact-default + expanded-opt-in. Cause-chain-fallback dropped. |
| Round 3 (kriskowal round-3 review) | 2026-05-20 | Sibling-package framing retired in favor of submodule `@endo/patterns/explain-mismatch.js`. Direct access to `matchHelpers` registry dissolves drift-vs-stable-internal-surface tension. Two-function `diagnose` + `render` API folded into single `explainMismatch({...})`. |

## Key design moves

- **§the-data-is-already-there-just-locked** discovery: SES `annotateError` (via `assert.note`) already records per-level labels as distinct Error objects forming a cause chain; the data is unreachable to programmatic readers but already exists. The gap is "render and combinator-awareness" not "record".
- **§non-throwing-matcher mirroring `matches(specimen, pattern): boolean`** — `explainMismatch(...): string | undefined`. Caller pattern: `const r = explainMismatch({specimen, pattern}); if (r !== undefined) console.error(r);`. No `try`/`catch`.
- **§opt-in-submodule with cost-asymmetry** — production matcher path (`mustMatch`, `assertMatches`, `matches`) pays zero. `package.json exports` add the new entry alongside the main entry; `./explain-mismatch.js` appears nowhere on the production import graph.
- **§submodule-not-sibling-package** — direct access to `matchHelpers` registry and `confirmMatches` recursion; no re-export hoops, no parallel implementation, single source of matcher truth, no API contract the package would otherwise not need.
- **§rich-not-configurable rendering convention** — all alternatives reported (Rust-compiler-error analogy); ranked by depth-of-match; reader picks. No closest-alternative heuristic. §Rust-as-cited-prior-art.
- **§compact-default + expanded-opt-in** — compact is `path | found | expected | reason` columns sized for AI-agent token economy; expanded is indented Rust-compiler-style for humans at a REPL. §Default-favors-the-tighter-budget-consumer (AI agents).
- **§seven-trace-step-kinds discriminated-union** — `property | index | mapKey | setElement | orBranch | arrayOfElement | recordOfEntry` for step-kind-discrimination that string/number labels lacked.
- **§tracing-recursion-reuses-helpers-in-place** — recursion imports `matchHelpers` and per-combinator helpers directly; a change to a helper updates both lanes simultaneously.
- **§composition with `@endo/exo`** via the optional `context` field on `ExplainMismatchInput`; no exo change required. Future `explainExoCall` helper named-not-shipped.
- **§nine Design Decisions canonical format**: 1) submodule not sibling; 2) non-throwing matcher not error post-processor; 3) single function returning string not split diagnose+render; 4) compact default; 5) `|` separator not JSON; 6) all-alternatives-reported no-heuristic; 7) helpers-in-place not parallel implementation; 8) no text-source pattern parser; 9) ASCII not unicode.
- **§single-PR-scope** (~600 lines including tests). Three revision rounds shrunk the scope, not expanded it.
- **§ASCII not unicode** for terminal/log/CI compatibility; future `style: 'unicode'` trivial to add.
- **§pipe-separated-columns** `path | found | expected | reason` for line-grep without sacrificing parseability (`split(' | ')`).
- **§one Open Question**: whether `explainExoCall` sugar helper ships in initial PR or waits.
- **§explicit-no-predecessors-row** in the Dependencies table.

## Two consumer postures (named explicitly)

- **Library users** writing `M.splitRecord(...)` shapes — see failure in AVA log; manually walk specimen against pattern in a REPL to find offending field.
- **AI agents** constructing patterns from natural-language or JSON-Schema inputs — see the same message but §cannot-walk-the-specimen-interactively. Retry with random perturbations until message changes, which is expensive and frequently masks the underlying mismatch.

§AI-agents-cannot-walk-the-specimen-interactively is the §unique-cost AI agents pay. The compact-default favors AI-agent token budget; expanded-opt-in favors human REPL reading.

## Phase A (single PR)

- `packages/patterns/src/explain-mismatch.js` (public entry)
- `packages/patterns/src/explain-mismatch/trace.js` (tracing recursion mirroring `confirmMatches`)
- `packages/patterns/src/explain-mismatch/render.js` (formatter with compact + expanded)
- `packages/patterns/package.json` `exports` entry
- `packages/patterns/test/explain-mismatch.test.js` (three exemplar cases × 2 formats + InterfaceGuard composition)
- No changes to `mustMatch`, `assertMatches`, `matches`, or `applyLabelingError`.

## Ingest scope

Cycle 198 (designs-lane): full ingest of the design document. One section file. Cohesion-honest single-section ingest because the design is structurally a single concept (the explain-mismatch submodule) refined through three revision rounds.

## Related material in the library

- **cycle 196 endoclaw**: §canonical-Design-Decisions-format and §two-consumer-postures sibling; this design also names two-consumer-postures but with different cast (library users + AI agents vs assistant + coding-agent).
- **cycle 197 @endo/panic**: §honest-design-evolution-in-the-README sibling — this design's §three-revision-rounds is a more extreme instance of the same family.
- **cycle 184 daemon-xs-worker-metering**: §canonical Design-Decisions format precedent (also seven-Design-Decisions; this design has nine).
- **cycle 188 daemon-rust-xs-performance**: §multi-revision-design-evolution sibling.
- **cycle 192 daemon-engo-supervisor**: §implicit-supersedes-lesson-learned (this design names §explicit-no-predecessors row, which is the inverse).
- **cycle 106 endo--packages-ses-src-error-tame-console**: SES error-observation surface that `applyLabelingError` rides on top of.
- **cycle 189 marshal-justin + marshal-stringify**: passableAsJustin diagnostic rendering at a different layer (CLAUDE.md-cited diagnostic substrate).
- **cycle 147 endo--packages-eventual-send-src-message-breakpoints-js**: another @endo diagnostic-surface-shape pattern.
- **cycle 178 daemon-xs-worker-snapshot**: §Revised-scope-2026-04-15 sibling — single revision visible vs this design's three.
- **`@endo/exo` InterfaceGuard argument labeling**: composes through `applyLabelingError`; explain-mismatch gets exo composition for free via the optional `context` field.
