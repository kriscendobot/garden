---
title: "Petnames versus E-order: does per-holder naming conflict with provenance-based message ordering?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-January.txt.gz
source_content_sha256: 98e2ac19fa805064090e4f4216f8b73b10bb1ab36d041b65937c1591d6fcef3a
source_authors: [Alan Karp, Charles Landau, Mark Miller, Rob Meijer]
source_date: 2009-01-19 to 2009-01-28
thread_subject: "Petnames versus E-order with ocaps"
ingested: 2026-09-16
ingested_by: scholar
topics: [distributed-objects, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Alan Karp poses a subtle tension between two properties of a distributed object-capability system: E's message-ordering guarantee (E-order) and a petname system's rule that the same object always gets the same name. E-order guarantees that if Alice sends a message to Carol, then sends Bob a reference to Carol, and Bob uses *that* reference to message Carol, Carol receives Bob's message after Alice's — but only for the reference obtained from Alice; a reference Bob already held to Carol carries no such ordering. A petname system, by contrast, maps every reference to Carol to one name ("foo"), erasing the distinction between the reference Bob got from Alice and one he already had. So if Bob wants his message to arrive after Alice's, he can do it with the newly-delegated reference but not with a pre-existing one — and a petname UI would show both as the same "foo", hiding which reference carries the ordering. Karp asks: is that a bug or a feature? Charles Landau pushes back that two references with different properties are, operationally, different references and should arguably have different petnames. The thread is an unresolved open question about whether human-facing naming (identity by object) and the machine's provenance-sensitive semantics (identity by delegation path) can be reconciled.

## E-order, stated

Karp's statement of the guarantee (checked with Miller): "If Alice sends a message to Carol, and then Alice sends a message to Bob containing a reference to Carol, and Bob uses that reference to send a message to Carol, Carol will receive the message from Bob after she receives the message from Alice. That ordering is not guaranteed if Bob sends a message to Carol using a reference not obtained from Alice." E-order is thus a property of the *delegation edge*, not of the target object: the ordering rides the specific reference that was passed.

## Petnames, stated

"A petname is a one-to-one mapping between an object reference and a name binding. If Bob has a reference to Carol that he calls foo, a reference to Carol that Bob receives from Alice will also be denoted foo." A petname is deliberately per-holder and object-identifying: its whole point is that the user sees one stable, personally-chosen name for a given object regardless of who introduced it.

## The tension (and whether it is a defect)

"Bob would like to ensure that a message he sends to Carol arrives after any messages Alice sent to Carol before she sent Bob a reference to Carol. In a petname system, he can't do that if he had a reference to Carol before Alice sent him one. Is that a problem or a feature?" The two disciplines disagree about what a "reference" is: E-order treats the delegated reference and the pre-existing one as distinguishable (they carry different ordering guarantees); the petname system collapses them because they designate the same object. Charles Landau's response takes the semantic view to its conclusion — "those two references have different properties, so they are different references... So they should have different petnames" — but that concedes that a strictly object-identifying petname loses information the ordering semantics need. The thread does not converge, which is why it is recorded as an open question.

## Bearing on Endo / OCapN

Endo and OCapN inherit both concerns: petname-based naming for humans, and provenance-sensitive delivery for capability transport. This thread is a primary-source flag that the two can pull apart — a naming layer that hides delegation provenance can hide semantically-relevant distinctions — and that a designer must decide, per use, whether petname identity or delegation-edge identity is the right granularity. It sits alongside the founding-era distinction between an off-line *representation* of a capability and the on-line *protocol* that carries ordering (see [`cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol`](cap-talk-2000-2001--off-line-capability-representation-vs-on-line-protocol.md)).

Source: [cap-talk 2009-January archive](http://www.eros-os.org/pipermail/cap-talk/2009-January/) (Internet Archive original-bytes `id_` snapshot of `2009-January.txt.gz`, sha256 `98e2ac19`), thread "Petnames versus E-order with ocaps", 2009-01-19 to 2009-01-28.
