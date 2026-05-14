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

## See also

- [[delegates-and-epithets]] — connectors that vend Handles for external identities use this guarantee.
- [[formula-graph]] — the substrate that makes formula-identifier equality stable across sessions.
