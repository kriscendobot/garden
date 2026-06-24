---
title: Body
source: packages/eventual-send/src/track-turns.js
source_repo: endojs/endo
source_branch: master
source_commit: 86d983a0fbd1c16089953eecabaec28e85defed5
source_date: 2025-05-12
source_authors: [Mark S. Miller]
source_lines: "1-31 (imports + cyclic-dependency disclaimer + global mutable state warning + env-option gates)"
topics: [eventual-send, errors, hardened-javascript]
status: current
notes: |
  The track-turns module is the *causal-console* instrument for the
  eventual-send pipeline: when an asynchronous-sent message is sent in
  turn `T:E` and then a later receiving turn throws or rejects, the
  diagnostic on the thrown/rejected error is annotated with the
  sending turn's address. The module is *normally inert* — it only
  activates when explicitly enabled via the `TRACK_TURNS=enabled`
  environment option. The opening comment block is unusual in
  declaring this module's *deliberate* global mutable state (`let
  hiddenPriorError`, `let hiddenCurrentTurn`, `let
  hiddenCurrentEvent`) with the *meta-level-privilege* framing:
  *normally we regard the ability to see console log output as a
  meta-level privilege analogous to the ability to debug; aside from
  that, this module should not have any observably mutable state*.
parent: endo--packages-eventual-send-src-track-turns-js--module-disclaimers-and-env-option-gates
---

### §The cyclic-dependency disclaimer

The opening four-line comment block records a structural fact:

> NOTE: We can't import these because they're not in scope before lockdown. We also cannot currently import them because it would create a cyclic dependency, though this is more easily fixed.
> ```
> // import { assert, X, Fail } from '@endo/errors';
> ```
> See also https://github.com/Agoric/agoric-sdk/issues/9515

Two distinct reasons for the workaround:

1. **Not in scope before lockdown**: track-turns is loaded *during* lockdown. The `@endo/errors` module's `assert` / `X` / `Fail` exports rely on machinery (the tamed `Error` constructor, the causal console) that doesn't exist until lockdown completes. Importing assert / X / Fail here would create a *use-before-define* hazard.

2. **Cyclic dependency**: `@endo/errors` likely depends on `@endo/eventual-send` (for promise rejection annotation), which depends on this file. The cycle is *more easily fixed* — but the fix hasn't landed.

The workaround: access `globalThis.assert` *lazily* inside the function bodies, not as a static import. The `wrapFunction` body reads `globalThis.assert.note` at call time; the `trackTurns` body reads `globalThis.assert.details` and `globalThis.assert.note`. If `globalThis.assert` doesn't exist (pre-lockdown or in an embedded environment without SES), `trackTurns` returns the input functions unchanged — see the §ENABLED-and-globalThis-guard pattern.

The §Agoric-SDK-issue-pointer is the *future-work-tracked-externally* discipline: the comment doesn't promise *when* the cyclic dependency will be fixed, but it names where the work is tracked.

### §The global-mutable-state warning + meta-level-privilege framing

The most quoted comment block in this module:

> WARNING: Global Mutable State!
> This state is communicated to `assert` that makes it available to the causal console, which affects the console log output. Normally we regard the ability to see console log output as a meta-level privilege analogous to the ability to debug. Aside from that, this module should not have any observably mutable state.

The structural reading:

- **The WARNING tag is load-bearing**: it flags this state as a *deliberate exception* to a discipline this module otherwise observes (no observably mutable state).
- **The state is communicated to assert** — three module-scoped `let` bindings (`hiddenPriorError`, `hiddenCurrentTurn`, `hiddenCurrentEvent`) read and updated by `trackTurns` and the function returned by `wrapFunction`.
- **The state affects console log output** — via `assert.note` annotations attached to thrown/rejected errors, which the causal console renders.
- **The meta-level-privilege framing** is the *justification* for the exception: seeing console log output is *already* a meta-level privilege (analogous to debugger access); a module that affects this output is operating at the *same* meta-level. So the mutable state is *not* a violation of capability discipline because it never affects observable program semantics — only the diagnostic surface.

The three module-scoped `let` bindings:

```js
let hiddenPriorError;
let hiddenCurrentTurn = 0;
let hiddenCurrentEvent = 0;
```

The `hidden` prefix is a deliberate marker: this state is *hidden* from observable program semantics. A program cannot test these values; the only way to *see* them is through the causal console's diagnostic output. The hidden- prefix mirrors the *@endo/marshal* package's `private`-prefixed slot names (which are similarly diagnostic-only).

The §meta-level-privilege framing generalizes: any module that affects *only* diagnostic surfaces can carry mutable state without violating the capability discipline, *provided* the state never leaks into observable program semantics. The track-turns module is the canonical worked example.

### §The two env-option gates

The module has *two* environment-option-controlled behaviors, both gating different aspects of the feature:

**Gate 1: `TRACK_TURNS=enabled` — the feature gate**

```js
// Track-turns is disabled by default and can be enabled by an environment
// option.
const ENABLED =
  /** @type {'disabled' | 'enabled'} */
  (getEnvironmentOption('TRACK_TURNS', 'disabled', ['enabled'])) === 'enabled';
```

The structural reading:

- **`TRACK_TURNS` is `disabled` by default**. The whole feature is opt-in.
- **The only valid enabled-value is the literal string `'enabled'`** (passed as the third argument to `getEnvironmentOption`). Other values yield the default.
- **`ENABLED` is a constant**, evaluated once at module-load time. The feature is statically on or off for the duration of the process.

When `ENABLED === false`, `trackTurns` returns the input functions unchanged — see line 94-96:

```js
if (!ENABLED || typeof globalThis === 'undefined' || !globalThis.assert) {
  return funcs;
}
```

The early-return is the *opt-in-discipline*: if the feature isn't enabled, the module is *fully inert*. No global state is mutated; no closures are wrapped; no annotations are attached. This matters because the performance impact of the wrapped functions is non-trivial (every TurnStarterFn call gets a try/catch + a few global mutations + a few error allocations).

**Gate 2: `DEBUG=track-turns` — the verbosity gate**

```js
// Turn on if you seem to be losing error logging at the top of the event loop
const VERBOSE = environmentOptionsListHas('DEBUG', 'track-turns');
```

The structural reading:

- **`DEBUG` is a *list* environment option**: it can carry multiple debug-channel names separated by some delimiter. `environmentOptionsListHas('DEBUG', 'track-turns')` returns true if `track-turns` is one of the listed channels.
- **The verbose-gate is *independent of* the feature-gate**. A developer can have `TRACK_TURNS=enabled DEBUG=track-turns` (full enable + verbose) or `TRACK_TURNS=enabled DEBUG=other-channel` (enable, but no console output from track-turns).
- **VERBOSE controls only the *additional* `console.log` calls** at the top of the event loop. The error-annotation behavior is gated by `ENABLED`, not VERBOSE.

The *Turn on if you seem to be losing error logging at the top of the event loop* hint is the diagnostic-self-description: VERBOSE is the *debug-the-debugger* affordance. If error logging at the top of the event loop is mysteriously missing, set VERBOSE to see the raw console output.

The two-gate pattern (feature-gate + verbosity-gate) is reusable: a feature can be *enabled* without being *verbose*; verbose output is a separate orthogonal concern.
