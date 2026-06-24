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
title: §The-Agoric-Familiar-pre.js-pattern (the shim assembly)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

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
