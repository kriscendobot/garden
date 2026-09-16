---
title: "Horton was tweeted: attenuated delegation, accountability, and the contract-law analogy"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-November/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-November.txt.gz
source_content_sha256: a945c23c23279daa1cee4544485098269d6dffff56bec8c9ce0017ce70bfe7e7
source_authors: [Alan Karp, Mark Miller, Ben Laurie]
source_date: 2010-11-03 to 2010-11-04
thread_subject: "Horton was tweeted"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages. 'Horton' is the accountability-in-ocap mechanism of Miller, Van Cutsem, and Tulloh (named for the Dr. Seuss elephant); Karp reports its reception at IIW."
---

Abstract: A short but conceptually dense November 2010 thread on **Horton**, the object-capability accountability mechanism (Miller, Van Cutsem, Tulloh — "Distributed Electronic Rights in JavaScript" and the earlier Horton work), sparked by Alan Karp reporting that he ran a session on *attenuated delegation* at IIW (the Internet Identity Workshop) where the **introduction problem** naturally arose, he mentioned Horton, identity-standards figure Eve Maler "loved the abstract and tweeted a link to the paper," and "the lawyer in the room loved the way Horton responsibility tracking follows that of contract law." The substance is Karp's unpacking, at Mark Miller's request, of the **contract-law analogy** for accountability under delegation. Ben Laurie stated the simple case: contracts chain, so "A contracts with B to do X, B contracts with C to do something related to X. If A fails, then C must sue B who sues A" — liability follows the chain of who-dealt-with-whom, not a direct line. Karp's key refinement is the *introduction* case: "That's the way it works when there's no introduction. Things get trickier when B tells A to contract with C. **B should be liable for C's actions as long as A has no independent knowledge of C.**" And the payoff — the thing the lawyer took notes on — is that "**Horton can allow A to hold C responsible for actions taken before A came to have independent knowledge of C.**" Horton's accountability bookkeeping mirrors how the law assigns responsibility across an introduction: the introducer B carries C's liability until the introduced party C becomes independently known to A, and Horton preserves the record needed to reassign responsibility retroactively.

## The introduction problem and who bears responsibility

Pure object-capability delegation is deliberately *anonymous* in one sense: when Alice holds a capability to Carol, nothing in the bare reference records *who introduced them* or *who should answer for Carol's behavior*. That is fine for authority (possession is authority), but it is insufficient for **accountability** — the ability, after something goes wrong, to say whose fault it was. Horton is the mechanism that adds accountability *without* adding ambient identity or breaking the capability discipline: it interposes accounting membranes so that each party knows the *others it dealt with* and can assign blame along the actual introduction graph.

The contract-law mapping the thread draws out:

- **No introduction (the simple chain).** A deals with B, B independently deals with C. Liability chains: if the end result fails, A holds B, and B holds C. A never needs to know C exists. This is Laurie's case and matches ordinary sub-contracting.
- **Introduction (the tricky case).** B *tells A to contract with C* — B introduces C to A. Now the question is who answers for C's conduct. Karp's rule: **B remains liable for C's actions for as long as A has no independent knowledge of C.** Once A comes to know C independently (a direct relationship forms), responsibility can shift to C directly.
- **Retroactive assignment (Horton's contribution).** The subtle part — and the reason the analogy impressed a lawyer — is the *time before* independent knowledge. Horton retains enough record that A can hold C responsible even for actions C took *before* A came to have independent knowledge of C. The accounting is not just "who do I blame now" but a preserved history that lets responsibility be assigned correctly across the introduction boundary after the fact.

## Bearing on Endo

Horton is the direct ancestor of the accountability layer relevant to Endo's distributed-rights and OCapN work: it shows how to add "who is answerable for this?" to a pure capability graph without smuggling in ambient identity or ACLs. The design principle — accountability is a *separable membrane over* the capability graph, tracking the introduction structure, not a property baked into references — is exactly what lets a capability system stay POLA-clean while still supporting after-the-fact blame assignment. The contract-law framing is the useful intuition: capabilities give you the authority chain; Horton gives you the liability chain that runs *alongside* it, including the introducer's residual liability for an introduced party until independent knowledge forms. See the [[object-capability]] and [[principle-of-least-authority]] concepts and the [[caretaker-pattern]] (the membrane mechanism Horton generalizes).

Source: [cap-talk 2010-November archive](http://www.eros-os.org/pipermail/cap-talk/2010-November/) (Internet Archive original-bytes `id_` snapshot of `2010-November.txt.gz`, sha256 `a945c23c`), thread "Horton was tweeted", 2010-11-03 to 2010-11-04.
