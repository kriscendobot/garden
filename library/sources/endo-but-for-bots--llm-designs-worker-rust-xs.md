---
title: "worker-rust-xs — Rust worker process embedding the XS JavaScript engine"
source-slug: endo-but-for-bots--llm-designs-worker-rust-xs
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/worker-rust-xs.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/worker-rust-xs.md
total-lines: 540
status: Not Started (2026-03-23 created; predecessor to cycle 176 daemon-endor-architecture and cycles 178/182/184/188)
ingest-cycle: 200
ingest-date: 2026-06-06
lane: designs
---

# worker-rust-xs.md

A 540-line **Not Started** design (2026-03-23) by Kris Kowal proposing a Rust worker process embedding the XS JavaScript engine, replacing today's Node.js-with-SES-shim workers. §The-foundational-predecessor-design for the XS-worker family that cycles 176/178/182/184/188 in the library all build on.

## Key design moves

- **§Engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting** — V8 has no native Compartment; the shim emulates confinement by rewriting source text but cannot enforce module-level isolation at the engine level. XS implements `Compartment` and `ModuleSource` natively. §The-decisive-architectural-shift.
- **§Three-numbered-problems-each-with-named-defense** in the Problem section — SES-shim-is-compatibility-not-boundary / every-I/O-crosses-process-boundary / (third problem about deployment). §Symmetric-problem/defense-enumeration.
- **§Host-compartment-vs-guest-compartment-split** — outer host compartment receives cap-std-backed powers (FilePowers/CryptoPowers/NetworkPowers); inner guest compartment has no host API access; can only reach I/O through capabilities passed via CapTP. §Same-trust-architecture-as-SES-workers but §engine-enforced-rather-than-source-rewritten.
- **§cap-std for capability-based I/O at syscall level** — `Dir` handles opened at startup; path traversal and symlink escapes rejected at syscall level (`openat(2)` / `renameat(2)`); §the-kernel-does-the-confinement, §independent-of-any-JS-level-checks.
- **§In-process host functions, not IPC** — direct C function calls from JS; no serialization, no pipe I/O, no nonce correlation; §orders-of-magnitude faster than envelope-based RPC for high-frequency I/O.
- **§Worker-process-not-supervisor-process** — supervisor stays thin (routing only); §eliminates-IPC-overhead for I/O operations; each worker has its own cap-std handles scoped to its directories.
- **§Heterogeneous workers — supervisor supports Node.js + Rust/XS** — Rust/XS is deployment target; Node.js with Chrome DevTools is development target; §the-supervisor-is-platform-agnostic at the envelope layer.
- **§Pre-compiled bytecode for Endo modules** — XS can compile JavaScript to bytecode at build time; §eliminates-parse-overhead at worker startup; debug builds preserve source positions for `xsbug`.
- **§Eight Design Decisions canonical format** — each names the alternative rejected and rationale.
- **§Six Implementation Phases with L/M/S effort sizing** — Phase 1 (XS Embedding Crate, L) / Phase 2 (Host Powers, M) / Phase 3 (Endo Module Loading, L) / Phase 4 (CapTP Integration, M) / Phase 5 (Worker Bootstrap, M) / Phase 6 (Platform Adapter, S).
- **§Known-Gaps instead of Open-Questions** — §five-empirical-verification-items in checkbox-task-list format (`- [ ]`): XS C API stability + @endo/captp on XS + xsbug TCP adapter + XS memory model + async I/O model (Tokio ↔ XS promise bridge).
- **§SharedArrayBuffer-deferred-with-named-condition** ("until profiling shows copy overhead matters") for future work with named trigger.
- **§Prompt-section preserves discard-prior-design narrative** — the maintainer's `I would like to discard this design and try another approach` quoted verbatim; §explicit-naming-of-what-this-design-replaces (an even-earlier sketch where the supervisor handled all I/O).

## The Prompt section preserves the maintainer's narrative

