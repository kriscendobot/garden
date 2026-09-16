---
title: "Where is the boundary between data and immutable instances?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-April.txt.gz
source_content_sha256: c936ab9042452a7724aa543019f7cc0ffa7c3eaea07bbe26bb2a1560fc1cbc81
source_authors: [Raffaello Giulietti, Mark Miller]
source_date: 2012-04-19
thread_subject: "immutable objects"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, pass-style]
status: current
notes: "Derived summary, not the original messages. Light month (7 messages)."
---

Abstract: Raffaello Giulietti pressed Mark Miller on a boundary his thesis draws but does not obviously settle: section 9.1 defines *data* as immutable information and a *capability* as a reference to non-data (an instance, device, or loader), so where does a *deeply immutable instance* — an immutable Point, Date, Person-holding-an-immutable-Address, or a `java.math.BigInteger` — fall? Is a reference to such a thing merely information, or a full capability? Miller's answer relocates the distinction away from mutability and onto **unforgeability plus identity**. The purpose of the Data category is that "access to these is knowledge-limited rather than permission-limited": if Alice can figure out which integer she wants — 7, or your private key — she can have it, because data can be *resynthesized* from adequate information, whereas a capability cannot. So Data is defined as *both* transitively immutable *and* transitively identity-free. The ocap model is deliberately neutral on whether objects have identity; in an identity-free object system transitive immutability suffices, but E objects generally have identity, so E defines Data narrowly. Joe-E, constrained to be a no-rewrite subset of Java, cannot escape pervasive object identity even on individual BigIntegers, so it marks the security-relevant cases with the `Token` interface and the `Powerless` type (transitively immutable and transitively purposeful-identity-free); if the "extra" unmarked identities are in fact never used, Joe-E `Powerless` is effectively Data — but strictly, because of Java's unavoidable per-object identity, "in Joe-E only scalars are Data."

## Immutability is not the criterion; unforgeable identity is

The intuitive reading of the thesis — data is the immutable stuff, capabilities are the mutable stuff — is the reading Miller corrects. A deeply immutable Person is still not Data if a reference to it carries *unforgeable identity* that some other party cannot resynthesize. The security-relevant question is never "can this change?" but "can someone who knows enough about it manufacture their own equal copy, or must they be *given* a reference?" A capability is exactly the thing you cannot conjure from a description; data is exactly the thing you can. This is why Miller folds identity into the definition alongside immutability: an immutable object with meaningful identity behaves like a capability (you must receive it), while an immutable object whose identity is irrelevant behaves like data (you can rebuild it). The `Token`/`Powerless` machinery in Joe-E is the pragmatic residue of a language that cannot make scalars-only Data hold cleanly, so it annotates which identities are load-bearing.

## Bearing on Endo

Endo resolves this boundary with the `passStyle` classification and transitive `harden()` rather than with a `Token`/`Powerless` marker retrofit. Hardened copy-data (records, arrays, strings, numbers) is *passable* and identity-free: it marshals by value across a vat boundary, and either side can hold an equal copy, so it is Data in exactly Miller's sense — knowledge-limited, resynthesizable, carrying no authority. A remotable or a promise is *not* copy-data: it has unforgeable identity, marshals by reference, and must be granted. The April 2012 question ("is a reference to an immutable Person a capability?") is answered in Endo by asking which pass-style it has: a hardened record of the same fields is copy-data with no authority, whereas a `Far`-tagged remotable with those fields is a capability even if none of its methods mutate. Endo thereby makes structural — a property of the value's pass-style — the distinction Joe-E could only approximate with interface markers, and sidesteps the "only scalars are Data" concession by giving deeply frozen aggregates a first-class copy-data pass-style. See [immutable-data-and-the-authority-boundary](cap-talk-2009-2012--immutable-data-and-the-authority-boundary.md) and [capabilities-for-immutable-data-sealed-values](cap-talk-2009-2012--capabilities-for-immutable-data-sealed-values.md) for the 2011 sealed-value form of the same dispute.

Source: [cap-talk 2012-April archive](http://www.eros-os.org/pipermail/cap-talk/2012-April/) (Internet Archive original-bytes `id_` snapshot of `2012-April.txt.gz`, sha256 `c936ab90`), thread "immutable objects", 2012-04-19.
