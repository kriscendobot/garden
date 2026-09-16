---
title: "Authorization versus authentication, and POSIX on a capability kernel"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-February/
source_snapshot: http://web.archive.org/web/20160729230456id_/http://www.eros-os.org/pipermail/cap-talk/2003-February.txt.gz
source_content_sha256: 10cfd1fc40d7d50f7bd969110072b72ce3eab99008f6994e2e37543a77210d31
source_authors: [Constantine Plotnikov, Alan Cox, Bill Frantz, James Buchanan, Sandro Magi]
source_date: 2003-02-15 to 2003-02-21
thread_subject: "Q: Authorization vs. Authentication? / CAP & POSIX"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Two short February 2003 threads settle recurring newcomer confusions. Prompted by a Schneier Crypto-Gram on "the importance of authentication," Constantine Plotnikov asks whether it is conflating authorization, integrity, and authentication. Alan Cox gives the crisp English distinction — *authenticate* means prove identity; *authorize* means permit an action — with a credit-card example (authenticating the card is genuine versus authorizing a payment). Bill Frantz clarifies what Schneier was actually after: encryption alone is insufficient because an attacker can inject or replay data without knowing its content, so message integrity and freshness matter independently of secrecy. The second thread, James Buchanan's "CAP & POSIX," voices the adoption worry — will a capability kernel be forgotten because it cannot run existing POSIX software? Sandro Magi answers with precedent: KeyKOS (EROS's commercial predecessor) had a fairly complete POSIX environment, and Dionysix was the POSIX emulation environment for EROS.

## Why the distinction matters for capabilities

The authorization/authentication split is load-bearing for object-capability security: a capability *authorizes* an action by being held, without *authenticating* who holds it. Confusing the two is the error that pushes designers toward identity-checking ACLs when possession would suffice — the same conflation the 2003 Li Gong/KeyKOS-myths thread later calls out. Frantz's integrity point is the companion caution: authorization by possession still needs the channel carrying the capability to resist injection and replay.

## POSIX on a capability kernel is a solved-in-principle problem

Buchanan's compatibility fear has a concrete answer in the KeyKOS/EROS lineage: a POSIX personality can be layered over a capability kernel (KeyKOS did it; EROS's Dionysix aimed to). Capability discipline underneath and a familiar POSIX surface above are not mutually exclusive; the surface is an emulation built from capabilities, not a compromise of them.

Source: [cap-talk 2003-February archive](http://www.eros-os.org/pipermail/cap-talk/2003-February/) (Internet Archive original-bytes snapshot `web/20160729230456id_/.../2003-February.txt.gz`, sha256 `10cfd1fc`), messages dated 2003-02-15 to 2003-02-21.
