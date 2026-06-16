---
section: endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
source: endo-but-for-bots--llm-designs-daemon-locator-reference
topics: [daemon, ocapn]
status: current
title: The §internal-formula-identifier format
parent: endo-but-for-bots--llm-designs-daemon-locator-reference--endo-locator-url-format-with-externalize-internalize-duality-and-LOCAL_NODE-sentinel
---

The §Formula Identifiers section names the *internal* form:

```
{formulaNumber}:{nodeNumber}
```

Both halves are 64-character hex strings; the colon separator is
fixed. The §internal-vs-external distinction:

- **Internal**: `{number}:{node}` — *compact*, single-string,
  no protocol scheme, no query params. Storage-efficient. Used
  in daemon state, pet stores, formula graphs.
- **External**: `endo://{node}/?id={number}&type={type}` — *URL-
  shaped*, suitable for clipboard / chat / network sharing. Used
  on the wire and at user interfaces.

The §`LOCAL_NODE` sentinel:

```js
const LOCAL_NODE = '0'.repeat(64);
```

*All-zeros is never a valid Ed25519 public key, making it a safe
sentinel for "this daemon".* The §safe-sentinel-via-impossibility-
in-the-domain discipline. Local formulas use `LOCAL_NODE` as the
node number; remote formulas use the actual peer's public key.
This lets one storage format cover both *this-daemon* and
*another-daemon* references — the local case just has a
distinguishable node-number value.
