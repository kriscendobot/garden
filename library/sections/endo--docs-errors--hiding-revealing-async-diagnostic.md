---
title: Hiding and Revealing Asynchronous Diagnostic Information
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, eventual-send]
status: current
notes: Section is plans-only. Tracked at https://github.com/Agoric/agoric-sdk/issues/1862 and https://github.com/Agoric/agoric-sdk/issues/1864.
---

> Abstract: Plans (not implemented) for "deep asynchronous stacks." Restricting instrumentation to `E()` and `E.when` (rather than `Promise.prototype.then`, which platform code calls implicitly in ways user code cannot override) preserves predictability and platform independence at the cost of some diagnostic completeness. Each `E()` or `E.when` would create a hidden error associated with the turn it causes; recursive logging of annotations reconstructs a deep-stack causal chain backward (and a tree forward). Memory pressure from accumulating deep annotation trees needs a bounded data structure.

## Hiding and Revealing Asynchronous Diagnostic Information

This section explains our *plans* to build a logging experience on top of this system that supports local and distributed asynchrony. Also tracked at [Support deep stacks for local asynchronous log-based debugging #1862](https://github.com/Agoric/agoric-sdk/issues/1862) and [Support distributed deep stacks for log-based debugging #1864](https://github.com/Agoric/agoric-sdk/issues/1864).

JavaScript itself is not a dustributed language, but it is a highly asynchronous language. Our distributed computational model (communicating event loops) pushes much of our code into making heavy use of this asynchrony. For such code, individual synchronous call stacks are often short and uninformative. [Causeway](https://github.com/Agoric/agoric-sdk/issues/1318#issuecomment-662127549) shows that the asynchronous and distributed analog of synchronous stack traces is a directed acyclic graph of prior causal events, each with their local synchronous stack at their moment of causation. To capture this well requires instrumenting the promise system in ways impossible for user code. However, the most important causal paths are:

* the [eventual-send](https://github.com/tc39/proposal-eventual-send) operations by [handled promise](https://github.com/endojs/endo/blob/master/packages/eventual-send/README.md), whether expressed by `E()` or `~.`.
* the `.then` operation. However, we replace the builtin `Promise.prototype.then` at our peril. Many built in operations implicitly invoke the original binding of `Promise.prototype.then` in ways we cannot override. However, our same eventual-send package already provides a safer alternative `E.when` operation.

Restricting the instrumentation to these two operations gives predictability and preserves platform independence, but at the loss of some useful diagnostic information. This loss may encourage programmers to shift from their current habits to eventual-send and `E.when`, which would be a good thing anyway.

(Note that some IDE debug experiences now include deep stacks over `await` boundaries. However, the engine provides to access to this mechanism from JavaScript. Without it, these stacks are impossible to capture without an invasive code transform.)

Ideally, the diagnostic information produced by such instrumentation should be sent to [other kind of logging system](https://github.com/Agoric/agoric-sdk/issues/1318), for post-processing by other tools. But it is at least possible to encode it in the system described here. The instrumentation would add enough overhead to eventual-send and `E.when` that it should not be the default setting. When the instrumentation is on, each `E()` or `E.when` operation would create a hidden error, to be associated with the turn it causes. When that turn does such an action, the hidden error it similarly creates would be annotated with the hidden error from the action that created this turn. Looking forward, this records a causal tree of events. Looking backward, it creates a linear "deep stack" of events (a sequence of shallow stacks). All this extra bookkeeping remains silent until an error is logged. Once an error is logged, its deep stack is included in the recursive logging of its annotations.

(However, this pattern of use will accumulate deep annotation trees, too deep to keep in memory. Instead we would need to bound the number of annotations we remember, which would require a different data structure.)

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
