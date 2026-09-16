---
title: "What sustained interest in capabilities: layering versus simplicity as the security argument"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-January.txt.gz
source_content_sha256: 98e2ac19fa805064090e4f4216f8b73b10bb1ab36d041b65937c1591d6fcef3a
source_authors: [David-Sarah Hopwood, Mitsu Hadeishi, Mark Miller, Jed Donnelley]
source_date: 2008-12 to 2009-01-07
thread_subject: "What sustained interest in capabilities (was: top-to-bottom)"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A January 2009 exchange between David-Sarah Hopwood and Mitsu Hadeishi over whether an access-control layer can ever make a system *more* secure. Hadeishi argues that adding a well-designed layer can simplify reasoning, so an ACL layer atop capabilities might be a net gain; Hopwood answers with the capability-community's core methodological claim: "Complexity is the enemy of security, and it's not possible to make a system simpler by adding layers. Since an ACL layer is typically already too complicated, it is only by removing such layers that we can obtain a high degree of confidence in the security of the whole system." His grounding is attack experience: "It is always easiest to attack the weakest sublayer, and that is in practice *too* easy in most systems." The thread is a compact statement of *security as extreme modularity* applied top-to-bottom — including the hardware — and a primary-source articulation of why the capability program removes rather than adds mechanism.

## The disagreement

Hadeishi asks Hopwood to keep an open mind about a "quite surprising" result — that a capability layer is "in itself a simplifying layer on top of the raw bits of the underlying computer or network of computers", so layering is not inherently bad. Hopwood accepts that a capability substrate is a simplifying abstraction but draws the line at *adding* an ACL layer on top of it: complexity is the adversary's friend, and the weakest sublayer is where the attack lands. "I've been thinking about it for 15 years, so I think that counts." His "top-to-bottom" explicitly includes the hardware — a capability discipline that stops at a trusted-but-complex lower layer has merely relocated the weakest link.

## The methodological claim

The exchange crystallizes a principle the archive returns to repeatedly and that the papers formalize as *security as extreme modularity* (Miller-Tulloh-Shapiro 2004; see the [`papers--miller-tulloh-shapiro-structure-of-authority-2004`](../topics/capability-theory.md) cluster): the way to raise confidence is to *subtract* mechanism until each remaining component's authority is small and legible, not to *add* a policy layer whose interactions with the layers below multiply the attack surface. It is the security-side reading of "the enemy is complexity" and the direct ancestor of the Hardened-JavaScript stance that removing ambient authority and freezing the platform (rather than wrapping it in more policy) is what makes untrusted code safe to run.

## Bearing on Endo

Endo's lockdown/harden approach is exactly "remove layers, don't add them": SES removes mutability and ambient authority from the JavaScript platform rather than adding a permission checker around it. Hopwood's "it is only by removing such layers that we can obtain a high degree of confidence" is a primary-source statement of why Endo confines by subtraction (freeze the primordials, cut off ambient I/O) instead of by an access-control overlay.

Source: [cap-talk 2009-January archive](http://www.eros-os.org/pipermail/cap-talk/2009-January/) (Internet Archive original-bytes `id_` snapshot of `2009-January.txt.gz`, sha256 `98e2ac19`), thread "What sustained interest in capabilities" (continuation of "top-to-bottom"), 2008-12 to 2009-01-07.
