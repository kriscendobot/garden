---
title: Dialog DB overview
source: README.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query, local-first-sync]
status: current
---

> Abstract: Dialog is an embeddable database designed for local-first software, in active-but-experimental development. It aims for four properties: schema-on-read via an expressive Datalog-esque query API; efficient synchronization across replicas; support for both WebAssembly and native runtimes; and an emphasis on data privacy and user-centered authority. The repository is a Rust core (`./rust`) with TypeScript/React bindings (`./typescript`), architectural decision records (`./adr`), and informal design notes (`./notes`). This section is the project's landing framing; the substance lives in the notes corpus.

Dialog is an **embeddable database designed for local-first software**. It aims to have the following properties:

- **Schema-on-read** via an expressive [Datalog]-esque query API.
- **Efficient synchronization** across replicas.
- Support for both **WebAssembly and native** runtime environments.
- Emphasis on **data privacy and user-centered authority**.

The project frames itself against the Ted Nelson critique that "right now you are a prisoner of each application you use" — the design intent is that users own their data rather than have it siloed within applications, with better conventions than the desktop-and-hierarchical-files status quo.

**Status: experimental.** Fundamental details (binary encoding, index construction) are expected to break over time; at this stage there is no promised migration path for old database versions as breaking changes land. The Mozilla Public License 2.0 governs the code.

Project layout:

- `./rust` — the core implementation of Dialog (the crate set: `dialog-artifacts`, `dialog-storage`, `dialog-search-tree`, `dialog-query`, `dialog-repository`, `dialog-capability`, `dialog-ucan*`, `dialog-remote-s3` / `dialog-remote-ucan-s3`, and support crates).
- `./typescript` — packages for using Dialog in TypeScript and/or React (`dialog-experimental`, `dialog-artifacts-web-tests`).
- `./adr` — architectural design records.
- `./notes` — informal notes about Dialog or adjacent topics (the primary design corpus this library ingests).

The development environment is encoded as a [Nix] flake; `nix develop` drops into a shell with the full toolchain, after which standard Rust and Node.js tooling builds the project (`cargo test` runs the native Rust suite).

Source: [README.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/README.md) at commit `f777fe7c`.

[Datalog]: https://en.wikipedia.org/wiki/Datalog
[Nix]: https://nixos.wiki/wiki/flakes
