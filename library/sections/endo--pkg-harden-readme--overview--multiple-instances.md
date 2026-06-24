---
title: Multiple instances
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

The first call to `harden` from any instance of `@endo/harden` determines the
behavior of any subsequent instance of `@endo/harden` that initializes later,
regardless of differences in behavior.
In a mutable, pre-lockdown JavaScript environment, it does this by behaving
somewhat like a shim.
A side-effect of that first call is that it installs its flavor of `harden` at
`Object[Symbol.for('harden')]` and all subsequent initializations just adopt
that behavior.
This property is how `lockdown` senses that it should fail.

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
