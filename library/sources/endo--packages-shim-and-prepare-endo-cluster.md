---
title: 'shim + prepare-endo cluster: @endo/eventual-send + @endo/promise-kit + @endo/ses-ava'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_paths:
  - packages/eventual-send/shim.js
  - packages/eventual-send/utils.js
  - packages/eventual-send/src/postponed.js
  - packages/promise-kit/shim.js
  - packages/promise-kit/index.js
  - packages/promise-kit/src/is-promise.js
  - packages/ses-ava/index.js
  - packages/ses-ava/prepare-endo.js
  - packages/ses-ava/prepare-endo-config.js
authors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
ingested: 2026-06-03
ingested_by: scholar
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
sections:
  - endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch.md
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
---

# The shim + prepare-endo cluster (Endo bootstrap continuation)

## Files

| File | Lines | Role |
|------|-------|------|
| `eventual-send/shim.js`           |  6 | Conditional HandledPromise install |
| `eventual-send/utils.js`          |  2 | Barrel: getMethodNames + makeMessageBreakpointTester |
| `eventual-send/src/postponed.js`  | 46 | Postponed handler with interlockP shared await |
| `promise-kit/shim.js`             |  4 | Unconditional Promise.race ← memoRace replacement |
| `promise-kit/index.js`            | 53 | makePromiseKit + racePromises + BestPipelinablePromise |
| `promise-kit/src/is-promise.js`   | 12 | `Promise.resolve(x) === x` realm-agnostic detection |
| `ses-ava/index.js`                |  1 | Barrel: wrapTest re-export |
| `ses-ava/prepare-endo.js`         | 27 | Three-purpose: lockdown + env + ava wrap |
| `ses-ava/prepare-endo-config.js`  |  7 | Default-export-masking via thin re-import |

## §Abstract

The shim + prepare-endo cluster contains the canonical
mechanisms that cycle 183's §shim-assembly-order (lockdown →
base64 → promise-kit → eventual-send) and the §pre-remoting.js
extension assemble for downstream consumers.

