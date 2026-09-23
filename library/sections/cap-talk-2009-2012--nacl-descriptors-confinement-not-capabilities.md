---
title: "NaCl descriptors: confinement is not yet object-capability discipline"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-October.txt.gz
source_content_sha256: 68456a3c01818f7a9058548bacac397ab922bcebceacde003f2bd129662a02f0
source_authors: [Sam Mason, Alan Karp, Toby Murray, Mark Seaborn, David-Sarah Hopwood]
source_date: 2009-10-05 to 2009-11-23
thread_subject: "Google's Native Client (NaCl) / NaCl descriptors are not (all) capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [sandbox-platforms, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages; thread continues in the 2009-November bundle."
---

Abstract: Native Client starts untrusted native code confined and exposes brokered resource descriptors, which its paper calls analogous to EROS capabilities. The list accepts the confinement value but resists equating the whole descriptor API with object capabilities. A channel is capability-like only when possession both designates a particular object and authorizes operations on it; a generic descriptor number whose meaning depends on an ambient table, broker policy, or separately named resource can retain handle-system or ACL semantics. The practical result is a layered reading: NaCl can supply a robust outer sandbox for native code, while capability discipline still depends on the broker protocol and the references actually handed across that boundary.

## Confinement is the beginning

Sam Mason reads NaCl's default confinement, explicit sockets, and caller-selected communication as capability-like and asks whether it could run confined native code alongside Caja. Alan Karp answers that the available material did not establish that NaCl *uses capabilities*. The paper's analogy to EROS descriptors is suggestive but not decisive.

Compatibility also matters. Few unmodified native programs ran under early NaCl, though interpreters could move broader ecosystems into the sandbox. That resembles the managed-language adoption debate: a strong boundary can be technically sound while requiring applications and libraries to be re-expressed around explicit brokered powers.

The November follow-up narrows the terminology. Not every descriptor is automatically a capability. The test is behavioral: does the descriptor directly designate one object and authorize its use, can it be transferred only through controlled channels, and can code name unrelated resources without first receiving a reference? If authority still comes from a broker consulting ambient identity or resource names, the descriptor layer is only a confinement handle.

## Bearing on Endo

Endo should describe OS sandboxes, XS workers, and native subprocess brokers as complementary layers, not assume process confinement proves an object-capability protocol. The outer sandbox limits machine effects after a compromise. The inner reference protocol limits which effects well-behaved or adversarial components can request at all. Each broker method should accept already-designated facets and avoid turning caller-supplied path or endpoint names into stronger authority. Open question 49 preserves the descriptor-category boundary.

Source: [cap-talk 2009-October and November archives](http://www.eros-os.org/pipermail/cap-talk/2009-October/) (Internet Archive original-bytes `id_` snapshots; October sha256 `68456a3c`, November sha256 `ba8f8f33`), threads "Google's Native Client (NaCl)" and "NaCl descriptors are not (all) capabilities", 2009-10-05 to 2009-11-23.
