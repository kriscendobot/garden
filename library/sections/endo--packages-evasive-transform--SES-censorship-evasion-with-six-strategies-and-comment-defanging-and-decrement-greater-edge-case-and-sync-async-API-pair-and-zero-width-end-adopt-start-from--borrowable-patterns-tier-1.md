---
title: §Borrowable patterns (tier-1)
source: endo packages/evasive-transform/{src/*.js,README.md}
source-slug: endo--packages-evasive-transform
ingest-cycle: 205
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: §SGML-comment-injection-defense at a different layer; both defend against HTML-comment-formation)
  - endo--packages-init-and-lockdown (cycle 183: SES bootstrap substrate that evasive-transform serves)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §sync/async-two-color-sharing-via-generator-trampoline sibling — evasive-transform's sync/async pair is the simpler shape)
  - endo--packages-cli-src-utility-cluster (cycle 195: §one-purpose-per-file sibling; evasive-transform has six source files each with named purpose)
  - endo-but-for-bots--llm-designs-hardened-url-shim (cycle 200; §two-specific-hazards-named — evasive-transform addresses §SES-censorship-hazards via §six-evasion-strategies)
  - endo--packages-immutable-arraybuffer (cycle 201: §Purposeful-Violation section sibling — evasive-transform's "*X/" end-of-comment-marker defense is §deliberate-fidelity-violation for §SES-safety)
keywords:
  - SES-censorship-evasion
  - six-evasion-strategies (evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + evadeComment/elideComment)
  - three-problematic-sequences (import\s*\( + <!-- + -->)
  - comment-defanging-with-three-patterns (<!-- → <!=-, --> → -=>, import → IMPORT)
  - homoglyphs-for-@kriskowal joke preserved in comment
  - HTML-comment-in-code edge case (`x-->y` → `(0,x--)>y`)
  - end-of-comment-marker defense (*/ → *X/) against block-comment escape
  - adoptStartFrom-with-zero-width-end (target appears shorter than source)
  - JSON-roundtrip-to-sever-references (deep-clone loc via stringify+parse)
  - try/catch-purely-opportunistic
  - sync-and-async-API-pair (evadeCensor wraps evadeCensorSync trivially)
  - three-overloads-with-JSDoc-narrowing (return type depends on sourceUrl presence)
  - Babel-traverse-default-import-workaround (babelTraverse.default || babelTraverse for node -r esm compat)
  - TaggedTemplateExpression excluded (honest-deferred-work-named)
  - customVisitor escape-hatch
  - EVADE_METHODS list (import + eval)
  - comment-preservation-via-magic-prefix (! prefix) and JSDoc tags (@preserve/@copyright/@license/@cc_on)
  - elideComment-vs-evadeComment two-mode
  - coerces-all-comments-to-CommentBlock
  - vestigial-useLocationUnmap-option marked deprecated
  - source-map-update discipline
  - meaning-preserving-transform discipline
  - one-purpose-per-file (six source files)
  - cycle 205 chat-lane
  - twenty-first-member of small-files-with-large-knowledge-density family
  - thirty-ninth consecutive designs/chat alternation cycle 166-205
parent: endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from
---

1. **§SES-censorship-evasion** as §a-named-design-purpose for §source-transforms-that-make-otherwise-rejected-code-loadable.
2. **§Six-evasion-strategies** as §a-toolkit (evadeStrings + evadeTemplates + evadeRegexpLiteral + evadeMethod + evadeDecrementGreater + evadeComment/elideComment).
3. **§Three-problematic-sequences** detected via §a-single-shared-evadeRegexp with §three-context-specific-transforms.
4. **§Comment-defanging-with-three-patterns** (`<!--` → `<!=-`, `-->` → `-=>`, `import` → `IMPORT`) + §end-of-comment-marker-defense (`*/` → `*X/`).
5. **§HTML-comment-in-code-edge-case** (`x-->y` → `(0,x--)>y`) — §SequenceExpression-wrap as §a-meaning-preserving-lexical-sequence-breaker.
6. **§adoptStartFrom-with-zero-width-end** — set target.loc.end = target.loc.start so the shorter node doesn't claim too much real estate.
7. **§JSON-roundtrip-to-sever-references** for §deep-clone-of-serializable-data (sibling to cycle 203 cache-map's §deepCopyJsonable).
8. **§Try/catch-purely-opportunistic** for §soft-failure-on-optional-operations — the transform proceeds even if location adoption fails.
9. **§Sync-and-async-API-pair** with §trivial-async-wrapper when §the-underlying-operation-is-synchronous-but-the-caller-might-want-async.
10. **§Three-overloads-with-JSDoc-narrowing** based on §presence-of-option-property — return type depends on whether sourceUrl is provided.
11. **§Babel-traverse-default-import-workaround** (`babelTraverse.default || babelTraverse`) with §named-future-resolutions for §CJS-ESM-interop.
12. **§customVisitor escape-hatch** for §library-extensibility-without-forking.
13. **§Comment-preservation-via-magic-prefix** (`!` prefix) and §JSDoc tags (`@preserve` + `@copyright` + `@license` + `@cc_on`) for §elision-with-explicit-opt-out.
14. **§elideComment-vs-evadeComment two-mode** — defang vs strip with column-stability.
15. **§Coerces-all-comments-to-CommentBlock** as §a-normalization-step that simplifies subsequent rewriting.
16. **§Honest-deferred-work-named-with-PR-discussion-citation** for §TaggedTemplateExpression-excluded.
17. **§Inline-typedef-deprecation-marker** ("deprecated, vestigial") as §a-zero-friction-deprecation-signal.
18. **§One-purpose-per-file** with §named-inter-file-dependencies — §a-layered-module-pattern-not-flat-utility-cluster.
19. **§Source-map-update-discipline** — original source map passed in, transform's mappings composed onto it.
20. **§Meaning-preserving-transform** as §the-load-bearing-discipline named in the README.
21. **§Homoglyph-joke** preserved in source comment ("(featuring homoglyphs for @kriskowal)") — §source-comments-as-affectionate-jokes for project maintainers.
