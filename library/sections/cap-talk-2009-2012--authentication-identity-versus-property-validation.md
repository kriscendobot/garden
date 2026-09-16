---
title: "Authentication: remote identity versus property validation"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-September/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-September.txt.gz
source_content_sha256: bde2949e1c5f8bc041b0c2e9b474a8b8bbd00abbb22f51949a9ec987e58b3151
source_authors: [Rob Meijer, Matej Kosik, Alan Karp, David-Sarah Hopwood, Mark Miller, James A. Donald]
source_date: 2009-09-03 to 2009-09-21
thread_subject: "Definition of Authentication on wiki.erights.org"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A 48-message attempt to define authentication splits between two meanings. The narrow definition establishes which principal is probably at the other end of a communication channel. The broad definition validates a security-relevant property of an object or subject, which need not reveal identity: a content hash, age predicate, gold content, or bearer token may be validated without naming a person. Hopwood argues the broad operation should simply be called validation or verification; Meijer argues ordinary security usage already calls it authentication. The thread agrees on the capability lesson even while leaving the word unresolved: authentication does not itself grant authority, and authorization need not depend on identity.

## The two definitions

The `wiki.erights.org` definition was: given one end of a communication channel, authentication establishes which principal is probably at the other end. Rob Meijer objected that this bakes identity-based access control into a supposedly general term. His successive proposals converged on "validation of a specific property of an object or subject," with authority and accountability as common reasons for validating that property.

David-Sarah Hopwood and Matej Kosik defended the channel-and-principal definition. If no principal needs identifying, Hopwood argued, the clearer words are validation or verification. This definition carries useful structure: every identity claim arrives through some channel, and the relying party must reason about that channel rather than treating a name as self-authenticating.

Alan Karp supplied counterexamples to identity as the universal target. A trusted hash can authenticate software without identifying its author; an artifact's composition can be authenticated; an order can be honored because it arrived through a trusted channel even if the soldier has never heard of the originating captain. James Donald's age example makes the privacy consequence explicit: a service may need proof that someone is over 18 while specifically not learning who they are.

## Authority and accountability remain separate

The durable point is a separation of axes. A property can support an authorization decision, an accountability inference, both, or neither. A capability can authorize by possession without identifying its holder. Conversely, authenticating an identity supplies no authority until a separate policy maps that identity to rights. Combining these steps is the characteristic move of identity-based access control, not a law of authentication.

## Why it remains open

The participants do not converge on whether the broad property-validation operation deserves the word *authentication*. The disagreement is not merely stylistic: the narrow definition forces every authentication claim into a principal-and-channel model, while the broad definition permits selective-disclosure and content-integrity proofs to stand on their own. Open question 45 records the unresolved vocabulary boundary.

## Bearing on Endo

Endo should keep three operations distinct at gateway boundaries: validate a claim, identify a remote principal when needed, and grant a narrow capability. A verified account or signature is evidence, not authority. The post-authentication step must deliberately map that evidence to the smallest reference set required for the session, preserving the archive's older "capability bucket" rule and avoiding an ambient identity object inside the compartment.

Source: [cap-talk 2009-September archive](http://www.eros-os.org/pipermail/cap-talk/2009-September/) (Internet Archive original-bytes `id_` snapshot of `2009-September.txt.gz`, sha256 `bde2949e`), thread "Definition of Authentication on wiki.erights.org", 2009-09-03 to 2009-09-21.
