---
title: "Shared-object lifetime and reference counting"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-January.txt.gz
source_content_sha256: dcec08bb49ef757ef1e9dfa76e04d8af2cc6a88dd5b54f610569da091dc6d38a
source_authors: [Charles Landau]
source_date: 1999-01-21
thread_subject: "KeyKOS design puzzle - shared object"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, persistence, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original message."
---

Abstract: Landau poses a distributed-lifetime puzzle: object X is shared by many users and should be reclaimed after every user is finished, including when a user disappears because its space bank is destroyed. His KeyKOS construction gives each user a registration object allocated from that user's bank and places a resume key in it; destruction triggers a callback that decrements X's count. The construction works but spends a domain and node per user to implement what looks like a reference count. The thread records the open tradeoff between explicit, capability-visible lifecycle signaling and a cheaper primitive distributed garbage-collection mechanism.

## The explicit construction

Each user registers with X and supplies a space bank. X allocates a per-user domain from its own bank and a per-user node from the user's bank. The node contains a resume key to the domain; the user receives a separate identification capability for explicit deregistration. If the user's bank is destroyed, invoking the resume key lets the helper decrement X's count and destroy itself.

The shape is relevant to Endo's cross-peer retention work: a retained object needs both a durable record of who is keeping it alive and a cleanup signal when that holder disappears. The 1999 puzzle makes the cost visible instead of treating reference counting as a local integer.

Source: [cap-talk 1999-January archive](http://www.eros-os.org/pipermail/cap-talk/1999-January/) (Internet Archive original-bytes snapshot, sha256 `dcec08bb`), message by Charles Landau, 1999-01-21.
