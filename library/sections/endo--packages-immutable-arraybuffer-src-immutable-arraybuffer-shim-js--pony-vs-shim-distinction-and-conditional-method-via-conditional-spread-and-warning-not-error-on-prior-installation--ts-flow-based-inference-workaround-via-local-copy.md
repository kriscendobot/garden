---
title: §TS flow-based inference workaround via local copy
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

```js
import {
  optTransferBufferToImmutable as optXferBuf2Immu,
} from './immutable-arraybuffer-pony.js';

// Even though the imported one is not exported by the pony as a live binding,
// TS doesn't know that,
// so it cannot do its normal flow-based inference. By making and using a local
// copy, no problem.
const optTransferBufferToImmutable = optXferBuf2Immu;
```

§The-import-is-renamed-to-a-short-alias + §the-local-binding-renames-it-back-to-the-canonical-name. §Why-the-double-rename: §TS-doesn't-know-the-import-isn't-a-live-binding + §TS-can't-do-flow-based-inference-on-imported-bindings + §making-a-local-copy-makes-the-flow-analysis-work.

§When-TypeScript's-flow-inference-fails-on-an-imported-binding, §rebind-it-locally-to-give-the-checker-a-fresh-binding-it-can-narrow. §The-comment-explicitly-names-the-cause-and-the-workaround.

§First-explicit-observation in library of §TS-flow-inference-workaround-via-local-rebinding as borrowable pattern. §Sibling-to-cycle-241's-`@ts-expect-error 2454` (acknowledgment of executor synchronous run) — §two-different-shapes-of-TypeScript-workaround. §Cycle-241-uses-expect-error-with-cited-error-code; §cycle-245-uses-local-rebinding-with-prose-explanation.

§The-rename-alias-`optXferBuf2Immu` is itself notable — §a-short-alias-for-a-long-name (sibling pattern to cycle 237's `q` = `JSON.stringify`). §Two-different-naming-conventions-for-rename-aliases: §single-letter (cycle 237 `q`) + §abbreviated-camel-case (cycle 245 `optXferBuf2Immu`). §When-a-name-is-imported-frequently-with-context-where-the-short-form-suffices, §use-a-short-alias.
