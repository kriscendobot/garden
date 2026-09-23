---
title: "Argument Passing Rules: vat-based rules (leaving home / going home / travelling) and the Lost Resolution bug"
source_kind: web
source_url: https://erights.org/elib/equality/passing-rules.html
source_content_sha256: 674e5229902870f36b8ac0a3ca4398a021591a529c4f4c54023be1e84d78b9fe
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [marshal, eventual-send, captp]
status: current
---

The *vat-relative* half of E's argument-passing rules: how a Near/Far reference to a **PassByProxy** object transforms as it crosses vat boundaries, defined relative to the transmitting vat, the receiving vat, and the argument's *home* vat. Terminology: to a Settled reference, the vat hosting the object it designates is "**home**"; a reference in the same vat as its object is "**at home**"; a Near reference is always at home; a PassByProxy object is hosted by one vat, so all references to it share a home. The three cases, by which of Alice/Bob/Carol share a vat (Carol is the passed object):

- **Leaving home** (Carol lives in Alice's, the transmitting, vat): a transmitted **Near** reference to a PassByProxy object arrives as a **Far** reference to the same object.
- **Going home** (Carol lives in Bob's, the receiving, vat): a **Far** reference transmitted toward the reference's home arrives as a **Near** reference.
- **Travelling** (Alice, Bob, Carol in three separate vats): a **Far** reference transmitted to a third vat must be received as a **Far** reference.

These three are the E-language statement of the connectivity transforms that OCapN CapTP realizes — the "travelling" three-vat case being exactly the situation the [[three-party-handoff]] protocol handles. The page also documents a *Lost Resolution* implementation bug.

But first some terminology. To a Settled reference, the vat hosting the object it designates is "**home**". If the reference is in the same vat as the object it designates, it is "**at home**". A Near reference is always at home. A PassByProxy object is hosted by one vat, so all references to the same PassByProxy object have the same home. The vat-based argument-passing rules for inter-vat messages may now be defined relative to the transmitting vat, the receiving vat, and the argument's home vat.

- **Leaving home:** (When Carol lives in Alice's vat.) A transmitted Near reference to a PassByProxy object will arrive as a Far reference to the same object.
- **Going home:** (When Carol lives in Bob's vat.) A Far reference transmitted as an argument in a message sent towards the reference's home arrives as a Near reference.
- **Travelling:** (When Alice, Bob, and Carol are in three separate vats.) A Far reference transmitted as an argument to a third vat must be received as a Far reference (but due to the Lost Resolution bug, in current E implementations it will arrive as a Promise instead).

**Known Implementation Bug: Lost Resolution.** In current implementations of E, a transmitted Far reference to Carol, sent by Alice to Bob, when Alice, Bob, and Carol reside in three separate vats, will be received instead as a *promise* for Carol that will eventually resolve into a Far reference to Carol. As a result, if Alice sends Bob a hashtable containing the reference to Carol as a key, the hashtable will fail to unserialize in Bob's vat (because the key arrives Unsettled). The fix is known but was deprioritized.

Source: [Argument Passing Rules](https://erights.org/elib/equality/passing-rules.html) § Vat-based Rules, Mark S. Miller, erights.org; fetched 2026-06-27 via the erights.github.io GitHub Pages mirror, content SHA-256 `674e5229` (byte-identical to the prior Internet-Archive capture).
