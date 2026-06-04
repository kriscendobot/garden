---
title: '@endo/init + @endo/lockdown: canonical bootstrap entry taxonomy'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/init
source_paths:
  - packages/init/index.js
  - packages/init/debug.js
  - packages/init/legacy.js
  - packages/init/unsafe-fast.js
  - packages/init/pre.js
  - packages/init/pre-remoting.js
  - packages/init/pre-bundle-source.js
  - packages/init/debug-async-hooks.js
  - packages/lockdown/pre.js
  - packages/lockdown/commit.js
  - packages/lockdown/commit-debug.js
  - packages/lockdown/post.js
authors:
  - Mark S. Miller (prompted)
  - Kris Kowal (prompted)
ingested: 2026-06-03
ingested_by: scholar
topics:
  - hardened-javascript
  - getting-started
sections:
  - endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline.md
genre: §endo-source-comment-fragment §canonical-bootstrap-pattern
cycle: 183
lane: chat
---

# @endo/init + @endo/lockdown: the canonical bootstrap pair

## Files

| File | Lines | Role |
|------|-------|------|
| `packages/init/index.js`               |  6 | Default entry: pre-remoting + commit |
| `packages/init/debug.js`               |  6 | Debug entry: pre-remoting + commit-debug |
| `packages/init/legacy.js`              | 12 | Loosest entry: manual lockdown(severe/verbose/unsafe) |
| `packages/init/unsafe-fast.js`         |  8 | Fast entry: __hardenTaming__:'unsafe' |
| `packages/init/pre.js`                 |  7 | Generic preamble: lockdown + base64 + promise-kit shims |
| `packages/init/pre-remoting.js`        |  4 | pre.js + eventual-send shim |
| `packages/init/pre-bundle-source.js`   |  8 | DEPRECATED redirect to pre.js |
| `packages/init/debug-async-hooks.js`   | 12 | Debug + Node.js async_hooks |
| `packages/lockdown/pre.js`             | 175 | Wrapped lockdown function (sniffs LOCKDOWN_OPTIONS) |
| `packages/lockdown/commit.js`          |  3 | Re-export pre.js + call lockdown() |
| `packages/lockdown/commit-debug.js`    | 83 | Same with debug tamings |
| `packages/lockdown/post.js`            | 13 | Per-platform post-lockdown harden() of globalThis surface |

## §Abstract

`@endo/init` + `@endo/lockdown` form the §canonical-bootstrap-
entry-taxonomy for hardened-JS programs. Together, the 12
entry-point files compose a §tolerance-ladder from default-safe
(`@endo/init`) through debug-tolerant (`@endo/init/debug.js`)
to loosest-incremental-migration (`@endo/init/legacy.js`) to
unsafe-fast (`@endo/init/unsafe-fast.js`), all built on a §two-
phase-init pattern (pre installs shims; commit calls lockdown).

The substantive code lives in `@endo/lockdown/pre.js` (175
lines). It wraps the SES-installed `globalThis.lockdown` in an
Endo-specific `lockdown` function that:

1. Imports `ses` (which installs the raw lockdown on
   globalThis).
2. Sniffs for a `LOCKDOWN_OPTIONS` global variable; if absent,
   sniffs the `process.env.LOCKDOWN_OPTIONS` environment
   variable. Both pathways emit a `console.warn` on detection
   so the discipline-violation is visible.
3. JSON-parses + type-validates the sniffed value (must be an
   object, not an array).
4. Calls the raw lockdown with the merged options, always
   appending `domainTaming: 'unsafe'` last — a named-hole-with-
   named-mitigation: domain-taming-unsafe is required because
   "our platform still depends on systems like
   standardthings/esm which ultimately pull in domains."
5. Calls `postLockdown()` to harden the platform-conditional
   globals (TextEncoder absent in eshost; URL absent on XSnap;
   Base64 present only on XSnap).

The most distinctive comment-discipline is the §NOTE-TO-
REVIEWERS-pattern, appearing in both `commit-debug.js` and the
default-path of `pre.js`. The pattern has two polarities:
"commented-out = accident in this debug-context" vs "not
commented-out = accident in this production-context". A
reviewer searches for "NOTE TO REVIEWERS" and mechanically
checks the polarity against the file.

The prose anchor for the whole package is the line:
"Initialization is often awkward."

## §Provenance and dependencies

- §Built-on `ses` (the SES shim itself, imported in lockdown/
  pre.js).
- §Wraps `@endo/base64/shim.js` (cycle 181 + cycle 180 design)
  for atob/btoa.
- §Wraps `@endo/promise-kit/shim.js` for Promise primitives.
- §Wraps `@endo/eventual-send/shim.js` (pre-remoting.js only)
  for HandledPromise + E.
- §Cycle-181-base64-source named the §pre-lockdown-shim-
  discipline: "package loads pre-lockdown via @endo/init/
  pre.js → @endo/base64/shim.js → ./atob.js / ./btoa.js."
  This-source-is-the-other-end of that path.

## §Related sources in the library

- §Cycle 181 (`endo--packages-base64-src-encode-decode-js.md`)
  — §pre-lockdown-shim-discipline sibling. The Object.freeze-
  not-harden decision in base64/index.js exists because of
  this package's shim assembly path.
- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  the §race-to-install-at-well-known-slot that @endo/lockdown's
  pre.js predates by side-effect-importing `ses` before any
  consumer can reach the harden slot.
- §Cycle 87 + cycles 93/96/98/100/106 (SES error system) —
  the underlying machinery that `lockdown`'s `errorTaming` /
  `consoleTaming` / `stackFiltering` options configure.
- §Cycle 167 (`endo--packages-where-index-js.md`) — §ENDO_SOCK-
  override-as-last-resort-user-override sibling. ENDO_SOCK +
  LOCKDOWN_OPTIONS are both §user-controllable-configuration-
  that-bypasses-normal-discipline; ENDO_SOCK takes silently,
  LOCKDOWN_OPTIONS warns.
- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — §design-after-implementation-as-ratification-discipline
  sibling. Both name violations of the ideal process honestly.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-worker-
  snapshot.md`) — §revised-scope-discussion-2026-04-15 sibling.
  Both record §honest-design-evolution in prose.

## §Comment fragments worth preserving

```
// Initialization is often awkward.
```

§The-design-anchor for the entire package. §A-five-word-
confession that justifies every awkward pattern that follows.

```
// NOTE TO REVIEWERS: If you see the following line commented out,
// this may be a development accident that should be fixed before merging.
```

```
// NOTE TO REVIEWERS: If you see the following line *not* commented out,
// this may be a development accident that MUST be fixed before merging.
```

§The-§two-polarities of the NOTE-TO-REVIEWERS-pattern. §Grep-
friendly + §self-documenting + §mechanical-review.

```
// For now, we are resigned to leave this hole open, knowing that all
// contract code will be run under XS to avoid this vulnerability.
```

§The-§named-hole-with-named-mitigation pattern. The discipline:
acknowledge the vulnerability + name the mitigation that
contains it.

```
// 'Compartment', 'assert', and 'harden' are now present in our global scope.
```

§Post-lockdown-state-comment. §A-one-liner that documents the
transition: before this line, globals are powerful; after this
line, they are hardened-and-tamed.
