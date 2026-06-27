---
id: sturdyref
aliases: ["sturdyref", "sturdy reference", "sturdyrefs", "SturdyRef", "sturdyref locator", "swiss-num", "swiss number", "offline capability", "persistent capability reference", "captp:// URI", "ocapn:// sturdyref"]
topics: [ocapn, captp, capability-security, persistence]
---

# sturdyref

A **persistent, offline capability reference** — a serializable token from
which a live CapTP reference to a specific remote object can be (re-)obtained
later, possibly after a network partition or a process restart, possibly from
a peer that has never connected before. Where an ordinary CapTP `desc:import`
reference is *transient* (valid only within a live session and dropped when the
session ends), a sturdyref is *durable*: it survives serialization to disk or a
URI and is the bootstrap by which a fresh reference graph is re-established.

In the OCapN Locators draft, a **sturdyref locator** is a **Peer Locator**
(how to reach the hosting peer) plus a **`swiss-num`** — an unguessable string
naming a specific object at that peer. "This should be considered a capability,
with this information alone being used to obtain a CapTP reference [to] the
given object." The swiss number is the unforgeable secret: holding the
sturdyref *is* the authority to re-acquire the object, so a sturdyref must be
guarded like any other capability. Sturdyrefs serialize both to a Syrup wire
form and to a `ocapn://…` URI form for out-of-band carriage (printed, mailed,
embedded in a config). In Miller-Tribble-Shapiro's *Concurrency Among
Strangers* (§9.2), offline capabilities (`captp://…` URIs and the SturdyRef
abstraction) are how a small seed of durable references bootstraps a live
session-scoped graph after partition — the distributed enactment of the
*Initial Conditions* mechanism in the four-ways enumeration.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [ocapn/locators/sturdyref-locator](../sections/ocapn--draft-specifications-locators--sturdyref-locator--sturdyref-locator.md) | **Canonical definition.** A sturdyref = Peer Locator + `swiss-num`; this information alone is a capability used to obtain a CapTP reference to the object. |
| [ocapn/locators/sturdyref-locator/syrup-serialization](../sections/ocapn--draft-specifications-locators--sturdyref-locator--syrup-serialization.md) | The Syrup (binary wire) serialization of a sturdyref locator. |
| [ocapn/locators/sturdyref-locator/uri-serialization](../sections/ocapn--draft-specifications-locators--sturdyref-locator--uri-serialization.md) | The `ocapn://…` URI serialization for out-of-band carriage of a sturdyref. |
| [ocapn/locators/peer-locator](../sections/ocapn--draft-specifications-locators--peer-locator--peer-locator-ocapn-peer.md) | The Peer Locator half of a sturdyref: how to reach the hosting peer (the address the swiss-num is resolved against). |
| [papers/cas/partial-failure-and-when-catch](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch--body.md) | §9.2 *Offline capabilities*: `captp://…` URIs and the SturdyRef abstraction as the durable seed from which a session-scoped reference graph is rebuilt after partition; the *Initial Conditions* mechanism in distributed form. |

## See also

- [[four-ways-to-acquire-references]] — a sturdyref is the *Initial Conditions* mechanism made durable and distributed: it is the bootstrap state from which a fresh live graph is grown. The four-ways page already cites §9.2 for this connection.
- [[three-party-handoff]] — the live-session counterpart. A handoff bridges two *already-connected* peers; a sturdyref bootstraps a *new* connection to an exporter from a persisted locator with no prior session.
- [[captp-bounded-transient-pin]] — the contrast that defines sturdyrefs: a transient pin keeps a reference alive only in-memory for the life of a session; a sturdyref deliberately outlives the session.
- [[dehydrate-hydrate]] — the Endo-side discipline of stable formula keys (durable) vs. ephemeral connection hints; a sturdyref is the OCapN wire analogue of a dehydrated, re-hydratable reference.
- [[per-agent-keypair]] — the hosting peer's identity (in the Peer Locator) is anchored by its keypair; the swiss-num names an object *within* that identity.

## Common confusions

- **"A sturdyref is a URL."** It carries a URI serialization, but unlike a URL the `swiss-num` is an *unguessable secret*, not a public address. Possession is authority; a sturdyref leaked into a log is a capability leak, not a broken link.
- **"Sturdyrefs replace live references."** No — they are the *entry point*. You exchange a sturdyref to *obtain* a live (session-scoped) CapTP reference; thereafter ordinary message passing, handoffs, and pipelining apply. The sturdyref is for crossing the offline / cold-start gap.
- **"Sturdyref durability means the object is durable."** The sturdyref names *where and which*; whether the object still exists when you re-acquire is the hosting peer's concern. Re-acquisition can fail (the object was revoked or destroyed), which is why offline capabilities pair with partial-failure handling.
