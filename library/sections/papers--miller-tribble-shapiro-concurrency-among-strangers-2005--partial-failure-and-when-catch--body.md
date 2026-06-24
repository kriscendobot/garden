---
title: Body
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
source_paper_pages: "215-221 (§9 Partial Failure, §10 The When-Catch Expression)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
ingested_via: orchestrator-direct-draft (subagent path twice filtered on this content)
topics: [capability-theory, eventual-send, persistence]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch
---

### §9 The partial-failure framing — what fails, and how the reference graph reflects it

The paper opens §9 by naming three classes of failure that aren't program behavior: network outages (partitioning one part of the network from another), transient machine failure (sometimes rolling back to a previous stable state), and permanent machine failure (making hosted objects forever inaccessible). From a machine that cannot reach a remote object, distinguishing among these is generally impossible; surviving components must continue providing valuable and correct — though possibly degraded — service while other components are inaccessible. The §9 framing is that there's *no single best strategy* for maintaining consistency across partition and merge; a general-purpose framework should provide simple mechanisms adequate for many strategies, leaving the choice of strategy to the components themselves.

E's contribution at this layer is to extend the reference-state machine. Figure 5 (page 216) shows the full state diagram: the *UNRESOLVED* region (subdivided into local-promise and vat-crossing remote-promise) connects via *resolve* transitions to the *RESOLVED* region (subdivided into near, far, and broken). Near and broken are terminal states. The *partition* transition takes vat-crossing references — both unresolved remote promises and far references — to broken. Once a partition occurs, *all* references crossing in a given direction between two vats break simultaneously; even after the partition heals, references broken by that partition stay broken. This is the eventual-common-knowledge mechanism: both endpoints know the connection was lost, without either needing positive acknowledgment of the other's state.

Delivery semantics layer cleanly on this: messages on a reference are delivered in FIFO order until the first failure on that reference, after which no later message will be delivered. Earlier messages will only be delivered if all prior in-order messages were already delivered. This *fail-stop FIFO* discipline relieves senders from waiting for acknowledgment of every prior message before sending later dependent messages — pipelining (§8) is therefore composable with partial-failure handling without the latency cost of a synchronous acknowledgement protocol.

The §9 working example is the statusHolder listener pattern from earlier sections, now considered under partition. If a partition separates the account's vat from the spreadsheet's vat, the statusHolder's reference to the spreadsheet's listener eventually breaks with a partition-exception. Of the `statusChanged` messages sent by the statusHolder, this reference will deliver them reliably in FIFO order until it fails. Once it fails, it never delivers any further message and will eventually become visibly broken. The defensive consistency guarantee survives the partition: a defensively consistent program that makes no provisions for partition *remains defensively consistent*. In the listener example, `statusChanged` notifications sent to broken listener references (e.g. broken because the connection to its subscriber vat was severed) are harmlessly discarded.

### §9.1 Handler registration — `_whenBroken`, `_whenMoreResolved`, `_reactToLostClient`

To explicitly manage failure of a reference, an object registers a *handler*, eventually notified when that reference becomes broken. The paper shows the augmented `addListener` from the statusHolder:

```
to addListener(newListener) {
    myListeners.push(newListener)
    newListener <- statusChanged(myStatus)
    def handler() { remove(myListeners, newListener) }
    newListener <- _whenBroken(handler)
}
```

`_whenBroken` is one of a handful of universally-understood messages that all objects respond to by default. The handful named in §9.1:

- **`_whenBroken(handler)`** — registers `handler` to be notified when this reference breaks.
- **`_whenMoreResolved(handler)`** — registers `handler` to be notified when the reference is first resolved (used through the when-catch surface syntax described in §10).
- **`_reactToLostClient(exception)`** — sent by E *to* the target object when a vat-crossing reference to it breaks, notifying the target that some of its clients may no longer be able to reach it.

Near references and local promises don't special-case these messages; they deliver them like any other message. Objects ignore `_whenBroken` by default since they're not broken. A broken reference responds to `_whenBroken(handler)` by eventual-sending a notification, equivalent to `to _whenBroken(handler) { handler <- run() }`. When a local promise gets broken, its messages are forwarded to the broken reference, which then notifies the registered handler.

