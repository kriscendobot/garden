---
title: "Defining a safe language, and whether ocap languages are a subset"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-April.txt.gz
source_content_sha256: 42f9e9e68c840b78c8e926839d54b6765df86c1a5f6681d967cab8dd83100ccd
source_authors: [Matej Kosik, Mike Samuel]
source_date: 2010-04-06 to 2010-04-07
thread_subject: "definition of the term \"safe language\""
ingested: 2026-09-16
ingested_by: scholar
topics: [programming-language-design, capability-theory, hardened-javascript]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The largest April 2010 thread (around 65 messages) fixes the definition of "safe language" the capability community uses and then argues over how object-capability languages relate to it. Matej Kosik quoted Benjamin Pierce's "Types and Programming Languages": a safe language is "one that protects its own abstractions." Every high-level language abstracts machine services (an array as an abstraction of memory, lexically-scoped variables, a call stack that truly behaves like a stack); a safe language guarantees the integrity of those abstractions and of programmer-defined ones, so they "can be used abstractly," whereas in an unsafe language understanding a program's possible misbehavior requires keeping in mind memory layout and allocation order, and a program "may disrupt not only its own data structures but even those of the run-time system." Kosik proposed that "object-capability language" is a *hyponym* of "safe language" (the ocap languages form a subset of the safe languages). Mike Samuel disputed the subset claim: an ocap language need only be safe with respect to the abstractions that *preserve ocap invariants* (object references, scopes, absence of ambient authority), so one can imagine a language safe in those respects yet unsafe elsewhere, making the two categories overlap rather than nest.

## Pierce's definition

The value of the thread is that it imports a precise, textbook definition into the list's vocabulary. Safety is not about types per se; it is abstraction integrity. An array can be changed "only by using the update operation on it explicitly, and not, for example, by writing past the end of some other data structure"; scoped variables are reachable "only from within their scopes"; the stack is really a stack. Where those guarantees hold, abstractions can be reasoned about locally; where they do not, no local reasoning is sound because any pointer arithmetic anywhere can corrupt anything. This is the property memory-safe managed languages provide and C does not.

## Subset or overlap

Kosik's hyponym claim is intuitive: ocap enforcement needs the language to protect references, so ocap languages look like a special case of safe languages. Samuel's counter is the careful one. What an ocap language must guarantee is the safety of exactly those abstractions that carry the ocap invariants (unforgeable references, honored scopes, no ambient authority). It need not guarantee safety of *every* abstraction. He offers a thought experiment: a hypothetical language safe with respect to references, scopes, and ambient authority, but with some other abstraction whose behavior is timing-dependent and not fully determinate, would still be an ocap language while not being fully "safe" in Pierce's total sense. So the precise relation is that ocap-ness requires safety of a specific *subset* of abstractions, not total safety, and the two sets need not nest. The thread does not fully converge, which is why the exact relation is recorded as an open question rather than a settled inclusion.

## Bearing on Endo

This is the theoretical prerequisite under all of SES and Endo made explicit. Object-capability enforcement is only as strong as the language's abstraction integrity: if a program can forge a reference by writing past an array or corrupting the run-time's data structures, no amount of reference discipline holds. JavaScript is memory-safe in Pierce's sense, which is why SES can build an ocap discipline on it at all (freezing the primordials and taming ambient authority adds the ocap-specific guarantees on top of the base safety). Samuel's refinement is the useful engineering lens: SES does not need JavaScript to be safe in every respect, only in the respects that preserve ocap invariants, which is exactly what `lockdown()` and taming target. See [[object-capability]] and the [hardened-javascript](../topics/hardened-javascript.md) topic; the relation-to-safe-languages question is recorded as open question 52.

Source: [cap-talk 2010-April archive](http://www.eros-os.org/pipermail/cap-talk/2010-April/) (Internet Archive original-bytes `id_` snapshot of `2010-April.txt.gz`, sha256 `42f9e9e6`), thread "definition of the term \"safe language\"", 2010-04-06 to 2010-04-07.
