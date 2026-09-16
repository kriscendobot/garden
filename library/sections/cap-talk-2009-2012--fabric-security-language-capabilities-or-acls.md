---
title: "Cornell's Fabric: is a decentralized information-flow language 'capabilities'?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-October.txt.gz
source_content_sha256: 6400467f7ecfd40ac0a49d55996a57b16129742f8d3aa84a157c420bea3c5e0f
source_authors: [John Carlson, Tony Finch, Alan Karp, Jonathan Shapiro, Mark Miller]
source_date: 2010-10-25 to 2010-10-26
thread_subject: "New Security Language from Cornell, \"Fabric\""
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages. Andrew Myers (Cornell), Fabric's lead, was cc'ed by Mark Miller; his claim is reported second-hand in the thread."
---

Abstract: When John Carlson posted a link to Cornell's Fabric ("a new security language," from Andrew Myers's group) asking "I'm not sure if this is capabilities or not...", the list applied its recurring litmus test — *is this actually capabilities, or a differently-named ACL/information-flow system?* — and largely concluded the latter. Fabric is a platform and language for secure distributed computation over shared persistent objects, built on Jif (Java + information flow), and its security model is **decentralized label-based information-flow control** with an `actsfor` delegation relation, not object-capabilities. Alan Karp read the paper and reported the decisive lines: the paper itself states "oids are not capabilities," Fabric's delegation is built on an `actsfor` (principal-hierarchy) model, and "the authorization model is very similar to other information flow control work" — Karp's judgment being that the authors "simply adapt conventional mechanisms because this part isn't their core contribution." Tony Finch's one-line read was blunter: "Looks to me like its objects have ACLs." Jonathan Shapiro noted the pedigree explained it — "Since Andrew [Myers] has a hand in it, that's not surprising" (Myers being the Jif/decentralized-label-model author). Mark Miller reported that Myers "claims it is both capabilities and information flow," but added the crux: "I haven't been able to figure out whether what he means by 'capabilities' is what we mean by 'capabilities'."

## The litmus test and the verdict

The thread is a compact instance of a pattern that recurs across this archive (compare the NaCl-descriptors and RabbitMQ threads): a well-funded new system is announced as offering "capabilities," and the list checks whether the word denotes the object-capability model (an unforgeable reference that both *designates* an object and *authorizes* its use, with authority propagated only by passing references) or something weaker. The evidence assembled here:

- **The paper's own words.** Karp: "The bottom of the left column on page 3 says 'oids are not capabilities.'" Object identifiers in Fabric are not authority-bearing references; possession of an oid does not confer access.
- **The delegation mechanism.** Fabric grants authority through an `actsfor` relation between principals (Section 3.1), which is delegation of *privileges within a principal hierarchy*, not transfer of object references. Karp noted it "implies that they allow delegation of individual privileges, but I don't see how that works," and that Fabric does not say "how to attach specific rights to each parameter in an invocation" — the fine-grained, per-argument authority that object-capability invocation gives for free.
- **The lineage.** Fabric is based on Jif; its authorization model "is very similar to other information flow control work." Shapiro's "Andrew has a hand in it" points at Myers's Decentralized Label Model, the canonical academic information-flow framework.

The verdict is not that Fabric is bad — it is a serious system for distributed secure computation — but that its "capabilities" are not object-capabilities. The genuinely open residue is *definitional*: Miller could not determine whether Myers's "capabilities" and the list's "capabilities" name the same thing, which is the same word-collision the "object-oriented security" naming thread (March 2010) and the ambient-authority definition thread (2009) worried about.

## Bearing on Endo

The value of the thread for the SES/Endo lineage is methodological: it is a worked example of the *test* one applies before accepting a system as capability-based, and the test is exactly the property Endo enforces. An Endo remotable is a capability precisely because holding the reference *is* the authority and there is no ambient principal hierarchy, no `actsfor`, and no name-to-authority lookup — the two things Fabric's `actsfor` and label model reintroduce. Fabric and Jif represent the information-flow *alternative* to the capability approach; understanding where they diverge (labels and principals versus references and message-passing) is part of knowing what object-capabilities specifically buy. See the [[object-capability]] and [[capabilities-vs-acls]] concepts and the neighboring [cap-talk-2009-2012--taxonomy-of-object-capability-systems](cap-talk-2009-2012--taxonomy-of-object-capability-systems.md).

Source: [cap-talk 2010-October archive](http://www.eros-os.org/pipermail/cap-talk/2010-October/) (Internet Archive original-bytes `id_` snapshot of `2010-October.txt.gz`, sha256 `6400467f`), thread "New Security Language from Cornell, \"Fabric\"", 2010-10-25 to 2010-10-26.
