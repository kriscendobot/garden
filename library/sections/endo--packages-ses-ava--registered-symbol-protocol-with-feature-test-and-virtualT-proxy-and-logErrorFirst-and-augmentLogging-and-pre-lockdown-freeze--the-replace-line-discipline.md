---
title: §The-replace-line-discipline
source-slug: endo--packages-ses-ava
section-id: registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
url: https://github.com/endojs/endo/tree/master/packages/ses-ava
authors: [Endo contributors]
repo: endojs/endo
path: packages/ses-ava/src/{ses-ava-test.js, command.js, reexport-ava.js}
status: shipping
ingest-cycle: 219
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-ses-ava--registered-symbol-protocol-with-feature-test-and-virtualT-proxy-and-logErrorFirst-and-augmentLogging-and-pre-lockdown-freeze
---

The README's §usage-instruction:

```
Replace:
  import 'ses'; // or however you initialize the SES-shim
  import test from 'ava';

With:
  import test from '@endo/ses-ava/prepare-endo.js';
```

§A-single-import-replaces-two. §The-prepare-endo.js-module-initializes-the-SES-shim-with-debug-options + §wraps-and-exports-the-test-function. §One-line-of-user-code-changes; §the-library-does-the-rest.

§Borrowable-pattern: §single-import-replaces-multiple-imports + §the-library-handles-the-coordination-internally.
