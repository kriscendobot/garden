---
title: "Persistence and transaction failure"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-September/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-September.txt.gz
source_content_sha256: 010be5fcf0f6dcd963ef7fee29915302180537f19436473e896cb2f8ee14ca22
source_authors: [Jonathan S. Shapiro]
source_date: 1999-09-27
thread_subject: "Persistence and transactions"
ingested: 2026-09-16
ingested_by: scholar
topics: [persistence, capability-security]
status: current
notes: "Derived summary, not the original message."
---

Abstract: Shapiro separates transparent persistence from transaction correctness. Persisting objects that contain capabilities creates circular write-order dependencies, one reason EROS checkpoints the whole system rather than serializing references independently. Yet persistence does not remove ordinary distributed-transaction failures: networks fail, a commit may succeed without its acknowledgment reaching the client, and splitting a check from a later update admits intervening writes. A persistent heap changes recovery mechanics, not these protocol obligations.

## Capability-bearing state motivates system-wide snapshots

Writing an object after the objects it references is not generally possible when the reference graph contains cycles. A system-wide checkpoint captures a mutually consistent graph without requiring a topological write order over capabilities.

## Clients still need failure-aware protocols

A transaction client must tolerate disconnection at any interaction point, including after the server commits. It must avoid a check-then-update split that lets another writer intervene. After recovery, the durable state may prove the commit happened even when the original caller never learned the result, so operations need retry and idempotency semantics above persistence.

The same distinction applies to Endo's durable formulas and vats: reconstructing the object graph after restart is not a substitute for application-level commit agreement.

Source: [cap-talk 1999-September archive](http://www.eros-os.org/pipermail/cap-talk/1999-September/) (Internet Archive original-bytes snapshot, sha256 `010be5fc`), message by Jonathan S. Shapiro, 1999-09-27.
