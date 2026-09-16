---
title: "GC versus RAII for resource lifetime"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-April.txt.gz
source_content_sha256: f28a7548e567b27ebc011f3f9ada2db5c782e5f6867a33eb70614f9e5aa258a1
source_authors: [Rob Meijer, David Barbour, Nathaniel Filardo]
source_date: 2011-04-29 to 2011-05-16
thread_subject: "GC versus RAII"
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, capability-security]
status: current
notes: "Derived summary, not the original messages. Spans 2011-April into 2011-May (sha ee0c54e9)."
---

Abstract: A resource-management argument that began in an earlier thread and ran from late April into May pits garbage collection against RAII (resource acquisition is initialization). Rob Meijer argued from a blog post that GC is anti-productive for resource management because without RAII the property of "being a resource" propagates transitively through composition: any object holding a resource that is neither GC-managed nor RAII-wrapped forces explicit release, and every composite that contains it must in turn arrange explicit release, all the way up. David Barbour countered that RAII makes *every* object a resource and so makes the transitivity trivially true rather than avoided, and that RAII does not remove explicit lifetime management (a heap-allocated RAII object still needs an explicit `delete`, or a smart pointer to arrange it). Nathaniel Filardo argued that using an object's static scope as a proxy for an external resource's lifetime is a symptom of lacking higher-order functions: Haskell's `bracket` gives a more flexible acquire-use-release pattern with no RAII object at all. The thread is a general programming-language debate rather than a capability one, but it turns on how a system's resource lifetimes compose, which is a security-relevant property.

## The transitivity claim and the counterpoints

Meijer's core claim is about composition. Consider RAII object B holding resource A, object C that has B as a member, and object D that has C as a member. Because B encapsulates its resource in a destructor, neither C nor D needs to define a destructor or perform any explicit release: the cleanup rides along automatically with ordinary object destruction. Meijer reads this as RAII containing the "being a resource" property inside B, so it does not leak into C, D, or the enclosing scope. Barbour's disagreement is twofold. First, RAII generalizes "resource" to every object, so the transitivity Meijer wants to avoid is instead universal (managing initializers and finalizers becomes something you always do, not something you do only for genuine resources). Second, RAII does not by itself eliminate explicit release: a dynamically allocated RAII object is freed by an explicit `delete` unless a smart pointer is layered on to schedule it, so the "automatic" cleanup depends on further machinery. Filardo reframed the whole framing as a missing-abstraction problem: tying a resource's lifetime to a lexical scope is a workaround for not having higher-order functions, and the `bracket` combinator expresses acquire-use-release directly and more flexibly, applicable even when the resource outlives no convenient scope.

## Bearing on Endo

Endo lives on JavaScript, a garbage-collected language, so it inherits the GC side of this debate and must supply what GC does not: deterministic release of external resources (open connections, file handles, remote references, revocable facets). The thread names the design pressure precisely. GC reclaims memory but not external effects, so Endo cannot rely on collection for lifetime and instead uses explicit disposal, revocation, and the higher-order acquire-use-release shape Filardo championed (a caller is handed a resource for the duration of a callback and the arranger closes it afterward) rather than a scope-bound RAII object. The transitivity worry Meijer raised survives in a capability system as the question of how a revocable or disposable capability composes: revoking a facet should cascade to the authority reached only through it, which is a lifetime-composition property, not a memory one.

Source: [cap-talk 2011-April archive](http://www.eros-os.org/pipermail/cap-talk/2011-April/) (Internet Archive original-bytes `id_` snapshot of `2011-April.txt.gz`, sha256 `f28a7548`) and the [2011-May archive](http://www.eros-os.org/pipermail/cap-talk/2011-May/) (sha256 `ee0c54e9`), thread "GC versus RAII", 2011-04-29 to 2011-05-16.
