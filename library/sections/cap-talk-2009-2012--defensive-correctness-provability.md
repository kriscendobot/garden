---
title: "Can defensive correctness be proved?"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-May.txt.gz
source_content_sha256: ee0c54e925a044f536a160f117cb132615fa750659bedd5a7b022c460d0d2642
source_authors: [Matej Kosik, Mark Miller, David Barbour, Dean Tribble, Kapaleeswaran Viswanathan]
source_date: 2011-05-15 to 2011-05-17
thread_subject: "is defensive correctness a plausible null hypothesis?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Matej Kosik asked whether defensive correctness and defensive consistency can be proved at all, and floated a null-hypothesis procedure: if you cannot disprove defensive correctness, accept it; else if you cannot disprove defensive consistency, accept that; else conclude the system is fragile. Dean Tribble located the source of the terms in the Miller-Tribble-Shapiro "Concurrency Among Strangers" paper and Mark Miller's thesis, where a program is *defensively correct* if it protects against all of its clients, and correctness divides into consistency (safety) and progress (liveness), so a program can be defensively consistent yet still vulnerable to client-caused denial of service. David Barbour argued the property is in fact provable by *local* reasoning: because the definition lets you assume your dependencies are correct and focus on defending against clients, you prove defensive correctness of a service R by examining the capabilities R exposes, not the behavior of its clients P and Q. Kosik and Kapaleeswaran Viswanathan raised a second doubt: the "Concurrency Among Strangers" definition (stated in terms of the service guarantee, never a wrong answer to a well-behaved client) and the Oz-E paper's definition (stated in terms of checking well-formed inputs) may not describe the same notion, leaving open both what exactly is to be proved and whether a machine-checkable proof is feasible.

## Two definitions, and the local-reasoning argument

The disagreement is partly about which definition is on the table. Tribble supplied the canonical one: P is defensively correct if it protects against all of its clients, and this splits into consistency (a safety property: never give a well-behaved client a wrong result, though you may give none) and progress (a liveness property). Under this reading a service can be defensively consistent while remaining open to denial of service by a hostile client, so consistency is the weaker, more achievable target. The Oz-E paper's phrasing (every entity explicitly checks its input arguments when invoked) sounds like a much weaker, syntactic obligation. Kosik and Viswanathan both flagged that the two may not coincide, so a proof would first have to fix which property it establishes.

Barbour's provability argument uses the structure of the definition itself. Because defensive correctness lets a component assume its dependencies are faithful and concern itself only with its clients, the proof factors: to show a service R is defensively correct you reason about the capabilities R exposes to the outside, not about the particular clients P and Q that hold them. Kosik's attempt to phrase this as "P cannot alter R's service to Q, and Q cannot alter R's service to P" Barbour judged too strong, since a legitimately shared object (a blackboard, a bulletin board, a database) does let one client affect what another sees; the real requirement is that any such cross-client relationship be *authorized*, and never arise through an unintended path or a rights-amplification accident. Whether the resulting obligation is amenable to a human-verifiable proof, a machine-checked proof, or neither, the thread left unsettled.

## Bearing on Endo

Defensive consistency is the exact property Endo undertakes to preserve: a well-written Endo object gives its callers correct results or none, never a wrong one, regardless of how hostile or buggy those callers are. Barbour's local-reasoning insight is why this is tractable in practice. An Endo object is hardened and reached only through the references it was explicitly granted, so its author reasons about the messages it can receive and the authority it exposes, taking the platform (the frozen primordials, the marshaling boundary) as the trusted dependency. The consistency-versus-progress split is also load-bearing for Endo: hardening and input validation buy defensive consistency, but availability against a client that floods or wedges a vat is a separate, weaker guarantee, which is why resource metering and supervision are distinct mechanisms. The unsettled definitional question survives as a real gap: the garden's own defensive-consistency claims would benefit from pinning down which formal property they assert.

Source: [cap-talk 2011-May archive](http://www.eros-os.org/pipermail/cap-talk/2011-May/) (Internet Archive original-bytes `id_` snapshot of `2011-May.txt.gz`, sha256 `ee0c54e9`), thread "is defensive correctness a plausible null hypothesis?", 2011-05-15 to 2011-05-17.
