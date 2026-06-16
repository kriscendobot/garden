---
title: Configurability of Compartment harden
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

The `harden` exported by `@endo/harden` prefers `Object[Symbol.for('harden')]`
over `globalThis.harden` since the former is an intrinsic that cannot be
overridden by an endowment.
Any code that relies on `globalThis.harden` being endowed with a different
behavior than `Object[Symbol.for('harden')]` should use that endowed
`globalThis.harden` directly instead.

Source: [packages/harden/README.md](https://github.com/endojs/endo/blob/20a61e3d/packages/harden/README.md) at commit `20a61e3d`.
