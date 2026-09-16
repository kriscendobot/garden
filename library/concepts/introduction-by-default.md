---
id: introduction-by-default
aliases: [introduction by default, introduction-by-default, proxy by default, proxy-by-default, direct delegation, path-based access]
topics: [capability-theory, distributed-objects, capability-security]
---

# introduction-by-default

**Introduction by default** and **proxy by default** name the two regimes for how a delegated reference is *used* in a distributed capability system, a distinction Alan Karp drew precisely on cap-talk in December 2011. Under **introduction by default** (E, Waterken, and CapTP/OCapN), when Bob delegates a reference to Carol to Alice, Alice's later invocations go *directly* to Carol — the delegator drops out of the path, which is efficient and low-latency but provides no natural chokepoint for revocation or reference counting. Under **proxy by default** (HP's Client Utility, the e-speak precursor), Alice's invocations on a delegated reference route *through Bob* via a path-based proxy, so the delegator can maintain a correct local reference count and revoke the entire downstream subtree by dropping its own reference. The trade is directness and performance against a built-in accounting-and-revocation chokepoint; introduction-by-default systems recover revocation with explicit caretaker/membrane objects rather than by routing.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [introduction-by-default-versus-proxy-by-default](../sections/cap-talk-2009-2012--introduction-by-default-versus-proxy-by-default.md) | Karp's two propagation regimes, kernel-provided sender identity as mechanism versus Horton responsibility as policy, and representing versus enforcing the accountable "who". |
| [distributed-reference-counting-garbage-collection](../sections/cap-talk-2009-2012--distributed-reference-counting-garbage-collection.md) | Reference counting is correct only where routing keeps counts local (proxy-by-default), which is why distributed GC is hard under introduction-by-default. |

## See also

- [[web-keys]] — an introduction-by-default artifact: a web-key is used directly, with no proxy chokepoint.
- [[confused-deputy]] — the hazard whose closure depends on whose authority an intermediary uses.
- [[revocation-by-withdrawal]] — the caretaker-based revocation introduction-by-default systems use in place of a proxy chokepoint.
