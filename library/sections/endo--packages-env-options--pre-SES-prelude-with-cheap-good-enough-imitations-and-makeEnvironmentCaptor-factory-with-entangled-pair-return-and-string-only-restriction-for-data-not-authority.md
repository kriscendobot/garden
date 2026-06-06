---
title: §pre-SES-prelude-with-cheap-good-enough-imitations (uncurryThis + freeze + q + Fail) + §named-end-prelude-marker + §makeEnvironmentCaptor-factory with §entangled-pair-return (getEnvironmentOption + getCapturedEnvironmentOptionNames) + §string-only-restriction-for-data-not-authority + §three-tier-API (getEnvironmentOption / getEnvironmentOptionsList / environmentOptionsListHas) + §optOtherValues-exhaustive-allowed-strings-list + §default-binding-via-dropNames=true for simple-case + §README-three-namespace-parameterization-frame + §compat-note-pointing-to-existing-issue + §test-migration-note + §SES-Lockdown-warns-named-environment-variables — @endo/env-options
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
---

# @endo/env-options — §pre-SES-prelude + §makeEnvironmentCaptor + §entangled-pair-return + §string-only-restriction-for-data-not-authority

## Source

- `endo packages/env-options/src/env-options.js` — 149 lines (single module exporting `makeEnvironmentCaptor` + three default bindings)
- `endo packages/env-options/README.md` — 116 lines (with §three-namespace-parameterization-frame + worked example + test-migration-note)
- `endo packages/env-options/index.js` — 1 line (`export * from './src/env-options.js';`) — minimal re-export
- Cycle 207 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 206's designs-lane inventory-cancel-and-liveness; §forty-first consecutive designs/chat alternation cycle 166-207).

§Twenty-second-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Pre-SES-prelude with §cheap-good-enough-imitations of SES utilities — the package §must-be-imported-quite-early and §cannot-depend-on-SES-or-anything-that-depends-on-SES, so it §imitates-uncurryThis-freeze-q-Fail-locally + §makeEnvironmentCaptor-factory-with-entangled-pair-return (getEnvironmentOption + getCapturedEnvironmentOptionNames) + §string-only-restriction-for-data-not-authority + §default-binding-for-simple-case (dropNames=true on globalThis-targeted captor).

§The-load-bearing-discipline: §`@endo/env-options`-needs-to-be-imported-quite-early — earlier than SES. §So-it-cannot-depend-on-SES. §So-it-must-imitate-SES-utilities-with-cheap-good-enough-versions.

## §Pre-SES-prelude with §named-end-prelude-marker

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

## §makeEnvironmentCaptor factory with §entangled-pair-return

```js
export const makeEnvironmentCaptor = (aGlobal, dropNames = false) => {
  const capturedEnvironmentOptionNames = [];
  // ... three methods ...
  const getCapturedEnvironmentOptionNames = () => {
    return freeze([...capturedEnvironmentOptionNames]);
  };
  return freeze({
    getEnvironmentOption,
    getEnvironmentOptionsList,
    environmentOptionsListHas,
    getCapturedEnvironmentOptionNames,
  });
};
freeze(makeEnvironmentCaptor);
```

§The-factory-returns-a-bag-of-four-functions sharing a §captured-array-`capturedEnvironmentOptionNames`. §The-entanglement: §the-three-option-readers-record-into-the-array; §getCapturedEnvironmentOptionNames-returns-a-frozen-snapshot.

§A-fresh-snapshot-on-every-call via `freeze([...capturedEnvironmentOptionNames])` — §defensive-clone-on-read. §Sibling-pattern to cycle 203 cache-map's §metrics-via-deepCopyJsonable-with-freezingReviver (same §defensive-clone-on-read discipline, different implementation).

§Borrowable-pattern: §factory-with-entangled-pair-return where §the-pair-shares-internal-state-not-visible-from-outside.

## §Three-tier API

```js
const FooBarOption = getEnvironmentOption('FOO_BAR', 'absent');
const ENABLED = getEnvironmentOption('TRACK_TURNS', 'disabled', ['enabled']) === 'enabled';
const DEBUG_VALUES = getEnvironmentOptionsList('DEBUG');
const DEBUG_AGORIC = environmentOptionsListHas('DEBUG', 'agoric');
```

Three-method API plus the entangled fourth (capture-names):

