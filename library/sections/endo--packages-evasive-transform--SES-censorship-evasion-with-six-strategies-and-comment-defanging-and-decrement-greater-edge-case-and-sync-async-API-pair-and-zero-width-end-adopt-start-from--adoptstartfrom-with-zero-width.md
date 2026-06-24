---
title: §`adoptStartFrom`-with-zero-width-end + §JSON-roundtrip-to-sever-references
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

```js
const adoptStartFrom = (target, src) => {
  try {
    const srcLoc = src.loc;
    if (!srcLoc) return;
    const loc = JSON.parse(JSON.stringify(srcLoc));
    const start = loc?.start;
    target.loc = loc;
    if (start) target.loc.end = { ...start };  // zero-width end
  } catch (_err) {
    // Ignore errors; this is purely opportunistic.
  }
};
```

§Two-honest-design-moves:

1. §JSON-roundtrip-to-sever-references — `JSON.parse(JSON.stringify(srcLoc))` is the canonical deep-clone for serializable data. §Sibling-pattern to cycle 203 cache-map's §deepCopyJsonable + freezingReviver — same JSON-roundtrip-as-deep-clone pattern.
2. §Zero-width-end — the new (shorter) AST node §appears-zero-width by setting end=start. §Honest-comment names §why:

> Text of the new node is likely shorter than text of the old (e.g., "import(<url>)" -> "im"), and in such cases we don't ever want rendering of the new node to claim too much real estate so we future-proof by making it appear to be zero-width and trusting in recovery of the actual location immediately afterwards.

§Trusting-in-recovery-of-the-actual-location — §the-Babel-source-map-generator will recover the true span via §the-following-AST-nodes. §This-is-an-honest-disclosure-of-the-trick.

§Try/catch-purely-opportunistic — the entire function is wrapped in try/catch. §If-anything-fails, §ignore-it; the transform proceeds without the location adoption. §Failure-mode-is-soft: §source-maps-might-be-imperfect-but-the-code-still-works.

§Borrowable-pattern: §JSON-roundtrip-to-sever-references + §zero-width-end + §try/catch-purely-opportunistic as §three-disciplines-for-AST-location-adoption.
