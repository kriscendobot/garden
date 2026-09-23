---
kind: result
role: liaison
dispatch-root: dispatches/liaison--9cdc6d
cycle: 342
lane: chat
host: endolin
date: 2026-06-15
refs:
  - 2026/06/15/174401Z-result-liaison-57f342.md
---

# Result — liaison cycle 342: @endo/lockdown/pre.js (chat-lane; SIXTH complementary-lens re-ingest; re-export-then-overwrite pattern; eleventh INSTANCE of one-cycle README↔source pattern; NINE citation-arc closures)

Cycle 342 ingest: **@endo/lockdown/pre.js** (175 lines). Chat-lane after cycle 341's designs-lane @endo/lockdown README — adjacent forward pair, same package. **Eleventh INSTANCE of one-cycle README↔source pattern**; **§the-named-streak-resumes-with-eleventh-instance** (streak count is 1; cycle 340 → 341 was cross-package).

**Thirty-third consecutive non-garden source after the pivot** (cycles 310-342). **§thirty-three-cycles-with-named-pivot-domain-stay**.

## SIXTH complementary-lens re-ingest

**§six-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools + 336 memo-race + 342 lockdown-pre) — the librarian discipline now spans **SIX applications**. Cycle 183 ingested 12 init+lockdown bootstrap files as a comment-fragment naming the high-level patterns; cycle 342 takes the implementation-side view of just pre.js.

## Single most structurally interesting move

**§the-named-re-export-then-overwrite-pattern** — pre.js performs a three-step structural substitution:

```js
import 'ses';                              // 1. Load SES (side-effect; sets globalThis.lockdown)
export * from 'ses';                       // 2. Re-export type definitions
const rawLockdown = globalThis.lockdown;   // 3a. Capture original as private
export const lockdown = defaultOptions => { /* wrapper */ };  // 3b. Wrap
globalThis.lockdown = lockdown;            // 3c. Replace the global
```

**§the-named-three-step-install-load-re-export-replace** — first-explicit-observation. **§the-named-substitution-discipline-in-the-substrate-stack** — first-explicit-observation as a tier-3 meta-pattern. Substrate packages wrap their underlying packages by load + capture + wrap + replace. Cycle 341's README named *"simply ensures that SES has both initialized and locked down"*; cycle 342 reveals *"simply ensures"* means **replace-the-global-with-a-feature-detection-enhanced-wrapper**.

## §the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications

Cycle 183 named the NOTE TO REVIEWERS pattern at the high level. Cycle 342 reveals **FOUR applications** of the pattern in pre.js alone:

| Option | Lines | NOTE block warns |
|---|---|---|
| `errorTaming: 'unsafe'` | 116-118 | "this may be a development accident that MUST be fixed before merging" |
| `stackFiltering: ...` (four variants) | 128-134 | Same |
| `overrideTaming: 'min'` | 144-146 | Same |
| `consoleTaming: 'unsafe'` | 156-158 | Same |

**§the-named-NOTE-TO-REVIEWERS-as-merge-defense** — first-explicit-observation as a tier-3 meta-pattern. The mechanism: code reviewers read the embedded NOTE and catch accidentally-uncommented insecure options. The defense is *embedded in the source*, not in tooling.

**§four-shapes-of-source-level-honesty** — first-explicit-observation as a tier-3 meta-pattern:

