---
title: SwingSet Vat (overview)
source: packages/SwingSet/README.md
source_repo: agoric/agoric-sdk
source_commit: 7d95438c0888b5f7e903e258013d30b66f2458cf
source_date: 2025-10-25
source_authors: [Richard Gibson]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, capability-security]
status: current
---

> Abstract: Frame. SwingSet implements an architecture where Vats run on top of a "kernel" as if they were userspace processes in an operating system. Each Vat gets a `syscall` object for sending messages to the kernel and registers a `dispatch` function to receive messages from the kernel. Deeper material in `./docs`; tooling via SwingSet Runner and the in-package `vat` utility.

# SwingSet Vat

This repository implements an architecture in which Vats run on top of a "kernel" as if they were userspace processes in an operating system. Each Vat gets access to a "syscall" object, through which it can send messages into the kernel. Vats receive message from the kernel via a "dispatch" function which they register at startup.

See [docs](./docs) for more information.

[SwingSet Runner](../swingset-runner) can be used to explore a SwingSet instance, as can the simple `vat` utility in this package.

Source: [packages/SwingSet/README.md](https://github.com/Agoric/agoric-sdk/blob/7d95438c0888b5f7e903e258013d30b66f2458cf/packages/SwingSet/README.md) at commit `7d95438c`.
