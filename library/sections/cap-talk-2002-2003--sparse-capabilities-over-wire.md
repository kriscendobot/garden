---
title: "Sparse capabilities over the wire"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-December/
source_snapshot: http://web.archive.org/web/20160730003013id_/http://www.eros-os.org/pipermail/cap-talk/2002-December.txt.gz
source_content_sha256: 18e3e510f1edc6bce4808c1dce5a6a00428969cbc3f9ed1856ad2beece5d7d12
source_authors: [Wes Felter, Ben Laurie, Mark S. Miller, Constantine Plotnikov]
source_date: 2002-12-12 to 2002-12-15
thread_subject: "security via capabilities / database wire protocols"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, captp]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Asked how a database wire protocol can carry unforgeable authority, Felter names the two standard representations: signed certificate chains (SDSI/SPKI) and sparse capabilities, large random `swissNumber` bearer secrets as used by E. A local export table maps each random number to an object reference; serialization replaces references with numbers; revocation deletes the table entry. The thread points to CapTP/VatTP as the object protocol and shows an application-level capability design pressure: conventional RDBMS authorization is coarse ACL policy, so applications commonly become all-powerful deputies. Fine-grained spaces or objects can instead be the units of designation and authority.

## Representation and protocol

Unforgeability need not mean signing every authority. A sufficiently sparse random namespace makes guessing infeasible, so legitimate introduction is the only practical acquisition path. The table is both the resolver and a revocation boundary. This is a representation choice inside a larger protocol: secure transport, object introduction, and reference lifecycle remain separate concerns.

## Database authority

Plotnikov notes that conventional applications often connect as one database user and reimplement all finer authorization in application code. The responses sketch capability-bearing tuple spaces and a persistent active object database, where possession of a space or object reference grants the corresponding operations. This is exploratory rather than a settled design, but it identifies the confused-deputy risk in the usual one-credential-per-application architecture.

Source: [cap-talk 2002-December archive](http://www.eros-os.org/pipermail/cap-talk/2002-December/) (Internet Archive original-bytes snapshot `web/20160730003013id_/.../2002-December.txt.gz`, sha256 `18e3e510`), messages dated 2002-12-12 to 2002-12-15.