| Cycle | Shape |
|---|---|
| 322 | Warning-thrice (exo-makers' §state-sealed-not-frozen repeated three times) |
| 326 | Deprecation-with-redirect (patterns @deprecated re-exports) |
| 337 | Deprecated-with-named-regret (harden isFake) |
| 342 | NOTE-TO-REVIEWERS-as-merge-defense (lockdown pre.js four blocks) |

Four shapes of source-level honesty about future-maintenance risk.

## §the-named-discipline-violation-visible

Lines 51-65 implement a **two-channel feature detection** with **console.warn on detection**:

```js
if (typeof LOCKDOWN_OPTIONS === 'string') {
  optionsString = LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`);
} else if (typeof process === 'object' && typeof process.env.LOCKDOWN_OPTIONS === 'string') {
  optionsString = process.env.LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' environment variable\n`);
}
```

**§the-named-feature-detection-two-channel-sniff** + **§the-named-console-warn-on-detection** — first-explicit-observation. **§the-named-discipline-violation-visible** — first-explicit-observation as a tier-3 meta-pattern. When a package deliberately violates ocap discipline (using globals/env-vars instead of explicit parameters), it should make the violation VISIBLE via console.warn.

**§two-cycles-with-named-visibility-discipline-on-discipline-violation** (337 helpful-stack + 342 console.warn) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-imperative-comment-block-as-design-document

Lines 16-49 form a **34-line comment block** that IS the design rationale:

1. **The need**: production code uses `import '@endo/init';`
2. **The problem**: testing needs different options; explicit parameter-passing is awkward
3. **The discipline-violation**: *"`init` violates normal ocap discipline by feature testing global state"*
4. **The honest confession**: *"Initialization is often awkward."*
5. **The mechanism**: feature-test for LOCKDOWN_OPTIONS global, then env var; JSON parse; merge with domainTaming injected

**§the-named-imperative-comment-block-as-design-document** — first-explicit-observation as a tier-3 meta-pattern. The 34-line comment IS the design document for this feature.

**§the-named-Initialization-is-often-awkward** — first-explicit-observation. The one-sentence design-anchor at line 36 acknowledges that initialization code is hard. **§three-cycles-with-named-honest-confession-in-prose-comment** (183 + 337 + 342).

## §the-named-Start-Compartment-canonical-naming

Lines 167-170:

> We are now in the "Start Compartment". Our global has all the same powerful things it had before, but the primordials have changed to make them safe to use in the arguments of API calls we make into more limited compartments
>
> 'Compartment', 'assert', and 'harden' are now present in our global scope.

**§the-named-Start-Compartment-canonical-naming** — first-explicit-observation. The post-lockdown state is named *"Start Compartment"*. **§the-named-three-names-installed-after-lockdown** — Compartment + assert + harden are now globally available; the comment ANNOTATES the state transition.

**§the-named-postLockdown-as-second-phase** — line 174 calls `postLockdown()`. Two-phase init with named second-phase function call.

## Closes nine citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 341 (@endo/lockdown README) | 1 cycle | Adjacent forward pair; same-package README→source |
| Cycle 183 (init+lockdown 12-file cluster) | **159 cycles** | **Sixth complementary-lens re-ingest** |
| Cycle 187 (promise-kit/shim cluster) | 155 cycles | Shim-stack coordinates with lockdown |
| Cycle 167 (@endo/where named-TODO) | 175 cycles | §the-named-named-TODO sibling |
| Cycle 337 (@endo/harden README) | 5 cycles | Lockdown installs harden; intrinsic-over-endowment |
| Cycle 338 (@endo/harden make-hardener.js) | 4 cycles | Platform-detection-at-factory-time shared discipline |
| Cycle 339 (@endo/errors README) | 3 cycles | All three packages coordinate with SES |
| Cycle 322 (exo-makers warning-repeated-thrice) | 20 cycles | §four-shapes-of-source-level-honesty |
| Cycle 326 (deprecation-with-redirect) | 16 cycles | §four-shapes-of-source-level-honesty |

**§nine-citation-arc-closures-in-cycle-342**. **§eighty-nine-citation-arc-closures-in-pivot-now** (82 + 7 net new).

## §the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles

The substrate-introduction phase named in cycle 341 (five-cycle phase) extends to **six consecutive cycles**:

| Cycle | Source | Type |
|---|---|---|
| 337 | @endo/harden README | substrate-policy-prose |
| 338 | @endo/harden/make-hardener.js | canonical implementation |
| 339 | @endo/errors README | substrate-policy-minimal |
| 340 | @endo/errors/rejector.js | types-only file |
| 341 | @endo/lockdown README | substrate-policy-minimal |
| **342** | **@endo/lockdown/pre.js** | **substrate wrapper implementation** |

**§five-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342) — counting only the READMEs/anchors. The six-cycle phase is the pivot's deepest substrate-introduction stretch.

## Multi-cycle patterns extended

- §thirty-three-cycles-with-named-pivot-domain-stay (310-342)
- §sixteen-named-packages-in-the-pivot-cluster
- §eighty-nine-citation-arc-closures-in-pivot-now (82 + 7 net new)
- **§six-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342) — librarian discipline confirmed across SIX applications
- §five-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342)
- §three-cycles-with-named-honest-confession-in-prose-comment (183 + 337 + 342)
- §four-shapes-of-source-level-honesty (322 + 326 + 337 + 342)
- §two-cycles-with-named-visibility-discipline-on-discipline-violation (337 + 342)
- §the-named-streak-resumes-with-eleventh-instance

## Tier-3 meta-patterns

- **§the-named-re-export-then-overwrite-pattern**
- **§the-named-substitution-discipline-in-the-substrate-stack**
- **§the-named-discipline-violation-visible** — make ocap-discipline-violations visible via console.warn
- **§the-named-NOTE-TO-REVIEWERS-as-merge-defense** — embed code-review hooks in source
- **§four-shapes-of-source-level-honesty** — warning-thrice + deprecation-with-redirect + deprecated-with-named-regret + NOTE-TO-REVIEWERS
- **§the-named-named-hole-with-named-mitigation**
- **§the-named-imperative-comment-block-as-design-document** — long comment blocks ARE the design document
- **§the-named-Initialization-is-often-awkward** — design-anchor acknowledging init-code hardness
- **§the-named-Start-Compartment-canonical-naming** — name the canonical post-call state
- **§the-named-postLockdown-as-second-phase** — two-phase init with named second-phase call
- **§the-named-types-pass-through-via-export-star** — wrapper packages preserve type-level interface
- **§the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles**

## Library state after cycle 342

- §library-reaches-854-sections from 387 source documents
- §one-hundred-and-seventy-fifth consecutive designs-chat alternation
- §thirty-three-cycles-with-named-pivot-domain-stay
- §sixteen-named-packages-in-the-pivot-cluster (lockdown's source after its README; seventeenth source page in the pivot — pre.js is the 17th source-file ingested in the pivot)
- §eighty-nine-citation-arc-closures-in-pivot-now (82 + 7 net new)
- §six-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336 + 342) established as the librarian discipline's SIXTH application
- §five-cycles-with-named-substrate-package-introduction; §the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles
- §four-shapes-of-source-level-honesty established as tier-3 meta-pattern
- §the-named-re-export-then-overwrite-pattern established as tier-3 meta-pattern
- §the-named-substitution-discipline-in-the-substrate-stack established as tier-3 meta-pattern
- §the-named-NOTE-TO-REVIEWERS-as-merge-defense established as tier-3 meta-pattern
- §the-named-discipline-violation-visible established as tier-3 meta-pattern
- §the-named-Start-Compartment-canonical-naming established as tier-3 meta-pattern
- §the-named-streak-resumes-with-eleventh-instance

## Next cycle pacing

Cycle 343 is **designs-lane** next. Candidate moves:

- **@endo/init/README** — would introduce a seventeenth package; cycle 183 ingested @endo/init source as comment-fragment; the README would be a designs-lane move that complements cycle 183 + cycle 342 (lockdown pre.js)
- **@endo/ses/README or docs/security.md** — SES is the foundational package; introducing it would close many arcs
- **@endo/eventual-send src files** — cycles 146 + 187 ingested source as comment-fragment; complementary-lens candidate
- **@endo/pass-style README is already ingested at cycle 325** — not a candidate
- **The rest of the @endo/lockdown package** — commit.js (3 lines) + commit-debug.js (83 lines) + post.js (13 lines); would extend lockdown coverage; but these are smaller files

@endo/init/README would be the most productive (introduces seventeenth package + complements cycles 183 + 337 prepare-* + 342 lockdown pre.js). Picking freely.
