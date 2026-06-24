---
section: Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
source: endo--packages-captp-src-trap-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §load-bearing-relationship — §lifted-from-E.js
parent: endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check
---

The §single-line-opening-comment is the most structurally
load-bearing acknowledgment in the file. It declares:

- *Where* the code came from (`E.js`).
- *That* it's a derivation, not an independent design.
- *Implicitly* that readers should understand `E.js` first to
  understand this file's structure.

The §lifted-from-X-comment discipline names the relationship
*at the file's top*, before any code. Future readers see the
provenance immediately; future changes to `E.js` are an
expected source of changes to this file.

The §shared-shape-different-semantics observation: this file
*mirrors* `E.js`'s structure (Proxy handler trio, freezable-
not-hardened targets, computed-property-key-arrow returning
method dispatch) *but* swaps eventual-send semantics for
synchronous-blocking semantics. Same lattice, different
operator.
