---
source_kind: source-file
source_repo: endojs/endo
source_path: packages/lockdown/pre.js
source_line_range: 1-175
file_commit: 178e25324651608fdd0888066ef2075b7efff531
file_commit_date: 2025-05-16
file_commit_author: Mark S. Miller
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 342 chat-lane ingest. 175-line pre.js — the most
  substantial of @endo/lockdown's four source files. Adjacent
  forward pair with cycle 341 designs-lane @endo/lockdown
  README. **Eleventh INSTANCE of one-cycle README↔source
  pattern** (cycle 341 → 342 same-package); §the-named-streak-
  resumes-with-eleventh-instance (streak count is 1 because
  cycle 340 → 341 was cross-package).

  **Sixth complementary-lens re-ingest** (after cycles 322 +
  324 + 330 + 332 + 336). §six-cycles-with-named-
  complementary-lens-re-ingest. Cycle 183 ingested 12 init+
  lockdown bootstrap files as a comment-fragment, naming the
  high-level patterns; cycle 342 takes the implementation-
  side view of just pre.js.

  Single most structurally interesting move: §the-named-re-
  export-then-overwrite-pattern — pre.js performs a three-
  step substitution: (1) `import 'ses'` for side-effect
  (loads SES's lockdown into globalThis); (2) `export * from
  'ses'` re-exports type definitions; (3) `const rawLockdown
  = globalThis.lockdown` captures the original; defines a
  wrapper that adds LOCKDOWN_OPTIONS feature-detection;
  `globalThis.lockdown = lockdown` REPLACES the global with
  the wrapper. §the-named-three-step-install-load-re-export-
  replace; §the-named-substitution-discipline-in-the-
  substrate-stack as a tier-3 meta-pattern — substrate
  packages wrap their underlying packages by load + capture
  + wrap + replace.

  Other key first-explicit-observations: §the-named-feature-
  detection-two-channel-sniff (LOCKDOWN_OPTIONS global OR
  process.env.LOCKDOWN_OPTIONS); §the-named-console-warn-on-
  detection; §the-named-discipline-violation-visible as
  tier-3 meta-pattern — when a package deliberately violates
  ocap discipline (using globals/env-vars instead of explicit
  parameters), make the violation VISIBLE via console.warn;
  §two-cycles-with-named-visibility-discipline-on-discipline-
  violation (337 helpful-stack + 342 console.warn). §the-
  named-three-branch-decision-tree-with-defaults (sniff /
  arg / hardcoded). §the-named-domainTaming-unsafe-always-
  injected (across all three branches; named hole with named
  mitigation: "all contract code will be run under XS to
  avoid this vulnerability"). §the-named-injected-default-
  as-platform-acknowledgment.

  §the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications
  — pre.js has FOUR NOTE TO REVIEWERS blocks (errorTaming +
  stackFiltering + overrideTaming + consoleTaming); §the-
  named-NOTE-TO-REVIEWERS-as-merge-defense as tier-3 meta-
  pattern — embed code-review hooks in source; §four-shapes-
  of-source-level-honesty (322 warning-thrice + 326
  deprecation-with-redirect + 337 deprecated-with-named-
  regret + 342 NOTE-TO-REVIEWERS-as-merge-defense).

  §the-named-imperative-comment-block-as-design-document —
  lines 16-49 form a 34-line comment block that IS the
  design rationale; §the-named-init-violates-normal-ocap-
  discipline-honest-comment; §the-named-Initialization-is-
  often-awkward as the one-sentence design-anchor; §three-
  cycles-with-named-honest-confession-in-prose-comment (183
  + 337 + 342).

  §the-named-Start-Compartment-canonical-naming — lines 167-
  170 name the post-lockdown state as the "Start
  Compartment"; §the-named-three-names-installed-after-
  lockdown (Compartment + assert + harden); §the-named-
  postLockdown-as-second-phase (line 174 calls the second
  phase). §the-named-export-star-for-types-from-source-
  package — line 8 `export * from 'ses'` re-exports SES's
  type definitions; §the-named-types-pass-through-via-
  export-star as a tier-3 meta-pattern.

  §five-cycles-with-named-substrate-package-introduction
  (337 + 339 + 340 + 341 + 342); §the-named-substrate-
  package-cluster-introduction-trend-extends-to-six-cycles —
  the trend named in cycle 341 (five-cycle phase) continues
  into cycle 342, now a six-cycle phase.

  Closes nine citation arcs: cycle 341 = 1 cycle (adjacent
  forward pair) + cycle 183 = 159 cycles (init+lockdown
  12-file cluster; sixth complementary-lens re-ingest) +
  cycle 187 = 155 cycles (shim cluster) + cycle 167 = 175
  cycles (named-TODO sibling) + cycle 337 = 5 cycles + cycle
  338 = 4 cycles + cycle 339 = 3 cycles + cycle 322 = 20
  cycles + cycle 326 = 16 cycles. Pushes citation-arc-
  closures-in-pivot to EIGHTY-NINE (82 + 7 net new).
---

> Abstract: 175-line pre.js — @endo/lockdown's main entry-
> point file. Adjacent forward pair with cycle 341 README.
> **Eleventh INSTANCE** of one-cycle README↔source pattern;
> §the-named-streak-resumes-with-eleventh-instance.
>
> **Sixth complementary-lens re-ingest** (after cycles 322 +
> 324 + 330 + 332 + 336); §six-cycles-with-named-
> complementary-lens-re-ingest. Cycle 183 ingested the 12
> init+lockdown files as comment-fragment naming high-level
> patterns; cycle 342 reveals the implementation-side via
> just pre.js.
>
> **Single most structurally interesting move**: §the-named-
> re-export-then-overwrite-pattern — three-step substitution
> (load source for side-effect + export-star for types +
> capture-wrap-replace global); §the-named-substitution-
> discipline-in-the-substrate-stack as tier-3 meta-pattern.
>
> §the-named-feature-detection-two-channel-sniff (global OR
> env-var); §the-named-console-warn-on-detection; §the-
> named-discipline-violation-visible.
>
> §the-named-three-branch-decision-tree-with-defaults +
> §the-named-domainTaming-unsafe-always-injected (named
> hole with named mitigation — XS isolation for contract
> code).
>
> §the-named-NOTE-TO-REVIEWERS-pattern-with-four-applications
> (errorTaming + stackFiltering + overrideTaming +
> consoleTaming); §the-named-NOTE-TO-REVIEWERS-as-merge-
> defense; §four-shapes-of-source-level-honesty (322 + 326
> + 337 + 342).
>
> §the-named-imperative-comment-block-as-design-document
> (34-line comment); §the-named-init-violates-normal-ocap-
> discipline-honest-comment; §the-named-Initialization-is-
> often-awkward; §three-cycles-with-named-honest-confession-
> in-prose-comment (183 + 337 + 342).
>
> §the-named-Start-Compartment-canonical-naming + §the-
> named-three-names-installed-after-lockdown (Compartment +
> assert + harden); §the-named-postLockdown-as-second-phase.
>
> §the-named-export-star-for-types-from-source-package;
> §the-named-types-pass-through-via-export-star.
>
> Closes nine citation arcs including 175-cycle arc to cycle
> 167 (named-TODO sibling) and 159-cycle arc to cycle 183
> (init+lockdown 12-file cluster; SIXTH complementary-lens
> re-ingest). §the-named-substrate-package-cluster-
> introduction-trend-extends-to-six-cycles (337-342).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [sixth-complementary-lens-re-export-then-overwrite-pattern-and-Start-Compartment-naming](../sections/endo--packages-lockdown-pre-js--sixth-complementary-lens-re-export-then-overwrite-pattern-and-Start-Compartment-naming.md) | hardened-javascript, lockdown-implementation, re-export-then-overwrite, NOTE-TO-REVIEWERS, Start-Compartment, design-document-as-comment, substrate-package-cluster | current (cycle 342, chat-lane) |

175-line file. One dense section with first-explicit-observations across re-export-then-overwrite + two-channel sniff + three-branch decision tree + four NOTE-TO-REVIEWERS applications + 34-line imperative comment + Start Compartment naming + postLockdown second-phase + types pass-through.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `178e25324651608fdd0888066ef2075b7efff531`) via the local clone.
- Last substantive touch 2025-05-16 by Mark S. Miller; prior touches by Turadg Aleahmad (2022) and Mark S. Miller (2023).
- Apache-2.0 license per package LICENSE file.
- **Thirty-third consecutive non-garden source after the pivot** (cycles 310-342).
- **Eleventh INSTANCE of one-cycle README↔source pattern** (cycle 341 → 342 same-package); §the-named-streak-resumes-with-eleventh-instance.
- **SIXTH complementary-lens re-ingest** (after cycles 322 + 324 + 330 + 332 + 336); §six-cycles-with-named-complementary-lens-re-ingest.
- §five-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342); §the-named-substrate-package-cluster-introduction-trend-extends-to-six-cycles.
- Cycle 342 closes **nine citation arcs** across the substrate-cluster + complementary-lens-of-cycle-183.