> I would like to discard this design and try another approach. It occurs to me that keeping the supervisor as a thin backbone for inter-worker communication is probably correct and that making it responsible for all I/O would become a bottleneck. This is not the migration path away from Node.js we need.
>
> Instead, we need a worker process in rust, using the same libraries, to provide I/O to an alternative JavaScript engine or possibly bindings to multiple engines, including Wasm. [...]
>
> I think we have to try XS simply because of Compartment support, as we can use that to hide host APIs from the guest program.

§Three-arguments-named: supervisor-as-thin-backbone is correct; supervisor-responsible-for-all-I/O-is-a-bottleneck; choose-XS-simply-because-of-Compartment-support. §Honest-design-evolution-in-the-Prompt-section sibling to cycle 178/180/183/184/188/192/196/197/198/200-retention-path/200-hardened-url-shim §honest-design-evolution-record family.

## The XS-worker family — three sibling designs at different abstraction layers

This design is the §foundational-predecessor for:
- **cycle 176 daemon-endor-architecture** — Rust supervisor architecture; this design's supervisor-host slot.
- **cycle 178 daemon-xs-worker-snapshot** — suspend/resume via CAS streaming; depends on this design's worker shape.
- **cycle 182 daemon-xs-worker-debugger** — six-layer XML pass-through debugger; the `xsbug` integration this design names as Known Gap #3.
- **cycle 184 daemon-xs-worker-metering** — admission-control metering; integrates with this design's worker shape.
- **cycle 188 daemon-rust-xs-performance** — three-variant benchmark of these workers; the empirical follow-up to Known Gap #4 (memory model).

§The-Known-Gaps-section is §a-roadmap-for-future-designs (this design's 5 gaps spawn at least 3 named sibling designs).

## Ingest scope

Cycle 200 (designs-lane milestone): full ingest of the 540-line design as one section. Cohesion-honest single-section because §the-design-is-structurally-one-architectural-shift (engine-level confinement via XS).

## Related material in the library

- **cycle 176 daemon-endor-architecture**: the Rust supervisor architecture; this design's worker shape generalized to three worker platforms with byte-identical CBOR envelopes.
- **cycle 178 daemon-xs-worker-snapshot**: suspend/resume design for these workers.
- **cycle 182 daemon-xs-worker-debugger**: six-layer XML pass-through; the xsbug integration named in Known Gaps.
- **cycle 184 daemon-xs-worker-metering**: admission-control metering integrating with this design's worker shape.
- **cycle 188 daemon-rust-xs-performance**: empirical follow-up; three-variant benchmark.
- **cycle 192 daemon-engo-supervisor**: §the-unrealized-Go-predecessor that this design's Rust choice supplanted.
- **cycle 190 endo-posix-sandbox**: §cap-std-equivalent in user-space sandboxing; sibling pattern at process layer.
- **cycle 161 daemon-capability-filesystem**: §three-layer-architecture sibling — both designs layer confinement.
- **cycle 166 daemon-mount**: §realpath-at-operation-time-confinement is the JS-level analog of cap-std's syscall-level analog.
- **cycle 175 endo--packages-harden-make-selector**: §front-load-the-cost-to-amortize-runtime sibling pattern (pin-on-first-install vs pre-compiled-bytecode).
- **cycle 196 endoclaw**: §three-named-attacks-with-three-structural-defenses sibling pattern (this design has three-numbered-problems with named defenses).
- **cycle 200 hardened-url-shim** (same cycle, also new): §two-named-hazards-with-named-defense-each sibling pattern.
- **cycle 200 retention-path-notation** (already ingested in earlier cycle as §rpn--; not duplicated): §sibling-design-split pattern but different shape.
- **cycle 197 endo--packages-panic**: §ponyfill-vs-shim distinction; this design's §XS-native-Compartment-vs-SES-shim-source-rewriting is a stronger version of the same axis (no emulation possible at all on V8).
