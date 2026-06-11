---
title: "@endo/ses/docs/ses-0.7.md — release-notes genre with four-section-categories (Security + Completeness + Testing + Development); the-named-changelog-by-concern; named-dependency-removal (Realms shim + esm package); preserved-typo `wokspaces`; intrinsics-whitelist-runs-last-discipline"
section-slug: endo--pkg-ses-docs-ses-0-7--release-notes-genre-with-four-section-categories-and-the-named-changelog-by-concern-and-named-dependency-removal-and-typo-preserved
source-slug: endo--pkg-ses-docs-ses-0-7
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/ses-0.7.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/ses-0.7.md
total-lines: 64
ingest-cycle: 295
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `@endo/ses/docs/ses-0.7.md` (full file)

A 64-line release-notes-style document introducing SES 0.7. Distinct from cycle 293's `guide.md` (general guide) and cycle 291's `draft-standalone-spec.md` (spec): this IS the *version-release notes* genre, naming what changed *in this version*.

## Key moves

- **§the-release-notes-genre as named design-doc-shape** (first-explicit-observation): the document IS structured as a release announcement, not a guide or spec. Title `# Introducing SES 0.7`. **§the-"Introducing"-prefix-in-the-title-as-named-genre-marker**.

§the-named-third-genre-of-ses-docs (after guide.md guide + draft-standalone-spec.md spec; cycle 295 adds release-notes). **§three-named-ses-doc-genres** (guide + spec + release-notes).

- **§the-four-section-categories** (first-explicit-observation): Security + Completeness + Testing + Development. Each IS a `###` subsection under `## Issues Resolved`. **§the-named-changelog-by-concern**: instead of organizing changes chronologically or by file, the doc organizes by *category of concern*. **§the-four-named-categories-IS-the-named-mental-organization**.

§the-category-list IS NOT exhaustive (no "Performance" or "Bugfixes" section); the doc only names the categories that had work this release.

- **§the-named-dependency-removal as named release-event-shape** (first-explicit-observation): the document names *two named removed dependencies*:
  - **Realms shim** (`https://github.com/Agoric/realms-shim`).
  - **esm package** (`https://github.com/standard-things/esm`).

**§the-removal-IS-named-with-named-explanation-of-the-prior-problem**: "esm transpiles code, alters globals, and proxies module namespaces" — names *three things* the removed package was doing that caused problems. **§three-named-side-effects-of-the-removed-package**.

§the-named-dependency-removal-IS-the-named-release-content: removing dependencies IS a *named release event* worth highlighting (security improvement, less surface area).

