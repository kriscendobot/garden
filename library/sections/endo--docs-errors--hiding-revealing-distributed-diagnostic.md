---
title: Hiding and Revealing Distributed Diagnostic Information
source: docs/errors.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-13
ingested_by: liaison
topics: [errors, captp, marshal]
status: current
notes: Section is plans-only; describes future work. Tracked at https://github.com/Agoric/agoric-sdk/issues/1863.
---

> Abstract: Plans (not implemented) for distributed error diagnostics across mutually suspicious platforms. Errors are sent by copy. Alice's comm system generates an identifier, logs the error association locally, and includes the identifier in the serialization. Bob's comm system annotates the unserialized error with that identifier, so Bob's local logging includes a pointer back to Alice's logs. Open issue: automatic per-send logging is too noisy; bounded in-memory tables are one proposed mechanism.

## Hiding and Revealing Distributed Diagnostic Information

This section explains our *plans* to build a distributed logging experience on top of this system. Also tracked at [Support stack-tracking serialization of error objects #1863](https://github.com/Agoric/agoric-sdk/issues/1863).

Only a local system will have a meaningful notion of "the developer" that should see all hidden diagnostic information. Our overall system is a decentralized fabric of multiple mutually suspicious platforms, including both public and private chains, and public and private non-chains. Alice running private chain A may or may not be willing to release A's logs to Bob, running public chain B, even if it would help Bob diagnose a problem. Our system must support Bob in both scenarios. When Bob can get all the relevant logs, we wish his debugging experience to approximate as close as possible the pleasure of the local debugging experience. When Bob can only get some logs, his ability to debug should degrade gracefully.

Our comm system sends errors by copy. At the level of abstraction of the distributed computation, an error serialized and sent by Alice is the "same" as the error as received and unserialized by Bob. At the JavaScript level of abstraction, they are of course distinct objects. Alice's system holds all this extra hidden information about the error she's sending, that her console uses to output useful diagnostic information. Alice's comm system therefore cannot simply serialize and send this information to untrusted Bob. Instead, Alice's comm system should generate identifying information which allegedly identifies this error. Alice's comm system should include this identifier in the serialization of the error, and it should arrange to locally log the association of this error with this identifier. Bob's comm system, on unserializing the error, should annotate this new error with this identifying information from the unserialization of this error.

If Bob's computation then causes that error to be logged, its local stack trace will uselessly identify the unserialializer as the code that created the error. But the annotation should inform Bob that he should go ask Alice for the logs containing the identified error. With more tooling to make such arrangements more automatic and immediate, the relevant portions of Alice's log could be made to appear to Bob as-if they are available in his own local diagnostic information.

However, the above description violates one of our constraints: The automatic logging of a sent error to Alice's log is noisy, especially if neither that error nor its remote copy would ever otherwise be logged. Ideally, this would instead be handled by that [other kind of logging system](https://github.com/Agoric/agoric-sdk/issues/1318) that produces symbolic output to be post-processed into useful diagnostic information. However, this particular special case is uniquely urgent and might not wait for us to build that other kind of logging system. As one possible mechanism, the comm system could maintain a bounded in-memory table of sent errors. If Bob's request arrive while the identified error is still in Alice's table, and Alice wishes to reveal this info to Bob, Alice can log it then.

Source: [docs/errors.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/errors.md) at commit `fe81477b`.
