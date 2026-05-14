---
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: SwingSet is agoric-sdk's foundational kernel — the "vats run on top of a kernel as if they were userspace processes" architecture. The README is REPL-and-bootstrap-focused; deeper material lives in `./docs/` (not yet ingested) and `packages/swingset-liveslots`. Cross-cuts with bundles (the bundling-per-vat-source process), capability-security (the Presence/Remotable distinction, identity-preservation rules), eventual-send (E() basics and promise pipelining), and agoric-sdk--pkg-zoe-readme--upgrade (which cites `packages/SwingSet/docs/vat-upgrade.md` for the vat-upgrade flow).
---

> Abstract: SwingSet implements an architecture where Vats run on top of a "kernel" as userspace-process analogs. Each Vat gets a `syscall` object for outgoing messages and registers a `dispatch` function for incoming messages. The README walks through the `vat` CLI + bootstrap discipline, Vat sources (the bundling pipeline, `buildRootObject` / Liveslots), pass-by-presence object identity, the `E()` wrapper for messaging, return values as promises, sending messages to promises, promise pipelining, and Presence identity comparison rules.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/agoric-sdk--pkg-swingset-readme--overview.md) | bundles, capability-security | current |
| [vat-cli-and-basedirs](../sections/agoric-sdk--pkg-swingset-readme--vat-cli-and-basedirs.md) | tooling, bundles | current |
| [vat-sources-and-liveslots](../sections/agoric-sdk--pkg-swingset-readme--vat-sources-and-liveslots.md) | bundles, capability-security, exo | current |
| [sending-messages-with-presences](../sections/agoric-sdk--pkg-swingset-readme--sending-messages-with-presences.md) | eventual-send, capability-security | current |
| [promise-pipelining](../sections/agoric-sdk--pkg-swingset-readme--promise-pipelining.md) | eventual-send | current |
| [presence-identity-comparison](../sections/agoric-sdk--pkg-swingset-readme--presence-identity-comparison.md) | capability-security, marshal | current |

## Cross-references

- The bundling pipeline cross-cuts with `endo--pkg-bundle-source-readme--*` and `endo--pkg-compartment-mapper-readme--*`.
- The E() wrapper material overlaps `endo--pkg-eventual-send-readme--*`; agoric-sdk's smart-contract platform sits on top of the same `@endo/eventual-send` primitive.
- The Presence/Remotable distinction echoes `endo--pkg-pass-style-readme--far` and `endo--pkg-marshal-readme--convert-val-slot`.
- Promise pipelining material overlaps `ocapn--implementation-guide--stage-4-promise-pipelining` (the wire-protocol view).

## Source

[packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
