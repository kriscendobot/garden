---
section: seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
source: metamask-ocap-kernel--docs-ken-protocol-assessment-md
topics: [daemon, captp, persistence]
status: current
title: The §crank-buffering centerpiece
parent: metamask-ocap-kernel--docs-ken-protocol-assessment-md--seven-Ken-properties-self-assessment-with-crank-buffering-and-savepoint-wrapped-receive-discipline
---

§Crank-buffering (Issue #786) is the implementation of the
§transactional-turns + §deferred-transmission + §output-
validity triad. The model:

```
crank_start(deliver one item from run queue)
  → create database savepoint
  → vat processes message
  → vat syscalls buffer outputs (sends, notifications) in CrankBuffer
crank_end:
  → if success: atomically flush buffer to run queue + commit state
  → if failure: rollback to savepoint, discard buffer
```

The §savepoint-create-then-buffer-then-commit-or-rollback
shape. Five concrete operations listed (lines 75-79):

- `enqueueSend(target, message, immediate=false)` buffers
  sends
- `enqueueNotify(endpoint, kpid, immediate=false)` buffers
  notifications
- `resolvePromises(endpoint, resolutions, immediate=false)`
  buffers all resolution effects
- On successful crank: `#flushCrankBuffer()` moves items to
  persistent run queue
- On rollback: buffer is discarded along with database
  changes

The §immediate-equals-false-by-default observation: all the
enqueue methods take an `immediate=false` parameter. The
*default* is buffering. The §default-safe-default-deferred
discipline.

The §the-key-insight paragraph (lines 81-83) makes the most
important §output-validity argument:

> *When a message destined for a remote reaches `RemoteHandle`,
> it arrives via the run queue. Items only reach the run queue
> after the originating crank commits. Therefore, by the time
> `RemoteHandle` persists and transmits a message, the crank
> that produced it has already committed. The transmitted
> message corresponds to committed local state.*

The §run-queue-as-the-commit-fence discipline: the *run queue*
is the *boundary* between *uncommitted state* and *committed
state*. Anything past the run queue *has been committed*.
Anything before the run queue *is still in a buffer that may
roll back*.
