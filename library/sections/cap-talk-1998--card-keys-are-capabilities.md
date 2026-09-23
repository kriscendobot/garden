---
title: "Card keys are capabilities (token vs. identity; ACLs build on capabilities, not the reverse)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-March.txt.gz
source_content_sha256: a88db289169663d08ae270831e0ec62a44a1245f4f4b0c22b8a61cb5d2c5b2af
source_authors: [Jonathan S. Shapiro]
source_date: 1998-03-10
thread_subject: "Card Keys and ACLs"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
---

Abstract: Jonathan Shapiro's founding reply on cap-talk, answering Frascadore's swipe-card-vs-key equivalence intuition. The core reframing: **card keys are actually capabilities that are difficult to copy** — the security of a card-key system rests on a *token* (hand me your card and I get in), not on *identity* (which is what an ACL system checks). The apparent ACL-like features of card keys (many keys per building, individually rescindable, modifiable entry set) are an ACL system *constructed on top of* a capability primitive, via a unique identifier per capability plus a destroyable indirection object. Shapiro states the asymmetry that anchors the whole debate: **it is straightforward and efficient to implement an ACL on top of capabilities, and almost impossible and damned inefficient to go the other way**; and that delegation, confinement, and the principle of least privilege are unsolvable with ACLs — confinement provably so.

## Token vs. identity

> If you think about it a little more, I think you'll conclude that card keys are actually capabilities that are difficult to copy. In an ACL system, it is the identity of the user that matters, not some token that they hold. In a card key system, all security is based on a token -- the card key. If you hand me your card key, I can get into the building.

The three features that make card keys *look* like an ACL, and their capability-primitive explanation:

1. there are multiple, individually identifiable card keys for the same building;
2. an individual card key can be rescinded without requiring everybody to get a new card key;
3. the set of entries named by the card key is modifiable.

> What's actually going on is that an access control list system has been constructed using a capability system as a primitive mechanism. 1. Put a unique identifier in every capability. 2. Introduce an indirection object that can be destroyed, and give the user a capability to the indirection object.

Because the unique-identity requirement is the exceptional case, EROS (the OS Shapiro's group built at Penn) adopts the second approach (the destroyable indirection object). See [capability IDs and indirection revocation](cap-talk-1998--capability-ids-and-indirection-revocation.md) for the mechanics.

## The asymmetry and its consequence

> If you are considering tradeoffs, it is both straightforward and efficient to implement an ACL system on top of a capability system. It is almost impossible and damned inefficient to do the other way around.

> For some problems, capabilities are a better answer. Delegation, confinement, and the principle of least privilege are all unsolvable using access control lists. Actually, it's been proven mathematically that confinement *cannot* be solved with ACL designs.

Shapiro is careful not to overclaim: capabilities "are not necessarily the right solution for all problems" — an ACL can be the best first-order answer to a specific problem such as entry-counting — "however, they provide the best primitive set for building problem-specific solutions."

This 1998 statement is the contemporaneous primary source for the arguments [Capability Myths Demolished (2003)](papers--miller-capability-myths-demolished-2003--confinement-myth.md) later formalizes as the Confinement Myth and the four-model taxonomy. The confinement-unsolvable-with-ACLs claim traces to the Harrison-Ruzzo-Ullman undecidability result and Lampson's 1973 confinement paper.

Source: [cap-talk 1998-March archive](http://www.eros-os.org/pipermail/cap-talk/1998-March/) (Internet Archive snapshot `web/2id_/.../1998-March.txt.gz`, sha256 `a88db289`), message from Jonathan S. Shapiro, 1998-03-10.
