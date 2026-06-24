---
section: daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
source: endo-but-for-bots--llm-designs-daemon-capability-bus
topics: [daemon, capability-security]
status: current
title: The five bus-*.js modules — what *makeWorker no longer forks* means
parent: endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting
---

The §The bus-*.js modules section is a five-file decomposition of the
bus-protocol surface:

- **`bus-daemon-node.js`** — Node.js manager child entry point.
  Establishes envelope reader/writer on fd 3/4, reads init envelope
  for its handle, constructs `bus-daemon-node-powers`, calls
  `daemon.js` (the shared core) with bus-specific powers, signals
  ready.

- **`bus-daemon-node-powers.js`** — *the key structural move*. A
  derivative of `daemon-node-powers.js` where `makeWorker` no longer
  forks a child. Instead it sends `[0, "spawn", {command, args},
  rid]` to the daemon and awaits a `"spawned"` response with the
  worker's handle. Then it establishes a CapTP session over
  envelope-framed messages to that handle. Also hosts future syscall
  stubs (`readFile`, `writeFile`, `listen`) that initially delegate
  to Node.js but can be individually replaced with daemon calls.

- **`bus-worker-node.js`** — Node.js worker entry point. Reads its
  handle from the init envelope on fd 4; rest of worker lifecycle
  (loading guest modules, evaluating code) is unchanged.

- **`bus-worker-node-powers.js`** — minimal worker powers. Provides
  a reader/writer pair backed by the envelope protocol on fd 3/4
  rather than raw Node.js pipe streams. CapTP frames are wrapped in
  `[managerHandle, "deliver", frameBytes, 0]` envelopes.

- **`bus-daemon-rust-xs.js`** — XS manager bootstrap. *Despite the
  "daemon" in its name (kept for symmetry), this module implements
  the manager role, not the daemon.* It runs inside the unified
  `endor` binary invoked as `endor manager -e xs` and uses
  `issueCommand` plus host powers in place of Node.js APIs. Bundled
  at build time via `scripts/bundle-bus-daemon-rust-xs.mjs` into
  `rust/endo/xsnap/src/daemon_bootstrap.js`, which the xsnap library
  embeds as `MANAGER_BOOTSTRAP`.

- **`bus-worker-xs.js`** — XS worker bootstrap. Runs inside the Rust
  `endor` binary (as `endor worker`) rather than Node.js. Uses
  `issueCommand` (synchronous host function) instead of
  `writeFrameToStream` for sending CapTP messages; uses
  `hostImportArchive` to load compartment-map archives natively in
  XS.

The previous file naming convention (`daemon-go.js`, `daemon-rust.js`,
etc.) was *duplicated per daemon language*; the unified `bus-` prefix
reflects that *the capability bus protocol is language-agnostic*. The
prefix denotes participation in the protocol, not a role.
