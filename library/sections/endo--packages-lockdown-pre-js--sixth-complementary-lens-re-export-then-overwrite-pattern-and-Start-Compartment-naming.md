---
title: "@endo/lockdown pre.js — sixth complementary-lens re-ingest; re-export-then-overwrite pattern; Start Compartment canonical naming; eleventh one-cycle README↔source pair (cycle 341 → 342)"
source: endo--packages-lockdown-pre-js
url: https://github.com/endojs/endo/blob/master/packages/lockdown/pre.js
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/lockdown/pre.js
total-lines: 175
ingest-cycle: 342
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-re-export-then-overwrite-pattern
  - the-named-three-step-install-load-re-export-replace
  - the-named-feature-detection-two-channel-sniff
  - the-named-LOCKDOWN_OPTIONS-as-global-OR-env-discipline
  - the-named-console-warn-on-detection
  - the-named-discipline-violation-visible
  - the-named-three-branch-decision-tree-with-defaults
  - the-named-imperative-comment-block-as-design-document
  - the-named-honest-confession-in-prose-comment
  - the-named-Initialization-is-often-awkward
  - the-named-init-violates-normal-ocap-discipline-honest-comment
  - the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications
  - the-named-four-commented-out-options-with-NOTE-TO-REVIEWERS
  - the-named-domainTaming-unsafe-always-injected
  - the-named-named-hole-with-named-mitigation
  - the-named-Start-Compartment-canonical-naming
  - the-named-postLockdown-as-second-phase
  - the-named-export-star-for-types-from-source-package
  - the-named-complementary-lens-re-ingest
  - six-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-eleventh-instance
  - thirty-three-cycles-with-named-pivot-domain-stay
  - eighty-nine-citation-arc-closures-in-pivot-now
  - five-cycles-with-named-substrate-package-introduction
---

# `@endo/lockdown pre.js` — sixth complementary-lens re-ingest; re-export-then-overwrite pattern

The 175-line pre.js — the most substantial of @endo/lockdown's four source files. Cycle 342 is **chat-lane after cycle 341's designs-lane @endo/lockdown README** — adjacent forward pair, same package. **§the-named-streak-resumes-with-eleventh-instance** — eleventh INSTANCE of one-cycle README↔source pattern; streak count is 1 (cycle 340 → 341 was cross-package).

