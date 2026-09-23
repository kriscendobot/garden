---
title: Enforcement is in the daemon, not the delegate
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--recursive-chains-and-enforcement
---

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
