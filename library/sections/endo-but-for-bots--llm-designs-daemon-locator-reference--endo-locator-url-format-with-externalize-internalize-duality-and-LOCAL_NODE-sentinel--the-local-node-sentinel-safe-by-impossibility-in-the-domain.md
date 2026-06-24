---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §LOCAL_NODE sentinel — *safe-by-impossibility-in-the-domain*
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §LOCAL_NODE section makes the sentinel's safety argument
explicit:

```js
const LOCAL_NODE = '0'.repeat(64);
```

*All-zeros is never a valid Ed25519 public key, making it a safe
sentinel for "this daemon".*

The §safe-by-impossibility-in-the-domain discipline: the sentinel
value is *not* a tagged or namespaced value — it's a *value that
the domain itself rules out*. Ed25519 public keys are derived
from random scalars; the probability of any specific public key
being all-zeros is *cryptographically negligible*. The sentinel
is safe *because the domain's structure prevents collision*, not
because of a separate marker bit.

Cycle 51's `daemon-agent-network-identity` (already ingested as
§dani section) named this as the *origin of the LOCAL_NODE
sentinel and the `0.0.0.0`-as-this-host analogy*. This design
codifies the sentinel's *operational* role: the daemon maintains
a `localKeys` set + `isLocalKey(node)` predicate; *any key in
this set* normalizes to `LOCAL_NODE` on internalization.