**Thirty-third consecutive non-garden source after the pivot** (cycles 310-342). **§thirty-three-cycles-with-named-pivot-domain-stay**. **§sixteen-named-packages-in-the-pivot-cluster** continues (lockdown's source after its README).

**Note on prior ingest**: Cycle 183 ingested **12 init+lockdown bootstrap files** as a comment-fragment, naming the high-level patterns: §two-phase-init-with-tolerance-ladder + §sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch + §NOTE-TO-REVIEWERS-pattern + §honest-confession-in-prose-comment + §named-hole-with-named-mitigation + §the-canonical-Agoric-shim-stack. Cycle 342 is a **§the-named-complementary-lens-re-ingest** — the **SIXTH application** of the librarian discipline (after cycles 322 + 324 + 330 + 332 + 336).

**§six-cycles-with-named-complementary-lens-re-ingest** (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools + 336 memo-race + 342 lockdown-pre) — the discipline now spans **six applications**.

## The single most structurally interesting move

**§the-named-re-export-then-overwrite-pattern** — pre.js performs a three-step structural move:

```js
// Step 1: Load SES (side-effect import; sets up globalThis.lockdown)
import 'ses';

// Step 2: Re-export SES type definitions to consumers
export * from 'ses';

// Step 3a: Capture SES's lockdown as raw
const rawLockdown = globalThis.lockdown;

// Step 3b: Define a wrapper that adds LOCKDOWN_OPTIONS sniff feature
export const lockdown = defaultOptions => {
  // ... feature-detection + three-branch decision tree ...
};

// Step 3c: REPLACE the global with the wrapper
globalThis.lockdown = lockdown;
```

**§the-named-re-export-then-overwrite-pattern** — first-explicit-observation as a tier-3 meta-pattern. The pattern wraps an existing global function:

1. **Load** the source package (SES) for its side effects
2. **Re-export** the source package's types (so consumers get type info)
3. **Capture** the original global as a private reference
4. **Wrap** it with added behavior
5. **Replace** the global with the wrapper

**§the-named-three-step-install-load-re-export-replace** — first-explicit-observation. The three structural moves: load (side-effect) + re-export (type-pass-through) + replace (wrapper-installation).

Cycle 341's README named the package as *"simply ensures that SES has both initialized and locked down the environment"* — but **§the-named-simply-ensures-language** hides this implementation pattern. Cycle 342 reveals: *"simply ensures"* means *replace the global with a feature-detection-enhanced wrapper*. The wrapper adds LOCKDOWN_OPTIONS feature-detection that the underlying SES lockdown doesn't have.

**§the-named-substitution-discipline-in-the-substrate-stack** — first-explicit-observation as a tier-3 meta-pattern. Substrate packages wrap their underlying packages by:
- Importing for side-effect (the underlying package installs its globals)
- Capturing the global
- Replacing with a wrapper that adds package-specific features

Compare to cycle 337 @endo/harden's §the-named-multiple-instances-first-call-wins — also a replace-at-shared-location pattern; cycle 342's pre.js is the implementation in a different package showing the same discipline.

## §the-named-feature-detection-two-channel-sniff

Lines 51-65 implement a two-channel feature detection:

```js
let optionsString;
if (typeof LOCKDOWN_OPTIONS === 'string') {
  optionsString = LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`);
} else if (typeof process === 'object' && typeof process.env.LOCKDOWN_OPTIONS === 'string') {
  optionsString = process.env.LOCKDOWN_OPTIONS;
  console.warn(`'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' environment variable\n`);
}
```

**§the-named-feature-detection-two-channel-sniff** — first-explicit-observation. **TWO channels** checked in **deterministic order**:
1. JavaScript global variable `LOCKDOWN_OPTIONS`
2. Environment variable `process.env.LOCKDOWN_OPTIONS`

**§the-named-LOCKDOWN_OPTIONS-as-global-OR-env-discipline** — first-explicit-observation. The discipline: one feature can be configured via TWO channels (browser-friendly global + Node-friendly env var). The two channels are NOT redundant — they reflect different host environments (browsers don't have `process.env`; Node has both).

**§the-named-console-warn-on-detection** — first-explicit-observation. Each successful sniff emits a `console.warn` with the package name and which channel triggered. **§the-named-discipline-violation-visible** — first-explicit-observation as a tier-3 meta-pattern. When a package deliberately violates ocap discipline (using globals/env-vars instead of explicit parameters), it should make the violation VISIBLE via console.warn.

Compare to cycle 337 @endo/harden's §the-named-helpful-stack-on-misuse (runtime detection of pre-lockdown harden); cycle 342's console.warn is the *cooperative* version of the same discipline — the package itself logs what it did, so reviewers can audit.

**§two-cycles-with-named-visibility-discipline-on-discipline-violation** (337 stack + 342 console.warn) — first-explicit-observation as a tier-2 multi-cycle pattern.

## §the-named-three-branch-decision-tree-with-defaults

Lines 67-160 implement a three-branch decision tree:

| Branch | Condition | Behavior |
|---|---|---|
| 1 | `optionsString` from sniff (lines 67-89) | Parse JSON; validate as object; merge with `domainTaming: 'unsafe'`; call rawLockdown |
| 2 | `defaultOptions` argument (lines 90-95) | Spread `defaultOptions`; add `domainTaming: 'unsafe'`; call rawLockdown |
| 3 | Fall through (lines 96-163) | Call rawLockdown with HARDCODED defaults including domainTaming: 'unsafe' |

**§the-named-three-branch-decision-tree-with-defaults** — first-explicit-observation. The branches enumerate THREE configuration sources: (1) external (sniffed); (2) caller-provided; (3) hardcoded fallback. The tree's structure: external-wins; caller-wins-over-default; default-as-last-resort.

**§the-named-domainTaming-unsafe-always-injected** — first-explicit-observation as a tier-3 meta-pattern. The `domainTaming: 'unsafe'` option is INJECTED in ALL THREE BRANCHES regardless of input. The rationale (lines 144-160):

> Domain taming causes lockdown to throw an error if the Node.js domain module has already been loaded... However, our platform still depends on systems like standardthings/esm which ultimately pull in domains. For now, we are resigned to leave this hole open, knowing that all contract code will be run under XS to avoid this vulnerability.

**§the-named-named-hole-with-named-mitigation** — already observed in cycle 183; reaffirmed in cycle 342 with a fuller treatment. The discipline: when a security hole cannot be closed in the immediate environment, name BOTH the hole AND the mitigation in another layer.

**§the-named-injected-default-as-platform-acknowledgment** — first-explicit-observation. The `domainTaming: 'unsafe'` injection acknowledges that the *npm ecosystem* (standardthings/esm) makes the strict default impossible. The injection is a PRAGMATIC compromise made explicit.

## §the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications

Lines 105-135 contain FOUR `NOTE TO REVIEWERS` blocks, each guarding a commented-out option:

| Option | Lines | Comment |
|---|---|---|
| `errorTaming: 'unsafe'` | 116-118 | "If you see the following line *not* commented out, this may be a development accident that MUST be fixed before merging" |
| `stackFiltering: ...` (four variants) | 128-134 | "If you see the `stackFiltering` settings *not* commented out below, this may be a development accident that MUST be fixed before merging" |
| `overrideTaming: 'min'` | 144-146 | Same NOTE TO REVIEWERS |
| `consoleTaming: 'unsafe'` | 156-158 | Same NOTE TO REVIEWERS |

**§the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications** — first-explicit-observation. Cycle 183 named the NOTE TO REVIEWERS pattern in the high-level; cycle 342's complementary-lens reveals **four applications** of the pattern in pre.js alone.

**§the-named-four-commented-out-options-with-NOTE-TO-REVIEWERS** — first-explicit-observation. Each NOTE TO REVIEWERS block is associated with a SPECIFIC commented-out option that would weaken security. The pattern:

1. Comment block explaining when/why one MIGHT want to uncomment
2. NOTE TO REVIEWERS warning about development-accident
3. The commented-out option itself

**§the-named-NOTE-TO-REVIEWERS-as-merge-defense** — first-explicit-observation as a tier-3 meta-pattern. The mechanism: if a developer accidentally commits an uncommented insecure option, the code reviewer reads the embedded NOTE and catches the accident. The defense is *embedded in the source*, not in tooling.

Compare to cycle 333 @endo/common's §the-named-discipline-with-named-exception (honesty about scope); cycle 337's §the-named-isFake-deprecated-with-named-regret (honest regret); cycle 342's NOTE TO REVIEWERS is a third shape of honesty-in-source. **§four-shapes-of-source-level-honesty** (322 warning-thrice + 326 deprecation-with-redirect + 337 deprecated-with-named-regret + 342 NOTE-TO-REVIEWERS-as-merge-defense). First-explicit-observation as a tier-3 meta-pattern.

## §the-named-imperative-comment-block-as-design-document

Lines 16-49 are a 34-line comment block that's effectively the **design rationale** for the LOCKDOWN_OPTIONS feature. The block names:

1. **The need**: production code uses `import '@endo/init';` for side-effect initialization
2. **The problem**: testing needs different options; explicit parameter passing is awkward during initialization
3. **The discipline-violation**: *"`init` violates normal ocap discipline by feature testing global state"*
4. **The honest confession**: *"Initialization is often awkward."*
5. **The mechanism**: feature-test for `LOCKDOWN_OPTIONS` global, then env var; if present, parse as JSON options bag

**§the-named-imperative-comment-block-as-design-document** — first-explicit-observation as a tier-3 meta-pattern. The 34-line comment IS the design document for this feature; the actual implementation that follows is the realization of the comment's narrative.

**§the-named-init-violates-normal-ocap-discipline-honest-comment** — first-explicit-observation. The package explicitly NAMES that it violates ocap discipline: *"This is something that a module can but normally should not do"*. The honesty is at the SOURCE-LEVEL (in the JS file), not just at the README-level.

**§the-named-Initialization-is-often-awkward** — first-explicit-observation as a tier-3 meta-pattern. The one-sentence design-anchor at line 36 acknowledges that initialization code is hard. **§the-named-honest-confession-in-prose-comment** — already noted in cycle 183; cycle 342 reaffirms with the specific sentence as the canonical anchor.

**§three-cycles-with-named-honest-confession-in-prose-comment** (183 + 337 deprecated-with-named-regret + 342 init-violates-ocap-discipline) — the discipline crosses three pivot cycles.

## §the-named-Start-Compartment-canonical-naming

Lines 167-174:

```js
// We are now in the "Start Compartment". Our global has all the same
// powerful things it had before, but the primordials have changed to make
// them safe to use in the arguments of API calls we make into more limited
// compartments

