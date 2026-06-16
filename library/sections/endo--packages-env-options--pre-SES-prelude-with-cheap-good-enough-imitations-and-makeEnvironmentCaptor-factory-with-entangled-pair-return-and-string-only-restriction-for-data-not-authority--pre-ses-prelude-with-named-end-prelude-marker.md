---
title: §Pre-SES-prelude with §named-end-prelude-marker
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

```js
// `@endo/env-options` needs to be imported quite early, and so should
// avoid importing from ses or anything that depends on ses.

// /////////////////////////////////////////////////////////////////////////////
// Prelude of cheap good - enough imitations of things we'd use or
// do differently if we could depend on ses

const localThis = globalThis;
const { Object, Reflect, Array, String, JSON, Error } = localThis;
const { freeze } = Object;
const { apply } = Reflect;

const uncurryThis =
  fn =>
  (receiver, ...args) =>
    apply(fn, receiver, args);
const arrayPush = uncurryThis(Array.prototype.push);
const arrayIncludes = uncurryThis(Array.prototype.includes);
const stringSplit = uncurryThis(String.prototype.split);

const q = JSON.stringify;

const Fail = (literals, ...args) => {
  let msg = literals[0];
  for (let i = 0; i < args.length; i += 1) {
    msg = `${msg}${args[i]}${literals[i + 1]}`;
  }
  throw Error(msg);
};

// end prelude
// /////////////////////////////////////////////////////////////////////////////
```

§Two-banner-comments mark §the-prelude-section explicitly. §The-`// end prelude` named-marker is §a-borrowable-shape for §clearly-bounded-pre-substrate-utilities.

§Six-intrinsics-destructured at module load: §Object + §Reflect + §Array + §String + §JSON + §Error. §The-eslint-disable on `localThis = globalThis` is §explicitly-named — `// eslint-disable-next-line no-restricted-globals`.

§Capture-before-scuttled at the §pre-SES layer. §Sibling-pattern to cycle 201 immutable-arraybuffer's §capture-before-scuttled (8 intrinsics with named comment) and cycle 199 trampoline's §classic-uncurry-this — but the §uncurryThis here is the §Reflect.apply shape, not the §bind.bind(bind.call) shape:

```js
// env-options uncurryThis (cycle 207):
const uncurryThis = fn => (receiver, ...args) => apply(fn, receiver, args);

// trampoline uncurryThis (cycle 199):
const uncurryThis = bind.bind(bind.call);
```

§Two-different-shapes for §the-same-name. §The-Reflect.apply-form is §more-readable; §the-bind.bind-form is §more-clever-and-performs-the-capture-in-fewer-tokens. §Both-are-canonical in @endo.

§The-`Fail`-template-tag is §a-locally-imitated-Fail (different from `@endo/errors`'s Fail). §The-comment names §"things we'd use or do differently if we could depend on ses".

§Borrowable-pattern: §pre-SES-prelude-with-named-end-marker + §cheap-good-enough-imitations + §cannot-depend-on-SES-discipline for §packages-that-load-earlier-than-SES.
