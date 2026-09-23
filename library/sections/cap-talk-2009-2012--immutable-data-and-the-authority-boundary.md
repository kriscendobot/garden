---
title: "Immutable data and the authority boundary"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-February/
source_snapshot: http://web.archive.org/web/20130603012729id_/http://www.eros-os.org/pipermail/cap-talk/2011-February.txt.gz
source_content_sha256: 04dab0af089f2d19a65291f03086bcc171b5fda8b785f79e64a4633a99b81a85
source_authors: [Sandro Magi, David Wagner, Mark Miller, David Barbour, Toby Murray, Alan Karp]
source_date: 2011-02-17 to 2011-02-23
thread_subject: "Capabilities for immutable data"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, distributed-objects, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Sandro Magi asked whether a reference to immutable data with an enforced invariant is a capability. David Wagner answered that terminology may vary, but a sound classification must conservatively include every reference that conveys authority; harmless immutable values may be included or excluded without weakening security. The difficult boundary is not mutability alone. Object identity can enable rights amplification, types can embody privileged tests or constructors, and a deeply immutable container can carry capability references that cannot be reconstructed from knowledge alone. Mark Miller consequently distinguished **selfless data** from merely immutable objects and separated local object capabilities from remote cryptographic capabilities: mutually suspicious machines cannot share an object reference, only cryptographic evidence represented as data. Endo's pass-style boundary follows this resolution by classifying deeply frozen copy-data separately from remotable identity-bearing objects.

## Data, permission, and authority

Magi's examples progress from integers through immutable structures with constructor-enforced invariants to remote references. Wagner offered three usable definitions: every object reference; every reference to something not transitively immutable; or every reference that conveys authority. The security requirement is one-way: anything that conveys relevant authority must be classified and controlled as a capability. It is harmless for the classification to conservatively include more references. Every system also chooses some powers to place "beneath notice," such as pure computation or allocation, because it does not attempt to reason about them as authority.

Identity makes the simple immutable/mutable split fail. A token can be immutable and still amplify rights when presented to another object. A type with a private constructor plus a membership test can do the same. Miller's example of an E `ConstList` containing `x` and `y` is frozen and selfless as a container, but cannot be transmitted over a bits-only channel unless the receiver already has or can reconstruct the contained capabilities. Deep selflessness therefore depends on the whole reachable value, not only the outer object's mutability.

## Local islands and a cryptographic sea

Miller accepted the provocative consequence that there is no remote **object** capability between mutually suspicious platforms. Object-capability reasoning assumes a mutually relied-upon platform that preserves reference identity. Across a network, cryptography enforces a weaker model and cryptographic capabilities are representable as data. His practical architecture is local object-capability islands connected by a cryptographic-capability sea. Application code can reason uniformly about local and remote references, while a small transport boundary such as CapTP/VatTP protects keys and translates between enforcement models.

## Bearing on Endo

Endo makes these distinctions explicit. Hardened copy-data is deeply pass-by-copy and carries no object identity. Remotables are identity-bearing pass-by-presence values. A hardened record containing a remotable is not pure data that can be reconstructed from bits alone; serialization must preserve the slot for the capability. CapTP is the bounded cryptographic boundary between vats. This is why `harden()` is necessary but not sufficient to decide whether a value conveys authority: pass style and reachable slots complete the classification.

Source: [cap-talk 2011-February archive](http://www.eros-os.org/pipermail/cap-talk/2011-February/) (Internet Archive original-bytes `id_` snapshot of `2011-February.txt.gz`, sha256 `04dab0af`), thread "Capabilities for immutable data", 2011-02-17 to 2011-02-23.
