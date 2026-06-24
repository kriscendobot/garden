---
title: §Feature-test-with-tolerate-absence-as-fallback
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

```js
const makeVirtualExecutionContext = originalT => {
  if (optMakeCausalConsoleFromLoggerForSesAva === undefined) {
    // Must tolerate absence as a failure of the feature test. In this
    // case, we fallback to `originalT` itself.
    return originalT;
  }
  // ... wrap originalT in a virtualT with SES-aware logger
};
```

§Feature-test-at-use-time (not at module-load). §If-the-substrate-isn't-there, §fall-back-to-the-original-AVA-execution-context. §The-test-still-runs; §it-just-doesn't-get-SES-aware-error-logging.

§Borrowable-pattern: §graceful-degradation-when-the-host-doesn't-provide-the-substrate. §Sibling to cycle 217 @endo/errors' §honest-fallback-policy and cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic (both pay a §degraded-but-still-functional cost when the substrate is absent).
