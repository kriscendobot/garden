---
title: §SES-censorship-evasion via §six-evasion-strategies + §comment-defanging-with-three-patterns + §HTML-comment-in-code-edge-case (`x-->y` → `(0,x--)>y`) + §adoptStartFrom-with-zero-width-end + §JSON-roundtrip-to-sever-references + §sync-and-async-API-pair + §three-overloads-with-JSDoc-narrowing + §Babel-traverse-default-import-workaround-for-node-r-esm-compat + §EVADE_METHODS-list (import + eval) + §comment-preservation-via-magic-prefix-and-jsdoc-tags + §elideComment-vs-evadeComment-two-mode + §honest-deferred-work-on-TaggedTemplateExpression + §customVisitor-escape-hatch — @endo/evasive-transform
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
kind: index
section_count: 13
---

Sections:

- [Source](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--source.md)
- [Single most structurally interesting move](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--single-most-structurally-interesting-move.md)
- [§Six evasion strategies](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--six-evasion-strategies.md)
- [§`adoptStartFrom`-with-zero-width-end + §JSON-roundtrip-to-sever-references](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--adoptstartfrom-with-zero-width.md)
- [§Sync-and-async-API-pair](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--sync-and-async-api-pair.md)
- [§Three-overloads-with-JSDoc-narrowing](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--three-overloads-with-jsdoc-narrowing.md)
- [§Babel-traverse-default-import-workaround](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--babel-traverse-default-import-workaround.md)
- [§customVisitor escape-hatch](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--customvisitor-escape-hatch.md)
- [§Six source files with §one-purpose-per-file discipline](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--six-source-files-with-one-purp.md)
- [§Vestigial useLocationUnmap option marked deprecated](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--vestigial-uselocationunmap-opt.md)
- [§Borrowable patterns (tier-1)](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--synthesis-target.md)
- [§Cycle 205 meta-observations](endo--packages-evasive-transform--SES-censorship-evasion-with-six-strategies-and-comment-defanging-and-decrement-greater-edge-case-and-sync-async-API-pair-and-zero-width-end-adopt-start-from--cycle-205-meta-observations.md)
