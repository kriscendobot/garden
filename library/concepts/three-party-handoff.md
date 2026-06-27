---
id: three-party-handoff
aliases: ["three-party handoff", "third-party handoff", "third party handoffs", "3-party introduction", "gift handoff", "CapTP handoff", "desc:handoff-give", "desc:handoff-receive", "deposit-gift", "Gifter Receiver Exporter", "cross-session reference passing", "distributed Granovetter operator"]
topics: [captp, ocapn, capability-security, capability-theory]
---

# three-party-handoff

The CapTP protocol that realizes the **Granovetter Operator across separate
sessions**: how a reference one peer *imported from a third peer* is securely
passed to a *second* peer, so the second peer ends up talking to the third
peer directly. In the single-session case, `bob.foo(carol)` introduces Bob to
Carol by passing the reference inline. When Carol lives in a *different* CapTP
session than the one over which `foo` is sent, the reference cannot be passed
as a plain descriptor — it must be handed off so that the receiver can open
(or reuse) its own session to the object's true exporter, without trusting the
intermediary and even if a malicious actor observes the messages.

The OCapN CapTP draft names three roles and three sessions:

- **Gifter** — the peer sharing a reference it holds.
- **Receiver** — the peer the reference is being shared with.
- **Exporter** — the peer that actually exports (hosts) the reference.

implying the **Gifter-Exporter**, **Gifter-Receiver**, and **Exporter-Receiver**
sessions. The flow: the Gifter (1) *deposits a gift* — sends `op:deliver` to
the Exporter's bootstrap object with the symbol `deposit-gift`, a 32-byte
random `gift-id`, and the reference; and (2) sends the Receiver a **signed
`desc:handoff-give`** certificate in place of the reference. The Receiver wraps
it in a `desc:handoff-receive` and presents that to the Exporter to *withdraw*
and redeem the gift. The signature and the random gift-id are what make the
handoff secure against a man-in-the-middle: only the intended Receiver can
redeem, and the Exporter can verify the certificate's provenance. This is the
distributed-systems enactment of *only connectivity begets connectivity* — a
new Receiver-Exporter connection is born only because the Gifter, who already
held both, decided to bridge them.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [ocapn/captp/third-party-handoffs](../sections/ocapn--draft-specifications-captp--third-party-handoffs--third-party-handoffs-third-party-handoffs.md) | **Canonical role/session definition.** Why handoffs exist (a message carries a reference imported from a different session), the three roles (Gifter / Receiver / Exporter), and the three implied sessions; done securely even if a malicious actor views the messages. |
| [ocapn/captp/handoffs-from-the-gifters-perspective](../sections/ocapn--draft-specifications-captp--third-party-handoffs--handoffs-from-the-gifter-s-perspective.md) | The Gifter's two actions: deposit the gift to the Exporter's bootstrap object (`op:deliver` with `deposit-gift` symbol + 32-byte `gift-id` + the reference), and send a signed `desc:handoff-give` to the Receiver in place of the reference. |
| [ocapn/captp/handoffs-from-the-receivers-perspective](../sections/ocapn--draft-specifications-captp--third-party-handoffs--handoffs-from-the-receiver-s-perspective.md) | The Receiver wraps the signed `desc:handoff-give` in a `desc:handoff-receive` and presents it to the Exporter to redeem the gift. |
| [ocapn/captp/handoffs-from-the-exporters-perspective](../sections/ocapn--draft-specifications-captp--third-party-handoffs--handoffs-from-the-exporter-s-perspective.md) | The Exporter validates the certificate and matches the redeemed `desc:handoff-receive` against the deposited gift. |
| [ocapn/captp/bootstrap-object/deposit-gift-method](../sections/ocapn--draft-specifications-captp--bootstrap-object--deposit-gift-method.md) | The bootstrap-object method the Gifter calls to stage the gift under its `gift-id`. |
| [ocapn/captp/bootstrap-object/withdraw-gift-method](../sections/ocapn--draft-specifications-captp--bootstrap-object--withdraw-gift-method.md) | The bootstrap-object method the Exporter runs to release the staged gift to the redeeming Receiver. |
| [ocapn/captp/descriptors/desc-handoff-give](../sections/ocapn--draft-specifications-captp--descriptors--desc-handoff-give-desc-handoff-give.md) | The signed certificate the Gifter mints; the wire shape and the signing discipline. |
| [ocapn/captp/descriptors/desc-handoff-receive](../sections/ocapn--draft-specifications-captp--descriptors--desc-handoff-receive-desc-handoff-receive.md) | The Receiver's wrapper that carries the signed give-certificate to the Exporter for validation. |

## See also

- [[granovetter-operator]] — the single-session primitive this protocol distributes. A three-party handoff *is* a Granovetter step where the introduced object lives behind a different session, so the inline reference cannot be passed directly.
- [[four-ways-to-acquire-references]] — the handoff is the *Introduction* mechanism realized across CapTP session boundaries; it is the wire form of the constraint that only an object holding both references can bridge two peers.
- [[grant-matcher-puzzle]] — the handoff answers the puzzle's *transport* question (reliably move a capability to a destination both parties designate); [[pass-invariant-handle-equality]] answers its *equality* question.
- [[sturdyref]] — the offline counterpart: a sturdyref bootstraps a *fresh* connection to an exporter from a persisted locator, where the handoff bridges *live* sessions.
- [[captp-bounded-transient-pin]] — the gift, while deposited but not yet redeemed, is a transiently-pinned reference on the Exporter; the same in-memory-pin discipline keeps it alive without granting persistence.

## Common confusions

- **"A handoff is just forwarding the descriptor."** No — forwarding a `desc:import-object` would make the Receiver route every call through the Gifter, who could observe or tamper. The handoff instead lets the Receiver open its *own* Exporter-Receiver session, so the Gifter drops out of the path after the introduction.
- **"The gift-id is the capability."** No — the 32-byte random `gift-id` only names a staged deposit at the Exporter; redemption additionally requires the signed `desc:handoff-give` the Receiver presents. The id without the signed certificate redeems nothing.
- **"Three parties means three machines."** The three *roles* (Gifter / Receiver / Exporter) are logical; two roles can be co-located. The protocol is defined by the three *sessions*, not by physical hosts.
