---
title: "Comparing models: ZBAC and attributes versus capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-June/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-June.txt.gz
source_content_sha256: 8cbb4cb659ac9deb86d73395a2ef63dc0462094c805a3a7d6730c8ae515e8072
source_authors: [Alan Karp, David Barbour, David Chadwick]
source_date: 2011-06-13 to 2011-06-14
thread_subject: "Comparison of Models"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, identity]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A comparison of authorization models set attribute-based and role-based schemes against capabilities, using the credit-card transaction as the shared example. David Chadwick read handing a merchant a credit card as delegating the right to withdraw funds from the customer's account, the same process seen from an attribute or delegation viewpoint. David Barbour and Chadwick sharpened what is actually delegated: not an open-ended right to take money, but the right to place a single pre-agreed debit, evidenced by a signed slip or a PIN and a receipt, disputable afterward, and workable in practice only because of surrounding social regulation (grievance courts, reputation, and card-network fraud insurance). Alan Karp supplied the field evidence against role and attribute agreement across administrative domains: the United States Department of Defense tried cross-service role recognition and it broke because an Army major has no Navy equivalent, the Air Force defined some four hundred roles none of the other services recognized, and reaching agreement on the meaning of roles and attributes is the hard, unsolved part. Chadwick offered the UK academic community's EduPerson schema as a partial answer while conceding it is too coarse for fine-grained control. Barbour named the gap that runs through all of it: there is a difference between the *legal* authority a transaction is supposed to convey and what the *protocol* actually protects.

## Delegation, pre-agreed amounts, and the social layer

The credit-card example is doing real work because it exposes how much of a "working" authorization system lives outside the protocol. The card does not hand the merchant the customer's account; it authorizes one debit of a stated amount, with a receipt that makes the amount checkable and a dispute path that makes it reversible. Barbour's point is that this only holds together because of social regulation: grievances go to court, a firm that abuses or leaks card data suffers reputational damage, and the card network self-insures against fraud. Strip those away and the raw protocol conveys more than anyone intends, which is why identity theft persists even inside this heavily regulated system. Karp's NFC cell-phone payment work aimed at the tighter primitive (a token authorizing deduction of a specific amount) precisely to shrink what the protocol grants toward what the transaction means.

Karp's DoD evidence is the empirical case against attribute and role agreement as the foundation for cross-domain authorization. Roles do not translate across administrative boundaries (the "thirteen-plus-two" mismatch of rank systems, the Air Force's four hundred unrecognized roles), and the failure is not merely technical but political: the Navy insists on Navy roles for Navy services and no one will pay for the translation. Chadwick's EduPerson counter shows a schema *can* be agreed within one community, but he conceded it is too coarse for fine-grained control, which concedes Karp's underlying point that shared-attribute agreement does not scale to precise authorization. Barbour's closing framing is the general lesson: a model should be judged by what its protocol actually protects, not by the legal or organizational authority it is imagined to convey.

## Bearing on Endo

This thread is the direct argument for why Endo authorizes with references rather than with identities, roles, or attributes. A capability needs no cross-domain agreement about what a role means, because possession of the reference *is* the authorization, so the DoD role-translation failure simply does not arise: Endo never has to reconcile one domain's attribute vocabulary with another's. The credit-card analysis maps onto the Endo pattern of handing out a narrow, pre-scoped facet (the analogue of the pre-agreed debit) rather than a broad account reference, and onto keeping the auditing and revocation that stand in for the social dispute layer. Barbour's legal-versus-protocol gap is a standing caution for Endo surfaces: the reference must actually bound the effect, because the surrounding social and legal machinery that props up ambient-authority systems is exactly what an ocap design is trying not to depend on.

Source: [cap-talk 2011-June archive](http://www.eros-os.org/pipermail/cap-talk/2011-June/) (Internet Archive original-bytes `id_` snapshot of `2011-June.txt.gz`, sha256 `8cbb4cb6`), thread "Comparison of Models" / "Comparing models", 2011-06-13 to 2011-06-14.
