---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: Related sections
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — this file uses `nearTrapImpl` from cycle 154's trap.js
  inside the `trapGuest` synchronous bridge.
- cycle 156
  [[endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability]]
  — this file uses `makeFinalizingMap()` from cycle 156 (in
  the §plain-Map-via-fakeFinalizingMap default branch);
  illustrates cycle 156's §test-utility-doesn't-want-gc-
  nondeterminism observation.
- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — the re-exported `E` originates here.
- cycle 134
  [[endo--packages-pass-style-src-remotable-js--two-distinct-shapes-with-tag-record-inheritance-and-canBeMethod-invariant]]
  — the `Far('refGetter', ...)` factory consumed in the
  bootstrap.
