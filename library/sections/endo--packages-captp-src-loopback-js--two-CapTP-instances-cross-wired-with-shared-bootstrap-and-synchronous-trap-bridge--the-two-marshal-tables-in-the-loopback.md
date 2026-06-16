---
section: two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
source: endo--packages-captp-src-loopback-js
topics: [captp, eventual-send, hardened-javascript]
status: current
title: The §two-marshal-tables in the loopback
parent: endo--packages-captp-src-loopback-js--two-CapTP-instances-cross-wired-with-shared-bootstrap-and-synchronous-trap-bridge
---

The loopback creates *two CapTP instances*, each with its
*own* slot tables. The `slot`-arg crossing in `trapGuest`
*uses the far side's* marshal tables (`farUnserialize`,
`farSerialize`) because:

- The near side received the message *via near's marshal* —
  the slot-numbers are in *near's* table.
- But the value being passed is *actually a far-side object*
  — to deref it, you must go through *far's* unserialize.

The §which-side's-marshal-tables-do-we-use? question is
answered by *which side owns the object* — not *which side
sent the message*. The §marshal-side-tracks-object-ownership
discipline.