- **§the-`%RegExpStringIteratorPrototype%`-and-`%FunctionPseudoConstructor%`-as-named-newly-included-intrinsics** (first-explicit-observation): the doc names two specific intrinsics added to the whitelist. **§the-named-intrinsics-by-spec-name** with the `%X%` convention (which IS the JavaScript spec's notation for intrinsics).

§the-named-intrinsics-vocabulary-IS-the-spec-vocabulary: the doc uses the canonical `%InternalName%` notation rather than describing the intrinsics in prose. **§the-named-canonical-spec-notation-discipline**.

- **§the-named-test-frameworks-migration as named release-event** (first-explicit-observation): "Migrated from `tape` to `tap`". **§the-named-migration-IS-the-named-release-content**.

§four-named-reasons-for-the-migration (better-skipped-count + more-stable-for-large-runs + parallelization + test-suites-in-separate-realms). §the-named-rationale-for-the-named-migration.

- **§the-named-intrinsic-whitelist-runs-last-discipline** (first-explicit-observation):

> "Whitelist on intrinsics runs last: Detect errors in shims."

**§the-named-ordering-IS-the-named-correctness-property**: by running the whitelist *after* shims, errors introduced by shims (which add or modify intrinsics) get caught. **§the-named-shim-error-detection-via-ordering**.

§the-named-ordering-discipline IS sibling-pattern to cycle 293's §Lockdown-IS-two-phases-with-vetted-shims-between (where shims run BETWEEN phases). Here the discipline IS that *some checks run AFTER all shims* to detect shim-introduced errors. §the-named-shim-ordering-discipline-has-multiple-named-phases.

- **§the-named-monorepo-discipline as named release-event** (first-explicit-observation):

> "Monorepo: Based on yarn wokspaces + Lerna."

**§the-`wokspaces`-as-named-preserved-typo** (first-explicit-observation): the typo "wokspaces" (should be "workspaces") IS preserved in the document. **§the-preserved-typo-as-named-evidence-of-the-document's-informal-status**. Sibling-pattern to cycle 263's §preserved-typo-as-evidence-of-design-fragment's-informal-status + cycle 280's §preserved-JSDoc-typo. **§three-cycles-with-preserved-typo-as-named-evidence-of-informal-or-incomplete-status** (263 + 280 + 295).

§the-named-typo-IS-the-named-evidence-of-a-not-yet-reviewed-document: release-notes get less editorial scrutiny than guides or specs.

- **§the-named-type-module-discipline** (first-explicit-observation):

> "All packages are type module: No reliance on `esm` package... No reliance on `rollup` to create common js distribution files..."

**§the-named-`"type": "module"`-discipline**: every package's `package.json` declares `"type": "module"` (the ESM native mode). **§the-removal-IS-named-with-named-replacement-strategy**: removing the `esm` package IS replaced by the platform-native ESM support. **§the-removal-IS-not-just-a-deletion-IS-a-named-architectural-shift**.

- **§the-named-code-quality-metrics** (first-explicit-observation):

> "Code quality metrics: Lint rules (error on unused lint rules). Complexity: 8. Max lines per module: 300. etc."

**§three-named-quality-metrics-with-named-thresholds**: cyclomatic-complexity ≤ 8 + max-lines-per-module ≤ 300 + lint-rules-must-be-used. **§the-quality-IS-a-named-set-of-thresholds**. §the-`etc.`-IS-the-named-continued-list-marker.

§the-`Complexity: 8`-IS-named-cyclomatic-complexity-threshold: ESLint's `complexity` rule defaults to 20; SES sets it to 8 — substantially tighter than the default. **§the-tighter-than-default-threshold-IS-named-explicitly**.

§the-`Max lines per module: 300`-IS-named-source-file-length-threshold: ESLint's `max-lines` rule. **§the-named-strict-source-file-length-cap**.

- **§the-named-Node.js-version-floor** (first-explicit-observation):

> "Removed support for node < 13."

**§the-named-LTS-window-tightening**: declaring a minimum Node.js version IS a named release-event because it directly affects who can use the new version. **§the-removal-of-old-version-support-IS-the-named-LTS-window-tightening**.

§the-named-LTS-window-tightening-IS-distinct-from-the-named-LTS-window-watching (cycle 251 had a skill or similar named: see node-lts-window-watch). The watching IS observing; the tightening IS acting on.

- **§the-named-`globalThis` usage migration** (first-explicit-observation):

> "Make use of globalThis (removed all evaluation of 'return this')"

**§the-named-anti-pattern-removal**: SES 0.7 removed all instances of the `(new Function('return this'))()` idiom (which gets the global object via Function-constructor evaluation). The replacement IS `globalThis` (the ECMA-2020 global-object reference). **§the-named-replacement-of-an-anti-pattern-with-a-named-standard-feature**.

§the-named-prior-art-was-bad: `Function('return this')` IS dynamic-code-evaluation, which IS exactly what SES IS trying to constrain. The migration to `globalThis` IS *aligning with SES's own discipline*. **§the-named-self-consistency-improvement**.

- **§the-named-`Define global globalThis, non-writable`-eslint-rule** (first-explicit-observation): the doc names a specific ESLint rule. **§the-named-eslint-rule-IS-the-named-enforcement-mechanism** for the `globalThis` migration.

§the-named-rules-IS-the-named-enforcement: instead of relying on developer discipline, the codebase encodes the discipline in lint rules.

- **§the-named-prior-flaws-in-the-removed-test-runner** (first-explicit-observation):

> "Migrated from `tape` to `tap`: Better count of test skipped. More stable for large test runs (no tests silently dropped)."

**§the-named-silent-test-drop-IS-the-named-bug-of-the-prior-tool**: tape was *silently dropping tests* on large runs. This IS a *named correctness bug* in the prior tool, surfaced as the motivating reason for the migration. **§the-migration-IS-named-with-the-named-bug-it-fixed**.

§the-named-anti-feature: "tests silently dropped" IS the named anti-feature of `tape` at SES's scale. §the-named-scale-dependent-bug.

- **§the-`Increased specific test coverage`-as-named-derived-benefit** (first-explicit-observation):

> "More granular, smaller, single-purpose packages (better division of concerns). Increased specific test coverage."

**§the-named-derived-benefit-of-the-named-structural-change**: smaller packages → more-specific-tests. **§the-name-the-causal-link-from-structure-to-test-coverage**.

§the-named-package-granularity-discipline.

## §the-bulleted-list-hierarchy-as-named-document-structure (first-explicit-observation)

The entire document IS a deeply-nested bullet list with `###` category headers. **§the-named-bullet-list-IS-the-named-release-notes-structure**: each bullet IS a named change; sub-bullets give context or detail. **§the-named-density-via-bullets-IS-the-named-release-notes-discipline**.

§the-bulleted-list-IS-NOT-prose: the doc doesn't try to be readable narrative; it tries to be *scannable*. §the-named-scannability-IS-the-named-design.

## Patterns from prior cycles, reaffirmed

- **§the-named-naming-evolution-as-pedagogy** — cycle 293 named "SES → HardenedJS" rebranding; cycle 295 names "SES 0.6 → SES 0.7" version evolution. **§the-naming-evolution-IS-multiple-named-axes** (rebranding-vs-versioning).
- **§the-named-shim-discipline** — cycle 293's §Lockdown-IS-two-phases-with-vetted-shims-between + cycle 295's §the-intrinsic-whitelist-runs-last-discipline. **§two-cycles-with-named-shim-ordering-disciplines**.
- **§the-preserved-typo-as-named-evidence-of-informal-status** — cycle 263 + cycle 280 + cycle 295.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-release-notes-genre + §the-"Introducing"-prefix-in-the-title-as-named-genre-marker + §the-named-third-genre-of-ses-docs + §the-four-section-categories + §the-named-changelog-by-concern + §the-named-dependency-removal-as-named-release-event-shape + §the-removal-IS-named-with-named-explanation-of-the-prior-problem + §three-named-side-effects-of-the-removed-package + §the-`%RegExpStringIteratorPrototype%`-and-`%FunctionPseudoConstructor%`-as-named-newly-included-intrinsics + §the-named-canonical-spec-notation-discipline + §the-named-test-frameworks-migration + §four-named-reasons-for-the-migration + §the-named-intrinsic-whitelist-runs-last-discipline + §the-named-ordering-IS-the-named-correctness-property + §the-named-shim-error-detection-via-ordering + §the-named-monorepo-discipline + §the-`wokspaces`-as-named-preserved-typo + §the-preserved-typo-as-named-evidence-of-the-document's-informal-status + §three-cycles-with-preserved-typo-as-named-evidence-of-informal-or-incomplete-status + §the-named-type-module-discipline + §the-removal-IS-not-just-a-deletion-IS-a-named-architectural-shift + §the-named-code-quality-metrics + §three-named-quality-metrics-with-named-thresholds + §the-quality-IS-a-named-set-of-thresholds + §the-tighter-than-default-threshold-IS-named-explicitly + §the-named-Node.js-version-floor + §the-named-LTS-window-tightening + §the-named-`globalThis`-usage-migration + §the-named-replacement-of-an-anti-pattern-with-a-named-standard-feature + §the-named-self-consistency-improvement + §the-named-`Define global globalThis, non-writable`-eslint-rule + §the-named-rules-IS-the-named-enforcement + §the-named-silent-test-drop-IS-the-named-bug-of-the-prior-tool + §the-migration-IS-named-with-the-named-bug-it-fixed + §the-named-scale-dependent-bug + §the-`Increased specific test coverage`-as-named-derived-benefit + §the-named-package-granularity-discipline + §the-bulleted-list-hierarchy-as-named-document-structure + §the-named-density-via-bullets + §the-named-scannability-IS-the-named-design — all forty first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §the-naming-evolution-IS-multiple-named-axes (rebranding + versioning) + §two-cycles-with-named-shim-ordering-disciplines (293 + 295) + §the-named-shim-ordering-discipline-has-multiple-named-phases.
- **Tier 3 (multi-cycle pattern recognition)**: §three-cycles-with-preserved-typo-as-named-evidence-of-informal-or-incomplete-status (263 + 280 + 295) + §three-named-ses-doc-genres (guide 293 + spec 291 + release-notes 295).

## Synthesis target

Slot machine library `@game/replay/docs/v0.7-release-notes.md`: release-notes genre with `# Introducing GameEngine 0.7` title; four section categories (Security + Completeness + Testing + Development); named dependency removals with named prior-problems explanation; canonical spec notation for newly-supported game-event types; named test framework migration with four named reasons; named whitelist-runs-last discipline; named monorepo discipline; named type-module-only discipline (no transpilation needed); named code quality metrics with thresholds (complexity ≤ 8 + max-lines-per-module ≤ 300); named Node.js version floor; named anti-pattern migration with named replacement (e.g., `Function('return this')` → `globalThis`); named eslint rule for enforcement; bulleted-list hierarchy for scannability.

## Single most structurally interesting move

**§the-named-dependency-removal-as-named-release-event-shape** combined with **§the-removal-IS-named-with-named-explanation-of-the-prior-problem** — the release notes don't just say "we removed dependencies X and Y"; they explicitly name *what each removed dependency was doing wrong*. The `esm` package "transpiles code, alters globals, and proxies module namespaces" — three named side-effects that conflict with SES's purposes.

This generalizes to any security-tooling release notes: **the named-removal-IS-the-named-release-content**, and **the named-prior-problem-IS-the-named-justification**. Removing dependencies IS a celebrated release event in security-tooling because reducing surface area = reducing attack surface. The discipline IS to *name the problem the dependency caused*, not just *what was removed*.

§the-removal-IS-not-just-a-deletion-IS-a-named-architectural-shift — and the architectural shift IS named with its motivating problem.
