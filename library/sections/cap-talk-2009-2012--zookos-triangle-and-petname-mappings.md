---
title: "Zooko's triangle and petname mappings"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-February/
source_snapshot: http://web.archive.org/web/20130603012729id_/http://www.eros-os.org/pipermail/cap-talk/2011-February.txt.gz
source_content_sha256: 04dab0af089f2d19a65291f03086bcc171b5fda8b785f79e64a4633a99b81a85
source_authors: [Alan Karp, Mark Miller, David Barbour, Sandro Magi, Ben Laurie, Bill Frantz]
source_date: 2011-02-10 to 2011-02-16
thread_subject: "Questions about Zooko's triangle"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Preparing an RSA talk, Alan Karp asked what the "global" corner of Zooko's triangle means, why petnames require a mapping while keys and nicknames appear not to, and whether HTTPS names occupy all three corners. Mark Miller sharpened "global" to **globally context-free**: different parties can use the same name for the same entity. He distinguished a name from the naming system that maps among edge-name kinds, and distinguished petnames from lambda names by mapping direction: a petname system supports recovery of the securely unique referent, while SPKI's many-to-one mapping lacks the inverse and is a lambda-name system. The HTTPS example exposed why the triangle cannot be read as three informal adjectives: memorable DNS names gain secure uniqueness through a centralized CA trust structure, so they do not supply the decentralized property in the original formulation and their security is conditional on authorities the relying party trusts.

## Three properties, several mappings

The discussion separates three often-collapsed questions. A name may be memorable to a person, securely unique enough for a machine, or context-free across holders. A **naming system** can contain mappings among these representations; the mapping is not itself one of the names. Petnames and lambda names both combine memorable and securely unique naming, but differ in whether the association can be recovered in both directions. Nicknames are memorable shared labels but need not uniquely identify one entity. Public keys are context-free and securely unique but not memorable.

Karp's HTTPS counterexample depends on replacing "decentralized" with "global." A DNS name plus a CA signature can be memorable, globally interpretable, and conditionally unique, but only because DNS and the CA hierarchy are shared authorities. Several replies also rejected the claim that a practically trusted CA makes this unconditional: jurisdictional compulsion or CA compromise can bind the same memorable name to another key. The archive converges on using the properties precisely, but not on one presentation of the triangle that makes every mapping and trust assumption intuitive. This residue is recorded as open question 56.

## Bearing on Endo

Endo sturdy references and petname-like UIs should keep machine designation separate from human labeling. A durable cryptographic identifier can be securely unique without being meaningful to a person; a display name can be memorable without proving endpoint identity. A trusted interface binds the two for one holder. Treating a DNS or account name as if it already carried all three properties recreates the authority confusion the petname layer is meant to prevent.

Source: [cap-talk 2011-February archive](http://www.eros-os.org/pipermail/cap-talk/2011-February/) (Internet Archive original-bytes `id_` snapshot of `2011-February.txt.gz`, sha256 `04dab0af`), thread "Questions about Zooko's triangle", 2011-02-10 to 2011-02-16.
