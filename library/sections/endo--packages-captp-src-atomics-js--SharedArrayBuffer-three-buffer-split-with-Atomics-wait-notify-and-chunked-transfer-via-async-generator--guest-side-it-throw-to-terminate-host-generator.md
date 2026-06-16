---
source: packages/captp/src/atomics.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/captp/src/atomics.js
source_path: packages/captp/src/atomics.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - captp
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 169
lane: chat
status: current
title: §Guest-side-it.throw-to-terminate-host-generator
parent: endo--packages-captp-src-atomics-js--SharedArrayBuffer-three-buffer-split-with-Atomics-wait-notify-and-chunked-transfer-via-async-generator
---

```js
// This throw is harmless if the host iterator has already
// finished, and if not finished, captp will correctly
// raise an error.
//
// TODO: It would be nice to use an error type, but captp
// is just too noisy with spurious "Temporary logging of
// sent error" messages.
// it.throw(makeError(X`Trap host has not finished`));
it.throw(null);
```

§Cleanup-via-iterator-protocol. §it.throw(null)-terminates-
host-generator. §Null-as-the-error-value because the
captp logging would spam with spurious messages otherwise.

§TODO-named: §would-be-nice-to-use-an-error-type-but-captp-
is-noisy. §Honest-limitation-with-named-future-improvement
(sibling to cycle 167's roaming-AppData TODO and cycle
166's POSIX-`*at`-family future-hardening note).

§The-throw-is-defensive: *harmless if the host iterator has
already finished, and if not finished, captp will correctly
raise an error*. §Always-safe-to-call.
