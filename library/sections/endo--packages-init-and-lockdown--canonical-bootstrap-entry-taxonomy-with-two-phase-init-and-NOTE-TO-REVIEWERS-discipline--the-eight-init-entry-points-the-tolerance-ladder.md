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
title: §The-eight-init-entry-points (the tolerance ladder)
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

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
