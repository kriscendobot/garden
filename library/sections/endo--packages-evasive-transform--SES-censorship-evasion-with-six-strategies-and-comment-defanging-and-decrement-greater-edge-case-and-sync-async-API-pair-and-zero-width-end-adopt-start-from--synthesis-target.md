---
title: §Synthesis-target
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

Slot machine library §game-state-source-transform — if game logic is loaded from user-provided sources and needs to be safe for SES evaluation:

- §SES-censorship-evasion borrowable directly via §evadeCensor pre-evaluation.
- §customVisitor escape-hatch borrowable for §game-specific-AST-transforms (e.g., insert telemetry hooks, enforce game-specific lints).
- §elideComment-with-magic-prefix borrowable for §shrinking-game-bundles while §preserving-license-headers.

§Comment-defanging borrowable for any §source-rewriting that needs to §preserve-textual-meaning-while-breaking-lexical-patterns. §The-three-defanging-replacements pattern (`<!--` → `<!=-`, `-->` → `-=>`, `import` → `IMPORT`) is §the-canonical-shape.

§HTML-comment-in-code-edge-case (`x-->y` → `(0,x--)>y`) borrowable for any §JS-source-rewriting that needs to §preserve-decrement-greater-operator-sequences while §breaking-the-lexical-`-->`.

§adoptStartFrom-with-zero-width-end borrowable for any §AST-rewriting where §the-rewritten-node-is-shorter-than-the-source and §the-source-map-recovery-should-not-be-pessimized.

§JSON-roundtrip-to-sever-references borrowable for §deep-clone-of-AST-fragments (cycle 205 names it; cycle 203 cache-map names it; cycle 199 names neither but uses similar JSON-as-clone-substrate).

§Sync-and-async-API-pair borrowable for §APIs-that-might-be-called-from-both-sync-and-async-contexts.

§Inline-typedef-deprecation-marker borrowable as §a-zero-friction-deprecation-signal for §vestigial-options.
