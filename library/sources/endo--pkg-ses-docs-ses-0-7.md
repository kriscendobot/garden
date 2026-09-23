---
title: "@endo/ses/docs/ses-0.7.md — Introducing SES 0.7: release-notes-style document with four-section-categories"
source-slug: endo--pkg-ses-docs-ses-0-7
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/ses-0.7.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/ses-0.7.md
total-lines: 64
ingest-cycle: 295
ingest-date: 2026-06-11
lane: designs
---

# `@endo/ses/docs/ses-0.7.md`

A 64-line release-notes-style document introducing SES 0.7. The third named genre of SES docs alongside cycle 293's guide.md (guide) and cycle 291's draft-standalone-spec.md (spec).

## Key moves

- **§the-release-notes-genre as named design-doc-shape** — `# Introducing SES 0.7` title; §three-named-ses-doc-genres (guide + spec + release-notes).
- **§the-four-section-categories** — Security + Completeness + Testing + Development; the-named-changelog-by-concern.
- **§the-named-dependency-removal-as-named-release-event-shape** — Realms shim + esm package; the-removal-IS-named-with-named-explanation-of-the-prior-problem (esm "transpiles code, alters globals, and proxies module namespaces" — §three-named-side-effects-of-the-removed-package).
- **§the-`%RegExpStringIteratorPrototype%`-and-`%FunctionPseudoConstructor%`-as-named-newly-included-intrinsics** — §the-named-canonical-spec-notation-discipline.
- **§the-named-test-frameworks-migration** — `tape` → `tap`; four named reasons (better-skipped-count + more-stable-for-large-runs + parallelization + test-suites-in-separate-realms).
- **§the-named-silent-test-drop-IS-the-named-bug-of-the-prior-tool** — the migration IS named with the named bug it fixed; §the-named-scale-dependent-bug.
- **§the-named-intrinsic-whitelist-runs-last-discipline** — §the-named-ordering-IS-the-named-correctness-property; §two-cycles-with-named-shim-ordering-disciplines (293 + 295).
- **§the-named-monorepo-discipline** — yarn workspaces + Lerna.
- **§the-`wokspaces`-as-named-preserved-typo** — §three-cycles-with-preserved-typo-as-named-evidence-of-informal-or-incomplete-status (263 + 280 + 295).
- **§the-named-type-module-discipline** — `"type": "module"` in package.json; the-removal-IS-not-just-a-deletion-IS-a-named-architectural-shift.
- **§the-named-code-quality-metrics** — Complexity ≤ 8 + Max lines per module ≤ 300; §the-tighter-than-default-threshold-IS-named-explicitly.
- **§the-named-Node.js-version-floor** — Removed support for node < 13; §the-named-LTS-window-tightening.
- **§the-named-`globalThis`-usage-migration** — Removed `Function('return this')` anti-pattern; §the-named-replacement-of-an-anti-pattern-with-a-named-standard-feature; §the-named-self-consistency-improvement.
- **§the-named-`Define global globalThis, non-writable`-eslint-rule** — §the-named-rules-IS-the-named-enforcement-mechanism.
- **§the-`Increased specific test coverage`-as-named-derived-benefit** — smaller packages → more-specific-tests.
- **§the-bulleted-list-hierarchy-as-named-document-structure** — §the-named-density-via-bullets-IS-the-named-release-notes-discipline; §the-named-scannability-IS-the-named-design.

## Section files

- [§release-notes-genre with four-section-categories + §named-changelog-by-concern + §named-dependency-removal + §preserved-typo](../sections/endo--pkg-ses-docs-ses-0-7--release-notes-genre-with-four-section-categories-and-the-named-changelog-by-concern-and-named-dependency-removal-and-typo-preserved.md) — full 64-line document in scope.

## Ingest scope

Cycle 295 (designs-lane after cycle 294 chat-lane @endo/zip/src/format-writer.js + MILESTONE 800). Full 64-line document in scope. **First-explicit-observations (forty)** at full scope covering the release-notes-genre, the four named section categories, the named-dependency-removal with named-prior-problem explanation, the named canonical spec notation (`%X%`), the named test-frameworks migration with named-prior-bug, the named whitelist-runs-last discipline, the named monorepo + type-module disciplines, the preserved typo `wokspaces`, the named code quality metrics with thresholds, the named Node.js version floor, the named `globalThis` migration with named anti-pattern replacement, the named eslint rule enforcement, and the bulleted-list-hierarchy as scannability discipline.
