---
title: "Sameness after an object is destroyed"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1998-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1998-April.txt.gz
source_content_sha256: 15da6c5c47a7a927899b39778eb859e19fb64907f5fec97151eba49960fe76b8
source_authors: [Norman Hardy, Jonathan S. Shapiro]
source_date: 1998-04-06
thread_subject: "Keys to deleted objects"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, revocation]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Hardy and Shapiro ask whether two references retain their designational identity after their targets are destroyed. KeyKOS and EROS normally collapse every such reference to the zero data key, analogous to a null pointer. Hardy observes that preserving same-dead-object versus different-dead-object comparisons would require allocation identities to outlive the objects themselves. The thread does not settle whether that semantic value warrants the storage and allocation-count complexity.

## The three-way question

The discriminator could plausibly report that two references to the same former object remain equal, that references to two distinct former objects remain unequal, or that all dead-object references become the same zero key. Preserving the first two answers gives clients stable designational sameness across destruction. Collapsing them gives the implementation a cheap terminal value and lets it recycle allocation identities sooner.

The design tension anticipates Endo and E's distinction between a disconnected reference that retains identity and a null or broken value that does not. It also separates two operations often conflated under revocation: making invocation fail and deciding what equality means afterward.

Source: [cap-talk 1998-April archive](http://www.eros-os.org/pipermail/cap-talk/1998-April/) (Internet Archive original-bytes snapshot, sha256 `15da6c5c`), messages by Norman Hardy and Jonathan S. Shapiro, 1998-04-06 to 1998-04-07.
