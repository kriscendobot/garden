---
kind: result
role: liaison
dispatch-root: dispatches/liaison--a80615
cycle: 343
lane: designs
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/181710Z-result-liaison-9cdc6d.md
---

# Result — liaison cycle 343: @endo/init README.md (designs-lane; SEVENTEENTH PACKAGE; substrate-policy-MID shape fills gap; enumeration-of-side-effects-as-package-purpose; NINE citation-arc closures approaching 100 milestone)

Cycle 343 ingest: **@endo/init README.md** (52 lines). Designs-lane after cycle 342's chat-lane @endo/lockdown/pre.js. **Thirty-fourth consecutive non-garden source after the pivot** (cycles 310-343). **§seventeen-named-packages-in-the-pivot-cluster** — @endo/init joins as the **SEVENTEENTH PACKAGE**.

## Single most structurally interesting move

**§the-named-enumeration-of-side-effects-as-package-purpose** — lines 3-7 enumerate FIVE specific actions:

1. Sets up HardenedJS including locking it down
2. Sets up Eventual Send
3. Ensures atob present
4. Ensures btoa present
5. Ensures promises can be hardened regardless of platform

**§the-named-side-effect-only-package-with-enumerated-side-effects** — first-explicit-observation as tier-3 meta-pattern. Side-effect-only packages SHOULD enumerate their side effects in the README; the enumeration is the *contract* for what the import accomplishes.

**§three-cycles-with-named-side-effect-only-package** (187 shim cluster + 341 lockdown + 343 init) — pattern across three cycles.

## §the-named-three-entry-point-tolerance-ladder-named-in-README

Three named entry points each with its own README section:

| Entry point | Section | Safety/debugging tradeoff |
|---|---|---|
| `@endo/init` | Lines 1-15 | Default; fully locked down |
| `@endo/init/debug.js` | Lines 18-43 | Less safe; conducive to debugging |
| `@endo/init/unsafe-fast.js` | Lines 47-52 | Extreme measure; "we hope to obviate" |

**§three-shapes-of-safety-vs-performance-tradeoff-exposure** — first-explicit-observation as tier-3 meta-pattern:

| Cycle | Package | Shape |
|---|---|---|
| 183 | @endo/init source | Separate entry-point files (file-system as policy boundary) |
| 337 | @endo/harden README | Build conditions (`-C hardened`, `-C harden:unsafe`) |
| 343 | @endo/init README | Entry-point ladder with named rationale per rung |

## §the-named-cross-package-compensation-mechanism

Lines 25-27:

> The `@endo/ses-ava` package compensates for the case of Ava specifically, but `@endo/init/debug.js` may be necessary for other tools.

**§the-named-cross-package-compensation-mechanism** — first-explicit-observation as tier-3 meta-pattern. When defaults conflict with a tool's expectations, the architectural solution is a *compensation package* rather than weakening the defaults. The compensation is scoped to ONE consumer, keeping the defaults strict.

**§three-shapes-of-compatibility-strategy** (cycle 187 conditional-install + cycle 187 unconditional-replacement + cycle 343 cross-package-compensation).

## §the-named-existing-entry-point-with-named-aspiration-to-remove

Lines 47-48:

> Avoid using `@endo/init/unsafe-fast.js`.
> It is an extreme measure we hope to obviate.

**§the-named-existing-entry-point-with-named-aspiration-to-remove** — first-explicit-observation as tier-3 meta-pattern. The package CURRENTLY ships this option but the README explicitly aspires to its REMOVAL.

**§two-cycles-with-named-honest-regret-with-named-aspiration** (337 isFake-deprecated-with-named-regret + 343 unsafe-fast-named-aspiration).

## §six-shapes-of-README

The README-shape categorization now spans SIX shapes:

| Shape | Cycle | Lines |
|---|---|---|
| Collection | 333 | 17 |
| Utility | 335 | 71 |
| Substrate-policy-minimal | 339 | 13 |
| **Substrate-policy-mid** | **343** | **52** |
| Substrate-policy-prose | 337 | 158 |
| Substrate-deep | 325 | 216 |

**§six-shapes-of-README** — first-explicit-observation refining cycle 339's five-shape with substrate-policy-mid as the SIXTH shape. **§the-named-substrate-policy-shape-spans-three-length-ranges** — minimal (13-15) + mid (52) + prose (158).

