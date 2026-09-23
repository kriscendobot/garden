---
title: "Singletons considered harmful: mutable global state is ambient authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-March.txt.gz
source_content_sha256: 1116e16a6279169b5cc8189a8e245cffe40bf1f47cc567537ccc53803ed979d0
source_authors: [Kenton Varda, David Wagner, Jed Donnelley, David Barbour]
source_date: 2010-03-09 to 2010-03-29
thread_subject: "Singletons Considered Harmful / Singleton discussion"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, hardened-javascript, programming-language-design]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A two-part March 2010 discussion (the "Singleton discussion" mid-month and Kenton Varda's "Singletons Considered Harmful" lets-argue page at the end) that pins down why the singleton pattern is an object-capability anti-pattern. The precise result, sharpened by David Wagner's review, is that *only mutable* globally-accessible singletons are the problem: "No one minds constant singletons." A mutable object reachable from anywhere is ambient authority by construction, because any code can reach it without being handed a reference, so it becomes a channel by which authority (and communication) leaks past the reference graph. Wagner tightened Varda's definitions to insert "mutable" at each point (a globally accessible *and mutable* object; a set of functions manipulating shared *mutable* global state) and pushed back on the claim that benign singletons are unacceptable or that auditing them is infeasible, using logging as the worked benign example. David Barbour contributed the constructive alternative: the "unum" pattern replaces singletons for many roles in capability systems, and capabilities embedded in source code are not singletons as long as they remain semantically location-transparent.

## Mutable is the whole distinction

Varda's page argued singletons are harmful; Wagner's review supplied the precision the argument needed. Every clause that condemned "globally accessible" objects needed "and mutable" added: a constant globally-accessible object (a pure function table, an immutable configuration) grants no authority and is fine, while a mutable one is a shared writable channel any code can reach. Wagner also disputed two overreaches. First, "singletons which do not provide any sensitive access are fine" should be conceded as a valid point rather than argued away, with the caveat that one must audit singletons to be sure none is sensitive and that combinations of individually-benign privileges can surprise. Second, he judged the claim that auditing is infeasible to be argument by assertion, offering logging as a benign singleton whose non-security objections (hard to follow, hard to test) do not obviously apply, and inviting the reader to look for other exceptions. He separately corrected Varda's ACL/confused-deputy example, noting it did not actually describe Java's stack-inspection model (which prevents that specific attack via `doPrivileged`).

## The capability alternative

Barbour's contribution reframes the fix. The "unum" pattern (from `wiki.erights.org`) fills many roles a singleton would in an ordinary system, but as a distributed, location-transparent object rather than a shared mutable global. He draws a distinction that matters for live-coding capability systems: embedding a cryptographic ocap directly in source code is not a singleton and violates no capability principle, provided the capability's *semantics* stay location-transparent (a capability to my webcam still refers to my webcam even when your code hosts it). Pervasive "machine" capabilities (a secure random source, wall-clock time, a standard font) can be distributed and locally implemented, which is a clean approach to foreign-function interface, while genuinely local resources like a webcam must always reach back across the network.

## Bearing on Endo

This is one of the clearest on-list statements of the principle SES enforces mechanically. `lockdown()` freezes the primordials precisely so that the shared globals are *immutable* singletons (Wagner's fine case) rather than *mutable* ones (the harmful case): a frozen `Object.prototype` or `Math` is a constant singleton nobody minds, whereas a writable global is exactly the ambient-authority channel this thread condemns. Module-level mutable state that any importer can reach is the same anti-pattern at a smaller scale, and Endo's discipline of passing authority as explicit endowments rather than reading it from a shared global is the direct application. Barbour's location-transparent-capability point prefigures Endo's remotables and the distinction between a pervasive powerless value and a genuine [[object-capability]]. See [[ambient-authority]] and open question 53 (whether benign singletons can be permitted or must all be forbidden), the dispute Wagner opened here.

Source: [cap-talk 2010-March archive](http://www.eros-os.org/pipermail/cap-talk/2010-March/) (Internet Archive original-bytes `id_` snapshot of `2010-March.txt.gz`, sha256 `1116e16a`), threads "Singleton discussion" and "Singletons Considered Harmful", 2010-03-09 to 2010-03-29.
