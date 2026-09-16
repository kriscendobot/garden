---
title: "The ACL model is incomplete: it cannot express changing the ACL"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2010-April/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2010-April.txt.gz
source_content_sha256: 42f9e9e68c840b78c8e926839d54b6765df86c1a5f6681d967cab8dd83100ccd
source_authors: [Alan Karp, Jonathan Shapiro]
source_date: 2010-04-07
thread_subject: "The ACL model is incomplete"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: In April 2010 Alan Karp asked the list for a citable reference for a claim he had been making to US Department of Defense audiences: "the access control list model is incomplete because it doesn't include a mechanism for modifying the ACL." Updating an ACL requires stepping outside the model and introducing the concepts of "administrator" and "owner," neither of which the pure access-matrix model defines. Nobody had disagreed with the claim, but he needed a citation, and "Capability Myths Demolished" never made it into a conference. Jonathan Shapiro supplied the answer: Harrison, Ruzzo, and Ullman's 1976 "Protection in Operating Systems" (Communications of the ACM), because HRU examines the *dynamic* view of the protection model rather than the static snapshot, and does model ownership. Karp confirmed the fit precisely: on page 463 HRU introduces the "own" permission, which "is part of the ACL entry for the file, but it is a permission on the ACL entry itself, not the file," and which "cannot be granted to any other user." Administrator authority remains outside even HRU's model, because an administrator implicitly holds all permissions on all resources while the model requires permissions to be granted explicitly.

## Why the ACL model is incomplete

The point is structural, not incidental. An access-control-list system answers "may principal P do action A on resource R?" by consulting R's list. But the operation "change R's list" is not itself an entry on any list in the model; it is smuggled in as the special authority of an owner or administrator. So the model as usually presented cannot account for its own maintenance. Shapiro's framing sharpens it: HRU is the right citation because it makes protection *dynamic* (commands that add and remove rights), and even there ownership is representable only by adding the "own" right as a special ACL-entry-level permission, while the administrator role stays outside. Shapiro noted capability systems need an analogue (unique object IDs, as ACL systems need unique principal IDs) but the maintenance authority in a capability system is not a privileged mode outside the model: the authority to change who can reach an object *is* just another capability, held and delegated like any other.

## Bearing on Endo

This is a precise statement of one advantage in the [[capabilities-vs-acls]] comparison. In an ACL world, the authority to grant authority (owner, administrator) is a privileged mode bolted onto the model, an ambient super-authority that the model cannot itself express or least-authority-scope. In an object-capability world there is no such mode: granting access is sending a reference, and the authority to grant is simply possession of the reference to send, held and attenuable like every other capability. There is no "administrator" standing outside the graph. This is why Endo can reason about the *entire* authority structure within one uniform model (references and messages) rather than carving out a trusted administrative plane, and it is a concrete instance of the "only connectivity begets connectivity" property. The HRU citation (Harrison-Ruzzo-Ullman 1976) is the durable scholarly anchor for the "ACLs need an out-of-model owner/admin" claim. See the [[capabilities-vs-acls]] concept and open question 1 (the ACL/capability equivalence dispute this refines).

Source: [cap-talk 2010-April archive](http://www.eros-os.org/pipermail/cap-talk/2010-April/) (Internet Archive original-bytes `id_` snapshot of `2010-April.txt.gz`, sha256 `42f9e9e6`), thread "The ACL model is incomplete", 2010-04-07.
