---
title: Embedded shell public surface
source: crates/pi-shell/src/lib.rs
source_repo: can1357/oh-my-pi
source_commit: 64e39987c9c6bc3314b23e0deee13b94f999747a
source_date: 2026-09-28
source_authors: [can1357, CoderTCY, incloon]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, llm-agent-frameworks]
status: current
notes: The source has no crate-level prose header; this section preserves and explains its module and re-export surface.
---

> Abstract: `pi-shell` is oh-my-pi's Rust shell facade: it exposes cancellation, output decoding, process control, the output minimizer, and shell execution APIs while re-exporting brush child-session behavior and `pi-builtins` runtime state for the N-API layer.

The crate's public modules are `cancel`, `minimizer`, `output_decode`, `process`, and `shell`, plus a Windows-specific module. Its main API re-exports the `Shell` type, configuration and result records, stream sinks, and buffered or streaming execution entry points.

The public boundary deliberately bridges two lower layers:

- `brush_core` supplies child-session actions and platform path spellings.
- `pi_builtins` supplies builtin runtime state, re-exported here so `pi-natives` depends on the shell facade rather than directly on the builtins crate.

This makes `pi-shell` the embedded-runtime seam rather than merely a command-spawning helper. In the Pi versus Endo comparison, it belongs to the ambient host-tool path described by [`designs/endopi.md`](../sources/endo-but-for-bots--llm-designs-endopi.md): Endo's lal/fae/genie surfaces may imitate or embed Pi's agent shape, but their capability boundaries are not supplied by `pi-shell` itself.

Source: [crates/pi-shell/src/lib.rs](https://github.com/can1357/oh-my-pi/blob/64e39987c9c6bc3314b23e0deee13b94f999747a/crates/pi-shell/src/lib.rs) at commit `64e39987`.
