---
id: cask-cluster-provisioning
aliases: ["cluster provisioning", "cask ssh provision", "provision HOST", "node join", "address discovery", "membership propagation", "push-members", "binary distribution", "gossip protocol", "rendezvous service", "DNS SRV", "cluster formation", "node removal", "key revocation", "NAT traversal", "hole punching"]
topics: [networking]
status: current
---

# cask-cluster-provisioning

CASK's **deferred** design for forming online multi-node clusters (it currently runs as a standalone node). A new node must exist (have the binary), initialize (a `.cask` store with a fresh key-pair identity), listen (run the daemon), join (exchange public keys so both nodes' membership tables permit sessions), and be addressable. An earlier `cask ssh provision HOST` prototype automated all five over SSH for a single-operator two-node topology — `ssh uname` arch detection, cross-compile + `scp`, remote `cask init`/`cask start`, `cask invite`/`cask accept` key exchange — but assumed SSH access and a Go toolchain, had no real address discovery (hostname + hardcoded port 1024), no cluster-awareness (a third node needed manual `push-members`), and no CASK-protocol liveness check. Proper provisioning needs four prerequisites: address discovery (DNS SRV, gossip, rendezvous/bootstrap service, or mDNS), a membership propagation protocol (membership replicated as just another Merkle tree via the block protocol, vs a dedicated quorum-acknowledged protocol), binary distribution (published releases or blobs fetched over CASK itself), and health/liveness over the CASK protocol. The future sketch keeps manual `cask invite`/`cask accept` key exchange as the deliberate trust root. Open questions: CRDT-merge vs quorum membership, node removal and key revocation, can-connect (membership) vs can-replicate-specific-cells (capabilities), and NAT traversal.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--cluster-provisioning--problem-and-prior-ssh-approach](../sections/cask--cluster-provisioning--problem-and-prior-ssh-approach.md) | The five steps a new node needs; the abandoned `cask ssh provision` prototype and its five limitations. |
| [cask--cluster-provisioning--prerequisites-and-future-design](../sections/cask--cluster-provisioning--prerequisites-and-future-design.md) | Address discovery, membership propagation, binary distribution, health/liveness; the future sketch and open questions. |

## See also

- [[cask-three-gate-access]] — joining means making two membership gates permit each other.
- [[member-table-authorization]] — the per-node member table that a join populates.
- [[noise-ik-session-establishment]] — the Noise-IK-over-UDP session used to verify connectivity after a join.
- [[content-addressed-block-store]] — membership-as-Merkle-tree replication rides the normal block protocol.