§The-key-asymmetry-named-here-for-the-first-time: §two-shim-
strategies-side-by-side. §`@endo/eventual-send/shim.js` uses
§conditional-install ("don't override existing HandledPromise");
§`@endo/promise-kit/shim.js` uses §unconditional-replacement
("Promise.race is broken; always replace with leak-free
memoRace"). §The-design-rule: §conditional-when-the-target-
may-be-correctly-installed; §unconditional-when-the-target-is-
known-broken.

§Three-additional-substantive-moves:

1. **§BestPipelinablePromise** in promise-kit/index.js =
   `globalThis.HandledPromise || Promise` — `makePromiseKit`
   automatically inherits pipelining when HandledPromise is
   installed, falls back to plain Promise otherwise.
2. **§postponedHandler-with-interlockP** in eventual-send/src/
   postponed.js — six handler traps (get / getSendOnly /
   applyFunction / applyFunctionSendOnly / applyMethod /
   applyMethodSendOnly) all share a single interlockP that
   `donePostponing()` resolves; until then every operation
   queues.
3. **§default-export-masking** in ses-ava/prepare-endo-config.js
   — seven-line file whose comment-block explains the value:
   AVA config modules can't have a default export that's
   anything other than a test; prepare-endo.js exports `test`
   as default; prepare-endo-config.js re-imports prepare-endo
   without re-exporting to strip the default.

§Additional-disciplines: `Promise.resolve(x) === x` for §realm-
agnostic-Promise-detection; `@ts-expect-error 2454` with
named issue number for §don't-suppress-blindly-name-the-
runtime-invariant; §thin-barrel-as-public-API-surface for
multiple packages (utils.js, ses-ava/index.js).

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/eventual-send/shim.js` | 6 | Conditional HandledPromise install |
| `packages/eventual-send/utils.js` | 2 | Thin barrel |
| `packages/eventual-send/src/postponed.js` | 46 | Postponed handler |
| `packages/promise-kit/shim.js` | 4 | Unconditional Promise.race replacement |
| `packages/promise-kit/index.js` | 53 | makePromiseKit + BestPipelinablePromise |
| `packages/promise-kit/src/is-promise.js` | 12 | Realm-agnostic detection |
| `packages/ses-ava/index.js` | 1 | Barrel |
| `packages/ses-ava/prepare-endo.js` | 27 | Three-purpose prepare |
| `packages/ses-ava/prepare-endo-config.js` | 7 | Default-export-masking |

## §Provenance and dependencies

- §Cycle-183-init's §shim-assembly-order names this cluster:
  `pre.js` imports lockdown + base64 + promise-kit shims;
  `pre-remoting.js` adds `@endo/eventual-send/shim.js`.
- §Built-on cycle 66 (`handled-promise.js`) — the
  HandledPromise factory.
- §Built-on cycle 173 (`promise-executor-kit.js`) —
  `makeReleasingExecutorKit` consumed by makePromiseKit.
- §Built-on cycle 152 (`memo-race.js`) — the leak-free
  Promise.race replacement.
- §Built-on cycle 90 (`track-turns.js`) — env.TRACK_TURNS
  trigger in prepare-endo.js.
- §Built-on cycle 87 (SES error/assert) — `assert` template
  used in postponed.js with `@ts-expect-error`.

## §Related sources in the library

- §Cycle 183 (`endo--packages-init-and-lockdown.md`) — §parent-
  shim-assembly. This cluster is what cycle 183's §pre-
  remoting.js + §pre.js import chain installs.
- §Cycle 181 (`endo--packages-base64-src-encode-decode-js.md`)
  — §sibling-shim. base64's `shim.js` installs atob/btoa
  globals; this cluster installs HandledPromise/Promise.race/
  ses-ava test wrapper.
- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  §singleton-install-discipline sibling. cycle 175 pins on
  first install (configurable:false); cycle 187 eventual-send
  yields to prior installer.
- §Cycle 173 (`endo--packages-promise-kit-src-promise-
  executor-kit-js.md`) — §releasing-executor-kit-consumer.
  makePromiseKit's executor comes from cycle 173.
- §Cycle 152 (`endo--packages-promise-kit-src-memo-race-js.md`)
  — §the-leak-free-race that promise-kit/shim.js installs
  unconditionally.
- §Cycle 90 (`endo--packages-eventual-send-src-track-turns-
  js.md`) — §track-turns-debug-output triggered by prepare-
  endo.js' env-setting.
- §Cycle 66 (`endo--packages-eventual-send-src-handled-
  promise-js--handler-protocol.md`) — §HandledPromise-factory
  that eventual-send/shim.js installs.
- §Cycle 186 (`endo-but-for-bots--llm-designs-break-dev-
  dependency-cycles.md`) — §the-SCC-member-cluster.
  eventual-send + promise-kit + ses-ava are all in the
  13-package SCC; this cluster is what the design's Cut 1 and
  Cut 5 target.

## §Comment fragments worth preserving

```
// Unconditionally replace with a non-leaking version
```

§Four-word-justification for §unconditional-replacement.
§Compare-to-cycle-181-base64's-§don't-over-validate-by-default-
with-RFC-citation — both are §brief-rationale-in-source.

```
if (typeof globalThis.HandledPromise === 'undefined') {
  globalThis.HandledPromise = makeHandledPromise();
}
```

§Six-line-conditional-install. §Inverted-discipline from the
sibling promise-kit shim. §The-§asymmetry-is-load-bearing.

```
// NB: Another implementation for Promise.race would be to use
// the releasing executor.  However while it would no longer
// leak the raced promise objects themselves, it would still
// leak reactions on the non-resolved promises contending for
// the race.
```

§Considered-and-rejected discipline. §Sibling to cycle 186's
§"illusion of an option" — §named-alternative-with-named-
reason-for-rejection.

```
// This module is a variation on "@ses-ava/prepare-endo.js" that
// is suitable for use in an AVA config's "require" array.
// AVA config modules are expected to either *not* export a `default`,
// or to export a test if they do.
// The default export of "@ses-ava/prepare-endo" is the `test` function, so
// this indirection exists solely to mask out the default export.
```

§The-comment-block-is-the-value. §Seven-line-file with the
implementation being one line. §The-comment-explains-why-
this-indirection-exists.

```
// @ts-expect-error 2454
assert(donePostponing);
```

§Named-issue-number-2454. §The-runtime-invariant (Promise
executor runs synchronously) is correct; the type system can't
see it. §`@ts-expect-error`-not-`@ts-ignore` so future TS
improvements would surface as errors.

```
/** @type {PromiseConstructor} */
const BestPipelinablePromise = globalThis.HandledPromise || Promise;
```

§Pick-the-better-Promise-at-module-load. §The-naming says it
all: the §best-pipelinable-Promise.
