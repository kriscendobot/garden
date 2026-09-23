---
section: llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
source: endo-but-for-bots--llm-designs-endopi-edit-tool
topics: [agent-conventions]
status: current
title: File-mutation queueing — *eventual-send semantics already
parent: endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation
---

serialize*

The §File-mutation queueing subsection is the most structurally
interesting *what-Pi-does-Endo-doesn't-need-to-do* observation:

> *Pi serializes edits/writes to the same file through a queue
> (`file-mutation-queue.ts`) so concurrent tool calls cannot
> interleave mid-write. Endo's eventual-send semantics already
> serialize per capability if all writes go through one exo;
> explicit queueing is unnecessary as long as the tool
> implementation does not split read-modify-write across multiple
> awaits without holding a lock.*

This is the *Endo-already-has-this-discipline-structurally* move
visible in cycle 121's family keystone: the comparative-mapping
mode keeps explicit Pi mechanisms only where Endo lacks an
equivalent structural property. Eventual-send + exo-per-File makes
the queue redundant — *one capability serializes its own writes by
construction*.

The §caveat is the *single-await-per-method discipline*: as long
as the implementation doesn't split read-modify-write across
multiple awaits without holding a lock, the per-capability
serialization holds. That's the same TOCTTOU concern cycle 118's
exo-tools.js raised for context lookup (*Get the context after all
waiting in case we ever do revocation by removing the context
entry. Avoid TOCTTOU!*).
