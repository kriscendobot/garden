---
title: "Paradigm Regained: permission, authority, and abstraction"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-August/
source_snapshot: http://web.archive.org/web/20160730011654id_/http://www.eros-os.org/pipermail/cap-talk/2003-August.txt.gz
source_content_sha256: 5e810c0e660634ab1962bd7d813b20c4da59541075e6bb837e2f00c6e54d9614
source_authors: [Mark S. Miller, David Wagner, David Hopwood, Ka-Ping Yee, Charles Landau, Bill Frantz]
source_date: 2003-08-22 to 2003-08-29
thread_subject: "Paradigm Regained: Abstraction Mechanisms for Access Control"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, revocation]
status: current
notes: "Derived summary of the public draft discussion, not the original messages or paper."
---

Abstract: Miller posts the pre-camera-ready *Paradigm Regained* draft and the list helps sharpen its central claim: access-control analysis that looks only at the arrangement of primitive permissions cannot see security-enforcing abstraction. Permission bounds the actions a program may directly perform on objects it directly reaches; authority bounds the effects it may cause through direct and indirect access, including the behavior of other programs. Caretakers, factories, and data-diode facets use simple trusted objects to transform permissions into narrower authority, enforcing revocation, confinement, and star-like information-flow properties that arrangement-only models declared impossible.

## The terminology was made on-list

Wagner worries that security literature used "authority" prescriptively for intended policy, while the draft uses it descriptively for actual possible effects. Yee urges placing the direct/indirect distinction before the definitions. Landau offers the compact formulation: permission concerns directly accessible objects; authority concerns effects on objects accessible directly or indirectly. Miller traces the historical split: much ACL and ICAP work interpreted least privilege as least permission, while the Hardy object-capability tradition meant least authority.

## Abstraction changes the bound

If all programs outside a monolithic TCB are modeled as hostile, a protection graph gives an upper bound from connectivity alone. But small partially trusted programs can enforce meaningful interfaces. A caretaker forwards until a revoker changes its target; a factory controls the initial closure of an untrusted program; separate diode facets allow one direction without the other. Their behavior is part of the access-control mechanism, not application detail to discard.

## Review outcome

Reviewers broadly endorse the reframing while pressing for a clearer one-sentence thesis, a more explicit definition of object-capability language, and care around claims that prior literature never modeled partial trust. The archive therefore records both the idea and the corrections that shaped its published presentation.

Source: [cap-talk 2003-August archive](http://www.eros-os.org/pipermail/cap-talk/2003-August/) (Internet Archive original-bytes snapshot `web/20160730011654id_/.../2003-August.txt.gz`, sha256 `5e810c0e`), messages dated 2003-08-22 to 2003-08-29.
