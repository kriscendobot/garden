---
title: Async Flow States (Running / Sleeping / Replaying / Failed / Done)
source: packages/async-flow/docs/async-flow-states.md
source_repo: agoric/agoric-sdk
source_commit: 1daa37f59b3c89d5af942e6a6bb74a892a07b1fb
source_date: 2024-09-26
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [capability-security, persistence, async-flow]
status: current
notes: A guest async-function activation in async-flow is internally an exoClass instance; the lifecycle here is the exoClass-instance lifecycle adapted to durable replay. The "eager waker" option is a configurable tradeoff between revival cost and time-of-first-use cost. The Failed state's "fix via next upgrade" semantic is the key correctness story for forward-compatibility of upgrades that may previously have misbehaved.
---

> Abstract: A prepared guest async function is internally an exoClass; each `wrapperFunc(...)` call creates an activation. The activation's lifecycle: **Running** (initial state, actions cause actual effects and are logged for replay), **Sleeping** (across an upgrade; awaiting a vow with the log intact and PC reset), **Replaying** (catch-up via the durable log; transitions back to Running when caught up), **Failed** (inactive state from replay misbehavior or `asyncFlow`-mechanism failure; cleared at the next reincarnation, which retries Replaying then Running), **Done** (the guest's outcome promise settled; bookkeeping is dropped). The activation can be optionally configured to be an "eager waker" — revival immediately starts Replaying instead of waiting for an awaited vow to settle.

# Async Flow States

![async flow state diagram](./async-flow-states.png)

A prepared guest async function is like an exoClass (and is internally implemented by an exoClass). It is primarily represented by the host wrapper function that `asyncFlow` returns. Each call on that wrapper function creates an activation of that guest function. A guest activation is like an exoClass instance (and is internally implemented as an instance of the function's internal exoClass). The state diagram shows the lifecycle of a guest function activation:

- ***Running***. Invoking the wrapper function creates an activation that is initially in the ***Running*** state. Actions the guest takes in the ***Running*** state, like invoking a host-provided API, cause actual effects and are also recorded for replay. The log records both actions initiated by the guest such as `checkCall`, and actions initiated by the host such as `doFulfill`. But it both cases it logs only host-side objects, since the log needs to survive an upgrade.

- ***Sleeping***. An activation that was ***Running*** just before an upgrade revives into the new incarnation in the ***Sleeping*** state ready to replay from scratch once it awakens. The previous log is intact, but the log's "program counter" is reset to zero. The membrane bijection starts empty since no guest object survives an upgrade. Since an upgrade can only happen between cranks, and therefore between turns, the ***Running*** activation must have been awaiting a vow. When a vow settles, then any ***Sleeping*** activation that might have been awaiting that vow wakes and starts ***Replaying***. An activation can also optionally be configured to be an "eager waker". On revival, a ***Sleeping*** eager waker immediately wakes and starts ***Replaying***. The tradeoff is when to pay the costs of replay.

- ***Replaying***. To start ***Replaying***, the activation first translates the saved activation arguments from host to guest, invokes the guest function, and starts the membrane replaying from its durable log. The replay is finished when the last log entry has been replayed. Once replaying is finished, the activation has caught up and transitions back to ***Running***.

- ***Failed***. If the guest activation misbehaves during the ***Replaying*** state (by failing to exactly produce its previously logged behavior) or during the ***Running*** state (by an invalid or unsupported interaction with the `asyncFlow` mechanism), it goes into the inactive ***Failed*** state, with a diagnostic explaining how the replay failed, so it can be repaired by another future upgrade. As of the next reincarnation, the failure status is cleared and it starts ***Replaying***, then ***Running*** again, hoping not to fail this time. If replay or running failed because the previous guest async function misbehaved, then to make progress, an upgrade needs to replace the function with one which behaves correctly. If a ***Replaying*** or ***Running*** guest failed because of a failure of the `asyncFlow` mechanism, whether a bug or merely hitting a case that is not yet implemented, then an upgrade needs to replace the relevant part of the `asyncFlow`'s mechanism.

- ***Done***. The guest async function invocation returned a promise for its eventual outcome. Once that promise settles, we assume that the job of the guest activation is done. It then goes into a durably ***Done*** state, dropping all its bookkeeping beyond just remembering the corresponding settled outcome vow, and that it is ***Done***. The replay logs and membrane state of this activation are dropped, to be garbage collected.

Source: [packages/async-flow/docs/async-flow-states.md](https://github.com/Agoric/agoric-sdk/blob/1daa37f59b3c89d5af942e6a6bb74a892a07b1fb/packages/async-flow/docs/async-flow-states.md) at commit `1daa37f5`.
