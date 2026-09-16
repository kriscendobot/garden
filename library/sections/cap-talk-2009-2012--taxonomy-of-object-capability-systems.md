---
title: "A taxonomy of current object-capability systems (Murray, 2009)"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-March.txt.gz
source_content_sha256: 1fc3830753ef60b463368e43af520bebbeb2040e1e905c1d4f4ac9c0110803d9
source_authors: [Toby Murray, Mark Miller, David-Sarah Hopwood, Charles Landau, Jonathan Shapiro, Kevin Reid]
source_date: 2009-03-04 to 2009-03-20
thread_subject: "A Taxonomy of Current Object-Cap Systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Toby Murray asks the list to help complete a taxonomy of *currently-implemented* object-capability systems — the criterion for inclusion is that a working or prototype implementation exists right now, so someone could (even with difficulty) write code for it today. This deliberately omits the historically-first systems that no longer run (KeyKOS and (D)CCS, the first ocap OSes; Gedanken, the first ocap language) and omits pure caps-as-data systems whose objects manipulate the bits of a capability directly (the E sturdyref part; webkeys), though partitioned password-capability systems (Annex) are included. The 2009 live set is a useful snapshot of the object-capability landscape at the moment JavaScript-subset systems (Cajita, and the Caja lineage that Endo/SES descend from) had joined the languages and the seL4/OKL4 microkernels had joined the OS side. The taxonomy's *features* enumerate the axes along which these systems genuinely differ — threading, synchronous cross-thread sends, recursive reentrancy, asynchronous communication, reference equality — which is the more durable contribution than the membership list.

## The inclusion criterion

"The only criteria for inclusion is that there must be a working / prototype implementation for the system in existence right now — i.e. it must be possible (even if very difficult) for /someone/ to write code for this system today." Hence the notable omissions: KeyKOS and (D)CCS (first ocap OSes) and Gedanken (first ocap language) are excluded as non-running, and "caps-as-data systems in which objects can handle the bits of a cap-as-data directly, such as the E sturdyref part and Webkeys" are excluded, while partitioned password-capability systems like Annex are kept.

## The live systems (2009)

The systems Murray lists:

- **Languages:** E; Cajita (and other JavaScript subsets); Joe-E; Emily; CaPerl; Sahara.
- **Operating systems / microkernels:** EROS/CapROS; Coyotos; seL4; OKL4.
- **Password-capability:** Annex (2008-09).

The JavaScript-subset entry is the one that matters most for the Endo lineage: Cajita is a node in the Caja → SES → Hardened JavaScript → Endo line, and its presence in a 2009 "currently implemented" list marks the point at which ocap moved onto the mainstream web platform.

## The distinguishing features

Rather than describe each system prose-style, Murray defines feature axes so the systems can be compared cell-by-cell:

- **OS / Language** — whether the system is an operating system or a programming language (EROS is an OS; E is a language).
- **Single-Threaded** — whether all objects share one thread of control (E and EROS do not; Joe-E does).
- **Inter-Thread Synchronous Sends** — whether objects in different threads can send synchronously (E does not; EROS does); not applicable to single-threaded systems.
- **Recursive Reentrancy** — whether an object may be recursively re-invoked automatically (E does; EROS does not).
- **Asynchronous Communication** — whether async sends and/or receives are supported (E allows both async sends `<-` and receives `when (p) -> {...}`; Joe-E allows neither).
- **EQ** — whether the system provides a reference-equality (`EQ`) implementation.

These axes are the same design tensions the archive argued about for a decade — the synchronous-vs-eventual split (see the *Concurrency Among Strangers* vat/event-loop material), reference equality vs behavioral identity (see [`cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference`](cap-talk-2000-2001--a-capability-is-behavior-not-an-object-reference.md)) — now tabulated across the implemented field.

## Bearing on Endo

Endo/SES is the direct descendant of the "Cajita (and other JavaScript subsets)" entry: an object-capability *language substrate* on top of JavaScript, single-address-space but event-loop concurrent (async sends via eventual-send, `E(x).foo()`), with behavioral reference identity across the marshal boundary. The taxonomy's axes are a useful checklist for describing where Endo sits relative to E, Joe-E, and the microkernel ocap systems.

Source: [cap-talk 2009-March archive](http://www.eros-os.org/pipermail/cap-talk/2009-March/) (Internet Archive original-bytes `id_` snapshot of `2009-March.txt.gz`, sha256 `1fc38307`), thread "A Taxonomy of Current Object-Cap Systems", 2009-03-04 to 2009-03-20.
