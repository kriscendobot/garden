---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §26 formula types with type-specific metadata
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

The §Key-Interfaces subsection names the existing API the
design extends:

```js
export const InspectorHubInterface = M.interface(
  'EndoInspectorHub', {
  lookup: M.call(NameOrPathShape).returns(M.promise()),
  list: M.call().returns(M.array()),
});
```

The §`InspectorHub.lookup(petName)` API *already* returns
formula-type-specific metadata. The design lists six type-
specific shapes:

| Formula type | Metadata fields |
|--------------|-----------------|
| `eval` | `endowments`, `source`, `worker` |
| `lookup` | `hub`, `path` |
| `guest` | `hostAgent`, `hostHandle` |
| `make-bundle` | `bundle`, `powers`, `worker` |
| `make-unconfined` | `powers`, `specifier`, `worker` |
| `peer` | `NODE`, `ADDRESSES` |
| Other types | empty metadata object |

The §type-specific-metadata discipline lets the UI render
each formula type in a *type-appropriate* way: `eval` shows
syntax-highlighted source, `lookup` shows the hub+path chain,
`peer` shows the network identity.

The §`makePetStoreInspector` reference at
`packages/daemon/src/daemon.js` lines 3210-3319 points to the
existing implementation that *already* surfaces this
metadata — the design's add is mostly UI.