1. **§getEnvironmentOption(name, default, [optOtherValues])** — single-string option with optional exhaustive allowed-strings list (throws on unrecognized values not in default + optOtherValues).
2. **§getEnvironmentOptionsList(name)** — comma-separated list parsed via `stringSplit(option, ',')` (empty string returns empty array).
3. **§environmentOptionsListHas(name, element)** — predicate over the list (uses arrayIncludes).
4. **§getCapturedEnvironmentOptionNames()** — fresh-frozen-snapshot of captured-names array.

§Three-shapes-for-three-use-cases: scalar / list / predicate. §The-list-and-predicate-shape sit on top of the scalar (compose by call).

§Borrowable-pattern: §three-tier-API (scalar / list / predicate) for §config-or-environment-option-readers with §single-source-of-truth (scalar implementation).

## §String-only-restriction-for-data-not-authority

```js
typeof optionValue === 'string' ||
  Fail`Environment option named ${q(optionName)}, if present, must have a corresponding string value, got ${q(optionValue)}`;
```

The README names this as §a-security-constraint:

> In either case, reflecting Unix environment variable expectations, the resulting setting must be a string. This restriction also helps ensure that this channel is used only to pass data, not authority beyond the ability to read this global state.

§Strings-can't-carry-capabilities. §If-an-environment-variable-could-be-an-object, §the-environment-could-be-a-back-channel-for-authority-transfer. §The-string-only-restriction is §a-named-security-invariant.

§Borrowable-pattern: §string-only-restriction-for-data-not-authority as §a-named-security-invariant for §global-state-readers.

§Sibling-pattern to cycle 197 panic's §default-erroneous-exit + no-ambient-normal-exit asymmetry (both designs §name-the-security-rationale-for-an-API-restriction) and cycle 196 endoclaw's §object-capability-vs-ambient-authority distinction.

## §optOtherValues — exhaustive allowed-strings list

```js
optOtherValues === undefined ||
  setting === defaultSetting ||
  arrayIncludes(optOtherValues, setting) ||
  Fail`Unrecognized ${q(optionName)} value ${q(setting)}. Expected one of ${q([defaultSetting, ...optOtherValues])}`;
```

§Three-condition-cascade: §(1) no `optOtherValues` provided (allow anything), §(2) value equals default (always allowed), §(3) value is in the optOtherValues list. §If-none-of-three, throw with named expected set.

§The-error-message-includes-the-default-prepended via `[defaultSetting, ...optOtherValues]` so the caller sees the §full-set-of-allowed-values not just the §named-other-values.

§Borrowable-pattern: §exhaustive-allowed-strings-list-with-default-prepended-in-error for §validated-enum-options.

## §Default-binding-via-makeEnvironmentCaptor(localThis, true) for simple case

```js
export const {
  getEnvironmentOption,
  getEnvironmentOptionsList,
  environmentOptionsListHas,
} = makeEnvironmentCaptor(localThis, true);
```

§The-simple-case (globalThis-targeted + no name tracking) gets §a-default-binding at module load. §dropNames=true skips the §arrayPush-into-capturedEnvironmentOptionNames — §no-overhead-for-callers-who-don't-want-names.

§The-three-default-exports cover §the-common-case directly. §makeEnvironmentCaptor-itself is also exported for §the-advanced-case (different global, want name-tracking).

§Borrowable-pattern: §default-binding-for-simple-case + §factory-for-advanced-case as §a-two-tier-API-shape — most callers use the simple case; advanced callers reach for the factory.

## §README — three-namespace-parameterization-frame

The README opens with §a-conceptual-frame:

> A pleasant parameterization would be for a static module to be function-like with explicit parameters [...] Compartments instead lets us parameterize the meaning of a module instance derived from a static module according to the three namespaces provided by the JavaScript semantics:
>   * The global variable namespaces.
>   * The import namespace.
>   * The host hooks.

§Three-namespaces-for-parameterization named. §env-options is §the-host-hooks parameterization (reading `process.env` from the global object).

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §three-layer-architecture (Guest / Composition / Backends) — both designs §enumerate-the-axes-of-an-abstract-design-space.

§Borrowable-pattern: §README-opens-with-conceptual-frame-naming-the-design-space + §names-where-this-package-sits-in-the-space.

## §Compat-note-pointing-to-existing-issue

```
(Compat note: https://github.com/Agoric/agoric-sdk/issues/8096 explains that
for `DEBUG` specifically, some existing uses split on colon (`':'`) rather
than comma. Once these are fixed, then these uses can be switched to use
`getEnvironmentOptionsList` or `environmentOptionsListHas`.)
```

§Honest-compat-note pointing to §a-specific-existing-issue with §a-named-resolution-path. §Borrowable-pattern: §compat-notes-with-issue-citations as §design-archaeology in README.