The mechanical subtlety the paper calls out: a vat-crossing reference registers the handler argument of a `_whenBroken` message **at the tail end of the reference, within the sending vat**. If the sending vat is later told the reference has resolved, it re-sends equivalent `_whenBroken` messages to the resolution. If the sending vat decides a partition has occurred (e.g. an internal keep-alive timeout has been exceeded), it breaks all outgoing references and notifies all registered handlers. The implication: handler-registration outlives the broken connection because it lives on the sender's side; an object that wants to be notified of failure doesn't have to maintain its own reachability to the broken counterpart.

Handler behavior is built into E's references only as eventual-sends, *never* as immediate-call control-flow interruption. The statusHolder continues to harmlessly use the broken reference to the spreadsheet's listener until the handler reacts — contingency concerns are thus handled separately from normal operation, not interleaved with it.

The complementary side is the `_reactToLostClient` notification on the target end. When a vat-crossing reference is severed by partition, the target object receives `_reactToLostClient`, notifying that at least one of its clients may no longer be able to send messages. Default behavior is to ignore it (since work-was-lost is one of several plausible causes); the spreadsheet might override to update its display:

```
to _reactToLostClient(exception) { ...update display... }
```

Notifications fire eventually at both ends of a severed vat-crossing reference. Connectivity is safely severed by partition, and objects on either side can react if they wish.

### §9.2 Offline capabilities — `captp://...` URIs and `SturdyRef`

Live references can re-establish themselves *while* a connection persists, but a reference that breaks because of partition is terminal. Re-establishing access across partition requires a new kind of artifact: an **offline capability**. Two surface forms exist:

- A **`captp://...`** URI string — a serializable reference suitable for storage or message-passing as plain text.
- An encapsulated **`SturdyRef`** object — the same information held as a first-class E object, which can be sent between vats by pass-by-copy.

Both forms contain the same triple:

1. **The fingerprint of the public key** of the vat hosting the target object.
2. **A list of TCP/IP location hints** to seed the search for a vat that can authenticate against this fingerprint.
3. **A *swiss-number*** — a large unguessable random number which the hosting vat associates with the target.

The paper's name for the cryptographic discipline: "Like the popular myth of how Swiss bank account numbers work, one demonstrates knowledge of this secret to gain access to the object it designates. Like an object reference, if you do not know an unguessable secret, you can only come to know it if someone who knows it and can talk to you chooses to tell it to you." An offline capability is therefore a form of *password capability* — it contains the cryptographic information needed both to authenticate the target and to authorize access to it.

Both forms are pass-by-copy and can travel between vats even when the vat of the target object is inaccessible. Offline capabilities don't directly convey messages to their target; to establish or re-establish access, one makes a new live reference *from* an offline capability. Doing so initiates a connection attempt to the target vat and immediately returns a promise for the resulting inter-vat reference. If the connection attempt fails, this promise is eventually broken.

The paper recommends a recovery pattern: *don't* try to recover the detailed state of all in-flight plans between two vats that lost connectivity. Instead, applications on either end should spawn a fresh structure from the small number of offline capabilities from which the complex structure was originally spawned. The two sides may need to explicitly reconcile to re-establish distributed consistency. In the listener example, the better design would be for *the listener* to hold an offline capability to the statusHolder (not the other way around — that puts the burden on the wrong party). The listener's `_reactToLostClient` method would attempt to reconnect to the statusHolder and resubscribe on the promise for the reconnected statusHolder. If between disconnect and reconnect the statusHolder is no longer relevant (perhaps the spreadsheet originally encountered this statusHolder by navigating from a parent collection that has since changed), a better design holds an offline capability only to the collection as a whole — and the spreadsheet navigates afresh on reconcile.

The §9.2 closing observation: separation of references from offline capabilities encourages programming patterns that separate reconciliation concerns from normal operations. Live references are the substrate for the steady-state plan; offline capabilities are the substrate for re-establishing the plan after disruption.

### §9.3 Persistence — vat incarnations, checkpoints, durable offline capabilities

For an object designated only by references, the hosting vat can tell when it is no longer reachable and can garbage-collect it. Once an offline capability is made *to* a given object, the vat can no longer determine when the object is unreachable; it must retain the swiss-number ↔ object association until the obligation to honor the offline capability expires.

The paper names three policies for ending that obligation:

