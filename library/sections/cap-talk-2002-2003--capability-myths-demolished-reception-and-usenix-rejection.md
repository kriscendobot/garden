---
title: "The reception of Capability Myths Demolished: a USENIX rejection dissected"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-March/
source_snapshot: http://web.archive.org/web/20160729225054id_/http://www.eros-os.org/pipermail/cap-talk/2003-March.txt.gz
source_content_sha256: 4905b0beb81f8fe06f00583932e532b6f3f3ca73380fec30132ca16b372901aa
source_authors: [Ka-Ping Yee, James Graves, Mark S. Miller, Brian Marick, Alan Cox, Hal Finney, Eyal Lotem, Lex Spoon, Charles Landau]
source_date: 2003-03-21 to 2003-03-31
thread_subject: "\"Capability Myths Demolished\" review / Palladium, er, NGSCB"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages. Documents the on-list reception of the paper indexed under papers--miller-capability-myths-demolished-2003."
---

Abstract: In March 2003 Ka-Ping Yee posts the USENIX Security 2003 program committee's rejection of *Capability Myths Demolished* (submission #099) with its reviewer comments, and the list dissects the reception. The reviewers treat the paper's central points as minor: the designation-plus-authority argument is "a pretty minor nitpick with ACLs" (you can always `ls -l`), granularity is "another minor thing in the endless ACL-vs-capability debate," and the confinement and revocation arguments are dismissed as either impractical or as capability systems smuggling ACL-like restrictions back in (a reviewer invokes Sandhu's typed access matrix against the anti-confinement argument). James Graves asks whether the reviewer "completely missed the point"; Mark Miller's reply refuses that comfort. He accepts the failure as the authors': the paper assumed people miss these points and set out to explain them well enough that they would not, and it failed. Two concrete lessons: Shapiro had warned that the confrontational tone and title would draw fire (the reactions complain more about tone than content), and *nobody understood Confused Deputy*, so every point resting on it was lost. Chip suggested breaking Demolished into perhaps seven papers because it asks readers to make too large a jump at once.

## What the reviewers said

The committee read the paper's four-model argument as a rehash of an endless debate rather than a clarification of it. Each myth-demolition landed as a "nitpick." Notably, the reviewer against the confinement argument reached for Sandhu's typed access matrix model — the same access-matrix framing the list would work through two months later — treating capability-controlled delegation as no different from ACL-controlled delegation "in practice."

## Miller's diagnosis: it is the authors' failure, not the reader's

Miller's public reflection is the section's core. He declines the flattering reading that the reviewer simply missed the point, because the paper's whole purpose was to prevent exactly that. The actionable failures: the confrontational tone and title (against Shapiro's advice) provoked defensiveness; the Confused Deputy foundation was not understood, collapsing everything built on it; and the paper tried to move readers too far in one step. The proposed remedies — a paper devoted just to Confused Deputy, and splitting Demolished into smaller papers — shaped how the capability-security argument was presented afterward. Miller places his own text in the public domain, as is his habit on the list.

## The companion Palladium/NGSCB thread

Running alongside is a large thread on Microsoft's Palladium (renamed NGSCB), where Shapiro, Alan Cox, Yee, Norman Hardy, and others debate what a hardware-rooted trusted-computing base does and does not buy — the contemporary industrial counterpoint to the list's academic capability arguments.

Source: [cap-talk 2003-March archive](http://www.eros-os.org/pipermail/cap-talk/2003-March/) (Internet Archive original-bytes snapshot `web/20160729225054id_/.../2003-March.txt.gz`, sha256 `4905b0be`), messages dated 2003-03-21 to 2003-03-31.
