---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §receive-side savepoint-wrapped processing
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

The §receive-side-implementation section (Issue #808) shows
the *implementation in TypeScript*:

```typescript
const savepointName = `receive_${this.remoteId}_${seq}`;
this.#kernelStore.createSavepoint(savepointName);
try {
  // Process message (translate refs, add to run queue, etc.)
  switch (method) {
    case 'deliver': ...
    case 'redeemURL': ...
    case 'redeemURLReply': ...
  }
  this.#kernelStore.setRemoteHighestReceivedSeq(this.remoteId, seq);
  this.#kernelStore.releaseSavepoint(savepointName);
} catch (error) {
  this.#highestReceivedSeq = previousHighestReceivedSeq;
  this.#kernelStore.rollbackSavepoint(savepointName);
  throw error;
}
```

The §savepoint-with-named-rollback-on-throw shape. Four
concrete moves:

1. **Create savepoint** with a *deterministic name* (`receive_
   ${remoteId}_${seq}`).
2. **Process the message** inside the savepoint.
3. **Update `highestReceivedSeq` at the end** (within the
   savepoint).
4. **On error**: rollback the savepoint *and* revert the
   in-memory `highestReceivedSeq` to its previous value.

The §revert-in-memory-state-too-not-just-the-database
observation. The savepoint rolls back *database* state; the
catch block separately reverts *in-memory* state
(`this.#highestReceivedSeq = previousHighestReceivedSeq`).
Without that line, the in-memory state would diverge from the
database after rollback — a subtle bug source.

The §deterministic-savepoint-name discipline: `receive_
${remoteId}_${seq}` encodes the *coordinate* of the savepoint
(*which* message). If multiple savepoints are nested or
debugger-inspected, the name pinpoints which one is which.
