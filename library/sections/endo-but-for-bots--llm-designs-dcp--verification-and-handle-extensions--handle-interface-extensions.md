---
title: Handle interface extensions
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions
---

```js
// Reading epithets (anyone holding the Handle can do this)
epithets: M.call().returns(M.arrayOf(EpithetShape)),

// Verification (anyone holding the Handle can ask)
verify: M.call(M.remotable('Handle'), M.string())
  .returns(M.promise(M.boolean())),
```

`epithets()` returns the chain. **Epithets are public to anyone who
holds the Handle** — they are claims, not secrets. Their value comes
from verifiability, not from concealment.

`verify(subordinateHandle, relationship)` asks the Handle's owner *did
you create this Handle as your [relationship]?* The response is at the
owner's discretion.
