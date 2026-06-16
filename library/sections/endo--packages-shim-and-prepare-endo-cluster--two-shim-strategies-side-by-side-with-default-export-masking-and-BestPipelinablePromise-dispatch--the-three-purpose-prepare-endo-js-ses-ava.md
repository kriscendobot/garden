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
title: §The-three-purpose prepare-endo.js (ses-ava)
parent: endo--packages-shim-and-prepare-endo-cluster--two-shim-strategies-side-by-side-with-default-export-masking-and-BestPipelinablePromise-dispatch
---

```js
/* global globalThis */

import '@endo/init/pre-remoting.js';
import '@endo/init/debug.js';
import { environmentOptionsListHas } from '@endo/env-options';

import rawTest from 'ava';
import { wrapTest } from './src/ses-ava-test.js';

const env = (globalThis.process || {}).env || {};
env.TRACK_TURNS = 'enabled';

if (!environmentOptionsListHas('DEBUG', 'track-turns')) {
  if ('DEBUG' in env) {
    env.DEBUG = `${env.DEBUG},track-turns`;
  } else {
    env.DEBUG = 'track-turns';
  }
}

const test = wrapTest(rawTest);

export { test as default };
```

§Twenty-seven-lines doing §three-things-at-once:

1. **§Install-HandledPromise-and-lockdown-with-debug-tamings**:
   `import '@endo/init/pre-remoting.js'` + `import '@endo/init/
   debug.js'` (the §tolerance-ladder rung from cycle 183).
2. **§Force-track-turns-debug-output**: sets
   `env.TRACK_TURNS='enabled'` + adds 'track-turns' to DEBUG
   list (cycle 90 track-turns.js's diagnostic mechanism).
3. **§Wrap-ava-test-with-ses-ava-test**: replaces `rawTest`
   with the SES-aware wrapper.

§The-default-export-is-the-wrapped-test. §A-consumer-imports:

```js
import test from '@endo/ses-ava/prepare-endo.js';
test('my SES-aware test', t => { ... });
```

§Side-effects + §functional-export-in-one-module. §Compare-to-
cycle-183-init's-§two-phase-init: prepare-endo.js is the
§canonical-AVA-integration-of-Endo.
