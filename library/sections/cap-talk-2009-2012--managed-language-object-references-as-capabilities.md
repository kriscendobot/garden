---
title: "Managed-language object references as operating-system capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-August.txt.gz
source_content_sha256: cf93f5280681f8b8c98a2f14691ea4198ce48c0bfb3f5c7d94c31c8f0b8c4cc8
source_authors: [Ben Kloosterman, Charles Landau, Jonathan M. Smith, Sam Mason, David Barbour, Alan Karp, Toby Murray, David-Sarah Hopwood]
source_date: 2009-08-01 to 2009-08-03
thread_subject: "Cap OS question / Cap type safe OS questions"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, programming-language-design]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A proposed C# operating system with one physical address space prompted the list to separate capabilities from their traditional kernel representation. In a memory-safe language, an ordinary object reference can be the capability: possession proves authority, method dispatch performs invocation, and a narrower interface or wrapper supplies attenuation. Kernel-maintained capability slots remain one implementation, not the definition. The security argument then rests on the language and compiler forbidding forged references, pointer arithmetic, ambient static powers, and unsafe reflection. This is a direct ancestor of SES and Endo's decision to make JavaScript references carry authority after `lockdown()` removes the ambient ways to recover it.

## Reference, object, and access right

Ben Kloosterman initially imagined a `Capability` class stored in protected or shared memory and invoked through a kernel message primitive. Charles Landau corrected the category error: in EROS and CapROS a capability is a reference to a protected object, not an active object that calls the kernel. Alan Karp sharpened the wording: a capability *is* an access right. In a kernel system, protected slots make references unforgeable; there are no user-space pointers to those slots.

For a wholly managed single-address-space system, several participants recommended taking the object model literally. An ordinary reference is enough if code cannot manufacture one except by receiving it through an allowed call. Attenuation becomes an object-design problem: hand out a read-only facet or wrapper, not a reference plus a separately consulted ACL. Toby Murray pointed to E and Joe-E as worked examples and named the language restrictions that make this valid, including eliminating mutable static state and ambient file construction.

## Where the trusted boundary moves

Language-enforced isolation does not remove the trusted computing base. It moves it into the verifier/compiler, runtime, and the rules governing unsafe features. Jonathan M. Smith framed the choice as deciding which resources require protection and then choosing hardware or language mechanisms to protect them. The managed design can avoid address-space transitions, but only if every admitted program is checkable and the resulting native code cannot forge or walk references.

The thread also distinguishes representation from persistence. A live in-memory reference may need a durable identity when stored, but that does not justify exposing raw addresses or turning ordinary names into authority. Persistence and garbage collection instead need a runtime mapping that preserves reference identity while retaining unforgeability.

## Bearing on Endo

Endo takes the managed-language branch of this fork. After SES removes unsafe reflection and ambient powers, a JavaScript object reference is the capability, a method call is local invocation, and `Far`/exo interfaces plus guards describe the admitted surface. Compartments replace the proposed OS protection regions, while explicit endowments replace a process's initial capability slots. The thread's warning remains load-bearing: if the host language can recover filesystem, network, evaluator, or mutable-global authority without receiving a reference, ordinary references no longer form a closed capability graph.

Source: [cap-talk 2009-August archive](http://www.eros-os.org/pipermail/cap-talk/2009-August/) (Internet Archive original-bytes `id_` snapshot of `2009-August.txt.gz`, sha256 `cf93f528`), threads "Cap OS question" and "Cap type safe OS questions", 2009-08-01 to 2009-08-03.