// 'Compartment', 'assert', and 'harden' are now present in our global scope.
postLockdown();
```

**§the-named-Start-Compartment-canonical-naming** — first-explicit-observation. The post-lockdown state is *named* explicitly as the "Start Compartment". This is a key concept in the SES architecture; cycle 342 reveals where the canonical naming lives.

**§the-named-three-names-installed-after-lockdown** — first-explicit-observation. After lockdown, three names are *globally available*: `Compartment` + `assert` + `harden`. The comment names them explicitly. These are the **canonical post-lockdown surface**.

**§the-named-canonical-comment-after-lockdown-names-the-surface** — first-explicit-observation as a tier-3 meta-pattern. The comment ANNOTATES the state transition; the reader knows what's available post-call.

**§the-named-postLockdown-as-second-phase** — first-explicit-observation. The function call `postLockdown()` at line 174 runs the second phase of the two-phase init. Cycle 183 named §two-phase-init-with-tolerance-ladder; cycle 342 reveals the specific second-phase call site.

## §the-named-export-star-for-types-from-source-package

Line 8: `export * from 'ses';`

**§the-named-export-star-for-types-from-source-package** — first-explicit-observation as a tier-3 meta-pattern. The `export *` re-exports SES's type definitions through the @endo/lockdown package. Consumers importing from `@endo/lockdown` get BOTH:
- The runtime side effects of loading lockdown (the import-for-side-effects)
- The type definitions from SES (the export-star)

**§the-named-types-pass-through-via-export-star** — first-explicit-observation. The discipline: a wrapper package can pass through the wrapped package's types via `export *`. The wrapper hides the implementation-level coupling but preserves the type-level interface.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 341 (@endo/lockdown README) | 1 cycle | Adjacent forward pair; same-package README→source |
| **Cycle 183 (init+lockdown 12-file cluster comment-fragment)** | **159 cycles** | **Sixth complementary-lens re-ingest** |
| Cycle 187 (promise-kit/shim cluster) | 155 cycles | Shim-stack coordinates with lockdown |
| Cycle 167 (@endo/where/index.js named-TODO) | 175 cycles | §the-named-named-TODO sibling |
| Cycle 337 (@endo/harden README installs harden at intrinsic) | 5 cycles | Lockdown's installation is parallel to harden's |
| Cycle 338 (@endo/harden make-hardener.js feature-detection) | 4 cycles | Both use platform-detection-at-factory-time |
| Cycle 339 (@endo/errors README coordinate with ses) | 3 cycles | All three packages coordinate with SES |
| Cycle 322 (exo-makers warning-repeated-thrice) | 20 cycles | §four-shapes-of-source-level-honesty |
| Cycle 326 (deprecation-with-redirect) | 16 cycles | §four-shapes-of-source-level-honesty |

**§nine-citation-arc-closures-in-cycle-342**. **§eighty-nine-citation-arc-closures-in-pivot-now** (82 + 7 net new). **§five-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341 + 342) — first-explicit-observation. The substrate-package-introduction phase continues into its **sixth consecutive cycle**.

**§the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles** — first-explicit-observation. The trend named in cycle 341 (five-cycle phase) continues into cycle 342, now a six-cycle phase.

## Patterns the cycle extends

- §thirty-three-cycles-with-named-pivot-domain-stay (310-342)
- §sixteen-named-packages-in-the-pivot-cluster (lockdown's source after its README)
- §eighty-nine-citation-arc-closures-in-pivot-now (82 + 7 net new)
- **§six-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342) — librarian discipline confirmed across **SIX applications**
- §five-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342)
- §three-cycles-with-named-honest-confession-in-prose-comment (183 + 337 + 342)
- §four-shapes-of-source-level-honesty (322 + 326 + 337 + 342)
- §two-cycles-with-named-visibility-discipline-on-discipline-violation (337 stack + 342 console.warn)
- §the-named-streak-resumes-with-eleventh-instance (cycle 341 → 342 same-package; streak count is 1)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

- **§the-named-re-export-then-overwrite-pattern** — the substitution discipline in the substrate stack
- **§the-named-three-step-install-load-re-export-replace**
- **§the-named-substitution-discipline-in-the-substrate-stack**
- **§the-named-feature-detection-two-channel-sniff** — global OR env-var
- **§the-named-LOCKDOWN_OPTIONS-as-global-OR-env-discipline**
- **§the-named-console-warn-on-detection** — visibility discipline
- **§the-named-discipline-violation-visible**
- **§the-named-three-branch-decision-tree-with-defaults** — sniff / arg / hardcoded
- **§the-named-domainTaming-unsafe-always-injected** — across all three branches
- **§the-named-injected-default-as-platform-acknowledgment**
- **§the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications**
- **§the-named-four-commented-out-options-with-NOTE-TO-REVIEWERS**
- **§the-named-NOTE-TO-REVIEWERS-as-merge-defense**
- **§the-named-imperative-comment-block-as-design-document**
- **§the-named-init-violates-normal-ocap-discipline-honest-comment**
- **§the-named-Initialization-is-often-awkward** — one-sentence design-anchor
- **§the-named-Start-Compartment-canonical-naming**
- **§the-named-three-names-installed-after-lockdown** — Compartment + assert + harden
- **§the-named-canonical-comment-after-lockdown-names-the-surface**
- **§the-named-postLockdown-as-second-phase**
- **§the-named-export-star-for-types-from-source-package**
- **§the-named-types-pass-through-via-export-star**
- **§the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles**

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-three-cycles-with-named-pivot-domain-stay
- §sixteen-named-packages-in-the-pivot-cluster
- §eighty-nine-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332 + 336 + 342)
- §five-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342)
- §three-cycles-with-named-honest-confession-in-prose-comment (183 + 337 + 342)
- §four-shapes-of-source-level-honesty (322 + 326 + 337 + 342)
- §two-cycles-with-named-visibility-discipline-on-discipline-violation (337 + 342)
- §the-named-streak-resumes-with-eleventh-instance

## Tier-3 borrowing (meta-patterns)

- **§the-named-re-export-then-overwrite-pattern** — substitution discipline at shared global location
- **§the-named-substitution-discipline-in-the-substrate-stack** — substrate packages wrap their underlying packages by load + capture + wrap + replace
- **§the-named-discipline-violation-visible** — when a package deliberately violates ocap discipline, log it via console.warn
- **§the-named-NOTE-TO-REVIEWERS-as-merge-defense** — embed code-review hooks in source
- **§four-shapes-of-source-level-honesty** — warning-thrice + deprecation-with-redirect + deprecated-with-named-regret + NOTE-TO-REVIEWERS
- **§the-named-named-hole-with-named-mitigation** — when a hole can't be closed in this layer, name it and the mitigation in another layer
- **§the-named-imperative-comment-block-as-design-document** — long comment blocks ARE the design document
- **§the-named-Initialization-is-often-awkward** — design-anchor acknowledging init-code hardness
- **§the-named-Start-Compartment-canonical-naming** — name the canonical post-call state
- **§the-named-postLockdown-as-second-phase** — two-phase init with named transition
- **§the-named-types-pass-through-via-export-star** — wrapper packages preserve type-level interface

## Synthesis-target

Slot machine library **§`@game/lockdown/pre.js`** — substrate wrapper implementation:

1. **Re-export-then-overwrite pattern** — load source for side-effect; export-star for types; capture global; wrap; replace
2. **Two-channel feature detection** — global var OR env var (browser-friendly + Node-friendly)
3. **Console-warn on detection** — discipline-violation visible
4. **Three-branch decision tree** — sniff / arg / hardcoded
5. **Always-injected named compromise** — security setting injected across all branches with named rationale
6. **NOTE TO REVIEWERS as merge defense** — embed code-review hooks for commented-out insecure options
7. **Imperative comment block as design document** — 34-line comment narrating the WHY before the WHAT
8. **Named state-transition comments** — *"We are now in the X state. Y, Z, W are now globally available."*
9. **Two-phase init** with named second-phase function call
10. **export * from source-package** for type pass-through

## Library state after cycle 342

- §library-reaches-854-sections from 387 source documents
- §one-hundred-and-seventy-fifth consecutive designs-chat alternation
- §thirty-three-cycles-with-named-pivot-domain-stay
- §sixteen-named-packages-in-the-pivot-cluster (lockdown's source after its README; sixteenth source page in the pivot)
- §eighty-nine-citation-arc-closures-in-pivot-now (82 + 7 net new)
- **§six-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342) — librarian discipline confirmed across SIX applications
- §five-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342); §the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles
- §four-shapes-of-source-level-honesty established as tier-3 meta-pattern (322 + 326 + 337 + 342)
- §the-named-re-export-then-overwrite-pattern established as tier-3 meta-pattern
- §the-named-substitution-discipline-in-the-substrate-stack established as tier-3 meta-pattern
- §the-named-NOTE-TO-REVIEWERS-as-merge-defense established as tier-3 meta-pattern
- §the-named-Start-Compartment-canonical-naming established as tier-3 meta-pattern
- §the-named-streak-resumes-with-eleventh-instance (cycle 341 → 342 same-package; eleventh INSTANCE of one-cycle README↔source pattern)
