---
source_kind: source-file
source_repo: endojs/endo
source_path: packages/harden/make-hardener.js
source_line_range: 1-471
file_commit: 11d260c86f250a782403a9a28b7a9f9034abf5ad
file_commit_date: 2026-02-24
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 338 chat-lane ingest. 471-line canonical implementation
  of `harden()` — adjacent forward pair with cycle 337 designs-
  lane @endo/harden README. **Ninth INSTANCE** of one-cycle
  README↔source pattern; §the-named-streak-resumes-with-ninth-
  instance (streak count is 1 because cycle 336 → 337 was
  cross-package). Twenty-ninth consecutive non-garden source
  after the pivot (310-338).

  Single most structurally interesting move: §the-named-three-
  phase-traversal-with-named-commit-after-all-frozen — the
  `harden(root)` function has three separable phases: (1)
  ENQUEUE walks reachable graph adding unfrozen objects to
  toFreeze Set; (2) DEQUEUE freezes each enqueued value (may
  throw); (3) COMMIT marks each frozen value as hardened (pure
  WeakSet adds, cannot throw). §the-named-mark-hardened-only-
  after-all-frozen-discipline — if traversal fails mid-flight,
  partially-frozen objects are NOT marked as hardened, so harden
  can be re-attempted. §the-named-transactional-harden-
  discipline (all-or-nothing). §four-shapes-of-atomic-transition-
  discipline (152 single-record + 322 state-seal + 336 assign-
  then-freeze + 338 three-phase-over-graph).

  Other key first-explicit-observations: §the-named-multi-
  generation-derivation-chain-named-in-the-header (four-stage
  attribution: Google Caja 2011 → TC39 frozen-realms → SES →
  @endo); §two-shapes-of-attribution-discipline (cycle 336
  verbatim-preserved-dedication + cycle 338 multi-generation-
  chain); §the-named-FERAL-prefix-naming-convention (FERAL_ERROR,
  FERAL_STACK_GETTER, FERAL_STACK_SETTER mark values with excess
  authority); §the-named-FERAL-binding-with-four-part-
  justification (safe-use + unsafe-exposure + platform + capability);
  §the-named-V8-error-own-stack-accessor-repair (70-line
  platform-specific repair); §the-named-platform-specific-repair-
  with-named-error-code (SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR);
  §the-named-error-code-as-stable-URL-anchor; §three-shapes-of-
  stable-pointer-discipline (326 deprecation + 336 issue-link
  + 338 error-code-Markdown); §the-named-platform-detection-at-
  factory-time-not-per-call (freezeAndTraverse is ONE OF TWO
  closures defined at factory time; no per-call branch on
  platforms without the V8 bug); §three-cycles-with-named-pay-
  only-when-necessary-discipline (332 + 334 + 338); §the-named-
  acknowledged-and-bounded-hazard (calls FERAL_STACK_GETTER
  during harden; "we're only calling the problematic getter
  whose hazards we think we understand"); §three-shapes-of-
  hazard-acknowledgment (156 + 322 + 338); §the-named-triple-
  duplication-with-named-layering-constraint (isPrimitive in
  THREE packages: @endo/harden, @endo/pass-style, and ses; cycle
  336 named TWO; cycle 338 reveals it's THREE); §the-named-
  bulk-destructure-of-globalThis (ten intrinsics at module
  load); §five-cycles-with-named-pre-lockdown-intrinsic-capture
  (314 + 318 + 332 + 334 + 338); §the-named-Safari-bug-
  workaround-with-named-tracking-URL; §the-named-forward-vs-
  backward-pointer-discipline (deprecation forward; bug-
  workaround backward); §the-named-Please-report-language
  (error message asks caller to report bug); §the-named-link-
  rot-acknowledgment-with-archive-URL (web.archive.org fallback
  for dead canonical URL); §the-named-named-lint-rule-with-
  canonical-exception (@endo/no-polymorphic-call rule + disable-
  comment as discipline-marker); §the-named-hasOwn-shim-with-
  named-issue-link (feature-detect + shim); §the-named-shim-
  explicitly-names-spec-divergence; §the-named-freezeTypedArray-
  with-tc39-spec-citation (TypedArrays as integer-indexed exotic
  objects; tc39 URL as rationale); §the-named-conceptual-
  analogy-to-justify-exception (TypedArray data "analogous to
  the data of a hardened Map or Set"); §the-named-platform-bug-
  defended-against-with-per-item-fallback (GraalJS
  getOwnPropertyDescriptor returns undefined for existing
  property); §the-named-substrate-of-substrates-zero-endo-
  imports (the canonical harden file depends on NO other @endo
  package); §the-named-dependency-import-count-tracks-package-
  tier (zero @endo imports = bottom of stack); §the-named-
  traversePrototypes-as-named-option; §the-named-named-option-
  vs-positional-arg-discipline; §the-named-canonical-Endo-
  idiom-named-function-via-object-destructure (method-syntax +
  object-destructure + named-binding; three-cycle confirmed:
  152 + 336 + 338).

  Closes nine citation arcs: cycle 337 = 1 cycle (adjacent
  forward pair) + cycle 87 = 251 cycles (V8 stack accessor;
  second-longest pivot arc after the 261-cycle record) + cycle
  152 = 186 cycles (canonical Endo idiom) + cycle 142 = 196
  cycles (isPrimitive triple-duplication) + cycle 175 = 163
  cycles (make-selector sibling) + cycle 211 = 127 cycles
  (@endo/common harden in dependency-ceiling) + cycle 156 = 182
  cycles (three-shapes-of-hazard) + cycle 322 = 16 cycles
  (cross-package canonical-idiom) + cycle 336 = 2 cycles
  (isPrimitive observation extended from TWO to THREE packages).
  Pushes citation-arc-closures-in-pivot to SIXTY-TWO (56 + 6
  net new).
---

> Abstract: 471-line canonical implementation of `harden()` —
> the third tier of HardenedJS's defense (per cycle 337's
> README). The file is the **substrate-of-substrates**: zero
> @endo imports; depends only on globalThis and the implicit
> Apache-2.0 license header.
>
> **Single most structurally interesting move**: §the-named-
> three-phase-traversal-with-named-commit-after-all-frozen —
> enqueue + dequeue + commit; the commit phase comes AFTER
> all freezes complete, so partial failures don't mark as
> hardened. §the-named-transactional-harden-discipline.
> §four-shapes-of-atomic-transition-discipline (152 single-
> record + 322 state-seal + 336 assign-then-freeze + 338
> three-phase-over-graph).
>
> §the-named-multi-generation-derivation-chain-named-in-the-
> header — four-stage attribution: Google Caja 2011 → TC39
> frozen-realms → SES → @endo. §two-shapes-of-attribution-
> discipline (verbatim-dedication 336 + multi-generation-chain
> 338).
>
> §the-named-FERAL-prefix-naming-convention — FERAL_ERROR,
> FERAL_STACK_GETTER, FERAL_STACK_SETTER mark values with
> excess authority; §the-named-FERAL-binding-with-four-part-
> justification (safe-use + unsafe-exposure + platform +
> capability).
>
> §the-named-V8-error-own-stack-accessor-repair — 70-line
> platform-specific repair with named error code (SES_
> UNEXPECTED_ERROR_OWN_STACK_ACCESSOR). §three-shapes-of-
> stable-pointer-discipline (deprecation 326 + issue-link 336
> + error-code-Markdown 338).
>
> §the-named-platform-detection-at-factory-time-not-per-call —
> freezeAndTraverse is defined as ONE OF TWO closures at
> factory time; no per-call branch on non-V8 platforms.
> §three-cycles-with-named-pay-only-when-necessary-discipline
> (332 + 334 + 338).
>
> §the-named-acknowledged-and-bounded-hazard — comment names
> hazard AND bounded reason for accepting it AND PR discussion
> link; §three-shapes-of-hazard-acknowledgment (156 named-
> warning + 322 repeated-warning + 338 four-part-acknowledgment).
>
> §the-named-triple-duplication-with-named-layering-constraint
> — isPrimitive duplicated in THREE packages: @endo/harden +
> @endo/pass-style + ses. Cycle 336 named two-package
> duplication; cycle 338 reveals three.
>
> §the-named-Safari-bug-workaround-with-named-tracking-URL +
> §the-named-link-rot-acknowledgment-with-archive-URL + §the-
> named-named-lint-rule-with-canonical-exception (@endo/no-
> polymorphic-call rule + disable-comment as discipline-
> marker) + §the-named-freezeTypedArray-with-tc39-spec-
> citation + §the-named-conceptual-analogy-to-justify-
> exception (TypedArray data "analogous to the data of a
> hardened Map or Set") + §the-named-platform-bug-defended-
> against-with-per-item-fallback (GraalJS).
>
> §the-named-substrate-of-substrates-zero-endo-imports + §the-
> named-dependency-import-count-tracks-package-tier (zero =
> bottom of stack).
>
> §the-named-canonical-Endo-idiom-named-function-via-object-
> destructure (three-cycle confirmed: 152 + 336 + 338).
>
> Ninth INSTANCE of one-cycle README↔source pattern (cycle 337
> → 338); streak count is 1 because cycle 336 → 337 was cross-
> package. §the-named-streak-resumes-with-ninth-instance.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen](../sections/endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen.md) | hardened-javascript, harden-implementation, atomic-transition-discipline, FERAL-prefix, V8-stack-accessor, platform-specific-repair, substrate-of-substrates | current (cycle 338, chat-lane) |

471-line file. One section with dense first-explicit-observations across the three-phase algorithm + four-stage derivation chain + FERAL prefix + V8/Safari/GraalJS bug repairs + triple-duplication TODO + TC39 spec citation + canonical Endo idiom.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `11d260c86f250a782403a9a28b7a9f9034abf5ad`) via the local clone.
- Last substantive touch 2026-02-24 by Kris Kowal in commit `11d260c8`.
- Apache-2.0 license per file header (lines 4-14).
- Adapted from SES/Caja (Google Inc. 2011, Agoric 2018); attribution chain includes Google Caja's `startSES.js` and `repairES5.js`, TC39's proposal-frozen-realms `deep-freeze.js`, and SES's `src/bundle/deepFreeze.js`.
- **Twenty-ninth consecutive non-garden source after the pivot** (cycles 310-338).
- **Ninth INSTANCE of one-cycle README↔source pattern** (cycle 337 → 338 same-package; streak count is 1 because cycle 336 → 337 was cross-package).
- Cycle 338 closes **nine citation arcs** including the 251-cycle arc back to cycle 87's pass-style/error.js V8-stack-accessor observation (second-longest pivot arc after the 261-cycle record).
- §the-named-substrate-of-substrates-zero-endo-imports — the file depends on NO other @endo package.