§Sibling-pattern to cycle 205 evasive-transform's §Babel-traverse-default-import-workaround (TODO with named future resolutions) and cycle 199 nat's §Apps-Script-bigint-literal-workaround.

## §SES Lockdown warns named environment variables — worked example

The README shows §a-canonical-consumer-pattern:

```js
import { makeEnvironmentCaptor } from '@endo/env-options';
const {
  getEnvironmentOption,
  getEnvironmentOptionsList,
  environmentOptionsListHas,
  getCapturedEnvironmentOptionNames,
} = makeEnvironmentCaptor(globalThis);
// ...
const capturedEnvironmentOptionNames = getCapturedEnvironmentOptionNames();
if (capturedEnvironmentOptionNames.length > 0) {
  console.warn(
    `SES Lockdown using options from environment variables ${enJoin(
      arrayMap(capturedEnvironmentOptionNames, q),
      'and',
    )}`,
  );
}
```

§The-purpose: §SES-lockdown reports §which-environment-variables-were-actually-read for §diagnostic-purposes. §Made-discipline-visible-to-humans (sibling to cycle 197 panic's §logs-then-terminates).

§The-`enJoin` is §an-English-list-joiner ("a, b, and c") not shown in this excerpt — §a-borrowable-utility for §human-readable-list-rendering.

## §Test-migration-note — honest acknowledgement of cyclic dependency resolution

> # Note of test migration
>
> To reduce cyclic dependencies, the tests of this module have been moved to @endo/ses-ava. Doing `yarn test` here currently does nothing.

§Honest-acknowledgement that §tests-moved-to-reduce-cyclic-dependencies. §`yarn test` here does nothing. §The-test-coverage-still-exists, just §lives-elsewhere.

§Borrowable-pattern: §test-migration-note in README for §packages-with-tests-elsewhere-to-avoid-cycles. §Sibling-pattern to cycle 186 break-dev-dependency-cycles's §sink-only-synthetic-test-packages discipline — both designs §move-test-code-to-avoid-cycles in different ways.

## §localThis aliased to globalThis

```js
// eslint-disable-next-line no-restricted-globals
const localThis = globalThis;
```

§Two-eslint-disables in the file. §The-rename `localThis = globalThis` is §the-canonical-Endo-pattern for §making-an-explicit-binding-that-can-be-renamed-without-rippling. §The-rest-of-the-module-references-`localThis`, not `globalThis`.

§Sibling-pattern to cycle 181 base64's §Reflect.apply-captured-at-module-load — both packages §use-explicit-named-bindings for §intrinsics-accessed-many-times.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §game-configuration-reader for §environment-variable-driven-tuning:

- §Three-tier-API borrowable for §game-config-readers (scalar / list / predicate).
- §String-only-restriction-for-data-not-authority borrowable directly — §game-environment-variables-must-not-be-objects.
- §Exhaustive-allowed-strings-list-with-default-prepended-in-error borrowable for §game-mode-enum-options.
- §Default-binding-for-simple-case + factory-for-advanced-case borrowable for §a-two-tier-config-reader.
- §Defensive-clone-on-read borrowable for §config-name-tracking that callers shouldn't be able to mutate.
- §Test-migration-note borrowable for §game-config-package-with-tests-in-the-game-runtime to avoid §config-depends-on-runtime-depends-on-config cycles.

## §Cycle 207 meta-observations

§The-forty-first-consecutive-designs/chat-alternation-cycle 166-207.

§Papers-lane-blocked 101+ consecutive cycles (since cycle ~106).

§Library-reaches-712-sections at cycle 207.

§Twenty-second-member of §small-files-with-large-knowledge-density family.

§Two-different-shapes-of-uncurryThis now in the library: §Reflect.apply-form (cycle 207 env-options) + §bind.bind(bind.call)-form (cycle 199 trampoline). §The-two-shapes-do-the-same-thing with §different-readability-vs-token-density-trade-offs.

§Pre-SES-prelude-pattern observed in cycle 197 panic (different shape — panic captures intrinsics at module load but doesn't isolate a §prelude-section explicitly). §Cycle-207-env-options is §the-most-explicit-named-prelude in the library at this point.

§SES-defense-family extends to ten cycles (cycle 175 + 183 + 197 + 199 + 200x2 + 201 + 203 + 205 + 207). §The-@endo-substrate is §richly-SES-aware throughout — every pre-SES package in @endo has §some-shape-of-SES-compatibility-discipline.
