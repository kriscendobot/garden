---
title: The cyclic-dependency disclaimer that forces assert/X/Fail to be reached via globalThis instead of imported; the meta-level-privilege framing for the module's deliberate global mutable state (the *only* exception to this module's no-observably-mutable-state norm); the two env-option gates (`TRACK_TURNS=enabled` for the feature; `DEBUG=track-turns` for verbose console logging)
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
---

## Abstract

The opening section of `packages/eventual-send/src/track-turns.js` (lines 1-31) sets two structural constraints on the module's design. **Constraint 1: assert / X / Fail cannot be imported.** *We can't import these because they're not in scope before lockdown. We also cannot currently import them because it would create a cyclic dependency, though this is more easily fixed.* The commented-out `// import { assert, X, Fail } from '@endo/errors';` plus the linked Agoric SDK issue (`agoric-sdk#9515`) record both the *technical-constraint* (not in scope before lockdown) and the *unblock-path* (the cyclic dependency *is more easily fixed*, but hasn't been). Instead, the module accesses `globalThis.assert` lazily at call time, not as a static import. **Constraint 2: the module has *deliberate* global mutable state, which is the *one* exception to this module's no-observably-mutable-state norm.** The comment block is direct: *WARNING: Global Mutable State! This state is communicated to `assert` that makes it available to the causal console, which affects the console log output. Normally we regard the ability to see console log output as a meta-level privilege analogous to the ability to debug. Aside from that, this module should not have any observably mutable state.* The three globals are: `hiddenPriorError` (the prior sending-turn's error-object), `hiddenCurrentTurn` (turn counter), `hiddenCurrentEvent` (event-within-turn counter). The module is then gated by two environment options: `TRACK_TURNS=enabled` (the *feature gate* — track-turns is *disabled by default*) and `DEBUG=track-turns` (the *verbosity gate* — when set, an additional `console.log('REJECTED at top of event loop', reason)` or `console.log('THROWN to top of event loop', err)` fires on each event-loop-top rejection or throw).

## Body

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

## Connection to the wider library

This section is the **canonical worked example of *deliberate-controlled-mutable-state-as-meta-level-privilege*** at the @endo/eventual-send level. Three threads:

1. **The cyclic-dependency-and-not-in-scope-before-lockdown disclaimer pattern.** Any module that needs to use SES-tamed errors but must load *during* lockdown carries the same hazard. The track-turns workaround (lazy `globalThis.assert` access + commented-out static imports + external-issue pointer) is the canonical mitigation.

2. **The meta-level-privilege framing for deliberate mutable state.** A module that affects only diagnostic surfaces can carry mutable state without violating capability discipline. The library can cite this section whenever a module needs to *justify* mutable state under the hardened JavaScript norm.

3. **The two-gate pattern (feature + verbosity).** Feature-enable is one gate; verbose-output is a separate orthogonal gate. Reusable for any module with optional debugging surfaces.

## Translation block (comment idiom → contemporary practice)

| Comment idiom | Contemporary practice |
| ------------- | --------------------- |
| Cyclic-dependency-not-in-scope-before-lockdown | The `globalThis.assert` lazy-access pattern; commented-out imports as documentation of intent. |
| `WARNING: Global Mutable State!` | Deliberate-controlled-mutable-state-as-meta-level-privilege disclaimer; the *hidden* prefix on the mutable bindings is the marker. |
| Meta-level-privilege framing | The hardened-JavaScript justification for diagnostic-only mutable state: never affects observable program semantics. |
| `TRACK_TURNS=enabled` feature gate | Opt-in feature default-off; the whole feature is inert when not enabled. |
| `DEBUG=track-turns` verbosity gate | Verbose console output orthogonal to feature enable. |
| External-issue pointer to Agoric SDK #9515 | The *future-work-tracked-externally* discipline; doesn't promise when, just where. |

## See also

- [[eventual-send]] (topic) — the broader eventual-send pipeline track-turns instruments.
- [[errors]] (topic) — the causal console and `assert.note` annotation system this module feeds.
- [[hardened-javascript]] (topic) — the lockdown-discipline under which this module's *not-in-scope-before-lockdown* constraint operates.
- `endo--packages-eventual-send-src-track-turns-js--closure-hoisting-and-bidirectional-error-annotation` — the next section in this source: the closure-hoisting discipline and the wrapFunction / addRejectionNote bidirectional-error-annotation construction.
- `endo--packages-eventual-send-src-track-turns-js--sending-event-causes-receiving-events-causal-model` — the third section: the trackTurns JSDoc's *each call is a sending event; each call to returned TurnStarterFn is a receiving event; sending caused receiving* causal model.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--promise-pipelining` — the eventual-send + promise-pipelining mechanism this module instruments.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch` — the `_whenBroken` / `_whenMoreResolved` machinery this module's causal annotations support.

## Common confusions

- **"Track-turns runs by default."** No — it is `disabled` by default. Set `TRACK_TURNS=enabled` to activate. The decision is *opt-in*: the performance impact of wrapped functions matters, so the default is inert.
- **"The global mutable state is a hardening violation."** It would be, *except* it affects only the causal-console diagnostic surface. The meta-level-privilege framing justifies the exception. A program cannot observe these globals from program semantics; they only show up in console output.
- **"`DEBUG=track-turns` enables track-turns."** No — it enables *verbose console output from* track-turns. `TRACK_TURNS=enabled` is what enables the feature itself. The two gates are independent.
- **"`assert.note` is a global side-effect."** It mutates an *Error object's* notes-list; the Error is the thing being thrown or rejected. The Error is going to flow up the stack anyway; annotating it is a *non-observable* operation in the sense that it doesn't affect *what happens next*; it only affects what the causal-console *displays* when the Error is eventually logged.
- **"The cyclic dependency should be fixed."** The disclaimer notes *this is more easily fixed*, but the workaround works. Fixing the cycle is *tracked externally* in `agoric-sdk#9515`. Until then, the lazy-globalThis-access pattern is correct.
- **"`getEnvironmentOption('TRACK_TURNS', 'disabled', ['enabled'])` is awkward."** The three-argument shape is the standard `@endo/env-options` pattern: option name, default value, allowed non-default values. The allowlist makes invalid values explicit; an unrecognized value (e.g. `TRACK_TURNS=foo`) yields the default rather than silently breaking.
