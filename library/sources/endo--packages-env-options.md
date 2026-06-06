---
title: "@endo/env-options — parameterizing modules via environment variables (pre-SES)"
source-slug: endo--packages-env-options
url: https://github.com/endojs/endo/tree/master/packages/env-options
authors: [Endo contributors]
repo: endojs/endo
path:
  - packages/env-options/src/env-options.js
  - packages/env-options/README.md
  - packages/env-options/index.js
total-lines: 149 source + 116 README + 1 index.js re-export
license: Apache-2.0
ingest-cycle: 207
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/env-options

A §pre-SES utility for reading Unix-style environment variables (Node `globalThis.process.env`) with §a-three-tier-API (scalar / list / predicate) and §optional-name-tracking for §diagnostic-purposes (used by SES Lockdown to report which environment variables were actually read).

## Key design moves

- **§Pre-SES-prelude with §named-end-marker** — `@endo/env-options` must be imported quite early and cannot depend on SES; the prelude section is bookended by `// /////` banner comments and `// end prelude`, containing §cheap-good-enough-imitations of `uncurryThis` + `freeze` + `q` (JSON.stringify) + `Fail` template tag.
- **§Reflect.apply form of uncurryThis** — `const uncurryThis = fn => (receiver, ...args) => apply(fn, receiver, args)` — readable alternative to cycle 199 trampoline's `bind.bind(bind.call)` form.
- **§Locally-imitated Fail template tag** — env-options cannot import from `@endo/errors`, so it imitates Fail locally with explicit message construction + `throw Error(msg)`.
- **§Six intrinsics destructured at module load**: Object + Reflect + Array + String + JSON + Error.
- **§localThis aliased globalThis** with `// eslint-disable-next-line no-restricted-globals` — §explicit-named-binding-that-can-be-renamed-without-rippling.
- **§makeEnvironmentCaptor factory** returns §an-entangled-pair (four functions sharing an internal captured-array):
  - `getEnvironmentOption(name, default, [optOtherValues])` — scalar; optional exhaustive allowed-strings list.
  - `getEnvironmentOptionsList(name)` — comma-separated list via `stringSplit(option, ',')`.
  - `environmentOptionsListHas(name, element)` — predicate.
  - `getCapturedEnvironmentOptionNames()` — fresh frozen snapshot of names that have been read.
- **§Defensive-clone-on-read** — `freeze([...capturedEnvironmentOptionNames])` (sibling to cycle 203 cache-map's metrics).
- **§Three-tier-API** (scalar / list / predicate) with §single-source-of-truth in the scalar (list and predicate compose by call).
- **§String-only-restriction-for-data-not-authority** as §a-named-security-invariant — environment values must be strings; the channel must not carry authority.
- **§Exhaustive-allowed-strings-list-with-default-prepended-in-error** — throws on unrecognized value with message listing `[defaultSetting, ...optOtherValues]`.
- **§Default-binding-for-simple-case** + §factory-for-advanced-case — the simple case (`globalThis` + dropNames=true) gets a default binding at module load; advanced callers reach for `makeEnvironmentCaptor`.
- **§dropNames-parameter** to opt out of name-tracking overhead when not needed.

## README — three-namespace-parameterization-frame

> A pleasant parameterization would be for a static module to be function-like with explicit parameters [...] Compartments instead lets us parameterize the meaning of a module instance derived from a static module according to the three namespaces provided by the JavaScript semantics:
>   * The global variable namespaces.
>   * The import namespace.
>   * The host hooks.

§env-options is §the-host-hooks parameterization (reading `process.env`).

## README — worked example of canonical consumer pattern

```js
import { makeEnvironmentCaptor } from '@endo/env-options';
const { getEnvironmentOption, getCapturedEnvironmentOptionNames } = makeEnvironmentCaptor(globalThis);
// ...
const capturedEnvironmentOptionNames = getCapturedEnvironmentOptionNames();
if (capturedEnvironmentOptionNames.length > 0) {
  console.warn(`SES Lockdown using options from environment variables ${enJoin(arrayMap(capturedEnvironmentOptionNames, q), 'and')}`);
}
```

§SES-Lockdown-warns-named-environment-variables — §diagnostic-discipline-made-visible-to-humans.

## Test migration note

> To reduce cyclic dependencies, the tests of this module have been moved to @endo/ses-ava. Doing `yarn test` here currently does nothing.

§Honest-acknowledgement of §test-migration-to-break-cycles. Sibling to cycle 186 break-dev-dependency-cycles design.

## Ingest scope

Cycle 207 (chat-lane): full ingest of source + README + index.js. One section.

## Related material in the library

- **cycle 183 endo--packages-init-and-lockdown**: SES bootstrap that env-options serves; ses lockdown reads environment via makeEnvironmentCaptor.
- **cycle 199 endo--packages-trampoline-memoize-nat-trio**: §minimal-dependency-discipline sibling — env-options follows similar discipline (can't depend on SES; locally imitates utilities).
- **cycle 201 endo--packages-immutable-arraybuffer**: §capture-before-scuttled sibling — env-options destructures globalThis intrinsics at module load.
- **cycle 197 endo--packages-panic**: §ponyfill-vs-shim distinction sibling — env-options is more like a §shim of SES utilities (imitates pre-SES).
- **cycle 205 endo--packages-evasive-transform**: §source-transform sibling — both packages serve SES bootstrap layer.
- **cycle 186 break-dev-dependency-cycles**: §sink-only-synthetic-test-packages design — env-options's tests-moved-to-@endo/ses-ava is sibling pattern.
- **cycle 181 endo--packages-base64**: §Reflect.apply-captured-at-module-load sibling — both packages capture intrinsics early.
- **cycle 203 endo--packages-cache-map**: §metrics-via-defensive-clone-on-read sibling — both packages return fresh frozen snapshots.
- **cycle 196 endoclaw**: §object-capability-vs-ambient-authority distinction sibling — env-options's §string-only-restriction-for-data-not-authority is the same principle at a different layer.
