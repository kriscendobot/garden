---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: Related sections
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

- cycle 74
  [[endo--packages-marshal-src-marshal-js--makeMarshal-constructor-rationale]]
  — the `makeMarshal` factory this file calls.
- cycle 69
  [[endo--packages-marshal-src-encodetosmallcaps-js--smallcaps-wire-format-rationale]]
  — the smallcaps format this file *pins away from* (with
  TODO).
- cycle 144
  [[endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap]]
  — the sibling "marshal twice" idiom for the membrane case.
  Together with this file, they show *both* directions of
  configuring `makeMarshal`: this file *removes* slot
  handling; dot-membrane.js *adds* the mirror-pair-of-
  marshals shape.
- cycle 146
  [[endo--packages-eventual-send-src-E-js--E-proxy-handler-trio-with-this-receiver-check-and-freezable-not-hardened-proxy-targets]]
  — sister §freeze-but-not-harden discipline with §verbatim-
  comment-shared-across-derived-files.
- cycle 154
  [[endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check]]
  — third file in the §triple-stabilize-citation cluster.
