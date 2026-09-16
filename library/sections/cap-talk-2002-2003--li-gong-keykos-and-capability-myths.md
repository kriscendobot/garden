---
title: "Li Gong, KeyKOS, and the capability myths"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-July/
source_snapshot: http://web.archive.org/web/20160729202529id_/http://www.eros-os.org/pipermail/cap-talk/2003-July.txt.gz
source_content_sha256: f06b013d9e348eccab8e0e2285105f77db40ba85149888469a64bf89b258438e
source_authors: [Mark S. Miller, Constantine Plotnikov, David Hopwood, Norman Hardy, Charles Landau]
source_date: 2003-07-09 to 2003-07-13
thread_subject: "Li Gong on KeyKOS"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: While revising *Capability Myths Demolished*, Miller finds Li Gong's 1988 paper acknowledging that KeyKOS can enforce properties Gong's later ICAP work helped portray as impossible for capabilities, then excluding KeyKOS as a special "fully armed" system. The list cannot find a coherent distinction between that category and an ordinary partitioned capability OS whose capability bits remain protected system state. Plotnikov identifies a deeper category error: ACL reasoning treats authentication of the request source as intrinsic to authorization, while a capability model authorizes by possession and locates authentication below the model (secure vat transport) or above it (login grants initial capabilities). The thread is an explicit primary-source reaction to the literature the 2003 paper set out to correct.

## Why the exception matters

Treating a working counterexample as outside the model lets a weak capabilities-as-rows or capabilities-as-keys model stand in for implemented object-capability systems. The participants instead insist that KeyKOS's partitioning and protected references are normal parts of the model to be explained.

## Authentication is not authorization

An ACL asks who issued a request and consults policy attached to a resource. A capability request carries its authorization in the invoked reference. Authenticating a vat or a human may still be necessary to establish an initial channel, but it is not repeated as the access-control decision for every operation. This distinction helps explain why an access-matrix critique can miss the behavior of object-capability systems.

Source: [cap-talk 2003-July archive](http://www.eros-os.org/pipermail/cap-talk/2003-July/) (Internet Archive original-bytes snapshot `web/20160729202529id_/.../2003-July.txt.gz`, sha256 `f06b013d`), messages dated 2003-07-09 to 2003-07-13.