- **Time-to-live (`durable` but expiring)** — the association expires at a chosen future date.
- **Revocable** — the association can be explicitly cancelled.
- **Transient** — the association expires when the hosting vat crashes.

§9.3 focuses on the contrast between *transient* and **durable** — associations that are not transient. A vat can be **ephemeral** (existing only until it terminates or crashes; transient durability is irrelevant) or **persistent** (periodically *checkpointing* its persistent state to non-volatile storage). A vat checkpoints only **between turns**, when its stack is empty — this is the architectural reason E's turn-boundary serves so many roles: persistence boundary, message-delivery boundary, and the unit of sequential execution all coincide.

A crash terminates a vat-incarnation, rolling it back to its last checkpoint. Reviving the vat from checkpoint creates a *new incarnation of the same vat*. A persistent vat lives through a sequence of incarnations; the vat's identity is preserved across the crash boundary by the public/private key pair that lives in the persistent state.

The persistent state itself is determined by **traversal from persistent roots**. This includes:

- The vat's public/private key pair (so later incarnations can authenticate).
- All unexpired durable swiss-number associations.
- State reached by traversal from there.

When the traversal reaches an offline capability, the offline capability itself is saved but its target is not traversed (target lives in a different vat). When the traversal reaches a vat-crossing reference, *a broken reference is saved instead* and the reference is again not traversed. Should this vat be revived from this checkpoint, old vat-crossing references will be revived as broken references — precisely correct since the counterparty cannot be presumed to have matching state through a crash. Following a revival, only offline capabilities in either direction enable reconnection.

The crash-as-partition framing is crisp: "A crash partitions a vat from all others." The same broken-reference machinery that handles network partition handles vat-revival; nothing new needs to be added at the protocol level.

### §10 The when-catch expression — surface syntax for handler registration

The `_whenMoreResolved` message can be used to register for notification when a reference resolves. Typically this message is used *indirectly* through the **"when-catch" syntax**:

```
when (promise) -> {
    /* code that runs if promise resolves to a value */
} catch exception {
    /* code that runs if promise is broken */
}
```

The when-catch expression takes a promise, a "when" block to execute if the promise resolves to a value, and a "catch" block to execute if the promise is broken.

The §10 worked example is `asyncAnd`, the natural eventual-send conjunction:

```
def asyncAnd(answers) {
    var countDown := answers.size()
    if (countDown == 0) { return true }
    def [result, resolver] := Ref.promise()
    for answer in answers {
        when (answer) -> {
            if (answer) {
                countDown -= 1
                if (countDown == 0) {
                    resolver.resolve(true)
                }
            } else {
                resolver.resolve(false)
            }
        } catch exception {
            resolver.smash(exception)
        }
    }
    return result
}
```

`asyncAnd` takes a list of promises for booleans and returns a single promise representing the conjunction. The returned promise must eventually resolve true if all elements of the list become true, or false if any of them become false, or broken if any of them break.

If the list is empty, the conjunction is true right away. Otherwise, `countDown` tracks how many true answers are still needed; each time an answer resolves to true, `countDown` decrements; when `countDown` reaches zero the result resolves true. Any false answer immediately resolves the result false. Any broken answer is handled by the `catch` clause, which calls `resolver.smash(exception)` to break the result by the same exception.

The mechanism here lets `asyncAnd` *test each answer as it becomes available* and report a result as soon as it has enough information. The §10 line summarizing the architectural payoff: the **if** statement requires control-flow data (a boolean answer to branch on); when-catch postpones the `if` until that data is available. Promise-chaining (§8) postpones plans by *data-flow* (queuing messages on unresolved promises); when-catch postpones plans until the data needed for *control-flow* is available. Together they cover the full space.

The §10 closing example illustrates the composition with a reselling application:

```
def allOk := asyncAnd([inventory <- isAvailable(partNo),
                      creditBureau <- verifyCredit(buyerData),
                      shipper     <- canDeliver(...)])
when (allOk) -> {
    if (allOk) {
        def receipt := supplier <- buy(partNo, payment)
        when (receipt) -> {
            ...
        }
    }
}
```

Three independent validity checks (inventory, credit, delivery) are issued concurrently; `asyncAnd` joins them; the outer when-catch waits for the conjunction; the inner when-catch waits for the purchase receipt. No checks are serialized unnecessarily.
