---
source: packages/{eventual-send,promise-kit,ses-ava}/* (shim + prepare-endo cluster)
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages
source_path: packages/eventual-send/{shim,utils}.js, packages/eventual-send/src/postponed.js, packages/promise-kit/{shim,index}.js, packages/promise-kit/src/is-promise.js, packages/ses-ava/{index,prepare-endo,prepare-endo-config}.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - eventual-send
  - getting-started
  - testing
genre: §endo-source-comment-fragment §shim-and-prepare-cluster
cycle: 187
lane: chat
status: current
title: §`@endo/ses-ava/prepare-endo-config.js` — the default-export-masking trick
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
// This module is a variation on "@ses-ava/prepare-endo.js" that
// is suitable for use in an AVA config's "require" array.
// AVA config modules are expected to either *not* export a `default`,
// or to export a test if they do.
// The default export of "@ses-ava/prepare-endo" is the `test` function, so
// this indirection exists solely to mask out the default export.
import './prepare-endo.js';
```

§Seven-lines-including-comment-block. §The-implementation-is-
one-line. §The-comment-block-is-the-value.

§Why-this-file-exists: AVA's config `require` array expects
modules that either §do-not-export-a-default or §export-a-test
as default. §`@endo/ses-ava/prepare-endo.js` exports `test` as
default. §If-AVA-config-required-prepare-endo-directly, the
default export would be interpreted as a test and ava would
try to run it.

§The-solution: §a-thin-re-import that §does-not-re-export-the-
default. §`import './prepare-endo.js'` runs the side effects
(lockdown + env setup + ava install) but exposes no exports.

§Compare-to-cycle-167-where/index.js' §named-TODO and cycle
183-init's §DEPRECATED-with-redirect-comment. §All-three-are-
§tiny-files-where-the-comment-is-the-real-content. §The-code-
is-just-the-implementation-of-what-the-comment-explains.

§Tier-1-borrowing: §indirection-as-default-export-masking
pattern. §If-a-module's-default-export-conflicts-with-a-
consumer's-expectation, write a one-line re-import that
strips the default.
