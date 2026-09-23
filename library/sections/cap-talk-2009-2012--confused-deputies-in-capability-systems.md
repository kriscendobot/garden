---
title: "Confused deputies inside object-capability systems: the missing capability-input-validation case"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-February/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-February.txt.gz
source_content_sha256: 450ead7831a992ddd5dce7ba9f10736b70db96fc2ce4d388ceee57fa3e4af041
source_authors: [Toby Murray, Sandro Magi, David Wagner, Mark Miller, Alan Karp, Ben Laurie, Jed Donnelley]
source_date: 2009-02-06 to 2009-02-27
thread_subject: "Confused Deputies in Capability Systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Following the "ACLs don't" discussion, Toby Murray makes the deliberately unconventional argument that confused deputies are not automatically eliminated by object capabilities. The prototypical ACL confused deputy (Hardy's FORTRAN compiler) arises because the deputy fails to validate a *designator* (a filename string) it is handed. Murray's claim: the same failure can occur in an ocap system whenever a service fails to validate a *capability* it is passed, in the case that the capability is more powerful in the service's hands than in the client's — for example through rights amplification (the service holds a trademark/brand or unsealer that turns a client-supplied reference into elevated authority). The only defense is for the service to perform input validation on the capabilities it accepts — which is exactly why ocap systems build capability-authentication in primitively: trademarks in E, Cajita, KeyKOS and EROS; static final-type checking in Joe-E. The thread's uncomfortable corollary: if the ocap fix for confused deputies is "the service must validate its inputs", then for an ACL/identity-based system the analogous fix ("validate the designator") is also available without converting to capabilities — so the confused-deputy argument, taken alone, is weaker than usually claimed.

## Murray's argument

"A confused deputy is any program that can be confused into using part of its authority, given to it for one purpose, for a different purpose, usually on behalf of some (malicious) client. A general symptom of a confused deputy is that the malicious client has excess authority." The conventional telling blames the ACL model because the compiler does not validate the string it is passed (it never checks that the user's named output file is not the billing file). Murray's move is to observe that an ocap service can be confused in the same way "whenever a service in an object-capability system similarly fails to perform input validation on the capabilities it is passed... in the case that those capabilities are more powerful in its hands than in those of its clients (e.g. via rights-amplification)." The service must authenticate the capabilities it accepts; the primitive mechanisms exist precisely for this: "trademarks in E, Cajita, KeyKOS and EROS, static checking of final types in Joe-E etc."

## Why it is an open question

Murray closes with the sharp point: "If not [some other defense], then the argument that the most appropriate way to deal with them in IBAC systems is through input validation (rather than transforming these systems to object-capability systems) seems more understandable." That is, if the ocap remedy reduces to "validate your inputs", a defender of identity-based access control can say the same, weakening the "capabilities eliminate confused deputies" slogan. The replies (Sandro Magi, David Wagner, Mark Miller, Alan Karp, Ben Laurie) probe where the two really differ: in an ocap system the *default* is that authority travels with designation, so the confusable case is the *exception* (deliberate rights amplification) a designer can see and guard, whereas in the ACL model ambient authority makes confusion the *default* that pervasive designator-validation must everywhere prevent. The distinction the thread sharpens is between eliminating a hazard by construction and merely making it visible and locally guardable.

## Bearing on Endo

Endo's `Far`/`Remotable` marking, brand/trademark checking, and pattern guards (`M.remotable()`, interface guards) are the modern form of the "authenticate the capabilities you accept" discipline this thread names. The lesson for an Endo service that performs rights amplification (an unsealer, a mint, a facet that upgrades a client reference) is Murray's: it must validate the shape and provenance of the references it accepts, because amplification is exactly the case where a passed reference is more powerful in the service's hands than in the caller's. See the [[confused-deputy]] concept for the ACL-side canonical telling.

Source: [cap-talk 2009-February archive](http://www.eros-os.org/pipermail/cap-talk/2009-February/) (Internet Archive original-bytes `id_` snapshot of `2009-February.txt.gz`, sha256 `450ead78`), thread "Confused Deputies in Capability Systems", 2009-02-06 to 2009-02-27.
