---
title: "Modeling capability propagation: predictable by default, Horton responsibility as the exception"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-November.txt.gz
source_content_sha256: 1b343432bdb27f21a1feb9042d06c9ca2d74be7ba7c7dc43f0ecd29cf5150c64
source_authors: [Thomas Leonard, David Barbour, Mark Miller, Jed Donnelley]
source_date: 2011-11-16 to 2011-11-23
thread_subject: "Comparing identity-based and capability-based designs / Capability propagation - e.g. Horton"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, distributed-objects]
status: current
notes: "Derived summary, not the original messages. Consolidates the November 'Comparing identity-based and capability-based designs' and 'Capability propagation - e.g. Horton' threads."
---

Abstract: Thomas Leonard reported that running capability-based designs through his SAM access modeller was "not very interesting" — access propagates the way you would expect — so he extended the tool to model identity-based (RBAC) systems, which behave much more surprisingly. His tutorial walks a data-hosting example: a simple RBAC policy is safe until a processing service is added, at which point a confused-deputy attack appears and must be closed by an extra access check; extending users to call untrusted providers then breaks safety again; whereas the *capability* version meets every safety property with no changes. David Barbour welcomed capability propagation being "boring in a very good way" and suggested a compare-and-contrast library as capability advocacy; Mark Miller compared SAM to his own SCOLLAR access modeller (asking whether it reduces to plain Datalog under IRIS). Jed Donnelley then pointed at Horton as a *deliberately unusual* propagation — "acting under the responsibility of an entity" injects identity-basing into capability design — and asked whether the modeller could shed light on it. Leonard modeled Horton and SAM found one leak: if two objects collaborate, one can obtain a direct reference to the other by throwing it back in an exception (SAM, like Java and E, assumes every object holds a reference to itself), bypassing Horton's logging membrane — though the example required an `<unsafe>` import not available to confined E code.

## Capability propagation is predictable; RBAC is where the surprises live

Leonard's empirical finding is the advocacy point the list had long asserted: in a capability design, authority goes where references go, so a modeller finds little to report — which is a *strength*, because predictable propagation is auditable propagation. The interesting failures cluster in identity-based systems, where authority is decided by who-you-are rather than what-you-hold, so adding an intermediary silently opens confused-deputy paths that need bolted-on access checks, and each extension can re-open them. The capability version's "no changes required" is the same result Karp's transitive-access work reaches from the other direction: reference-carried authority composes without the cross-checks identity-carried authority keeps needing.

The one genuine subtlety Leonard flagged even in capability designs is *composition*: a read-only-file mechanism and an access-logging mechanism, each correct alone, can combine so that the read-only path bypasses the logger. That non-monotonic composition — two safe features producing an unsafe whole — is the residual hard case, and it is why "propagates as you'd expect" is "mostly," not "always."

## Horton: responsibility tracking, and a reference leak through exceptions

Horton is the studied exception because it layers *responsibility* (who is accountable for an invocation) onto pure capability propagation, approximating identity-basing without abandoning capabilities. SAM's modeling result is instructive: Horton's logging/membrane discipline can be bypassed if a callee can hand back a *direct* reference to itself — Leonard's example throws the real object in an exception, and the caller catches it and invokes the unlogged method. The caveat matters as much as the leak: reproducing it required importing an exception type via E's `<unsafe>` facility, which confined code cannot reach, so under E's normal confinement the membrane holds. The exchange is a concrete demonstration that responsibility-tracking membranes are only as strong as the guarantee that no un-membraned reference can escape — the same invariant every membrane depends on.

## Bearing on Endo

This thread is direct antecedent to two Endo commitments. "Capability propagation is predictable" is the auditability argument for Endo: because authority travels only as granted references, the reachable-authority graph is something you can actually inspect, which is why Endo can reason about a guest's powers by looking at what it was handed rather than tracing an identity's roles. Miller's SCOLLAR/Datalog modeller is the lineage of treating that graph as a queryable object. The Horton exception-leak result is a standing warning for Endo membranes: a revocable or logging membrane is defeated the moment an un-wrapped reference leaks across it (through an exception, a callback, or a returned object), which is exactly why Endo's membranes must wrap *everything* crossing the boundary — arguments, returns, and thrown values alike — the same completeness the [js-membranes-and-fine-grained-object-views](cap-talk-2009-2012--js-membranes-and-fine-grained-object-views.md) work makes concrete in JavaScript. The composition hazard (read-only plus logging bypassing the log) is the general caution that Endo's individually-sound facets still need whole-system review where they meet.

Source: [cap-talk 2011-November archive](http://www.eros-os.org/pipermail/cap-talk/2011-November/) (Internet Archive original-bytes `id_` snapshot of `2011-November.txt.gz`, sha256 `1b343432`), threads "Comparing identity-based and capability-based designs" and "Capability propagation - e.g. Horton", 2011-11-16 to 2011-11-23.
