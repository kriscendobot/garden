---
title: "Sidebars: privilege/permission/authority, and virus/worm"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark Miller]
source_year: 2004
source_venue: HP Laboratories Palo Alto Technical Report HPL-2004-221
source_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_fetched_via: wayback
source_wayback_timestamp: 20220423221140
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-theory]
status: superseded
superseded_by: papers--stiegler-polaris-virus-safe-computing-2004--excess-authority-the-virus-problem-and-permission-versus-authority
superseded_on: 2026-06-28
superseded_reason: |
  Duplicate ingest of the same report. The 2004 HP Labs report HPL-2004-221 was
  ingested twice by two gardeners racing the same cycle, under two source slugs with
  the identical source_pdf_sha256 6c95faf19fef (9 pages, four authors). The canonical
  cluster is papers--stiegler-polaris-virus-safe-computing-2004, cross-referenced by
  the concepts/polaris.md and concepts/powerbox.md concept pages. The permission-vs-
  authority distinction this sidebar captures is covered by the canonical excess-
  authority / permission-versus-authority section. Kept, not deleted: the journal is
  append-only.
---

## Abstract

The two conceptual sidebars of the Polaris paper. The first distinguishes **privilege, permission, and authority** — defining permission as the rules written down (e.g. an ACL) and authority as the set of actions a process can actually cause to happen, the latter combining permissions with the behavior of the parties holding them; the web-server-and-visitor example shows authority can exist without a matching permission. The second distinguishes **virus from worm**. The permission-vs-authority distinction is the same one the Paradigm Regained and Structure of Authority papers formalize, and it is the principle that justifies Polaris's copy-plus-synchronizer design.

## Content

**Sidebar: Privilege, Permission, and Authority.** "The security community often refers to the Principle of Least Privilege. However, exactly what constitutes a privilege isn't clear. One attempt at a definition introduces the distinction between permission and authority. The authors define **permission** to be the set of rules as written down, say in an access control list, and **authority** to be the set of actions a process can cause to happen. The latter combines the set of permissions with the behavior of parties having these permissions."

The worked example: "Consider a web server. The process running the server has permission to read the files of the web site; there is a specific entry in the ACL for each file. Someone visiting the web site has no entry in the ACL but still can read the contents of the file because the server presents the information. Hence, the visitor has authority to read the files even though there is no explicit permission granting the access." The lesson: "Security analysis that considers only permission will be incomplete. Security analysis that includes authority is necessarily limited by our ability to understand the behavior of programs. Fortunately, it is often possible to get a usable bound on the authority available to any process." (The cited definition is Miller & Shapiro's "Paradigm Regained"; the library indexes the same distinction at [papers--miller-shapiro-paradigm-regained-2003](papers--miller-shapiro-paradigm-regained-2003.md) and [papers--miller-tulloh-shapiro-structure-of-authority-2004](papers--miller-tulloh-shapiro-structure-of-authority-2004.md).) This distinction is what justifies Polaris's design: the restricted account has *authority* to change the original file (through the synchronizer) but never *permission*, so the authority vanishes when the synchronizer stops.

**Sidebar: Viruses and Worms.** "The terms virus and worm have been used interchangeably to describe somewhat different types of malware. We use a loosely followed distinction that worms propagate on their own, but viruses are only spread by people." The prototypical worm is the 1988/1989 Morris worm; an early virus is Love Letter (a VBS script that modifies the machine and mails itself to all Outlook address-book entries once a person opens the attachment). The paper quotes the Jargon File definitions — a worm "propagates itself over a network, reproducing itself as it goes"; a virus "searches out other programs and 'infects' them by embedding a copy of itself … Unlike a worm, a virus cannot infect other computers without assistance" — and notes the distinction "is hardly settled" (a CERT advisory titled the Love Letter virus a "Worm").

Source: Polaris: Virus Safe Computing for Windows XP, HP Laboratories technical report HPL-2004-221 (December 2004); PDF fetched via the Internet Archive original-bytes capture (`source_fetched_via=wayback`, [web/20220423221140id_/](http://web.archive.org/web/20220423221140id_/http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf)), PDF SHA-256 `6c95faf1`.
