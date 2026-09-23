---
section: weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
source: endo--packages-captp-src-finalize-js
topics: [captp, hardened-javascript, capability-security]
status: current
title: Related sections
parent: endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability
---

- cycle 100
  [[endo--packages-ses-src-error-unhandled-rejection-js--SES-rejection-tracking-via-GC-driven-finalization]]
  — sibling §GC-driven-finalization design (SES's unhandled-
  rejection tracker also uses FinalizationRegistry). Both
  files name the §unregister-immediately-suppresses-
  finalization assumption (cycle 100's tracker has the same
  hazard with explicit `rejectionHandledHandler` cancel).
- cycle 142
  [[endo--packages-pass-style-src-passStyle-helpers-js--PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-factory-for-object-vs-function-tag-records]]
  — provides the `isPrimitive` that this file's `set` method
  asserts.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — defines what `Far` produces; this file uses it to wrap
  both real and fake finalizing maps.
- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — sibling first @endo/captp source file. Both touch CapTP's
  slot machinery from different angles (user-facing proxy vs
  GC-driven release).
- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — daemon-side §pattern of cross-process slot tables; this
  file's §multi-map-coordinated-removal is the in-process
  cousin.
