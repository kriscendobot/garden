---
title: Recursive epithet chains and daemon-enforced propagation
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
---

## Chains grow monotonically

When a delegate creates its own subordinate, the subordinate
**inherits the delegate's entire epithet chain and must add at least
one new epithet** describing its relationship to the delegate. The
chain grows monotonically — it can never shrink.

```
Alice creates Aifred:
  Aifred's epithets: [(assistant to Alice)]

Aifred creates Jarvis:
  Jarvis's epithets: [(majordomo of Aifred), (assistant to Alice)]

Jarvis creates Minion:
  Minion's epithets: [(worker for Jarvis), (majordomo of Aifred), (assistant to Alice)]
```

The composite epithet reads naturally left to right as a chain of
delegation: *Minion is a worker for Jarvis, who is a majordomo of
Aifred, who is an assistant to Alice.* Each link is independently
verifiable by asking the referenced Handle.

## Attenuation by extension, not contraction

This is the same **attenuation pattern** as Dir/File in the daemon: a
Dir can create a sub-Dir (narrowing scope) but cannot widen it. A
delegate can create sub-delegates (adding epithets) but cannot remove
inherited ones. Authority over identity narrows as you go deeper in
the delegation tree.

## Enforcement is in the daemon, not the delegate

The delegate's `provideGuest` (or equivalent creation method) must:

1. Accept the new epithet(s) for the subordinate.
2. **Prepend them to the delegate's own epithet chain.**
3. Store the composite chain in the subordinate's Handle formula.
4. The subordinate's Handle formula is immutable — the chain cannot
   be modified after creation.

> *The delegate cannot create a subordinate without propagating its
> own chain, because the creation method is guarded by an interface
> that requires the chain as input and the daemon (which writes the
> formula) prepends the inherited epithets. The delegate has no
> mechanism to create a "clean" Handle — only the original Host can
> do that.*

The primary threat — *a delegate finding a way to create a subordinate
without propagating its epithet chain* — is therefore defended not by
policy but by structural impossibility: the API the delegate has does
not include a chain-stripping path. The daemon is the writer of the
Handle formula; the delegate calls into a creation method whose
contract requires the inherited chain as the prefix.

This is the same *daemon-implements-the-invariant* discipline the
daemon uses for cohort destruction (see [[cohort-destruction]]) and
for the LOCAL_NODE sentinel (see [[local-node-sentinel]]) — the
property holds because no API exposed to user code allows the
property to be violated.
