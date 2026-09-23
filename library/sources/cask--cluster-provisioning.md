---
source: doc/design/cluster-provisioning.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 2
status: current
---

> Abstract: A **deferred** design capturing the problem space for forming online CASK clusters (CASK currently runs as a standalone node). A new node must exist, initialize, listen, join (exchange public keys so both membership tables permit sessions), and be addressable. An earlier `cask ssh provision HOST` prototype automated all five over SSH for a two-node topology but assumed SSH access and a Go toolchain, had no real address discovery (hostname + hardcoded port 1024), no cluster-awareness (manual `push-members` for a third node), and no CASK-protocol liveness check. Proper provisioning needs address discovery (DNS SRV / gossip / rendezvous / mDNS), a membership propagation protocol (block-replicated Merkle tree vs quorum-acknowledged), binary distribution (releases or CASK-served blobs), and health/liveness. The future sketch keeps manual `cask invite`/`cask accept` key exchange as the trust root; open questions cover CRDT-vs-quorum membership, key revocation, can-connect-vs-can-replicate, and NAT traversal.

| Section | Topics | Status |
|---------|--------|--------|
| [problem-and-prior-ssh-approach](../sections/cask--cluster-provisioning--problem-and-prior-ssh-approach.md) | networking | current |
| [prerequisites-and-future-design](../sections/cask--cluster-provisioning--prerequisites-and-future-design.md) | networking | current |
