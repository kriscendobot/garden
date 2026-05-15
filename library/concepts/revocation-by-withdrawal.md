---
id: revocation-by-withdrawal
aliases: ["revocation by withdrawal of the constructor", "revocation by withdrawal", "fourth revocation mechanism", "immediate local revocation", "timely revocation through local reachability"]
topics: [capability-security, daemon, patterns]
---

# revocation-by-withdrawal

The fourth revocation mechanism Formula Persistence introduces, alongside
the three named in the existing literature (inline caretakers, revocation
lists, expiry). **Removing or invalidating a formula withdraws the recipe
for constructing the capability**, which cascades into the disincarnation
of the corresponding live reference and anything that depends upon it
for its own construction. Because the formula graph is acyclic and
locally managed, this revocation is *immediate, local, and requires no
distributed protocol* — a stronger guarantee than caretakers (which
must remain alive), revocation lists (which must propagate), or expiry
(which is coarse-grained).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dp/acyclic-formula-graph-and-revocation](../sections/endo--designs-dp--acyclic-formula-graph-and-revocation.md) | Canonical exposition: the four-mechanism comparison table; *the user does not need to trust the distributed system to honor revocation — revocation is enforced locally, at the persistence layer, before any distributed protocol is consulted*. |
| [dp/system-fit-and-not-orthogonal](../sections/endo--designs-dp--system-fit-and-not-orthogonal.md) | Why a user agent needs this mechanism: a Waterken-style orthogonally-persistent system has nothing to "withdraw" since the heap object is opaque to the user agent. |
| [dp/six-aspects-of-sharing-and-related-work](../sections/endo--designs-dp--six-aspects-of-sharing-and-related-work.md) | How withdrawal-of-constructor satisfies the seventh Karp/Stiegler/Close aspect (revocable). |
| [dcp/verification-and-handle-extensions](../sections/endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions.md) | Worked example at the Handle layer: HandleControl `revoke()` invalidates the Handle formula and the epithet-chain link breaks cleanly at that point — *revocation as chain break*. |
| [d256/per-agent-keypairs](../sections/endo-but-for-bots--llm-designs-d256--per-agent-keypairs.md) | Worked example at the agent-identity layer: revoking an agent is revoking its `keypair` formula; keypair lifecycle follows formula lifecycle (deleting the formula deletes the keys). |

## See also

- [[formula-graph]] — the substrate whose acyclicity makes this mechanism work.
- [[cohort-destruction]] — withdrawal triggers cohort destruction of the dependent live-reference subgraph.
- [[four-tables-coordinated-retention]] — coordinated retention is what *survives* withdrawal across peers (the local user's withdrawal is authoritative).
- [[caretaker-pattern]] — caretakers contrast with withdrawal-of-constructor: caretakers must remain alive to enforce; withdrawal does not.
- [[delegates-and-epithets]] — the dcp/Handle-revocation chain break is the worked example linked above.
