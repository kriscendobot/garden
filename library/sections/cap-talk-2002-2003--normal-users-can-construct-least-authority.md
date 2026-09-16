---
title: "Normal users can construct least authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-April/
source_snapshot: http://web.archive.org/web/20160730002931id_/http://www.eros-os.org/pipermail/cap-talk/2003-April.txt.gz
source_content_sha256: a35a68e1356df225df33551ec9224d6b53958b91683b8f577fe403f48a0ba384
source_authors: [Bryce Wilcox-O'Hearn, Ben Laurie, Norman Hardy, Jonathan S. Shapiro, Charles Landau, David Chizmadia, Hal Finney]
source_date: 2003-04-01 to 2003-04-09
thread_subject: "an access control matrix model of capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Wilcox-O'Hearn attempts to derive capability semantics by extending a Lampson access matrix until ordinary users can create a fresh subject, give it a subset of their own authority, and control who else may grant to it -- all without administrator authority. The thread rejects his name "Higher-Order Least Privilege" but preserves the desideratum: an access-control system should enable normal users to practice least authority. Hardy locates the constructive mechanism in language abstraction (attenuating wrappers, already expressible in Algol 60); Finney contrasts Unix `chroot` and user creation, which require root. Chizmadia adds the key warning that least permission is not least authority when a privilege ranges over every nameable object.

## The matrix construction

Model S0 lets an administrator create subjects; S1 lets any subject create a fresh one; S2 makes granting require both authority to the resource and authority to the recipient row. The proposed punchline is that ACL delegation follows a resource column, while capability delegation requires connectivity to both resource and recipient. The list treats this as suggestive rather than a finished formal equivalence.

## The durable result

The useful criterion is user-level composability: a subject should be able to construct a less-authorized subject using only its own authority. Capability systems support creation, attenuation, and further recursive attenuation as ordinary operations. ACL systems that require root to manufacture an identity or sandbox make POLA depend on a central administrator.

Wilcox-O'Hearn explicitly reports that Miller was considering the row-and-column idea for *Capability Myths Demolished*. The thread is therefore direct drafting context for the paper's Dynamic Subject Creation, Subject-Aggregated Authority Management, and composability distinctions.

Source: [cap-talk 2003-April archive](http://www.eros-os.org/pipermail/cap-talk/2003-April/) (Internet Archive original-bytes snapshot `web/20160730002931id_/.../2003-April.txt.gz`, sha256 `a35a68e1`), messages dated 2003-04-01 to 2003-04-09.
