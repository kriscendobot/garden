---
title: "Waterken persistence, transactions, and failure"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2011-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2011-March.txt.gz
source_content_sha256: 53c919781803551ba1970dcce4f57c44ffc7ad43b9516e77ecb993c36f7f6256
source_authors: [Raoul Duke, Marc Stiegler, Tyler Close, David Wagner, Alan Karp]
source_date: 2011-03-01 to 2011-03-04
thread_subject: "small notes re: waterken"
ingested: 2026-09-16
ingested_by: scholar
topics: [distributed-objects, persistence, eventual-send, programming-language-design]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Raoul Duke's review of the Waterken tutorial exposed the contract behind its persistent vats. A turn is a transaction: changes to both purses become durable together at the end-of-turn checkpoint, while a crash during the turn commits neither. A normal exception is returned as a broken promise and the turn may still checkpoint, so code must ensure no exception can occur after only part of an invariant has changed. Marc Stiegler defended the tutorial's simplified purse as correct under its stated one-currency assumptions, while David Wagner warned that Java can throw at surprising points, including compiler-inserted casts. Joe-E makes `VirtualMachineError` fatal to avoid checkpointing after unpredictable resource failures. The thread links eventual-send syntax, promise representation, durable serialization, schema evolution, and exception discipline into one persistence boundary.

## Turn transactions and broken promises

Waterken checkpoints a vat after a turn. If the server crashes during a purse transfer, no checkpoint is taken and neither balance changes. If ordinary code throws after mutating only one balance, the exception becomes a broken promise and the checkpoint can preserve the partial update. Stiegler's tutorial arranges for its only expected cast failure to occur before either balance changes. Wagner's objection is broader: Java exceptions are not always visible at the source location a reviewer expects, especially with generic heap pollution. Joe-E's response is to make unpredictable virtual-machine failures fatal, preventing recovery from accidentally treating them as an application-level broken promise.

## Host-language seams

The tutorial also reveals Java-specific asymmetries. Interfaces can be dynamically implemented by promise proxies, so a promise for interface `Foo` can itself be used as a `Foo`; final concrete classes such as `String` require an explicit `Promise<String>`. Java serialization gives straightforward persistence but makes application schema evolution a hard problem. Stiegler accepts a concrete cast as a compact rights-amplification mechanism for the one-currency tutorial, while acknowledging that multiple currencies require an additional brand check or a sealer/unsealer construction.

## Bearing on Endo

Endo's crank boundary inherits the good part of this model: delivery and durable state transition need one explicit atomic unit, and promise rejection carries application failure without corrupting committed state. Durable object code must still distinguish an expected rejection from a vat-fatal invariant failure. Persisted state should use an explicit, upgradeable data schema rather than serializing live closure layout. The thread is a warning that transactional semantics depend on the host language's complete failure surface, not only the exceptions application code intended to throw.

Source: [cap-talk 2011-March archive](http://www.eros-os.org/pipermail/cap-talk/2011-March/) (Internet Archive original-bytes `id_` snapshot of `2011-March.txt.gz`, sha256 `53c91978`), thread "small notes re: waterken", 2011-03-01 to 2011-03-04.
