---
source: packages/init + packages/lockdown (entry-point files)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_path: packages/init/*.js, packages/lockdown/*.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - getting-started
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
status: current
---

# The canonical bootstrap entry taxonomy with two-phase init, tolerance ladder, sniff-LOCKDOWN_OPTIONS escape hatch, and NOTE-TO-REVIEWERS discipline

> §Chat-lane after cycle 182's designs-lane. §The-seventeenth-
> consecutive designs/chat alternation cycle (166-183). §This-
> cycle-ingests the §bootstrap-package-pair: `@endo/init` (8
> entry-point files, ~70 lines) + `@endo/lockdown` (4 entry-
> point files + post.js, ~275 lines). §Together-they-define
> how a hardened-JS program starts up.

`packages/init/` and `packages/lockdown/` form the §canonical-
bootstrap-entry-taxonomy. §The-12-entry-point-files compose a
§tolerance-ladder from default-safe through debug-tolerant to
unsafe-fast, all built on a §two-phase-init pattern (pre →
commit) that separates §shim-installation from §lockdown-
invocation.

§The-single-most-structurally-interesting-move is §two-phase-
init-with-tolerance-ladder + §sniff-LOCKDOWN_OPTIONS-as-
pragmatic-escape-hatch + §NOTE-TO-REVIEWERS-pattern. §All-three-
disciplines are §honest-confessions about the awkwardness of
initialization: the design admits the violations rather than
hiding them.

## §The-eight-init-entry-points (the tolerance ladder)

| File | Lines | What it imports | What it does |
|------|-------|-----------------|--------------|
| `index.js`           |  6 | pre-remoting + commit | **Default** — safe lockdown + HandledPromise |
| `debug.js`           |  6 | pre-remoting + commit-debug | Debug — errorTaming:unsafe, overrideTaming:min |
| `legacy.js`          | 12 | pre-remoting + manual lockdown | Loosest — overrideTaming:severe, stackFiltering:verbose, errorTaming:unsafe |
| `unsafe-fast.js`     |  8 | pre-remoting + manual lockdown | Fast — `__hardenTaming__: 'unsafe'` |
| `pre.js`             |  7 | lockdown + base64 + promise-kit shims | Generic preamble for all shims |
| `pre-remoting.js`    |  4 | pre.js + eventual-send shim | Adds @endo/far support |
| `pre-bundle-source.js` |  8 | pre.js | §DEPRECATED-with-redirect-comment |
| `debug-async-hooks.js` | 12 | node-async_hooks-patch + pre-remoting + commit-debug | Debug + Node.js async_hooks |

§The-ladder-rungs:

```
unsafe-fast (performant, unsafe)
    │
    ├─ legacy (loosest; overrideTaming severe)
    │
    ├─ debug-async-hooks (Node.js async_hooks shim + debug)
    ├─ debug (errorTaming unsafe + overrideTaming min)
    │
    └─ index (default — safe production)

  All built on:
    pre-remoting → pre → lockdown shim assembly
```

§Each-rung-is-a-named-entry-point. §Consumers-import-the-shape-
they-need: `import '@endo/init';` for production / `import
'@endo/init/debug.js';` for development / `import '@endo/init/
legacy.js';` for incremental migration.

§Compare-to-cycle-180-hex-package's §five-deployment-shapes
(developer-install / system-service / Familiar-bundled-fallback
/ public-relay / OS-packaging). §Here-the-shapes-are-import-
paths-not-configurations. §Same-discipline-different-mechanism.

## §Two-phase-init-pre→commit (the spine)

§The-§pre/commit-decomposition lives in `@endo/lockdown`:

- **`@endo/lockdown/pre.js`** (175 lines) — imports `ses`
  (which installs `globalThis.lockdown`), wraps it in a custom
  `lockdown` function that sniffs environment, and re-exports
  the wrapped function.
- **`@endo/lockdown/commit.js`** (3 lines) — re-exports
  pre.js + actually calls `lockdown()`.
- **`@endo/lockdown/commit-debug.js`** (83 lines) — same but
  with §development-friendly-tamings.

```js
// commit.js
export * from './pre.js';

lockdown();
```

§Three-lines-but-the-pattern-is-load-bearing. §The-§re-export-
then-invoke discipline lets consumers:

1. **§Import-as-side-effect-only** (`import '@endo/init';`)
   — runs lockdown as a side effect of module-load.
2. **§Import-the-function-without-running-it** (`import {
   lockdown } from '@endo/lockdown';` then call manually) —
   used by `legacy.js` and `unsafe-fast.js` for custom options.

§The-side-effect-route is the canonical production use; §the-
function-route is for entry-points that need non-default
options. §Both-paths-share-the-same-`pre.js`-substrate.

§Compare-to-cycle-181-base64's §three-tier-dispatch-with-IIFE-
bound-at-module-load: the IIFE returns a bound implementation;
here `pre.js` exports a function + commit.js invokes it. §Both-
are-§module-load-as-the-binding-moment.

## §The-LOCKDOWN_OPTIONS-sniff (the pragmatic escape hatch)

```js
let optionsString;
if (typeof LOCKDOWN_OPTIONS === 'string') {
  optionsString = LOCKDOWN_OPTIONS;
  console.warn(
    `'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`,
  );
} else if (
  typeof process === 'object' &&
  typeof process.env.LOCKDOWN_OPTIONS === 'string'
) {
  optionsString = process.env.LOCKDOWN_OPTIONS;
  console.warn(...);
}
```

§Two-source-priority: global variable first; environment
variable second. §Both-warn-via-console-when-detected — §sniffing-
is-acknowledged-not-hidden.

§The-design-justification-is-explicit (lines 35-47):

> The `init` module exists so the "main" of production code
> can start with the following import or its equivalent:
> `import '@endo/init';`
> But production code must also be tested. Normal ocap
> discipline of passing explicit arguments into the `lockdown`
> call would require an awkward structuring of start modules,
> since the `init` module calls `lockdown` during its
> initialization, before any explicit code in the start module
> gets to run.
>
> Instead, for now, `init` violates normal ocap discipline by
> feature testing global state for a passed "parameter". This
> is something that a module can but normally should not do,
> during initialization or otherwise. Initialization is often
> awkward.

§"Initialization-is-often-awkward" is the §honest-confession
disciplinary anchor. §The-design-names-the-violation-instead-of-
hiding-it.

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §revised-
scope-discussion-2026-04-15 and cycle 180-hex-package's §design-
phase-after-implementation-phase. §All-three-are-§honest-
admission-against-the-ideal-process patterns. §The-init-package
is the oldest in this family — the §awkward-initialization
violation has been documented in-source for years.

§JSON-error-handling-on-the-sniffed-value:

```js
if (typeof optionsString === 'string') {
  let options;
  try {
    options = JSON.parse(optionsString);
  } catch (err) {
    console.error('Environment variable LOCKDOWN_OPTIONS must be JSON', err);
    throw err;
  }
  if (typeof options !== 'object' || Array.isArray(options)) {
    const err = TypeError(
      'Environment variable LOCKDOWN_OPTIONS must be a JSON object',
    );
    console.error('', err, options);
    throw err;
  }
  rawLockdown({
    ...options,
    domainTaming: 'unsafe',
  });
}
```

§Three-validation-layers: JSON-parse + type-object + not-array.
§The-error-shape includes the offending value for diagnostic
purposes. §Cycle-177-netstring/reader.js' §four-pieces-of-
context-per-error sibling: §multiple-error-paths-with-named-
shape.

## §NOTE-TO-REVIEWERS-pattern (the deepest move)

§The-most-distinctive-comment-discipline in this package is the
§NOTE-TO-REVIEWERS pattern, appearing repeatedly in `commit-
debug.js` and the default-path branch of `pre.js`:

```js
// NOTE TO REVIEWERS: If you see the following line commented out,
// this may be a development accident that should be fixed before merging.
//
errorTaming: 'unsafe',
```

```js
// NOTE TO REVIEWERS: If you see the following line *not* commented out,
// this may be a development accident that MUST be fixed before merging.
//
// errorTaming: 'unsafe',
```

§The-pattern-comes-in-two-polarities:

1. **§Polarity-positive** (in `commit-debug.js`): "If you see
   the following line **commented out**, this may be a
   development accident." — the option is **expected** to be
   set.
2. **§Polarity-negative** (in `pre.js` default branch): "If you
   see the following line **not** commented out, this may be a
   development accident." — the option is expected to be
   **commented out**.

§The-two-polarities are §opposite-defaults for the same
parameter (errorTaming) in two contexts:

- `commit-debug.js` — debug mode; expects `errorTaming:
  'unsafe'` set.
- `pre.js` default — production-fallback; expects
  `errorTaming: 'unsafe'` **un**set.

§A-reviewer-can-search-for-"NOTE TO REVIEWERS" and §mechanically-
check that the polarity matches the file's purpose. §The-
comment-is-grep-friendly + §self-documenting.

§Compare-to-cycle-181-base64's §don't-over-validate-by-default-
with-RFC-citation: that comment closed the §future-contributor-
hole (a reviewer might add a check thinking it was missing
hardening). §This-comment-closes-the-§development-accident-
hole (a reviewer might miss that a debug-option was left set in
a production file).

§Both-are §code-comment-as-vocabulary-instruction patterns, but
they target different review failure modes. §The-NOTE-TO-
REVIEWERS-pattern is §belt-and-suspenders-against-merge-time-
mistakes.

§Five-options-with-NOTE-TO-REVIEWERS-pattern in `commit-debug.js`:
errorTaming + stackFiltering + overrideTaming + consoleTaming +
(implicit) one other. §Each-has-the-polarity-comment block
naming the development accident.

## §The-§domainTaming-unsafe-always-injected (the pragmatic hole)

```js
rawLockdown({
  ...options,
  domainTaming: 'unsafe',
});
```

§Whatever-options-the-user-passes (via LOCKDOWN_OPTIONS, via
`defaultOptions` argument, or via default fallback),
§`domainTaming: 'unsafe'` is always merged in last so it
overrides any user attempt to set it.

§The-prose-justification (lines 152-162):

> Domain taming causes lockdown to throw an error if the
> Node.js domain module has already been loaded, and causes
> loading the domain module to throw an error if it is pulled
> into the working set later. This is because domains may add
> domain properties to promises and other callbacks and that
> these domain objects provide a means to escape containment.
> However, our platform still depends on systems like
> standardthings/esm which ultimately pull in domains. For
> now, we are resigned to leave this hole open, knowing that
> all contract code will be run under XS to avoid this
> vulnerability.

§"For now we are resigned to leave this hole open" is the
§honest-admission discipline. §Compare-to-cycle-180-hex-
package's §boundary-sites-explicitly-named-and-defended — both
are §named-trade-off rather than §silent-default.

§The-mitigation-named: "all contract code will be run under XS
to avoid this vulnerability." §The-hole-is-pragmatic-not-
principled; it exists because of legacy dependency chains, and
the mitigation moves the vulnerability surface (contract code
under XS doesn't see the domain module).

§Compare-to-cycle-170-daemon-capability-filesystem's §defense-
in-depth-deny-patterns + §map-to-existing-substrate. §domain-
Taming-unsafe is the dual: §not-a-defense-but-an-acknowledged-
hole with a §named-mitigation-strategy.

## §post-lockdown-explicit-hardening (post.js)

```js
export default () => {
  // Even on non-v8, we tame the start compartment's Error constructor so
  // this assignment is not rejected, even if it does nothing.
  Error.stackTraceLimit = Infinity;

  harden(globalThis.TextEncoder); // Absent in eshost
  harden(globalThis.TextDecoder); // Absent in eshost
  harden(globalThis.URL); // Absent only on XSnap
  harden(globalThis.Base64); // Present only on XSnap
};
```

§Four-platform-aware-hardens. §Each-line-has-an-availability-
comment naming the §platform-matrix:

| Platform | TextEncoder | TextDecoder | URL | Base64 |
|----------|-------------|-------------|-----|--------|
| Node.js / V8 | ✓ | ✓ | ✓ | — |
| eshost | — | — | ✓ | — |
| XSnap | ✓ | ✓ | — | ✓ |

§harden-of-undefined-is-a-no-op (because typeof undefined !==
'object'); §the-four-harden-calls-are-cheap-on-missing-platforms.

§Compare-to-cycle-167-where/index.js' §per-platform-naming-
conventions (POSIX lowercase-dotted / macOS CapitalE-space /
Windows CapitalE-backslash). §Both-encode-platform-knowledge-
in-source-comments-and-conditional-paths.

§The-`Error.stackTraceLimit = Infinity` line has a tamed-
constructor comment explaining why it's safe (assignment is
silently ignored on non-v8). §Sibling-discipline to cycle 87
ses error/console taming: §preserve-developer-affordance-
without-introducing-leak.

## §The-Agoric-Familiar-pre.js-pattern (the shim assembly)

```js
// packages/init/pre.js — 7 lines
import '@endo/lockdown';
import '@endo/base64/shim.js';
import '@endo/promise-kit/shim.js';

export * from '@endo/lockdown';
```

§Three-shim-imports + §re-export-from-@endo/lockdown.

§The-import-order-is-load-bearing:

1. `@endo/lockdown` first — installs the wrapped `lockdown`
   function on globalThis (via pre.js side effect) but does
   **not** call it yet.
2. `@endo/base64/shim.js` — installs `atob` / `btoa` globals
   before lockdown freezes the prototype.
3. `@endo/promise-kit/shim.js` — installs the polyfilled
   promise primitives.

§Cycle-181-base64-source named §pre-lockdown-shim-discipline:
"importing @endo/harden from that path would race-to-install
(cycle 175's slot) a fallback harden before SES lockdown could
pin the canonical one." §Here-we-see-the-shim-path-explicitly:
`@endo/base64/shim.js` is loaded **before** the lockdown is
committed.

§pre-remoting.js extends this:

```js
export * from './pre.js';
export * from '@endo/eventual-send/shim.js';
```

§Adds-eventual-send-shim. §The-canonical-Agoric-shim-stack is
lockdown + base64 + promise-kit + eventual-send.

## §The-DEPRECATED-with-redirect-comment

```js
// pre-bundle-source.js - initialization to use @endo/bundle-source
// DEPRECATED: no longer necessary, imports of this module can be replaced with
//   import '@endo/init';
// or if further vetted shim initialization is needed:
//   import '@endo/init/pre.js';

// eslint-disable-next-line import/export
export * from './pre.js';
```

§Eight-line-file with §three-lines-of-DEPRECATED-explanation +
§one-line-of-replacement-instruction + §one-eslint-disable. §The-
deprecation-comment-tells-callers-where-to-go.

§Compare-to-cycle-167-where/index.js' §named-TODO §roaming-
AppData-with-content-addressable-state-merge — both name the
§future-state in-source.

§The-eslint-disable-`import/export` is necessary because
re-exporting from pre.js produces a duplicate-default-export
warning; the disable acknowledges the necessary duplication for
backwards-compat.

## §The-§console-warn-on-LOCKDOWN_OPTIONS-detection

```js
console.warn(
  `'@endo/lockdown' sniffed and found a 'LOCKDOWN_OPTIONS' global variable\n`,
);
```

§Why-warn-instead-of-silent: the LOCKDOWN_OPTIONS pathway
violates ocap discipline (§init-module-feature-tests-global-
state-for-a-passed-parameter). §The-warning-makes-the-violation-
visible.

§Compare-to-cycle-167-where/index.js' §ENDO_SOCK-override-as-
§last-resort-user-override — both expose user-controllable
configuration that bypasses normal discipline. §where/index.js
takes the override silently; lockdown warns. §The-difference:
ENDO_SOCK affects a daemon socket path (recoverable); LOCKDOWN_
OPTIONS affects the entire SES security boundary (security-
critical).

§The-warning-shape: §package-name + §sniff-source + §variable-
name. §All-three-pieces-help-the-reader trace where the
configuration came from.

## §Cohesion notes

- §The-bootstrap-pair-init+lockdown is the §canonical-bootstrap-
  entry-taxonomy. 17 files total (8 init + 9 lockdown).
- §Two-phase-init (pre / commit) separates §shim-installation
  from §lockdown-invocation. Lets consumers choose between
  side-effect-import-only and import-the-function-without-
  running-it.
- §Tolerance-ladder via separate entry-point files: index <
  debug < legacy < unsafe-fast. Each is a one-import affordance.
- §Sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch — global
  first, env var second; both warn on detection. §Honest-
  admission of ocap discipline violation in the prose comment.
- §"Initialization is often awkward" is the §design-anchor for
  the entire package. The honest framing.
- §NOTE-TO-REVIEWERS-pattern with §two-polarities (commented-
  out-means-accident-in-debug-file / not-commented-out-means-
  accident-in-production-file). §Grep-friendly + §mechanical-
  review.
- §domainTaming-unsafe-always-injected is the §named-mitigation-
  for-a-named-hole pattern.
- §post-lockdown-explicit-hardening with §per-platform-
  availability-comments (TextEncoder absent in eshost; URL
  absent on XSnap; Base64 present only on XSnap).
- §Shim-assembly-order in pre.js is load-bearing: lockdown
  (wrapped function) → base64 (atob/btoa globals) → promise-kit
  → eventual-send (in pre-remoting).
- §DEPRECATED-with-redirect-comment names the replacement
  imports in source.

## §Tier-1 borrowing

- §two-phase-init pre→commit (separate shim assembly from
  lockdown invocation)
- §tolerance-ladder via separate entry-point files (one-import
  affordance per shape)
- §sniff-LOCKDOWN_OPTIONS-as-pragmatic-escape-hatch (global
  first, env var second, both warn on detection)
- §honest-confession-in-prose-comment ("Initialization is often
  awkward"; "we are resigned to leave this hole open")
- §NOTE-TO-REVIEWERS-with-two-polarities (debug-file expects
  set; production-file expects unset; same pattern, opposite
  polarity)
- §domain-Taming-unsafe-always-injected (named-hole-with-named-
  mitigation)
- §per-platform-availability-comments-on-harden-calls (cheap
  no-op when absent; explicit comment on which platform)
- §shim-assembly-order-as-load-bearing (lockdown → base64 →
  promise-kit → eventual-send)
- §DEPRECATED-with-redirect-comment (name the replacement
  imports in source)
- §console-warn-on-discipline-violation (make the violation
  visible rather than hiding it)
- §re-export-then-invoke discipline (consumers choose side-
  effect vs function-form)

## §Synthesis-target

The §slot-machine-library's bootstrap module (if it has one)
can §borrow-the-tolerance-ladder: separate entry-point files
(`/init`, `/debug`, `/legacy`, `/unsafe-fast`) so consumers
pick the shape they need with a single import path. §The-
NOTE-TO-REVIEWERS-pattern is borrowable for any §development-
default-vs-production-default configuration that risks merge-
time accidents.

§The-LOCKDOWN_OPTIONS-sniff-pattern is borrowable for
§initialization-parameters-without-explicit-argument-passing
when ocap-discipline-strictness is impractical. The pattern:
sniff + warn + JSON-parse + type-validate + last-merge-injection
of safety overrides.
