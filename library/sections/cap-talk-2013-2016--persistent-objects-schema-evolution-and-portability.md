---
title: "Persistent objects, schema evolution, and data portability"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-January.txt.gz
source_content_sha256: ab55d60dbe97a5b53df7c9920f9ea9aba4fe67d974408eb676f3727ab5da3324
source_authors: [Dan Connolly, Raoul Duke, Marc Stiegler, Mark S. Miller, David Barbour, Bill Frantz, Rob Meijer]
source_date: 2013-01-08 to 2013-01-10
thread_subject: "What does the SQL storage of a cap-based application looks like?"
ingested: 2026-09-16
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The durability argument between object checkpoints and relational data separates three concerns that are too easily collapsed: preserving a live authority graph, preserving queryable bulk data, and migrating state across code versions or language implementations. Connolly's warning that old data may outlive the code needed to decode an object store meets three different answers: Stiegler recommends keeping large, arbitrarily queried records in a DBMS while checkpointing behavior and system-model state; Miller contrasts E's explicit Data-E save/restore with Waterken's improved orthogonal persistence and KeyKOS's automatic persistence plus explicit upgrade serialization; and the thread agrees that cross-language wire access does not imply that one runtime can directly open another runtime's checkpoint.

The practical split is enduring. A checkpoint is valuable because it preserves object identity and authority without application save code, but its decoder and class definitions become part of the long-term compatibility surface. A data format can be implementation-neutral, but manual save/restore and schema evolution become application obligations. Automatic persistence therefore does not make upgrade orthogonal by itself: a system still needs an intentional boundary for the state that survives code replacement.

## Bearing on Endo

Endo's durable vats and formula persistence should state which layer supplies each guarantee. Durable object identity is not the same promise as portable archival data, and neither is a substitute for an explicit upgrade schema. Applications with large queryable datasets should not force that data through an authority-graph checkpoint merely because the runtime can persist it.

Source: [cap-talk 2013-January archive](http://www.eros-os.org/pipermail/cap-talk/2013-January/) (Internet Archive original-bytes `id_` snapshot of `2013-January.txt.gz`, sha256 `ab55d60d`), thread "What does the SQL storage of a cap-based application looks like?", 2013-01-08 to 2013-01-10.
