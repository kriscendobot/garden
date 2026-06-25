---
title: Cluster Provisioning — Prerequisites and Future Design
source: doc/design/cluster-provisioning.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: What proper cluster provisioning needs before it can be built, and a sketch of the eventual design. Four prerequisites: **address discovery** (a node advertises its addresses and peers find them, via DNS SRV records, a gossip protocol, a rendezvous/bootstrap service, or mDNS/LAN broadcast); **membership protocol** (today adding a member is a CAS on the head block, but multi-node clusters need propagation, either replicated via the existing block protocol since membership is just another Merkle tree, or a dedicated protocol with stronger quorum-acknowledged consistency); **binary distribution** (published releases or blobs fetched over CASK itself, rather than cross-compiling on the fly); and **health/liveness** (verify bidirectional CASK-protocol connectivity, not just SSH reachability). The future sketch keeps key exchange intentionally manual as the trust root: out-of-band install + `cask init && cask start`, `cask invite`/`cask accept` key exchange, address registration in shared cluster state (a cell or directory entry), membership propagation via normal block synchronization, and a Noise-IK-over-UDP session for end-to-end verification. Open questions: eventually-consistent (CRDT-merge) vs quorum membership, node removal and key revocation, the can-connect vs can-replicate-specific-cells distinction, and NAT traversal (hole punching, relays).

## Prerequisites for Revisiting

Before implementing cluster provisioning properly, we need:

### Address discovery

A node must be able to advertise its address(es) and have peers discover them. Options include DNS SRV records (static deployments), a gossip protocol (nodes exchange peer lists), a rendezvous/bootstrap service (new nodes contact it to find the cluster), and mDNS/LAN broadcast (local-network clusters).

### Membership protocol

Adding a member currently requires a CAS on the head block. In a multi-node cluster, membership changes need to propagate. This could be **replicated via the existing block protocol** (membership is just another Merkle tree rooted in the head) or **a dedicated membership protocol** with stronger consistency guarantees (e.g. a node is not considered joined until a quorum acknowledges it).

### Binary distribution

Rather than cross-compiling on the fly, pre-built binaries for common platforms could be published as releases (GitHub, a package registry) or stored as blobs in a CASK store and fetched over the CASK protocol itself.

### Health and liveness

After joining, a node should be able to verify bidirectional connectivity over the CASK protocol, not just SSH reachability.

## Sketch of a Future Design

1. **Out-of-band setup**: Install the `cask` binary and run `cask init && cask start` on the new machine by whatever means the operator prefers (SSH, Ansible, a container image, a cloud-init script).
2. **Key exchange**: The new node runs `cask invite`, producing its public key. The operator provides this key to an existing node via `cask accept`. The existing node's key is provided back via the same channel. This is intentionally manual — it's the trust root.
3. **Address registration**: The new node's address is recorded in the cluster's shared state (a cell or directory entry). Peers discover it by reading this state.
4. **Membership propagation**: When a node accepts a new member, the updated membership tree is replicated to peers as part of normal block synchronization.
5. **Verification**: The new node and at least one existing node establish a CASK session (Noise IK over UDP) to confirm end-to-end connectivity.

## Open Questions

- Should membership be eventually consistent (CRDT-like merge of sets) or require explicit quorum?
- How do we handle node removal and key revocation?
- Should there be a distinction between "can connect" (membership) and "can replicate specific cells" (capabilities)?
- How do we handle nodes behind NAT (hole punching, relay nodes)?

Source: [doc/design/cluster-provisioning.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cluster-provisioning.md) at commit `cdb975d8`.