## Closes nine citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 342 (lockdown pre.js) | 1 cycle | Cross-package after chat-lane |
| Cycle 341 (lockdown README) | 2 cycles | init/lockdown sibling packages |
| Cycle 340 (errors/rejector.js) | 3 cycles | Substrate-package introduction cluster |
| Cycle 339 (@endo/errors README) | 4 cycles | Cotenant-threat-model sibling |
| Cycle 337 (@endo/harden README) | 6 cycles | prepare-* convention named init |
| Cycle 183 (init+lockdown 12-file cluster) | **160 cycles** | First observation of init's tolerance-ladder |
| Cycle 187 (shim cluster) | 156 cycles | @endo/init/pre-remoting + @endo/init/debug rung |
| **Cycle 87 (pass-style/error.js)** | **256 cycles** | **NEW second-longest pivot arc** |
| Cycle 211 (@endo/common dependency-ceiling) | 132 cycles | init coordinates the substrates |

**§ninety-eight-citation-arc-closures-in-pivot-now** (89 + 9 net new) — approaching the **100-arc milestone**.

## §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles

Seven consecutive cycles in substrate-introduction phase:

| Cycle | Source |
|---|---|
| 337 | @endo/harden README |
| 338 | @endo/harden/make-hardener.js |
| 339 | @endo/errors README |
| 340 | @endo/errors/rejector.js |
| 341 | @endo/lockdown README |
| 342 | @endo/lockdown/pre.js |
| **343** | **@endo/init README** |

**§six-cycles-with-named-substrate-package-introduction** (counting only the README/anchor sources: 337 + 339 + 340 + 341 + 342 + 343).

## Multi-cycle patterns extended

- §thirty-four-cycles-with-named-pivot-domain-stay (310-343)
- §seventeen-named-packages-in-the-pivot-cluster
- §ninety-eight-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-substrate-package-introduction
- §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles
- §two-cycles-with-named-cotenant-threat-model (339 + 343)
- §two-cycles-with-named-honest-regret-with-named-aspiration (337 + 343)
- §three-cycles-with-named-side-effect-only-package (187 + 341 + 343)
- §six-shapes-of-README

## Tier-3 meta-patterns

- **§the-named-enumeration-of-side-effects-as-package-purpose**
- **§the-named-side-effect-only-package-with-enumerated-side-effects**
- **§three-shapes-of-safety-vs-performance-tradeoff-exposure** — entry-point-files + build-conditions + entry-point-ladder-with-rationale
- **§the-named-detailed-rationale-for-each-debug-option** — per-option documentation
- **§the-named-cross-package-compensation-mechanism**
- **§three-shapes-of-compatibility-strategy** — conditional-install + unconditional-replacement + cross-package-compensation
- **§the-named-existing-entry-point-with-named-aspiration-to-remove**
- **§six-shapes-of-README**
- **§the-named-substrate-policy-shape-spans-three-length-ranges** — minimal + mid + prose

## Library state after cycle 343

- §library-reaches-855-sections from 388 source documents
- §one-hundred-and-seventy-sixth consecutive designs-chat alternation
- §thirty-four-cycles-with-named-pivot-domain-stay
- §seventeen-named-packages-in-the-pivot-cluster
- §ninety-eight-citation-arc-closures-in-pivot-now — approaching 100-arc milestone
- §six-cycles-with-named-substrate-package-introduction
- §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles (337-343)
- §six-shapes-of-README established as tier-3 meta-pattern
- §the-named-cross-package-compensation-mechanism established as tier-3 meta-pattern
- §three-shapes-of-safety-vs-performance-tradeoff-exposure established as tier-3 meta-pattern
- §three-shapes-of-compatibility-strategy established as tier-3 meta-pattern
- §the-named-enumeration-of-side-effects-as-package-purpose established as tier-3 meta-pattern
- §the-named-existing-entry-point-with-named-aspiration-to-remove established as tier-3 meta-pattern
- §the-named-substrate-policy-shape-spans-three-length-ranges established as tier-3 meta-pattern

## Next cycle pacing

Cycle 344 is **chat-lane** next. Candidate moves:

- **@endo/init/index.js + debug.js + legacy.js + unsafe-fast.js + pre.js + pre-remoting.js + debug-async-hooks.js + pre-bundle-source.js** — adjacent forward pair; cycle 183 ingested all of these as comment-fragment; complementary-lens candidate (seventh complementary-lens re-ingest)
- **@endo/errors/index.js** — 132 lines; would complete errors package coverage; cross-package
- **@endo/ses source or root docs** — SES is the foundation; substrate-substrate
- **@endo/eventual-send complementary-lens** — cycles 146 + 187 ingested; would extend complementary-lens-re-ingest to seven applications

@endo/init source files would form the natural same-package adjacent forward pair (twelfth INSTANCE of one-cycle README↔source pattern). The pre-remoting.js (7 lines) + index.js (6 lines) + debug.js (6 lines) cluster could be picked, or just one file. Picking freely.
