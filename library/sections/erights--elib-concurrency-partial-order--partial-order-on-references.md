---
title: "Partially-Ordered Message Delivery: full order (two-party), tree order (three-party), partial order"
source_kind: web
source_url: http://erights.org/elib/concurrency/partial-order.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/partial-order.html
source_fetched_via: mirror
source_content_sha256: 340e9bbfb33e67b414b84d2ec1dc48f9bf422a8e5ef75df27d285a72702fd70a
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The delivery-ordering spec the queuing
  chapter says the FIFO event queue over-specifies: two-party single-reference =
  full order; three-party Granovetter (a reference forked into a sent message) =
  tree order; four-party grant-matching = partial order. Topology is in the
  specification only; the implementation may collapse to any consistent full
  order. The "just enough distributed sequentiality" guarantee `@endo/eventual-send`
  and CapTP inherit. source_date is an era approximation matching the sibling
  concurrency chapters.
---

## Abstract

The chapter that specifies **how much delivery order E guarantees** — "just enough
distributed sequentiality." For two parties communicating on a **single reference**
(successive `<-` sends), E guarantees **fully order-preserving delivery**: messages
arrive in send order until the reference breaks (a partition), after which none
arrive; so if any message is delivered, all earlier ones on that reference already
were. For **three parties** (the Granovetter case, where Alice shares her reference
to Carol with Bob inside a sent message), the same full-order guarantee cannot hold
across vats and is not needed; instead the shared reference is **forked**, and the
guarantee becomes a **tree order**: a message may be delivered only when nothing
precedes it in the reference topology. For **four-party grant-matching** the
guarantee is a genuine **partial order**. Crucially, the message topology lives **in
the specification only, not the implementation**: an implementation may deliver in
any full order consistent with the specified partial order (Bill Frantz's
observation that here the spec is more "expensive" than the implementation). The
spec is also tightened for **security**: even a malicious vat must be unable to
deliver a message to Carol ahead of the messages Alice already sent her. This is the
ordering discipline `@endo/eventual-send` and CapTP preserve.

## Two-party on a reference: full order

Among messages successively sent on a **single** reference (the `<-` operator), E
guarantees **fully order-preserving delivery**. All messages are delivered in the
order sent, unless and until the reference **breaks** (a partition, a communications
failure between vats); once it breaks, no further messages are delivered. So if a
particular message is delivered, all messages sent earlier on the same reference were
already delivered.

Consequently, once Alice has sent message X to Carol, Alice should think of the
reference she now holds as a **reference to the Carol that has already seen X** —
even though Carol has not yet seen X and may never (a communications failure Alice
does not yet know about). Either way, Alice no longer has any ability to deliver a
message to Carol **before** Carol sees X, and if Carol does not see X she will see no
further messages Alice sends on this reference after X. (If Alice and Carol are in
the same vat and Alice has a NEAR reference, Alice can still immediately **call**
Carol, possibly delivering a message ahead of earlier eventually-sent ones; the
chapter otherwise ignores NEAR references and immediate calls.)

## Three-party Granovetter: tree order via forking

The two-party full order lets the Alice-to-Carol protocol be naively stateful. But
the guarantee cannot be afforded once there are three parties in three vats: if Alice
shares her reference to Carol with Bob, it would be unreasonable (and unnecessary) to
require Carol to see Alice's and Bob's messages in their global-time send order —
Alice and Bob should not care how their actions interleave in global time.

Yet a naive implementation would be **too weak**. After Alice sends X on her
reference to Carol, that reference represents (to her) only the ability to talk to
**the Carol that already received X**. If Alice sends that reference to Bob in
message Y, and Bob uses it to send W to Carol, variable network delays could let W
arrive **before** X — handing Bob a dangerous ability beyond Alice's notion of the
reference's meaning. To prevent this, when a reference is included as an argument of
an eventually-sent message (as Alice's reference to Carol is included in Y), the
reference is **forked**: Bob receives not the reference Alice sent but a **fork** of
it, diagrammed at the fork-position on the reference between the two messages.

By these rules the **tree of messages connected by the reference topology is the
partial order itself**. As of any state, the messages deliverable to Carol are those
with nothing ahead of them in the topology. The message Bob receives from Alice is
**as safe in Bob's hand as in Alice's**: the assumptions Alice needs for her own
sanity remain valid as she delegates to Bob.

## Topology is specification, not implementation

The topology is **in the specification only**. The implementation is free to deliver
messages to Carol in any full order consistent with the specified partial order, so
it can collapse partial orders to full orders whenever convenient. As **Bill Frantz**
observed, this is one of those rare cases where the specification is much more
"expensive" than the implementation.

Although the motivation is **correctness in the face of error**, the spec is tightened
to handle **security in the face of malice**: even if Bob is hosted in a tampered vat
VatB that does not play by the rules, the protocol must constrain VatB to be unable to
deliver a message to Carol ahead of X. (The simplified protocol in the **Ode**
violates this property.) VatA must not communicate to VatB the authority to access
Carol herself; VatA must communicate only an authority to reach a **post-X Carol**.

## Four-party grant matching: partial order

The four-party grant-matching case is the full **partial order**; the chapter
forwards to the "Four Party Partial Order" treatment for it.

## Translation to Endo

| E (partial-order) | Endo / Hardened JavaScript |
|---|---|
| `<-` eventual send | `E(ref).m()` message on a reference |
| full order on a single reference | per-reference FIFO message ordering CapTP preserves |
| forking a reference passed in a message | the ordering established when a presence is passed as an argument over CapTP |
| partition breaks the reference | a disconnected CapTP session rejects in-flight and future messages |
| topology in spec, not implementation | the implementation may deliver in any order consistent with the per-reference guarantee |
| "post-X Carol" | the causal "already-saw-X" view a reference carries after a send |

Source: [elib/concurrency/partial-order.html](https://erights.github.io/erights-org-website/elib/concurrency/partial-order.html) (canonical `http://erights.org/elib/concurrency/partial-order.html`), content SHA-256 `340e9bbfb33e67b414b84d2ec1dc48f9bf422a8e5ef75df27d285a72702fd70a`, fetched via the erights.org GitHub Pages mirror.
