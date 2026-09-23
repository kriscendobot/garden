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
title: §Two-phase-init-pre→commit (the spine)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

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
