---
title: "Distributed reference-counting garbage collection, and space recovery under POLA"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-January.txt.gz
source_content_sha256: 52782d21e89c47e0c4931c78329d1b093de7d749722a0acc54dd4dac33a580f2
source_authors: [Jed Donnelley, Bill Frantz, Alan Karp, Jonathan S. Shapiro, David Barbour, Rob Meijer, Sandro Magi]
source_date: 2012-01-01 to 2012-01-03
thread_subject: "Reference count based garbage collection seen as flawed / Resource management on OCap systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [distributed-objects, capability-theory, persistence]
status: current
notes: "Derived summary, not the original messages. Consolidates the January 'Reference count based garbage collection seen as flawed' and 'Resource management on OCap systems' threads, continuing the December distributed-GC strand."
---

Abstract: Continuing from the December Binder/proxy-by-default discussion, the list debated whether reference-count-based garbage collection is viable in distributed object-capability systems and, more broadly, how space is reclaimed without violating least authority. Jed Donnelley argued reference counting is unreliable in a distributed setting (references can be "lost") and that object *existence* is a separate concern from the existence of references — better tied to the resource accounts an object draws from. Alan Karp described how HP's Client Utility made reference counting work *because* it was proxy-by-default (delegated access routed through the delegator, so counts stayed local and correct), and noted his design deliberately had no "name an object you can't reach" special case — either a process could name an object or it could not. Bill Frantz described the KeyKOS alternative: *no* garbage collection at all, but the ability to delete an object and automatically null every reference to it, which is attractive for mutual suspicion (the space owner can always reclaim and stop paying) but dangerous (you cannot foresee what deleting an object destroys, and examining the object graph to find out would itself violate POLA); he called space recovery in these systems "an unsolved problem." Jonathan Shapiro raised the deeper worry that in *extensible, fine-grain* capability systems, distributed GC remains unsolved and its absence undermines a core argument for capability architectures. Rob Meijer and Sandro Magi tied the resource question to *linear (move) typing*: passing a capability revokes the sender's copy by default unless sharing is made explicit, so there is simply less shared state to collect.

## Reference counting works only where routing makes counts local

Karp's Client Utility result is the concrete data point: distributed reference counting was correct there *because* the system was proxy-by-default, so every delegated use flowed back through the delegator and the count could be maintained locally and severed on drop. Donnelley's general skepticism — that references get "lost" and counting is unreliable across a distributed boundary — is the flip side: in an introduction-by-default system, where delegated references go direct, there is no local chokepoint to count against, which is exactly why distributed GC is hard there. The design lesson is that reference counting is not a free-standing feature; it is affordable only under a routing discipline that keeps the count local.

## Deletion, POLA, and "space recovery is unsolved"

Frantz's KeyKOS account frames the alternative to GC and its cost. Deleting an object and nulling all references gives the space owner unconditional reclamation — valuable under mutual suspicion, because you can always stop paying for storage — but the blast radius is unknowable in advance (deletion might destroy nothing or an entire application), and the only way to find out, examining the object graph, is itself a POLA violation and hard to present to a human. Donnelley's suggestion of *recovering* a reference to a deleted object has the same POLA problem (the recovered reference might reach data the storage owner should not see). Shapiro sharpened the stakes: in extensible, fine-grained capability systems the problem is open, and an unsolved resource-reclamation story weakens the case for capability architectures generally. The Meijer/Magi move-semantics angle is the partial escape: if handing off a capability revokes the sender's copy by default (linear typing), the volume of shared, hard-to-collect references shrinks, so the accounting problem is smaller by construction.

## Bearing on Endo

This thread is the resource-lifetime problem Endo inherits and partly sidesteps. Endo/CapTP is introduction-by-default, so it faces exactly Donnelley's difficulty — no local chokepoint for counting delegated references — and the practical answer is the same the thread gropes toward: reclamation is driven by *explicit* lifecycle (dropping a reference, a caretaker's revoke, an object's own `die()`), not by trying to distributed-garbage-collect a graph whose full shape no party may inspect without violating POLA. Frantz's "you cannot examine the graph to see what deletion breaks" is precisely why Endo does not expose a global object graph and why revocation is done at membranes and caretakers the holder controls, not by system-wide collection. Shapiro's "unsolved for extensible fine-grain systems" remains a genuine open question (recorded as open question 60). The move-semantics observation prefigures Endo's preference for handing out narrow, single-purpose references (so there is little ambiguous sharing to reclaim) and its treatment of hardened copy-data as freely-passable values that need no reference accounting at all.

Source: [cap-talk 2012-January archive](http://www.eros-os.org/pipermail/cap-talk/2012-January/) (Internet Archive original-bytes `id_` snapshot of `2012-January.txt.gz`, sha256 `52782d21`), threads "Reference count based garbage collection seen as flawed" and "Resource management on OCap systems", 2012-01-01 to 2012-01-03.
