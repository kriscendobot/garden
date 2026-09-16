---
title: "Reference versus capability"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-January/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-January.txt.gz
source_content_sha256: be281f3e6a7d6713a9751304edbb15cddf46adfe070a5384084d45cc36d31d99
source_authors: [Jed Donnelley, Jonathan S. Shapiro, Mark S. Miller, David Hopwood, Ka-Ping Yee, Toby Murray, Charles Landau, David Wagner, Kevin Reid, Bill Frantz, Alan H. Karp, Rob Meijer]
source_date: 2007-01-08 to 2007-01-20
thread_subject: "Wikipedia: Object-capability model - reference vs. capability?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A long Wikipedia-editing thread asks whether every object reference is a capability. The strongest formulation says yes only inside a disciplined object-capability semantics: the reference must be unforgeable, it must designate the object, and possession must suffice to authorize the operations it exposes. A language reference in a system with ambient globals or separately checked ACLs is not enough to characterize the surrounding security model.

The debate separates the local meaning of one reference from the system-wide acquisition rules. A reference can carry authority while the system still provides ambient ways to obtain more authority. Conversely, a sparse or password representation can implement the same capability behavior without being a machine pointer. The important unit is the behavior available through the reference and the ways references may be acquired.

The thread never reaches a wording that satisfies every participant. It does clarify why "object-capability" is the safer term: it invokes the language/actor lineage and its reference graph, not every operating-system feature historically called a capability.

Source: [cap-talk 2007-January archive](http://www.eros-os.org/pipermail/cap-talk/2007-January/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-January.txt.gz`, sha256 `be281f3e`), messages dated 2007-01-08 to 2007-01-20.
