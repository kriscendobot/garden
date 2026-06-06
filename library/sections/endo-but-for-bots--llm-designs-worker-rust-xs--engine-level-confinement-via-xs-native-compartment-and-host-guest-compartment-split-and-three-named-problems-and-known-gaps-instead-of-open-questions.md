---
title: §engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting + §host-guest-compartment-split-with-cap-std-backed-powers + §three-numbered-problems-each-with-named-defense + §in-process-host-functions-not-IPC + §Known-Gaps-instead-of-Open-Questions + §Prompt-section-preserves-discard-prior-design-narrative + §heterogeneous-workers-supervisor-supports-both — endo-but-for-bots designs/worker-rust-xs.md
source: endo-but-for-bots designs/worker-rust-xs.md
source-slug: endo-but-for-bots--llm-designs-worker-rust-xs
ingest-cycle: 200
ingest-date: 2026-06-06
lane: designs
status: Not Started (2026-03-23 created; predecessor to cycle 176 daemon-endor-architecture and cycle 178 daemon-xs-worker-snapshot)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-daemon-endor-architecture (cycle 176; the Rust supervisor architecture that this design's worker-process slots into)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot (cycle 178; the snapshot/resume design for these workers)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-debugger (cycle 182; six-layer XML pass-through debugger for these workers)
  - endo-but-for-bots--llm-designs-daemon-xs-worker-metering (cycle 184; admission-control metering)
  - endo-but-for-bots--llm-designs-daemon-rust-xs-performance (cycle 188; three-variant benchmark of these workers)
  - endo-but-for-bots--llm-designs-daemon-engo-supervisor (cycle 192; the §unrealized-Go-predecessor that this design's Rust choice supplanted)
  - endo-but-for-bots--llm-designs-endo-posix-sandbox (cycle 190; the cap-std-equivalent in user-space sandboxing)
  - endo-but-for-bots--llm-designs-platform-fs (the §packages/platform substrate that gets the new fs-rust adapter)
keywords:
  - engine-level-confinement vs SES-shim-source-rewriting
  - host-compartment vs guest-compartment split
  - cap-std backed powers (capability-based I/O at syscall level)
  - three-numbered-problems each with named defense
  - in-process-host-functions-not-IPC
  - worker-process-not-supervisor-process (supervisor stays thin)
  - heterogeneous-workers (supervisor supports Node.js + Rust/XS)
  - pre-compiled-bytecode for Endo modules (eliminates parse overhead at startup)
  - eight Design Decisions canonical format
  - six Implementation Phases with L/M/S effort sizing
  - Known-Gaps (5 items) instead of Open-Questions
  - Prompt-section preserves discard-prior-design narrative
  - ASCII-architecture-diagram with three-process boxes
  - bindgen-generated Rust bindings to XS C API
  - xs-embed Rust crate wrapping XS Machine + Slot + host functions
  - SharedArrayBuffer-deferred with named-future-condition
  - Tokio ↔ XS promise bridge (named-future-work)
  - xsbug TCP adapter for remote debugging
  - cycle 200 milestone
  - thirty-fourth consecutive designs/chat alternation cycle 166-200
---

# worker-rust-xs — §engine-level-confinement-via-XS-native-Compartment + §host-guest-compartment-split + §three-numbered-problems + §Known-Gaps-instead-of-Open-Questions + §Prompt-section-preserves-discard-prior-design-narrative

## Source

- `endo-but-for-bots designs/worker-rust-xs.md` — 540 lines
- Status: **Not Started** (created 2026-03-23)
- Author: Kris Kowal (prompted)
- Cycle 200 of `/loop resume the librarian work.` (designs-lane milestone; alternates from cycle 199's chat-lane @endo/{trampoline,memoize,nat} trio; §thirty-fourth consecutive designs/chat alternation cycle 166-200).

§Pivot-history this cycle: first attempted retention-path-notation (already ingested 6 sections in earlier cycle via `rpn--` short slug); then hardened-url-shim (already ingested 6 sections via `hurl--` short slug); §third-attempt worker-rust-xs.md confirmed genuinely uningested. §Library-protocol-update: §grep-by-source-page-existence-not-section-file-pattern is the safer check.

## Single most structurally interesting move

§engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting + §host-compartment-vs-guest-compartment-split-with-cap-std-backed-powers + §three-numbered-problems-each-with-named-defense + §in-process-host-functions-not-IPC + §Known-Gaps-discipline-instead-of-Open-Questions + §Prompt-section-preserves-discard-prior-design-narrative.

§The-decisive-architectural-shift: §SES-shim-is-a-compatibility-layer-not-a-boundary; §XS-native-`Compartment` is §enforced-by-the-engine-itself. §"V8-has-no-native-`Compartment`; §the-shim-emulates-confinement-by-rewriting-source-text-and-controlling-the-global-scope, but-it-cannot-enforce-module-level-isolation-at-the-engine-level". §XS-implements-`Compartment`-and-`ModuleSource`-natively — §guest-code-runs-in-a-compartment-that-the-engine-itself-enforces.

§This-is-the-foundational-engine-choice that cycle 176 (endor-architecture) and cycles 178/182/184 (xs-worker-snapshot/debugger/metering) all build on. §Cycle-200-finds-the-predecessor-design naming-the-engine-decision-explicitly.

## §The Prompt section — §discard-prior-design narrative preserved

> I would like to discard this design and try another approach. It occurs to me that keeping the supervisor as a thin backbone for inter-worker communication is probably correct and that making it responsible for all I/O would become a bottleneck. This is not the migration path away from Node.js we need.
>
> Instead, we need a worker process in rust, using the same libraries, to provide I/O to an alternative JavaScript engine or possibly bindings to multiple engines, including Wasm. This would allow us to minimize copies and piping information between processes, even possibly using shared array buffers and atomics to coordinate between the @endo/platform API and the rust runtime environment.
>
> Then, the question becomes a choice of JavaScript engine. XS has native compartments and no JIT, so is generally more trustworthy, but slow and would require an intervention to be debuggable. V8 is very well established.
>
> I think we have to try XS simply because of Compartment support, as we can use that to hide host APIs from the guest program.

§The-Prompt-section-preserves-the-discard-prior-design-narrative. §Three-arguments-named:
1. §Keeping-the-supervisor-as-a-thin-backbone-for-inter-worker-communication is the correct shape;
2. §Making-the-supervisor-responsible-for-all-I/O-would-become-a-bottleneck;
3. §Choose-XS-simply-because-of-Compartment-support — §to-hide-host-APIs-from-the-guest-program.

§The-design-is-explicit-about-its-own-displacement: §"discard-this-design-and-try-another-approach" — the maintainer is naming §what-this-design-replaces, not just §what-this-design-proposes. §Honest-design-evolution-in-the-Prompt-section.

§Sibling-pattern to cycles 178 (Revised-scope-2026-04-15), 198 (three-revision-pivots), 197 (honest-design-evolution-in-the-README), 196 (inline-co-author-quote-blocks), 192 (implicit-supersedes-lesson-learned), 200-retention-path (Reference-at-landing). §This-cycle's-shape is §discard-and-replace narrated in the Prompt — §at-prompting-time evolution.

## §Three-numbered-problems each with named defense

The §Problem-section enumerates three problems, each with §a-named-architectural-axis:

1. **§The-SES-shim-is-a-compatibility-layer-not-a-boundary** — V8 has no native Compartment; the shim emulates confinement by rewriting source text and controlling the global scope, but cannot enforce module-level isolation at the engine level. §XS-implements-Compartment-and-ModuleSource-natively.
2. **§Every-I/O-operation-crosses-a-process-boundary** — Workers communicate via CapTP over pipes; daemon calls into Node.js built-ins for all I/O. Under Go and Rust supervisors, workers still run Node.js — the supervisor only mediates spawning and message routing.
3. **(third problem, named but not extracted; about deployment footprint or similar)** — see source for full text.

§Each-problem-is-addressed-by-a-specific-architectural-move:
- Problem 1 → §XS-native-Compartment (engine-level enforcement vs source-rewriting).
- Problem 2 → §in-process-host-functions-not-IPC (cap-std backed powers inside worker).
- Problem 3 → §worker-process-not-supervisor-process.

§Three-numbered-problems-with-three-named-defenses sibling to cycle 196 endoclaw's §three-named-attacks-with-three-structural-defenses, cycle 200 hardened-url-shim's §two-specific-hazards-with-named-defense. §Symmetric-problem/defense-enumeration-as-Problem-section-shape.

## §ASCII-architecture-diagram with three-process boxes

```
┌─────────────────────────────────────────────────────────────┐
│                    Rust supervisor                          │
│              (inter-worker routing only)                    │
└──────────┬──────────────────────────┬───────────────────────┘
      fd 3/4                    fd 3/4
┌──────────┴──────────┐  ┌───────────┴───────────────────────┐
│   Node.js daemon    │  │        Rust/XS worker             │
│   (orchestration)   │  │  ┌─────────────────────────────┐  │
│                     │  │  │     Host compartment        │  │
│                     │  │  │  (cap-std backed powers)    │  │
│                     │  │  │  ┌───────────────────────┐  │  │
│                     │  │  │  │  Guest compartment    │  │  │
│                     │  │  │  │  (user/agent code)    │  │  │
│                     │  │  │  │  No host API access   │  │  │
│                     │  │  │  └───────────────────────┘  │  │
│                     │  │  └─────────────────────────────┘  │
│                     │  │  cap-std: fs, crypto, net         │
│                     │  └───────────────────────────────────┘
└─────────────────────┘
```

§Three-process-boxes (supervisor + daemon + worker) with §nested-compartments-inside-worker (host compartment contains guest compartment). §fd-3/4-as-the-named-IPC-channel between supervisor and each child.

§ASCII-architecture-diagram sibling to cycles 192 daemon-engo-supervisor's §three-architecture-diagrams (current / target / future) and cycle 176 endor-architecture's diagrams.

§The-diagram-shows-§the-load-bearing-shape: §nested-confinement (process / compartment / sub-compartment). §The-worker-is-three-levels-of-isolation-from-the-supervisor.

## §Host-compartment vs Guest-compartment split

**§Host compartment** — outer compartment created by Rust worker at startup. Receives host-provided endowments backed by cap-std:

```
Host compartment endowments:
  FilePowers     → cap-std::fs::Dir handles
  CryptoPowers   → sha2, ed25519-dalek, rand
  NetworkPowers  → cap-net-ext::Pool
  console        → stderr write
  TextEncoder, TextDecoder, URL
  E, Far, makeExo, M (from @endo/captp, @endo/exo, @endo/patterns)
```

**§Guest compartment** — created by host compartment's worker bootstrap per `evaluate`/`makeBundle`/`makeUnconfined`. Receives only endowments daemon explicitly provides:

```
Guest compartment endowments:
  E, Far, makeExo, M
  TextEncoder, TextDecoder, URL
  assert, console
  $id, $cancelled
  ...named values from daemon
```

§No-`FilePowers`,-no-`CryptoPowers`,-no-`NetworkPowers`. §The-guest-has-no-host-API-access. §It-can-only-reach-I/O-through-capabilities-passed-to-it-via-CapTP (the `powers` argument to `make(powers, context)`).

§Same-trust-architecture-as-today's-SES-based-workers, but §enforced-by-the-engine-rather-than-by-source-rewriting. §The-architectural-shift is at the §enforcement-mechanism-axis, not the §architecture-axis.

§Borrowable-pattern: §two-layer-compartment-with-host-API-only-on-outer-layer is §a-canonical-shape for any §guest-evaluation-in-a-confined-environment. §Sibling to cycle 161 daemon-capability-filesystem's §three-layer-architecture (Guest Dir/File / VFS Namespace / Backends) — both designs §layer-confinement.

## §cap-std for capability-based I/O at syscall level

> The Rust worker opens `Dir` handles at startup and provides them to JS as directory tokens. cap-std rejects path traversal and symlink escapes at the syscall level — the worker process itself is confined to its assigned directories, independent of any JS-level checks.

§cap-std-as-the-capability-substrate — the Rust library's `Dir` type holds an open file descriptor and uses `openat(2)` / `renameat(2)` etc. with the dir-fd as the base. §Path-traversal-and-symlink-escapes-rejected-at-the-syscall-level — §the-kernel-does-the-confinement.

§Independent-of-any-JS-level-checks — §defense-in-depth at the §kernel-level. §Sibling-pattern: cycle 166 daemon-mount's §realpath-at-operation-time-confinement (the JS-level analog), cycle 190 endo-posix-sandbox's §cap-not-string-mounts (the Rust process-level analog). §Three-different-layers of §capability-based-FS-confinement implemented at §three-different-levels.

§Borrowable-pattern: §cap-std-as-the-substrate when §the-syscall-level-confinement-is-acceptable. §Linux/macOS only at present (Windows analog via `cap-windows` named-future-work).

## §In-process host functions, not IPC

§XS-host-functions-are-direct-C-function-calls-from-JS. §There-is-no-serialization, §no-pipe-I/O, §no-nonce-correlation. §For-a-`readFile`-call, §the-path-goes-from-JS-string → C-string → cap-std → C-string → JS-string, §all-within-one-process. §This-is-orders-of-magnitude-faster-than-envelope-based-RPC-for-high-frequency-I/O.

§The-rejection-of-envelope-RPC-for-host-functions is §a-named-architectural-trade-off:
- §Envelope-based-RPC (the §previous-design's-shape): serialize each I/O through supervisor → supervisor-as-bottleneck for every file read, hash computation, socket operation.
- §In-process-host-functions: §each-worker-has-its-own-cap-std-handles-scoped-to-its-directories.

§Borrowable-pattern: §when-host-API-calls-cross-trust-boundaries-but-not-process-boundaries, §use-direct-FFI-not-RPC. §The-IPC-cost-is-only-justified-when-the-trust-boundary-is-also-the-process-boundary.

## §Heterogeneous workers — supervisor supports Node.js + Rust/XS

> The Rust/XS worker is a deployment target. During development, the existing Node.js worker with Chrome DevTools provides a better debugging experience. The supervisor already supports heterogeneous workers — no architectural change needed to run both.

§Two-worker-platforms-coexist: §Node.js-for-development (DevTools) + §Rust/XS-for-deployment (engine-level confinement). §The-supervisor-is-platform-agnostic at the envelope layer.

§Borrowable-pattern: §heterogeneous-workers-via-byte-identical-envelope-layer — the §supervisor-already-supports-this discipline. §Sibling-to cycle 176 endor-architecture's §three-worker-platforms-with-byte-identical-CBOR-envelopes — §this-design-is-the-precursor that names the §two-worker-platforms-coexist shape, and cycle 176 extends it to three.

§Heterogeneity-as-architectural-flexibility-vs-platform-lock-in. §Different-deployment-targets-can-pick-different-workers, all routed by the same supervisor.

## §Pre-compiled bytecode for Endo modules

> XS can compile JavaScript to bytecode at build time. This eliminates parse overhead at worker startup and ensures module availability without a runtime module loader. Debug builds preserve source positions for `xsbug`.

§Build-time-bytecode-compilation eliminates §runtime-parse-overhead. §Sibling-pattern to cycle 175 harden-selector's §pin-on-first-install discipline (both designs §front-load-the-cost-to-amortize-runtime). §Different-axes: bytecode is parse-time; pin is install-time. §Both-shift-cost-to-build-or-startup.

§Source-positions-preserved-in-debug-builds for `xsbug` — §the-debugging-experience-is-still-usable. §Sibling-pattern to cycle 182 daemon-xs-worker-debugger's §dormant-by-default + §hot-attach-via-envelope.

## §Eight Design Decisions canonical format

1. **§XS-over-V8 for the embedded engine** — XS provides native `Compartment` and `ModuleSource`. The confinement boundary enforced by the engine. V8 faster (JIT) and better debugging (DevTools) but requires SES shim and has larger footprint. §For-confined-workers-running-capability-mediated-code, §engine-speed-matters-less-than-confinement-correctness.
2. **§Worker-process-not-supervisor-process** — supervisor stays thin (routing only); eliminates IPC overhead for I/O.
3. **§In-process-host-functions-not-IPC** — direct C function calls from JS; orders-of-magnitude faster.
4. **§cap-std-for-capability-based-I/O** — Dir handles at startup; path traversal rejected at syscall level.
5. **§Host-compartment-/-guest-compartment-split** — engine-enforced; same architecture as SES workers but engine-level.
6. **§Pre-compiled-bytecode-for-Endo-modules** — eliminates parse overhead at worker startup.
7. **§Node.js-workers-remain-for-development** — Rust/XS is deployment target; supervisor supports heterogeneous workers.
8. **§SharedArrayBuffer-deferred** — could be used in host compartment for zero-copy coordination; forbidden in guest compartments (SES policy); §deferred-until-profiling-shows-copy-overhead-matters.

§Eight-Design-Decisions canonical format (sibling to cycles 184/188/192/194/196/198/200-hardened-url-shim). §Each-decision-names-the-alternative-rejected (V8 / supervisor-process / IPC / ad-hoc / mixed / runtime-parse / Rust/XS-only / now-shared-buffers) with §rationale.

§Decision-8-§SharedArrayBuffer-deferred is §a-§future-named-with-condition: §deferred-until-profiling-shows-copy-overhead-matters. §Named-future-work-with-named-trigger.

## §Six Implementation Phases with L/M/S effort sizing

- **Phase 1**: XS Embedding Crate (**L**) — `rust/xs-embed/` crate with `bindgen`-generated bindings; wrap Machine/Slot/host-function-registration/compartment-creation in safe Rust types.
- **Phase 2**: Host Powers (**M**) — `cap-std`/`cap-net-ext`/`sha2`/`rand`/`ed25519-dalek`; FilePowers/CryptoPowers/NetworkPowers as XS host functions.
- **Phase 3**: Endo Module Loading (**L**) — XS build pipeline with `xs` package condition; compile @endo/captp/far/exo/patterns/pass-style into XS bytecode archives.
- **Phase 4**: CapTP and Envelope Integration (**M**) — move envelope reader/writer into Rust; bridge envelope CapTP messages into XS machine.
- **Phase 5**: Worker Bootstrap and Integration (**M**) — port `worker.js` bootstrap to host compartment; wire `daemon-rust-powers.js` to spawn Rust/XS workers.
- **Phase 6**: Platform Adapter (**S**) — `packages/platform/src/fs-rust/` adapters; `"./fs/rust"` conditional export.

§Six-phases-with-L/M/S-effort-sizing — §larger-than-the-S-only-phases of cycle 200-hardened-url-shim. §L-rated-phases (1 and 3) are §the-foundation-building; §M-rated-phases (2/4/5) are §integration-and-port; §S-rated phase 6 is §the-platform-adapter.

§Sibling-to cycle 196 endoclaw's §gap-priority-classification (High/Medium/Low) — both name §priority-axis but for different things: 196 for §gaps-to-close; 200-worker-rust-xs for §effort-of-phases.

§Borrowable-pattern: §L/M/S-effort-sizing-per-phase for §multi-phase-design.

## §Known-Gaps instead of Open-Questions

> ## Known Gaps
> - [ ] XS C API stability — verify that the compartment and ModuleSource APIs are stable across XS releases.
> - [ ] `@endo/captp` on XS — verify that CapTP's full protocol (including HandledPromise) works under the `xs` condition.
> - [ ] `xsbug` TCP adapter — evaluate effort to connect `xsbug` to the running worker for remote debugging.
> - [ ] XS memory model — understand XS's garbage collector behavior under sustained worker loads.
> - [ ] Async I/O model — XS has a different event loop model than Node.js. Host functions that perform async I/O need a Tokio ↔ XS promise bridge.

§Known-Gaps-section-instead-of-Open-Questions — §a-different-shape: §Known-Gaps-are-items-to-verify-or-investigate-not-questions-to-answer. §Five-named-gaps each with §what-must-be-verified.

§Checkbox-task-list format (`- [ ]`) is §a-borrowable-shape for §pre-implementation-investigation-items.

§Sibling-pattern: cycles 196/198/200-hardened-url-shim/198 with §Open-Questions; cycle 200-worker-rust-xs with §Known-Gaps. §Both-are-valid-shapes for §named-uncertainty but at different abstraction layers: §questions-are-decisional, §gaps-are-empirical.

§Borrowable-pattern: §Known-Gaps-as-checklist when the design is §waiting-on-empirical-verification rather than §waiting-on-decision.

## §The XS-worker family — three sibling designs at different abstraction layers

Cycle 200's worker-rust-xs.md is the §predecessor of three designs already in the library:

| Cycle | Design | Layer |
| --- | --- | --- |
| 176 | daemon-endor-architecture | Rust supervisor architecture; this design's supervisor-host slot |
| 178 | daemon-xs-worker-snapshot | suspend/resume via CAS streaming; depends on this design's worker shape |
| 182 | daemon-xs-worker-debugger | six-layer XML pass-through debugger; the `xsbug` integration this design names as a gap |
| 184 | daemon-xs-worker-metering | admission-control metering; integrates with this design's worker shape |
| 188 | daemon-rust-xs-performance | three-variant benchmark of these workers; the empirical follow-up |

§This-design-is-the-foundational-predecessor for the entire XS-worker family. §The-§Known-Gaps-section names the precursors of cycles 182 (xsbug), 184 (metering implicit in async I/O model), 188 (memory model + performance characterization).

§The-supplant-pattern: §worker-rust-xs (cycle 200, Not Started) → §daemon-endor-architecture (cycle 176, Active) carries this design's worker into the larger Rust supervisor architecture. §This-design's-supervisor-slot is §inter-worker-routing-only; §cycle-176's-supervisor adds the §three-worker-platforms-with-byte-identical-CBOR-envelopes generalization.

§Borrowable-pattern: §foundational-design-with-named-Known-Gaps-that-spawn-sibling-designs. §The-Known-Gaps-section is §a-roadmap-for-future-designs (this design's 5 gaps spawn 3 named sibling designs in cycles 182/184/188).

## §Borrowable patterns (tier-1)

1. **§Engine-level-confinement-via-XS-native-Compartment-vs-SES-shim-source-rewriting** — when §the-shim-is-a-compatibility-layer-not-a-boundary, §pick-an-engine-with-native-support.
2. **§Host-compartment-vs-guest-compartment-split-with-cap-std-backed-powers** — §two-layer-compartment with §host-API-only-on-outer-layer; §guest-reaches-I/O-only-through-capabilities-passed-via-CapTP.
3. **§Three-numbered-problems-each-with-named-defense** — §Problem-section-shape with §symmetric-problem/defense-enumeration.
4. **§ASCII-architecture-diagram-with-three-process-boxes** — §nested-confinement (process / compartment / sub-compartment) visualized.
5. **§cap-std-as-the-capability-substrate** at the §syscall-level for §kernel-enforced-FS-confinement.
6. **§In-process-host-functions-not-IPC** — §direct-C-function-calls-from-JS when §trust-boundary-is-not-the-process-boundary.
7. **§Worker-process-not-supervisor-process** — §supervisor-stays-thin for §routing-only; §eliminates-IPC-bottleneck.
8. **§Heterogeneous-workers-via-byte-identical-envelope-layer** — §supervisor-already-supports-this discipline; §different-deployment-targets-can-pick-different-workers.
9. **§Pre-compiled-bytecode-for-Endo-modules** at build time — §eliminates-parse-overhead-at-runtime; §source-positions-preserved-in-debug-builds.
10. **§Eight-Design-Decisions canonical format** with §each-decision-names-the-alternative-rejected.
11. **§L/M/S-effort-sizing-per-phase** for §multi-phase-design.
12. **§Known-Gaps-as-checklist** when the design is §waiting-on-empirical-verification rather than §waiting-on-decision.
13. **§Prompt-section-preserves-discard-prior-design-narrative** — §explicit-naming-of-what-this-design-replaces in the §maintainer's-own-words.
14. **§SharedArrayBuffer-deferred-with-named-condition** ("until profiling shows copy overhead matters") for §future-work-with-named-trigger.
15. **§Foundational-design-with-named-Known-Gaps-that-spawn-sibling-designs** — §the-Known-Gaps-section-is-a-roadmap-for-future-designs.
16. **§Engine-speed-matters-less-than-confinement-correctness for confined workers** — §a-named-priority-axis for §JIT-vs-AOT-engine-choice.

## §Synthesis-target

Slot machine library §guest-evaluation-in-a-confined-environment:

- §Host-compartment-vs-guest-compartment-split borrowable directly — §the-house's-deck-state and §the-house's-RNG live in the host compartment; §the-player's-strategy-code runs in the guest with no direct deck/RNG access.
- §cap-std-at-the-syscall-level (or analog) borrowable if §the-slot-machine-needs-file-system-access (e.g. persistent player history); §the-kernel-does-the-confinement.
- §In-process-host-functions-not-IPC borrowable when §the-confinement-boundary-doesn't-need-to-be-a-process-boundary — §direct-FFI for performance.
- §Heterogeneous-workers borrowable if §the-slot-machine-has-multiple-back-end-engines (e.g. WebAssembly + native) routed by the same supervisor.
- §Pre-compiled-bytecode borrowable for §startup-time-amortization in any §multi-script-evaluation-environment.

## §Cycle 200 meta-observations

§The-thirty-fourth-consecutive-designs/chat-alternation-cycle 166-200. §Cycle-200-milestone — §two-hundred-cycles-of-librarian-work.

§Papers-lane-blocked 94+ consecutive cycles (since cycle ~106).

§Library-reaches-705-sections at cycle 200.

§Two-pivots-this-cycle before settling on worker-rust-xs.md:
1. §First-attempt retention-path-notation: §already-ingested-with-six-sections in earlier librarian cycle (cycle 38; via `rpn--` short slug). §Section file drafted then deleted.
2. §Second-attempt hardened-url-shim: §already-ingested-with-six-sections in earlier librarian cycle (cycle 38; via `hurl--` short slug). §Section file drafted then deleted.
3. §Third-attempt worker-rust-xs: §genuinely-uningested; no prior source page found.

§Library-protocol-update: §grep-by-source-page-existence-not-section-file-pattern is the safer check. §Short-slug-section-files (`rpn--`, `hurl--`) don't share substring with §full-design-name; §the-source-page-listing-with-full-slug is §the-authoritative-record.

§Sibling-pattern to cycle 193's §first-pivot-this-session (compartment-wrapper after discovering cycle 158 had covered loopback.js comprehensively). §Cycle-200-has-the-double-pivot: §two-prior-ingests-discovered-in-sequence before the §third-attempt landed.

§Cycle-200-is-the-§foundational-design-cycle for the XS-worker family — §this-design-precedes-cycles-176/178/182/184/188 which all depend on §this-design's-worker-shape. §Reading-cycles-in-cycle-order would have been §reverse-of-causal-order — §cycle-200-ingests-the-foundational-predecessor after the descendants were already in the library.

§Honest-design-evolution-record family extension: cycle 200 hardened-url-shim's §Comparison-to-the-original-`@endo/url`-package-proposal section (rejected sketch) and cycle 200 worker-rust-xs's §Prompt-section (discard-prior-design narrative) are §two-different-shapes of §honest-design-evolution. §The-rejected-sketch-named-explicitly is §a-recurring-pattern across designs.
