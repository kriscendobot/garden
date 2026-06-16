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
title: §The-DEPRECATED-with-redirect-comment
parent: endo--packages-init-and-lockdown--canonical-bootstrap-entry-taxonomy-with-two-phase-init-and-NOTE-TO-REVIEWERS-discipline
---

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
