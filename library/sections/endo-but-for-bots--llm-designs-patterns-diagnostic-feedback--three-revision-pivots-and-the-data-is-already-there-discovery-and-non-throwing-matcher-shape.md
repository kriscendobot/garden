---
title: Three-revision-pivots visible in source (carry-on-error → sibling-package → submodule) + §the-data-is-already-there-just-locked discovery + §non-throwing-matcher-mirroring-`matches`-shape + §opt-in-submodule-with-cost-asymmetry — endo-but-for-bots designs/patterns-diagnostic-feedback.md
source: endo-but-for-bots designs/patterns-diagnostic-feedback.md
source-slug: endo-but-for-bots--llm-designs-patterns-diagnostic-feedback
ingest-cycle: 198
ingest-date: 2026-06-06
lane: designs
status: Proposed (2026-05-19 created; 2026-05-20 round-3 reshape)
author: Kris Kowal (prompted by maintainer kriskowal)
related:
  - endo--packages-pass-style (cycle 71+: passable substrate matched against)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: passableAsJustin diagnostic rendering)
  - endo-but-for-bots--llm-designs-endoclaw (cycle 196: §honest-architectural-difference + §multi-author-quote-blocks; sibling §genre but different shape)
  - endo--packages-panic (cycle 197: §honest-design-evolution-in-the-README; this design's §three-revision-rounds is a more extreme instance)
  - endo--packages-eventual-send-src-message-breakpoints-js (cycle 147: also @endo addresses-diagnostic-surface-shape problem)
  - endo--packages-ses-src-error-tame-console-js (cycle 106: SES error-observation surface — `applyLabelingError` rides on top of this)
keywords:
  - three-revision-pivots visible in Prompt section
  - the-data-is-already-there-just-locked discovery
  - sibling-package to submodule pivot
  - opt-in submodule with cost-asymmetry
  - non-throwing matcher mirroring matches() shape
  - compact-default + expanded-opt-in
  - AI-agent-token-economy rationale
  - Rust-compiler-error analogy
  - all-alternatives-reported no-heuristic
  - rich-not-configurable convention
  - column separator | not JSON-Lines
  - ASCII not unicode for terminal/log/CI
  - tracing recursion reuses helpers in place (no parallel implementation)
  - two-consumer-postures (library users + AI agents)
---

# patterns-diagnostic-feedback — three-revision-pivots, §the-data-is-already-there discovery, §non-throwing-matcher-mirroring-`matches`-shape, and §opt-in-submodule-with-cost-asymmetry

## Source

- `endo-but-for-bots designs/patterns-diagnostic-feedback.md` — 704 lines
- Status: **Proposed** (created 2026-05-19; updated 2026-05-20 after three review rounds)
- Author: Kris Kowal (prompted by maintainer kriskowal)
- Cycle 198 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 197's chat-lane @endo/panic; §thirty-second consecutive designs/chat alternation cycle 166-198).

## Single most structurally interesting move

§three-revision-pivots-visible-in-Prompt-section + §the-data-is-already-there-just-locked discovery + §non-throwing-matcher-mirroring-`matches`-shape + §opt-in-submodule-with-cost-asymmetry + §rich-not-configurable rendering convention with §Rust-compiler-error analogy as cited prior art.

The design's Prompt section preserves §three-round-review-trail in the source itself — the original three-axis "thread structured payloads through the matcher" framing got §CHANGES_REQUESTED'd and reshaped through three pivots, each named with the maintainer's review and the structural change it produced:

| Revision | Date | Pivot |
| --- | --- | --- |
| Original | (per the Prompt section) | Three-axis "carry-on-error" design threading structured payloads through the matcher. |
| Round 1 (CHANGES_REQUESTED) | 2026-05-19 | **§the-data-is-already-there-just-locked** discovery: `applyLabelingError` already records the chain via `annotateError` (SES `assert.note`); the chain is unreachable to programmatic readers but the data exists. Reshape: "build a sibling package that reads what is already there and renders it richly" instead of "thread structured payloads through the matcher". §Text-source-parse-path deferred as separable. |
| Round 2 (kriskowal round-2 review) | 2026-05-20 | `diagnose(err, options)` (error post-processor needing `try`/`catch`) reshaped into `diagnose({ specimen, pattern })` (non-throwing matcher mirroring `matches(specimen, pattern): boolean`). Renderer split into `compact` (default; one-line-per-mismatch sized for AI-agent token economy) + `expanded` (indented Rust-compiler-style for humans at a REPL). §Cause-chain-fallback-phase dropped (no error means no chain to walk). |
| Round 3 (kriskowal round-3 review) | 2026-05-20 | Sibling-package framing **retired** in favor of a submodule of `@endo/patterns` itself, exported as `@endo/patterns/explain-mismatch.js`. Direct access to `matchHelpers` registry and `confirmMatches` recursion; §the-drift-vs-stable-internal-surface tension a sibling would have introduced dissolves. Two-function `diagnose` + `render` API folded into single `explainMismatch({ specimen, pattern, context?, format?, width?, color? })`. |

§honest-design-evolution-record at higher fidelity than cycle 197's @endo/panic README — three pivots visible vs one. §honest-design-evolution-record family member (cycles 178/180/183/184/188/192/196/197/198).

## §The-data-is-already-there-just-locked — the central discovery

The original prompt assumed the matcher needed augmenting to carry diagnostics. A close read of `applyLabelingError(func, args, label)` in `@endo/common` revealed the data is mostly already there:

1. On rejection it constructs an outer Error with `` message = `${label}: ${innerErr.message}` `` and annotates via `annotateError(outerErr, X\`Caused by ${innerErr}\`)` (SES `assert.note`).
2. `annotateError` attaches a hidden details record, surfaced by the SES console at log time but **not** present on `err.message` or any enumerable property.
3. The cause chain is reachable only via SES's privileged `takeNoteLogArgs(err)` (internal weakmap accessor) or by capturing console output.

In `packages/patterns/src/patterns/patternMatchers.js`, the matcher uses `applyLabelingError` at every nesting level. A six-level-deep failure produces a six-link annotated cause chain plus a flattened message `"l1: l2: l3: l4: l5: l6: detail"`.

The gap is **not** "the matcher fails to record the path". The gap is "the recorded path is held in a private place, in a string-only format, with no combinator-aware renderer, and the disjunction combinator discards its branch attempts".

§the-gap-is-render-not-record is the load-bearing reframing. §discovery-driven-redesign: "build a sibling package that reads what is already there and renders it richly" instead of "thread structured payloads through the matcher". This is §worth-naming-as-a-pattern: §before-adding-storage-check-if-the-data-is-already-stored. The bonus over cycle 197 panic's design: panic's evolution was security argument; this is information-architecture.

§What-was-already-true:
- Per-level labels preserved as distinct Error objects (chain-walker can recover each label independently).
- SES console already renders the full causal chain (just not in actionable format and not at err.message).
- `InterfaceGuard` argument labeling composes through the same chain — explain-mismatch gets exo composition for free.

§What-was-the-gap:
- No programmatic walker over the cause chain (data lives in SES-internal weakmaps).
- No discrimination of step kinds (a label of `2` could be array index, bag-count index, or alternative branch).
- No combinator awareness at render time (`M.or` over three alternatives currently fails with `"Must match one of [...]"` and abandons all per-alternative chain information).
- No rendering convention (the flat colon-joined message is the only string format).

## §Non-throwing-matcher mirroring `matches()` shape

```ts
function explainMismatch(input: ExplainMismatchInput): string | undefined;
// Returns undefined on match; rendered diagnostic string on mismatch.
```

The shape mirrors `matches(specimen, pattern): boolean` from `@endo/patterns` (which returns a verdict without throwing). The caller pattern collapses to:

```js
const report = explainMismatch({ specimen, pattern });
if (report !== undefined) console.error(report);
```

§No-try/catch + §no-error-construction + §no-error-inspection + §no-separate-render-step. §Caller-pattern-collapses-to-single-conditional. §Two-Endo-buys-on-the-same-axis: `matches()` returning boolean is the precedent; `explainMismatch()` returning `string | undefined` is the extension of that shape — both non-throwing, both single-conditional at call site.

The §error-post-processor framing (round-2's input) required `try`/`catch` at every call site. The §non-throwing-matcher reshape (round-2's output) eliminates that. §The-shape-is-the-API.

## §Opt-in-submodule-with-cost-asymmetry

§Package boundary unchanged. `package.json` `exports` simply lists the new entry alongside the existing main entry:

```json
{
  "./explain-mismatch.js": "./src/explain-mismatch.js"
}
```

§Production-matcher-path pays §zero-additional-cost. Bundlers and Node's ESM loader pull a submodule only when an import names it; `./explain-mismatch.js` appears nowhere on the production matcher's import graph. §Callers-that-never-import-it-never-pay-for-it.

§Submodule-direct-access-to-matchHelpers — the submodule has direct access to `matchHelpers` registry and `confirmMatches` recursion without re-export hoops. §There-is-exactly-one-source-of-matcher-truth. §No-API-contract-the-package-would-otherwise-not-need.

§Why-not-sibling (round-3's reshape, named in Design Decision 1):
- Sibling would either re-implement the matcher (drift risk and duplicated maintenance) or expose a stable internal surface for the sibling to consume (an API contract the package would otherwise not need).
- §The-submodule-has-neither-problem.

§Why-not-thread-payloads-through-matcher (round-1's reshape):
- Production matcher is loaded by every application that uses `mustMatch`, `assertMatches`, or an `InterfaceGuard`.
- §Download-size-plus-startup-cost-felt-across-the-whole-audience.
- §A-diagnostic-facility-that-adds-even-a-few-kilobytes-to-the-production-matcher-path-is-a-regression-for-callers-who-never-read-the-resulting-message.

§The-three-rejected-framings — original carry-on-error / sibling package / two-function API — each had a specific cost that named its rejection.

## §Rich-not-configurable convention with §Rust-compiler-error analogy

> Rust's mismatch output does not let the caller pick between "first candidate" or "best candidate"; it shows them all, with the most likely intent surfaced as a `help:` suggestion. The explain-mismatch submodule follows that convention.

§All-alternatives-reported-no-heuristic-suppresses-the-others is the load-bearing convention. §M.or over three alternatives shows all three branches with their attempted-match chain, ranked by depth-of-match (deeper = considered closer), and §the-reader-picks.

§Rich-rather-than-configurable trades §a-small-amount-of-verbosity for §predictability — §the-same-mismatch-always-renders-the-same-way regardless of how the caller configured the package. §A-configurable-picker-would-invite-per-consumer-config-drift; §a-single-convention-is-predictable.

§Rust-as-cited-prior-art is the §gold-standard-the-design-aspires-to-match. §Borrowable-from-Rust: the convention §show-all-candidates-rank-by-depth-of-match.

## §Two-consumer-postures (library users + AI agents)

§Library-users writing `M.splitRecord(...)` shapes against incoming CapTP traffic see a failure in their AVA log and have to manually walk the specimen against the pattern in a REPL to find the offending field.

§AI-agents that construct patterns from natural-language or JSON-Schema inputs (the `endo-but-for-bots` audience) see the same message but §cannot-walk-the-specimen-interactively. They retry with random perturbations until the message changes, which is §expensive-and-frequently-masks-the-underlying-mismatch.

§AI-agents-cannot-walk-the-specimen-interactively is the §unique-cost-AI-agents-pay that humans don't. §library-users have escape hatches AI agents don't. §the-design-addresses-both. §Sibling-pattern to cycle 196 endoclaw's §two-consumer-postures (assistant + coding-agent) — the design names §who-suffers-most-without-this-feature explicitly.

§Compact-default-is-AI-tuned: §an-agent-has-less-budget-per-token-than-a-human and §a-one-line-per-mismatch-shape-is-both-smaller-and-easier-to-line-grep.
§Expanded-opt-in-is-human-tuned: §a-human-who-wants-the-indented-Rust-compiler-style-view-passes-`{ format: 'expanded' }`.

§Default-favors-the-tighter-budget-consumer (AI agents) rather than the looser (humans) — §the-design-defends-the-token-budget-by-default.

## §Tracing recursion reuses helpers in place — no parallel implementation

The submodule's recursion mirrors `confirmMatches` from `patternMatchers.js` but accumulates a structured trace instead of throwing:

```ts
type TraceStep = { kind: 'property', name: string }
              | { kind: 'index', index: number }
              | { kind: 'mapKey', key: Passable }
              | { kind: 'setElement', element: Passable }
              | { kind: 'orBranch', branchIndex: number, branchPattern: Pattern }
              | { kind: 'arrayOfElement', index: number }
              | { kind: 'recordOfEntry', key: string };

type Trace = {
  path: TraceStep[],
  outcome: 'match' | { failure: string, specimenFragment: Passable, expectedFragment: Pattern },
  children: Trace[]
};
```

§Seven-trace-step-kinds (the discriminated-union shape gives §step-kind-discrimination that the today-shape lacks: a label of `2` is now `{ kind: 'index', index: 2 }` or `{ kind: 'orBranch', branchIndex: 2, ... }`).

The recursion §calls-into-the-existing-matchHelpers-registry-directly — there is exactly one source of matcher truth. §No-parallel-implementation-to-drift. §A-change-to-a-helper-updates-both-lanes-simultaneously. §A-shared-test-corpus-exercising-both-`matches`-and-`explainMismatch`-pins-the-verdict-equivalence.

§The-earlier-sibling-package-draft-worried-about-drift; §the-submodule-reshape-dissolves-that-concern-entirely. §Drift-elimination-by-co-location is the §architectural-pay-off of round 3.

## §Composition with `@endo/exo` argument guards — no exo change required

```js
const report = explainMismatch({
  specimen: arg,
  pattern: methodGuard.argGuards[i],
  context: `${methodName}(${i})`,
});
```

The renderer prefixes the report with the context string. §No-change-to-@endo/exo-itself. §A-future-helper (`explainExoCall(interfaceGuard, methodName, args)`) can sugar this when the submodule sees real use; §the-primitive-surface-is-`explainMismatch({ specimen, pattern, context? })`. §Future-helpers-named-not-shipped (sibling to cycle 197 panic's §three-named-future-extensions).

## §Compact format: column separator `|` not JSON-Lines

```
mismatch (or, 3 alternatives, none matched): { kind: "image", url: 42 }
  alt 0 | .url | found 42 (number) | expected string
  alt 1 | .kind | found "image" | expected "text"
  alt 2 | .kind | found "image" | expected "embed"
```

§Four-column-shape: `path | found | expected | reason`. §No-key-names-per-line (no `"path":` repetition). §No-quoting-overhead.

§Equally-machine-parseable: §a-one-line-`split(' | ')`-recovers-the-columns.

§JSON-Lines was considered and rejected — §a-consumer-that-genuinely-wants-JSON-gets-a-future-second-export, not §a-configuration-knob-on-the-string-renderer.

§The-choice-favors-line-grep over §structured-deserialization. §Tier-1-borrowable: §pipe-separated-columns-for-line-greppable-machine-readable-format.

## §ASCII not unicode for terminal/log/CI compatibility

§ASCII renders correctly in every terminal, log file, and CI output. §Unicode-box-drawing-is-prettier-in-modern-terminals-but-introduces-font-and-encoding-sensitivity that the submodule does not need.

§Future-`style: 'unicode'`-option-is-trivial-to-add (the line-art characters are module constants) §if-a-caller-asks. §Minimal-public-surface-with-named-extension-points.

§ASCII-as-the-default-line-art-discipline sibling to cycle 167 where's §unix-style-only-ASCII and other ASCII-discipline patterns in the library.

## §Nine Design Decisions canonical format

The design enumerates §nine-Design-Decisions, each named with its alternative and the reason for choosing one over the other. §Canonical-Design-Decisions-format (per the §canonical-Design-Decisions-format family cycles 184/188/192/194/196):

1. Submodule of `@endo/patterns`, not a sibling package.
2. `explainMismatch` is a non-throwing matcher, not an error post-processor.
3. Public surface is a single function returning a string, not a split diagnose-plus-render pair.
4. `compact` is the default format, `expanded` is opt-in.
5. Column separator is `|`, not JSON.
6. All alternatives reported, no closest-alternative heuristic.
7. Tracing recursion reuses the matcher's helpers in place.
8. No text-source pattern parser in this design.
9. Renderer uses ASCII, not unicode box-drawing.

§Each-decision-names-the-alternative-it-rejected. §The-pattern-is-not-"here's-what-we-did"-but-"here's-what-we-considered-and-why-we-chose-one".

§Sibling-to cycle 184 daemon-xs-worker-metering's §seven-Design-Decisions and cycle 196 endoclaw's §status-matrix — both name §what-was-considered-but-not-chosen.

## §Single-PR-scope despite three revision rounds

> The submodule is small enough to land as a single PR. The new code is approximately 600 lines including tests.

§Phase-A-is-the-whole-thing — only one phase. §The-three-revision-rounds-shrank-the-scope-not-expanded-it.

Phase A breakdown:
- `packages/patterns/src/explain-mismatch.js` (public entry)
- `packages/patterns/src/explain-mismatch/trace.js` (tracing recursion mirroring `confirmMatches`)
- `packages/patterns/src/explain-mismatch/render.js` (formatter with compact + expanded, width + color)
- `packages/patterns/package.json` `exports` entry
- `packages/patterns/test/explain-mismatch.test.js` (three exemplar cases × 2 formats + InterfaceGuard composition)
- §No-changes-to-`mustMatch`,-`assertMatches`,-`matches`,-or-`applyLabelingError`.

§Three-revision-rounds-shrunk-the-scope is unusual and worth naming as a §borrowable-pattern: §each-review-round-was-a-simplification, not §each-review-round-added-features. §Round-1 dissolved the "thread payloads through matcher" framing. §Round-2 dissolved the try/catch boilerplate. §Round-3 dissolved the sibling-package boundary and folded two functions into one.

## §No-design-predecessors named explicitly

> | (none in `designs/`) | New submodule inside `@endo/patterns`; reads but does not modify `@endo/common/apply-labeling-error.js`. No design predecessors. |

§Explicit-no-predecessors-row in the Dependencies table. §honest-about-being-a-greenfield-design — §sibling-to cycle 192 daemon-engo-supervisor's §implicit-supersedes-lesson-learned and cycle 178's §revised-scope-2026-04-15.

§Future-pattern: when a design has no predecessor, §record-that-explicitly so future readers don't search for one. §Negative-space-as-record.

## §One open question

> **Interaction with `@endo/exo` argument guards.** The `context` field on `ExplainMismatchInput` carries the method-name and argument-index prefix. Whether a sugar helper (`explainExoCall(interfaceGuard, methodName, args)`) should ship in the initial PR or wait for an in-repo user is open. A short integration test against an `InterfaceGuard`-rejected call before Phase A lands is appropriate either way.

§Single-Open-Question discipline — §the-design-is-mostly-settled. §Sibling to cycle 196 endoclaw with §seven-Open-Questions for a §reference-document vs cycle 198 with §one-Open-Question for a §nearly-ready-implementation.

§Open-Question-count-as-design-maturity-signal: more open questions = earlier in the design lifecycle. §198-is-late-in-its-lifecycle (one question), §196 is mid (seven questions, plus Reference status).

## §Borrowable patterns (tier-1)

1. **§three-revision-pivots-visible-in-Prompt-section** — preserve the review trail in the source itself; future readers see the design's evolution, not just its endpoint.
2. **§the-data-is-already-there-just-locked discovery** — before adding storage, check if the data is already stored somewhere unreachable. §Discovery-driven-redesign: build a renderer that reads what already exists instead of threading new storage through the production path.
3. **§non-throwing-matcher mirroring an existing non-throwing API shape** — when a feature could be an "error post-processor", check if a sibling API is already non-throwing; if so, mirror its shape.
4. **§opt-in-submodule with cost-asymmetry** — production path pays zero; only callers that import the submodule pay. Bundler / ESM-loader / `package.json exports` mechanics make this enforceable without convention.
5. **§submodule-not-sibling-package** — when the diagnostic facility needs internal access, a submodule with direct registry access dissolves the drift-vs-stable-internal-surface tension a sibling package would have introduced.
6. **§rich-not-configurable rendering convention** with §Rust-compiler-error-analogy as cited prior art.
7. **§all-alternatives-reported, ranked-by-depth-of-match, no-heuristic-suppresses-the-others** — show all candidates and let the reader pick.
8. **§two-consumer-postures named explicitly** (library users + AI agents) with §AI-agents-cannot-walk-the-specimen-interactively as the unique cost AI agents pay.
9. **§compact-default + expanded-opt-in** with §default-favors-the-tighter-budget-consumer (AI agents) rather than the looser (humans).
10. **§pipe-separated-columns for line-greppable machine-readable format** — `path | found | expected | reason` beats JSON-Lines for line-grep without sacrificing parseability (`split(' | ')`).
11. **§ASCII-not-unicode** for terminal/log/CI compatibility, with §future-unicode-trivial-to-add if a caller asks.
12. **§tracing-recursion-reuses-helpers-in-place** — one source of matcher truth; a change to a helper updates both lanes simultaneously; no parallel implementation to drift.
13. **§seven-trace-step-kinds discriminated-union** for step-kind-discrimination that string/number labels lacked.
14. **§each-Design-Decision-names-the-alternative-it-rejected** — not "here's what we did" but "here's what we considered and why we chose one".
15. **§nine-Design-Decisions canonical format** — sibling to cycle 184/188/192/194/196 same-shape format.
16. **§single-PR-scope-despite-three-revision-rounds** — review rounds shrank the scope, not expanded it. §Each-review-round-was-a-simplification.
17. **§explicit-no-predecessors-row** in the Dependencies table — negative space as record.
18. **§future-helpers-named-not-shipped** (`explainExoCall`, structured-trace export, JSON export, `style: 'unicode'`) — minimal public surface with named extension points; future-pattern reflects what cycle 197 panic also documents as §three-named-future-extensions.
19. **§single-Open-Question-discipline** as §design-maturity-signal.
20. **§composition-without-modification** of `@endo/exo` — the `context` field on `ExplainMismatchInput` carries the method-name + argument-index prefix without any exo change required.

## §Synthesis-target

Slot machine library §pattern-matcher-diagnostic-surface (when the slot machine's predicate over an outcome fails) can §borrow-the-non-throwing-matcher-shape directly: a `explainOutcome({ outcome, predicate }): string | undefined` mirror of a boolean `matches()` API. §opt-in-submodule discipline gates the diagnostic feature behind an explicit import so the production payout-path pays zero.

§The-data-is-already-there-just-locked discovery pattern is borrowable in any §library-with-a-throwing-API that consumers wish were §programmatically-introspectable: check whether the data already exists in a hidden place (in this case, SES `annotateError` chain via `assert.note`) before threading new storage through.

§All-alternatives-reported-no-heuristic borrowable for any §multi-candidate-failure surface (slot machine combinator failures, predicate disjunctions). §Rust-compiler-error-analogy is the citable prior art.

§Two-consumer-postures-named-explicitly with §default-favors-the-tighter-budget-consumer borrowable for any §dual-audience API where humans and AI agents both consume output.

## §Cycle 198 meta-observations

§The-thirty-second-consecutive-designs/chat-alternation-cycle 166-198.

§Papers-lane-blocked 92+ consecutive cycles (since cycle ~106). §The-rotation-discipline gracefully pivots away from papers-lane every cycle.

§Library-reaches-703-sections at cycle 198.

§honest-design-evolution-record family member (cycles 178/180/183/184/188/192/196/197/198) — ninth member; this one shows the most revision-rounds visible-in-source (three) of any member.

§Sibling-pattern to cycle 197 @endo/panic's §honest-design-evolution-in-the-README but at higher fidelity — three pivots visible vs one. §Both-name-the-prior-position-before-naming-the-new-one.

§Sibling-to cycle 196 endoclaw's §canonical-Design-Decisions-format and §multi-author-quote-blocks — §198 has the §Design-Decisions structure but lacks co-author quotes (single-author drafted from prompted-by-maintainer review feedback; the review feedback shows up in the Prompt section as §revised-after-CHANGES_REQUESTED narration rather than as inline quote-blocks).
