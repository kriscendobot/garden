---
title: "Persistence, session failure, and powerboxes"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-March/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2008-March.txt.gz
source_content_sha256: 023fb3241abb9d14f0db2ebf1b5b73bf64c7cd7dc97f7847c166de7db1295d7f
source_authors: [Jed Donnelley, Jonathan S. Shapiro, Mark S. Miller, Alan H. Karp, Sandro Magi, James A. Donald, Kevin Reid, Pierre-Antoine Champin, David-Sarah Hopwood]
source_date: 2008-03-11 to 2008-03-21
thread_subject: "Persistence as a cap value / Session failures"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The persistence thread treats durability as a capability-system dimension, not an invisible implementation detail. Process-local systems such as Plash can deliver strong least authority for running programs while losing their reference graph at termination. Persistent object systems preserve designations across restart, but must define checkpoint consistency, distributed rollback, revocation, and what a caller learns when a session fails.

Shapiro explains that distributed checkpoint consistency can be recovered from the causal ordering of epochs, with rollback and replay between a leading computation edge and a committed trailing edge. That machinery does not erase application-level uncertainty: a remote operation may have happened even when its acknowledgment was lost. Defensive APIs still need idempotency or explicit recovery semantics.

The thread connects persistence to powerbox UI. A project file must not contain forgeable filenames that an application can edit into new authority. The trusted powerbox records or reconstitutes the user's intended references. Persistence is valuable only if restored references retain their authority boundaries rather than becoming ambient names.

Source: [cap-talk 2008-March archive](http://www.eros-os.org/pipermail/cap-talk/2008-March/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2008-March.txt.gz`, sha256 `023fb324`), messages dated 2008-03-11 to 2008-03-21.
