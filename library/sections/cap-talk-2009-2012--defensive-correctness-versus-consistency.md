---
title: "Defensive correctness versus defensive consistency: what object-capability languages can and cannot guarantee"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-July/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-July.txt.gz
source_content_sha256: 0fb935659a9664fc3880d95a3280f0e32b472df344e79f078e7bc25857044a30
source_authors: [Matej Kosik, Mark Miller, David Wagner, Toby Murray]
source_date: 2009-07-02 to 2009-07-15
thread_subject: "controversial article"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Matej Kosik poses a deliberately provocative claim: object-capability programming languages can build *defensively consistent* systems but not *defensively correct* ones. The thread sharpens the two properties and the gap between them. Miller's definitions: a server is **defensively consistent** if none of its clients can cause it to give *incorrect* service to any other client; it is **defensively correct** if, in addition, none of its clients can *prevent* it from giving correct service to another (defensive correctness = consistency + a liveness/availability guarantee). The consensus that emerges: defensive *consistency* is what an ocap language delivers by construction; defensive *correctness* is not fully achievable in general because a co-located client can always exhaust memory or loop forever — but it is achievable in restricted settings and approximable in practice. Miller enumerates the practical approximations from his thesis §5.7: correctness in the absence of *spontaneous* partitions/crashes; correctness *up to resource exhaustion* (the traditional liveness standard, non-termination counting as exhaustion); and correctness under *budgeted, preemptively-reclaimable* resource allocation, which isolates the blast radius of exhaustion to the exhausting subject's own clients. The KeyKOS family (KeyKOS, EROS, CapROS, Coyotos) achieves non-distributed defensive correctness through a kernel that does no implicit allocation and uses rendezvous rather than buffered async messages; distributed defensive correctness over an *unreliable* network is, "almost by definition of unreliable, impossible." David Wagner's pedantic caveat: the languages are Turing-complete, so they *can* express defensively-correct systems — they simply give you no special help reasoning about or ensuring correctness.

## The two definitions

Miller states them in server/client terms:

> A server is defensively consistent if none of its clients can cause it to provide incorrect service to any other client. A service is defensively correct if it is defensively consistent and none of its clients can prevent it from giving correct service to any other.

Defensive consistency is a *safety* property (nothing bad — no client corrupts another's service); defensive correctness adds a *liveness/availability* property (something good keeps happening — no client can deny another correct service). The extra clause is where resource exhaustion bites.

## Why full correctness is not free

The blocking case is co-location. Toby Murray: if clients "are part of the same vat, then ... there is no way to ensure defensive correctness (one client can always exhaust all of the available memory or enter an infinite loop or whatever)." Across *separate* vats it is "quite possible" — "if the server is Functionally Pure, I fail to see how it cannot be defensively correct." So the boundary that makes correctness attainable is the vat/isolation boundary plus purity, not the language alone. Miller's correction of the "E ensures correctness between vats" hope: "Not 'ensure', but to defend to an often practical degree."

## Miller's practical approximations

Rather than an all-or-nothing guarantee, Miller (thesis §5.7, "A Practical Standard for Defensive Programming") offers a ladder of approximations:

- **Absence of spontaneous partitions/crashes** — correctness assuming failures are not caused by the programs under consideration.
- **Correctness up to resource exhaustion** — the traditional *liveness* standard, explicitly folding non-termination (an infinite loop) into "resource exhaustion." Protocols meeting only this are normally regarded as satisfying a meaningful liveness requirement.
- **Budgeted, preemptively-reclaimable allocation** — run each subject with a resource budget so that a subject which exhausts its budget "only exhausts its own storage and thereby fails to service only its own clients," and cannot prevent an adequately-authorized subject from reclaiming that storage. This is the design that isolates the *effect* of exhaustion even when exhaustion itself cannot be prevented.

The KeyKOS-family existence proof: a kernel with no implicit allocation and rendezvous-based (unbuffered) message passing gives non-distributed defensive correctness, because there is no kernel-side unbounded buffering to exhaust.

## Why it is an open question

The thread does not settle whether "defensive correctness up to resource exhaustion" is *usefully* stricter than mere cooperative progress — Miller explicitly "leave[s] to the judgement of the reader" — and whether E's unbounded message-buffering requirement (the distributed analogue of unbounded local heap/stack) means sender-side buffering is better for correctness is raised and left open. The precise line between what the language guarantees and what the runtime/resource-discipline must add is genuinely contested here, not documented.

## Bearing on Endo

This is the direct conceptual ancestor of what Hardened JavaScript and Endo guarantee versus delegate. Endo's SES layer delivers **defensive consistency** by construction — a frozen, tamper-proof primordial environment and object-capability discipline mean no client can corrupt a well-written server object's service to another client. Endo does *not* by itself deliver **defensive correctness**: an in-compartment infinite loop or memory exhaustion can still deny service, exactly Murray's same-vat case. The practical answer Endo/Agoric adopt is Miller's third approximation — *budgeted, preemptively-reclaimable resource allocation* — realized as metering and per-vat resource budgets (the SwingSet vat model), so that an exhausting computation harms only its own vat's clients and its resources can be reclaimed. "Functionally Pure across separate vats ⇒ defensively correct" is the design guidance behind favoring pure, well-isolated exos. See the [[robust-composition-thesis]] and [[principle-of-least-authority]] concepts; the definitions here trace to Miller's 2006 dissertation §5.7, and the concurrency-control framing to [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola.md).

Source: [cap-talk 2009-July archive](http://www.eros-os.org/pipermail/cap-talk/2009-July/) (Internet Archive original-bytes `id_` snapshot of `2009-July.txt.gz`, sha256 `0fb93565`), thread "controversial article", 2009-07-02 to 2009-07-15.
