---
id: pass-invariant-handle-equality
aliases: ["pass-invariant equality of Handles", "pass-invariant Handle equality", "handleFor returns same identifier", "Handle equality", "connector identity guarantee"]
topics: [daemon, capability-security, pass-style]
---

# pass-invariant-handle-equality

The discipline that a connector (or any Handle-vending facet)
guarantees: **requesting a Handle for the same backing identity
returns the same formula identifier.** Two `E(connector).handleFor(X)`
calls for the same `X` produce Handles with identical formula keys,
so an agent's directory can detect that two pet names point at the
same underlying person / channel / object via `identify()`.

```js
const bobHandle1 = await E(slackConnector).handleFor('@bob');
const bobHandle2 = await E(slackConnector).handleFor('@bob');
// Same formula identifier — the agent can detect this via identify()
```

This is the Handle-side instance of the broader **pass-invariant
equality** convention in the OCapN family — values that pass over the
wire and back preserve identity comparison, so agents and connectors
can de-duplicate references without trusting the sender to be
consistent.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dcp/ai-delegates-connectors-and-anti-impersonation](../sections/endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation.md) | The connector guarantee + the `handleFor` example; cross-service identity (bob-on-slack ≡ bob-on-email) as a host-asserted directory grouping. |
| [papers/capmyths/equivalence-myth](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) | Property A (No Designation Without Authority) is the upstream formal name for what Endo enforces by making a Handle's *formula identifier* both designator and authority — a Handle that designates the same backing identity carries the same authority. |

## See also

- [[passable-equality]] — the value-level, structural counterpart of this identity-level guarantee: `keyEQ` (`compareKeys === 0`) over Keys at the marshalling layer. This Handle-side discipline is the identity-level instance of that broader pass-invariant equality convention.
- [[delegates-and-epithets]] — connectors that vend Handles for external identities use this guarantee.
- [[formula-graph]] — the substrate that makes formula-identifier equality stable across sessions.
- [[object-capability]] — Property A is the formal property name in the Miller-Yee-Shapiro vocabulary; this discipline is Endo's enforcement of it at the Handle layer.
- [[grant-matcher-puzzle]] — the canonical *motivation* for pass-invariant equality: Mark Miller's Grant Matcher Puzzle is *why* a distributed capability system needs an equality primitive that two parties can trust to decide whether they designate the same object, defeating a capability man-in-the-middle.
- [[three-party-handoff]] — the transport counterpart: equality decides *whether* two designations match; the handoff reliably *moves* the capability to the matched destination.
