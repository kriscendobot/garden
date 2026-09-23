---
title: Without HardenedJS
source: packages/harden/README.md
source_repo: endojs/endo
source_commit: 20a61e3d
source_date: 2025-10-10
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
parent: endo--pkg-harden-readme--overview
---

Libraries that use `@endo/harden` can be used without HardenedJS and the
exported `harden` freezes the object itself and the transitive own properties
of the object, and does not traverse prototype chains.

Consequently, the surface of an object is immutable.
However, if any fields of an object are optional, an attacker can subvert them
by altering their prototype.
This provides a degree of immutability that is useful for partial safety and
does not interfere with uncoordinated alteration of the realm intrinsics, on
which some testing and frontend user interface frameworks rely.

To opt out of any safety guarantees and to avoid the computation cost of
transitively hardening own properties, use the `-C harden:unsafe` build
condition with tools like `node` and Endo's `bundle-source`.

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
