---
title: Cluster Provisioning — Problem and Prior SSH Approach
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

> Abstract: The problem space for forming online CASK clusters, captured as a **deferred** design (CASK currently operates as a standalone node). A new node must exist (have the `cask` binary), initialize (a `.cask` store with a fresh key-pair identity), listen (run the daemon), join (exchange public keys with at least one existing node so both membership tables permit sessions), and be addressable (the cluster must know its host:port). Steps 1-3 are local; steps 4-5 require coordination. An earlier prototype `cask ssh provision HOST` automated all five over SSH — detecting remote OS/arch via `ssh uname`, cross-compiling and `scp`ing the binary, running `cask init`/`cask start` remotely, exchanging keys via `cask invite`/`cask accept` on both sides, and optionally saving the remote address locally. It worked for a single-operator two-node topology but assumed SSH access and a Go toolchain, inferred the address from the SSH hostname plus a hardcoded port 1024 (no real address discovery), had no cluster-awareness (a third node needed manual `push-members`), and offered no CASK-protocol liveness/health check.

## Status

Deferred. CASK currently operates as a standalone node. This document captures the problem space and design considerations for when we're ready to form online clusters.

## Problem

A new CASK node needs to:

1. **Exist** — have the `cask` binary for its platform.
2. **Initialize** — create a `.cask` store with a fresh identity (key pair).
3. **Listen** — run the daemon so it can accept connections.
4. **Join** — exchange public keys with at least one existing node so that both membership tables permit sessions.
5. **Be addressable** — the existing cluster must know how to reach the new node (host:port).

Steps 1–3 are local to the new machine. Steps 4–5 require coordination between the new node and the existing cluster.

## Previous Approach

An earlier prototype implemented `cask ssh provision HOST`, which automated all five steps over SSH:

- Detected the remote OS/arch via `ssh uname`.
- Cross-compiled the binary and copied it with `scp`.
- Ran `cask init` and `cask start` remotely.
- Exchanged keys by running `cask invite` and `cask accept` on both sides.
- Optionally saved the remote address in the local root tree.

This worked for a single-operator, two-node topology but had several limitations:

- **Assumes SSH access.** Not all deployment targets grant shell access.
- **Assumes a Go toolchain.** Cross-compilation requires the source tree and `go build` on the provisioning machine.
- **No address discovery.** The remote address was inferred from the SSH hostname plus a hardcoded port (1024). Real deployments involve NAT, DNS, load balancers, and dynamic IPs.
- **No cluster awareness.** Adding a third node required manually pushing membership entries (`push-members`). There was no protocol for a node to announce itself to the cluster or for the cluster to propagate membership changes.
- **No liveness or health.** After provisioning, there was no way to verify the remote node was reachable over the CASK protocol (as opposed to SSH).

Source: [doc/design/cluster-provisioning.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cluster-provisioning.md) at commit `cdb975d8`.
