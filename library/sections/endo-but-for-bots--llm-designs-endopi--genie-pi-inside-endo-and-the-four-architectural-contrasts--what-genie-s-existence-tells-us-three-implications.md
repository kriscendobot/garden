---
section: genie-pi-inside-endo-and-the-four-architectural-contrasts
source: endo-but-for-bots--llm-designs-endopi
topics: [agent-conventions, capability-security]
status: current
title: "*What Genie's existence tells us* — three implications"
parent: endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts
---

The §What Genie's existence tells us subsection names three
shifts in the gap-closing roadmap:

1. **The provider-registry gap is partially closed today.** Genie
   ships `pi-ai`'s full registry by transitive dependency. M1 of
   `endopi-provider-registry-and-oauth` reduces to (a) consolidating
   onto one registry surface (Genie's vs Lal's) and (b) the OAuth
   and cross-provider-handoff work that `pi-ai` does not provide.

2. **The compaction gap has a working implementation.** Genie's
   observer + reflector pair is *closer to a shipped iterative
   compactor than `endopi-iterative-compaction`'s design
   anticipated*. The substrate now exists; the design's role
   *shifts from "specify the algorithm" to "harmonise with the
   observer/reflector pair and route Lal/Fae transcripts through
   them"*.

3. **The confinement story is the open question.** Genie's tool
   surface runs with ambient Node authority (the `command` tool
   spawns subprocesses; the `vfs-node` tool reaches the filesystem
   directly). The tool-gate's role is *to constrain which tools and
   which arguments a sub-agent may invoke, not to confine what
   those tools can reach*. The maintainer's direction is
   `packages/sandbox` as the confinement layer for ambient tools.
   `packages/sandbox` ships a multi-driver shape: podman is its
   primary driver today, bwrap is also present, and additional
   drivers are anticipated for macOS and Windows. *Wiring
   `packages/sandbox` underneath `command` and `vfs-node` is the
   natural follow-on design once `endo-posix-sandbox` Phase 1.5
   lands.*

A second viable angle for the filesystem half of the confinement
problem (per jcorbin's follow-up on PR #265): *rather than
implementing a `vfs-endo` backend for genie's vfs-holding tools,
implement a 9p filesystem server that exports endo's filesystem
space*. A 9p server is reachable from both genie's existing
`vfs-node` implementation (as a mounted 9p export) and from normal
system command tools running inside the sandbox (as a mounted 9p
export inside the sandbox), so *one interface covers both
consumers instead of two parallel backends*. The trade-off (vfs-
endo backend vs 9p server) is named as an *open question that the
follow-on design captures*.
