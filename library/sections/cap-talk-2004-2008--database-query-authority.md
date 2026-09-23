---
title: "Database queries as capability-bearing closures"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-April/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-April.txt.gz
source_content_sha256: f703bd57321173a188c122853cad9f2c048fb31d7e82e4cea48d4ea0f4c3d9dc
source_authors: [John Carlson, David Hopwood, Marc Stiegler, Jonathan S. Shapiro, Ian Grigg, Jed Donnelley, Ben Laurie]
source_date: 2005-04-06 to 2005-04-25
thread_subject: "capabilities for databases and database-like systems; More on capabilities for query languages"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A database capability need not authorize arbitrary SQL over a named global table. It can be a reference to a closure whose captured table capabilities and fixed query plan define its authority, with callers supplying only constrained parameters. This makes database authority compositional and lexically scoped rather than another identity check at the database boundary.

John Carlson proposes protecting parameterized query sentences and returning capability groups. David Hopwood sharpens the design: table identifiers in the query language should be actual references, not strings resolved through a global namespace, and a restricted query is simply a closure that captures the capabilities it needs. The capability substrate therefore needs no database-specific primitive. Query construction, joins, projections, and updates become ordinary object interfaces whose implementations close over narrower table or view facets.

The thread is an early statement of a pattern Endo can use for data services: compile a request into a hardened callable object, inject only the source facets it may consult, and expose parameters through guards. The resulting authority is visible in the closure's endowments and cannot grow merely because the caller knows another table name.

Source: [cap-talk 2005-April archive](http://www.eros-os.org/pipermail/cap-talk/2005-April/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-April.txt.gz`, sha256 `f703bd57`), messages dated 2005-04-06 to 2005-04-25.
