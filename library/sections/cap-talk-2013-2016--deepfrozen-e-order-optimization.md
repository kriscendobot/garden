---
title: "DeepFrozen values narrow the need for E-order"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-October.txt.gz
source_content_sha256: 095b711d4d0b4f7a9be06c84817306b28e4baefda16ed35aa33b4ca0fd67010c
source_authors: [Kevin Reid, Mark S. Miller, Alan Karp]
source_date: 2013-10-02 to 2013-10-03
thread_subject: "E-order can be optimized out of CapTP for DeepFrozen objects"
ingested: 2026-09-16
ingested_by: scholar
topics: [captp, eventual-send, distributed-objects]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Reid proposes bypassing E-order delays for messages to stateless `DeepFrozen` objects, then weakens the claim after a counterexample: the safe condition is that the receiver **and the arguments** are DeepFrozen. Otherwise a stateless receiver can still observe or cause stateful effects through an argument, and reordering two calls can reverse later sends. The optimization therefore depends on transitive immutability of the whole authority-bearing input graph, not merely the target's local fields.

Miller notes that CapTP may already deliver a message to the destination machine early; E-order constrains when effects become observable, not necessarily network arrival. Karp recalls that speculative execution still needs failure recovery. The thread is a compact warning for transport optimization: “pure target” is insufficient when arguments carry authority.

Source: [cap-talk 2013-October archive](http://www.eros-os.org/pipermail/cap-talk/2013-October/) (Internet Archive original-bytes `id_` snapshot of `2013-October.txt.gz`, sha256 `095b711d`), thread "E-order can be optimized out of CapTP for DeepFrozen objects", 2013-10-02 to 2013-10-03.
