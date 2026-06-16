---
title: §the-named-uncurry-this-canonical-idiom
source: endo--packages-harden-make-hardener-js
url: https://github.com/endojs/endo/blob/master/packages/harden/make-hardener.js
authors: [Kris Kowal, Mark S. Miller, Google Caja contributors, Agoric contributors]
repo: endojs/endo
path: packages/harden/make-hardener.js
total-lines: 471
ingest-cycle: 338
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-harden-implementation
  - the-named-three-phase-traversal-with-named-commit-after-all-frozen
  - the-named-enqueue-dequeue-commit-algorithm
  - the-named-mark-hardened-only-after-all-frozen-discipline
  - the-named-transactional-harden-discipline
  - the-named-multi-generation-derivation-chain-named-in-the-header
  - the-named-four-stage-attribution-chain
  - the-named-FERAL-prefix-naming-convention
  - the-named-feral-error-with-named-reason
  - the-named-V8-error-own-stack-accessor-repair
  - the-named-platform-specific-repair-with-named-error-code
  - the-named-platform-detection-at-factory-time-not-per-call
  - the-named-platform-conditional-fast-path-vs-slow-path
  - the-named-acknowledged-and-bounded-hazard
  - the-named-triple-duplication-with-named-layering-constraint
  - the-named-bulk-destructure-of-globalThis
  - the-named-Safari-bug-workaround-with-named-tracking-URL
  - the-named-error-code-as-stable-URL-anchor
  - the-named-link-rot-acknowledgment-with-archive-URL
  - the-named-fallback-URL-when-canonical-dies
  - the-named-uncurry-this-canonical-idiom
  - the-named-hasOwn-shim-with-named-issue-link
  - the-named-substrate-of-substrates-zero-endo-imports
  - the-named-freezeTypedArray-with-tc39-spec-citation
  - the-named-freeze-before-traversal-defends-against-reactive-objects
  - the-named-getOwnPropertyDescriptors-defends-against-Object.prototype-poisoning
  - the-named-traversePrototypes-as-named-option
  - the-named-canonical-Endo-idiom-named-function-via-object-destructure
  - the-named-streak-resumes-with-ninth-instance
  - twenty-nine-cycles-with-named-pivot-domain-stay
  - sixty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen
---

Lines 95-108 — the canonical uncurryThis idiom:

```js
const { bind } = functionPrototype;
const uncurryThis = bind.bind(bind.call); // eslint-disable-line @endo/no-polymorphic-call
```

The comment block (98-108) cites BOTH the canonical wiki URL AND the web.archive.org URL:

> http://wiki.ecmascript.org/doku.php?id=conventions:safe_meta_programming
> which only lives at
> http://web.archive.org/web/20160805225710/...

**§the-named-link-rot-acknowledgment-with-archive-URL** — first-explicit-observation. The README ACKNOWLEDGES that the canonical URL is dead and provides the archive URL. **§the-named-fallback-URL-when-canonical-dies** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-uncurry-this-canonical-idiom** — `bind.bind(bind.call)` — the canonical pre-lockdown method-extraction technique. Sibling to cycle 334's §the-named-Function.prototype.call.bind-as-method-extraction; cycle 338's `bind.bind(bind.call)` is a third shape of uncurry-this. **§three-canonical-uncurry-shapes-now-observed** (cycle 199 + cycle 207 + cycle 211 + cycle 334 + cycle 338) — the family grows.

**§the-named-eslint-disable-no-polymorphic-call** — `// eslint-disable-line @endo/no-polymorphic-call` — the uncurry-this idiom is so canonical that there's a SPECIFIC lint rule for it (which this line deliberately disables). **§the-named-named-lint-rule-with-canonical-exception** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when a project standardizes on a canonical idiom AND a lint rule that prevents it elsewhere, the rule + disable-comment becomes a discipline-marker.
