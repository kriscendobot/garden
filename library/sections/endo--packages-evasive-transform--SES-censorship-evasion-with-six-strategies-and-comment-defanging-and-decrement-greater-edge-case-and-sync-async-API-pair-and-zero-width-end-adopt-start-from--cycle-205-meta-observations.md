---
title: §Cycle 205 meta-observations
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

§The-thirty-ninth-consecutive-designs/chat-alternation-cycle 166-205.

§Papers-lane-blocked 99+ consecutive cycles (since cycle ~106).

§Library-reaches-710-sections at cycle 205.

§Twenty-first-member of §small-files-with-large-knowledge-density family.

§Library-protocol-from-cycle-200 applied: §grep-by-source-page-existence with `endo--packages-evasive-transform` full slug — §no-prior-ingest-found.

§Six-evasion-strategies as §a-systematic-toolkit is §a-new-pattern named at this cycle. §Sibling-to cycle 189 marshal-justin's §two-pass-decoder-with-mirror-control-flow at a different layer (marshal-justin defends against SGML-comment-injection-in-rendered-output; evasive-transform defends against SES-censorship-of-sources). §Both-defend-against-HTML-comment-formation.

§SES-defense-family now in the library:
- Cycle 175 harden-selector's §race-to-install-with-pin (pre-lockdown).
- Cycle 183 init+lockdown's §NOTE-TO-REVIEWERS pattern.
- Cycle 197 panic's §three-layer-dispatch-chain (impossible-state).
- Cycle 199 memoize's §contingent-safety framing.
- Cycle 200 hardened-url-shim's §two-specific-hazards-named-with-named-defense.
- Cycle 200 worker-rust-xs's §engine-level-confinement-vs-SES-shim.
- Cycle 201 immutable-arraybuffer's §Purposeful-Violation (concordance-sniff-defense).
- Cycle 203 cache-map's §capable-of-supporting-SES (assert error notes).
- Cycle 205 evasive-transform's §SES-censorship-evasion (this cycle).

§Nine-cycles addressing §SES-related-defenses-or-accommodations across §nine-different-axes. §The-@endo-substrate is §richly-SES-aware throughout.
