---
title: "Petname definitions, attribution, and usability limits"
source_kind: paper
source_title: "Petname Systems"
source_url: https://www.hpl.hp.com/techreports/2005/HPL-2005-148.pdf
source_snapshot: http://web.archive.org/web/20220105063409id_/https://www.hpl.hp.com/techreports/2005/HPL-2005-148.pdf
source_pdf_sha256: ac432db20f8bef9fd7dd674978fdc404dea9fa87273cde7b0b4771fb7db4569c
source_authors: [Marc Stiegler]
source_date: 2005-08-15
retrieved: 2026-10-08
ingested: 2026-10-08
ingested_by: scholar
topics: [petnames, identity, capability-security]
status: current
content_caveat: "Jev preclassification was unavailable because TYPESAFE_API_KEY was absent; ingested under the standing untrusted-data discipline."
---

Abstract: Marc Stiegler's 2005 HP Labs report is the canonical broad exposition of a petname system, not the invention of the idea. It defines keys, nicknames, alleged names, and petnames; says a true petname is one holder's editable private one-to-one, bidirectional UI mapping to a key; attributes the invention to Electric Communities; and credits Tyler Close with first recognizing petnames as a phishing defense. It also makes the design's human limits explicit: security fails when UI confuses an alleged or public name with a user-chosen petname.

The paper partitions the name kinds as follows:

- A **key** is the machine-handled globally unique, unforgeable designator. It prevents forgery.
- A **nickname** is an owner-selected public discovery label. It may map one-to-many and offers no collision guarantee.
- An **alleged name** is a third party's name proposal during an introduction. The key plus alleged name is a referral.
- A **petname** is one user's private, editable, one-to-one and bidirectional mapping to the key. It prevents mimicry only when every UI occurrence of the key renders that petname and the UI keeps proposed labels visibly distinct.

This terminology explains Endo's “edge name.” An introducer's label is an alleged or proposed name attached to the delegation edge. It is not the recipient's petname until the recipient binds it in the recipient's own namespace. The key or object reference is the underlying machine designation and authority-bearing reference, not any of these human labels.

Stiegler also qualifies the idealized one-key/one-entity assumption. A durable human trust relationship may outlive key rotation, one entity may have several keys, and one key may cover several organizational faces. The paper temporarily assumes one-to-one mapping for exposition. Discovery and trust transfer remain separate problems, and the UI must make petname creation both low-friction and resistant to confusingly similar names.

Source: [Marc Stiegler, *Petname Systems*, HPL-2005-148](http://web.archive.org/web/20220105063409id_/https://www.hpl.hp.com/techreports/2005/HPL-2005-148.pdf), 2005-08-15, sha256 `ac432db2`.
