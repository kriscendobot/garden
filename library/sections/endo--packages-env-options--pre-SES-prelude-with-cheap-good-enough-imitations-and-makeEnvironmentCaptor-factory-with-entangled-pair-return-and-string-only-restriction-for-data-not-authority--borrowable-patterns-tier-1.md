---
title: §Borrowable patterns (tier-1)
source: endo packages/env-options/{src/env-options.js,README.md,index.js}
source-slug: endo--packages-env-options
ingest-cycle: 207
ingest-date: 2026-06-06
lane: chat
authors: [Endo contributors]
related:
  - endo--packages-init-and-lockdown (cycle 183: SES bootstrap that env-options serves; ses lockdown reads environment via makeEnvironmentCaptor)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling; env-options also avoids @endo/ses-ava and any SES-dependent imports)
  - endo--packages-immutable-arraybuffer (cycle 201: §capture-before-scuttled sibling — env-options destructures globalThis intrinsics at module load with named comment)
  - endo--packages-evasive-transform (cycle 205: §source-transform sibling — both packages serve SES bootstrap layer)
  - endo--packages-panic (cycle 197: §ponyfill-vs-shim distinction sibling; env-options is more like a shim that imitates SES utilities pre-SES)
keywords:
  - pre-SES-prelude with cheap good-enough imitations
  - named end-prelude marker (`// end prelude`)
  - cannot-depend-on-SES discipline
  - makeEnvironmentCaptor factory with entangled-pair return
  - getCapturedEnvironmentOptionNames as diagnostic surface
  - three-tier API (getEnvironmentOption / getEnvironmentOptionsList / environmentOptionsListHas)
  - optOtherValues exhaustive allowed-strings list (throws on unrecognized)
  - default-binding-via-makeEnvironmentCaptor(localThis, true) for simple-case
  - string-only-restriction-for-data-not-authority (named in README)
  - three-namespace-parameterization-frame in README (global / import / host hooks)
  - compat-note-pointing-to-existing-issue (Agoric/agoric-sdk#8096 for DEBUG colon-split)
  - test-migration-note (tests moved to @endo/ses-ava to reduce cyclic dependencies)
  - SES-Lockdown-warns-named-environment-variables (example in README)
  - localThis-aliased-globalThis with eslint-disable
  - destructure-intrinsics-at-module-load (Object/Reflect/Array/String/JSON/Error)
  - uncurryThis via Reflect.apply (different shape than cycle 199 trampoline's bind.bind.bind.call)
  - Node-process-env-precedent for option lookup
  - dropNames parameter for simple-vs-tracking-mode
  - cycle 207 chat-lane
  - twenty-second-member of small-files-with-large-knowledge-density family
  - forty-first consecutive designs/chat alternation cycle 166-207
parent: endo--packages-env-options--pre-SES-prelude-with-cheap-good-enough-imitations-and-makeEnvironmentCaptor-factory-with-entangled-pair-return-and-string-only-restriction-for-data-not-authority
---

1. **§Pre-SES-prelude-with-named-end-marker** + §cheap-good-enough-imitations + §cannot-depend-on-SES-discipline for §packages-that-load-earlier-than-SES.
2. **§Two-banner-comment-bookends** to mark §the-prelude-section visually.
3. **§Reflect.apply-form of uncurryThis** as §an-alternative to cycle 199 trampoline's §bind.bind(bind.call) — §the-Reflect.apply-form is §more-readable; both are canonical in @endo.
4. **§Locally-imitated-Fail-template-tag** for §packages-that-cannot-depend-on-@endo/errors.
5. **§Factory-with-entangled-pair-return** — `makeEnvironmentCaptor` returns four functions sharing one captured-array; §the-three-readers-record; §the-fourth-returns-a-snapshot.
6. **§Defensive-clone-on-read** — `freeze([...capturedEnvironmentOptionNames])` returns a fresh frozen snapshot on every call (sibling to cycle 203 cache-map's §metrics-via-defensive-clone-on-read).
7. **§Three-tier-API** (scalar / list / predicate) with §single-source-of-truth in scalar; list and predicate compose by call.
8. **§String-only-restriction-for-data-not-authority** as §a-named-security-invariant for §global-state-readers.
9. **§Exhaustive-allowed-strings-list-with-default-prepended-in-error** for §validated-enum-options.
10. **§Default-binding-for-simple-case** + §factory-for-advanced-case as §a-two-tier-API-shape.
11. **§dropNames-parameter** to opt out of name-tracking when not needed.
12. **§README-opens-with-conceptual-frame** naming the design space and where this package sits in it.
13. **§Compat-note-with-issue-citation** as §design-archaeology in README.
14. **§Test-migration-note** for §packages-with-tests-elsewhere-to-avoid-cycles.
15. **§localThis-aliased-globalThis** with §named-eslint-disable for §explicit-named-bindings-that-can-be-renamed-without-rippling.
16. **§Worked-example-of-canonical-consumer-pattern** in README (SES Lockdown's diagnostic warning).
