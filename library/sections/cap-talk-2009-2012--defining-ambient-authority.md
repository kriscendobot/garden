---
title: "Defining ambient authority: the 2009 encyclopedia thread"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-June.txt.gz
source_content_sha256: 5b9ecc12441b145590b2d016b15cc5aa279c342a736bd9c18258b3c633c13dda
source_authors: [Rob Meijer, David-Sarah Hopwood, Dave Chizmadia, Mark Miller, Alan Karp, Toby Murray]
source_date: 2009-06-05 to 2009-06-30
thread_subject: "\"ambient authority\" on wiki.erights.org / Concerning entry \"ambient authority\" in Wikipedia"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The single densest thread of June 2009 (roughly 140 of the month's messages) is an attempt to write a definition of *ambient authority* good enough for Wikipedia and `wiki.erights.org` — and it exposes that, as David-Sarah Hopwood puts it, "ambient authority is never clearly defined in any of the capability literature." Three candidate definitions surface and none fully satisfies. Hopwood offers two: (1) the authority a program shares with *all* other programs in the system, and (2) the authority it can exercise *without presenting any credential* — and rejects both (1 fits few uses of the term; 2 collapses into "identity-based authority"). Dave Chizmadia offers a precise designation-based definition: ambient authority is the pattern in which an Initiator is *not required to explicitly designate the specific authority* by which it requests an action, so the required authority is *inferred* from Access Control Information rather than designated — and crucially, a system that nominally uses tokens still has ambient authority if a "helper" facility automatically searches the caller's token list for one that permits the request (the SETUID/`sudo`-style automatic-authority-selection trap). Mark Miller's terse operational form — "if a requesting entity requests an action that it is permitted to perform, then the action is allowed" — anchors the discussion. The thread's lasting result for the SES/Endo lineage is the designation-centric reading: authority is ambient exactly when it is exercised *without being designated*, which is precisely what object-capability discipline (and later `lockdown()`) removes.

## Why the definition was contested

Rob Meijer opened by asking the list for "some encyclopedic resource defining the terms we use," pointing at the existing `wiki.erights.org/wiki/Ambient_authority` page and Mark Miller's compact phrasing, and asking whether it was correct. Hopwood's reply is the crux: the term is load-bearing across the literature yet never pinned down. His two candidates and his objections:

1. *Shared-with-all*: "the subset of its authority that it shares with all other programs in the computer system." Rejected because it "doesn't fit with most uses of the term."
2. *No-credential*: "the subset of its authority that it can exercise without having to present any form of credential, such as a capability, password, certificate etc." Rejected because it "seems to coincide with 'identity-based authority', which is more descriptive."

Hopwood adds a constraint the whole thread respects: a good definition "should avoid relying on the object-capability model" — the term must be meaningful to describe the systems ocap is arguing *against*, not defined circularly in ocap's own vocabulary. He notes ocap "almost" eliminates the no-credential kind, the "almost" being Non-Delegatable Authorities (NDAs), which can be reconstructed in *any* ocap system with rescinded-on-presentation nonces simulating EROS/KeyKOS resume keys.

## The designation-based definition

Dave Chizmadia's contribution is the one closest to the modern reading. Ambient authority is an access-control *pattern* in which "one Actor (the Initiator) is not required to explicitly designate the specific authority by which it requests an action by another Actor (the Target)." It is "(nearly?) inevitable in systems where the access control check is made at the Target by evaluating access control rules over ACI (Access Control Information) provided by the Initiator" — the specific authority is "inferred from the ACI, rather than being explicitly designated." His sharpest observation is that presenting tokens is *not* enough to escape ambient authority: it persists "if the Inter-Actor Communication system provides a 'helper' facility that automatically looks through the list of Initiator authorization tokens to find the one that will allow the action requested." That helper — the Kerberos-ticket-cache, the browser's automatic cookie/credential attachment, the OS deciding which of your permissions to apply — is exactly the mechanism that turns a nominally-credentialed system back into an ambient one.

## Why it is (still) an open question

The thread converges on designation as the discriminator but does not produce a single agreed sentence, and the participants ask the deeper question directly: "Can you create (useful) software systems written in object-capability languages ... which do not contain subsystems that have ambient authority?" — conceding that even ocap systems harbor ambient-authority pockets (the NDA construction, root objects, the powerbox). The definitional disagreement — shared-with-all versus no-credential versus not-designated — is a genuine, unresolved fork in the vocabulary, not settled documentation.

## Bearing on Endo

This thread is the conceptual root of what `lockdown()` and SES operationalize. The designation-based reading — authority is ambient exactly when it is exercised *without being designated* — is the criterion SES enforces by freezing the primordials and denying modules any authority they did not receive as an explicit argument: there is no ambient `fetch`, no ambient filesystem, no mutable shared global through which authority leaks. Chizmadia's "helper facility" warning is the reason Endo is wary of any framework that *automatically* selects and attaches authority on a caller's behalf (an implicit credential store, an ambient context object): the automation is what re-creates ambient authority on top of a capability substrate. See the [[ambient-authority]] and [[principle-of-least-authority]] concepts, and open question 33 (authority monotonicity) which turns on the same designation-versus-inference distinction.

Source: [cap-talk 2009-June archive](http://www.eros-os.org/pipermail/cap-talk/2009-June/) (Internet Archive original-bytes `id_` snapshot of `2009-June.txt.gz`, sha256 `5b9ecc12`), threads "\"ambient authority\" on wiki.erights.org" and "Concerning entry \"ambient authority\" in Wikipedia", 2009-06-05 to 2009-06-30.
