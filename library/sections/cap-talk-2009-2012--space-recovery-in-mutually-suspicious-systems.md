---
title: "Reference counting versus mark-and-sweep for capability space recovery"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2012-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2012-May.txt.gz
source_content_sha256: f8e543934d49521eae106fb923d9059befc446bd7a01eb946934d000bed723a2
source_authors: [Bill Frantz, David Nicol, Charles Forsyth, Norman Hardy]
source_date: 2012-05-17
thread_subject: "Reference count based garbage collection seen as flawed"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, programming-language-design, persistence]
status: current
notes: "Derived summary, not the original messages. Continuation of a January 2012 Bill Frantz thread; six messages in May."
---

Abstract: A KeyKOS-rooted argument about how a capability system reclaims storage when its tenants are mutually suspicious. Bill Frantz set the frame: KeyKOS had no garbage collection at all — it could delete an object and automatically null every reference to it. The plus is that whoever pays for an object's space can always recover it and stop paying; attractive precisely for mutual suspicion. The minus is that deletion could wreak arbitrary havoc (from nothing, to destroying an entire application), and determining what a deletion would break requires examining the object graph, which is itself a POLA violation and useless to present to a human. Frantz called space recovery in such systems "an unsolved problem." David Nicol pushed back: done right, mark-and-sweep has no POLA problem — objects need not be erasable, only references droppable; exported references pass through a membrane, so an apparent deletion is dropping the "wet" reference, leaving the holder a useless lightweight access proxy, and useless references still count against the holder's reference allowance, motivating their release. Norman Hardy answered from the KeyKOS design's actual purpose: the hard questions are operational — what do you do when GC *fails* to produce space, how do you debug a leak, and how do you put the onus of the fix on the agency that owns the buggy code? KeyKOS targets mission-critical apps sharing a machine with leaky decision-support apps, and its **space banks** enforce per-tenant limits, which is what protects one tenant's availability against another's profligacy. Nicol countered that leak debugging is not a GC problem — reservation, usage limits, and over-provisioning handle it — and Hardy partly agreed, recalling that the KeyKOS team once considered but never finished a global mark-and-sweep that would return space to the banks it "rightfully belonged" to.

## Space banks, not a collector, are the availability mechanism

The thread's durable point is that in a mutually-suspicious multi-tenant system the interesting problem is not *finding* unreachable objects but *accounting* for who pays and *guaranteeing* that one tenant cannot starve another. KeyKOS space banks are storage-charging authorities: every allocation draws on a bank, and a bank's limit is a hard cap, so a leaky non-critical app exhausts only its own bank and cannot deny a critical app its reserved storage. That is why Hardy resists framing space recovery as a collector's job — a collector answers "is this reachable?", but the availability property comes from the *budget*, which is a capability the tenant holds and spends. Nicol's membrane-and-allowance sketch converges on the same insight from the language side: charge for held references, and holders drop what they no longer need, so the accounting drives reclamation without any party examining another's object graph. The unsolved residue Frantz named is the global reconciliation — returning swept space to the correct bank — which the KeyKOS team never prioritized because their tenants were not, in practice, running out.

## Bearing on Endo

This is the direct ancestor of Endo's retention-and-budget concerns. Endo cannot examine a guest's object graph to decide what a revocation or a daemon shutdown will break, for exactly the POLA reason Frantz gave, so it must make reclamation an accounting property, not a graph-analysis property. The space-bank model — authority to consume storage is a spendable capability with a hard per-holder cap, and exhaustion is contained to the profligate holder — is the shape Endo wants for durable formula storage and for the daemon's protection of one guest's availability against another's leak. Nicol's "useless references still count against your allowance, so you are motivated to drop them" is the incentive Endo needs for distributed GC of remote references across a `captp` boundary, where no collector can see the far side. See [gc-versus-raii-resource-lifetime](cap-talk-2009-2012--gc-versus-raii-resource-lifetime.md) for the 2011 lifetime-semantics facet, and the concepts [[resource-slice-budget]] and [[retention-accumulator]].

Source: [cap-talk 2012-May archive](http://www.eros-os.org/pipermail/cap-talk/2012-May/) (Internet Archive original-bytes `id_` snapshot of `2012-May.txt.gz`, sha256 `f8e54393`), thread "Reference count based garbage collection seen as flawed", 2012-05-17.
