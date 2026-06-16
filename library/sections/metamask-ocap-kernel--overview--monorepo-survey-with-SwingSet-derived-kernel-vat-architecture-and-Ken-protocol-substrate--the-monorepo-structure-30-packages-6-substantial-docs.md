---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
title: The §monorepo-structure — 30 packages + 6 substantial docs
parent: metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
---

The repo's top-level layout at commit `a3eff0efb` (HEAD as of
2026-06-03, last touched 2026-05-28 by Chip Morningstar in
`feat: agentmask + service discovery infrastructure (#952)`):

**Documentation** (~2000 lines total):

| Doc | Lines | Subject |
|-----|-------|---------|
| `docs/glossary.md` | 240 | canonical vocabulary — kernel, vat, baggage, exo, kref, vref, rref, eref, channel, stream, subcluster, clist |
| `docs/identity-backup-recovery.md` | 289 | BIP39 mnemonic backup/recovery of kernel identity |
| `docs/ken-protocol-assessment.md` | 203 | Ken protocol (HPL-2010-155) gap analysis — the most directly cross-comparable doc |
| `docs/kernel-guide.md` | 689 | host-app developer guide — kernel API, vat code, services, subclusters, baggage |
| `docs/platform-specific.md` | 92 | Node.js vs browser implementation split |
| `docs/usage.md` | 691 | usage guide — setup, vat bundles, cluster config, CLI tools, testing |

**Top-level**: `README.md` (100 lines), `AGENTS.md` (72 lines
— ocap patterns + testing discipline + TypeScript prefs).

**Packages** (30 total, categorized by role):

*Kernel core:*
- `ocap-kernel` — *OCap kernel core components*. Contains
  `Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`,
  `KernelQueue.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`,
  `SubclusterManager.ts`, and `store/methods/` for persistence.
- `kernel-store` — *storage abstractions and implementations*.
  SQLite-backed (both Node.js native and WASM for browser).
- `kernel-shims` — SES/lockdown integration.
- `kernel-utils` — *kitchen drawer of utilities* including
  `makeDefaultExo` (the project's `@endo/exo` wrapper).
- `kernel-errors` — error type catalog.
- `kernel-rpc-methods` — JSON-RPC method utilities.
- `kernel-platforms` — cross-platform capability specs.

*Runtime hosts:*
- `kernel-browser-runtime` — *Tools for running the MetaMask
  Ocap Kernel in a web browser*.
- `kernel-node-runtime` — Node.js host environment.
- `extension` — browser-extension package (e2e tests +
  control panel).
- `nodejs-test-workers` — Node.js worker scaffolding.

*Streams + iterables (parallel to @endo):*
- `streams` — *SES-compatible streams, in the lineage of
  `@endo/stream`*. Contains `BaseDuplexStream.ts` (channel
  substrate).
- `remote-iterables` — *Remotable iterable objects* (parallel
  to @endo's `makeIteratorRef`).

*Agents + LLM integration:*
- `kernel-agents` — *Capability-enabled, language-model-
  flow-controlled programming*.
- `kernel-agents-repl` — REPL for agent development.
- `kernel-language-model-service` — language-model service
  implementations.
- `llm-bridge` — *long-running bridge process that proxies a
  single LLM conversation between a vat (over a Unix-socket
  IOChannel) and the openclaw gateway's OpenAI-compatible
  /v1/chat/completions endpoint*. The §SES-restricts-network-
  so-bridge-via-Unix-socket discipline.
- `agentmask` — *OpenClaw plugin for requesting and using
  MetaMask wallet capabilities via the OCAP kernel daemon*.

*Service discovery (newest feature, May 2026):*
- `service-discovery-types` — types + validators for service-
  discovery model.
- `service-matcher` — vat implementing the matcher.

*Testing:*
- `kernel-test` — *Run tests on the kernel that involve
  interaction with vats*.
- `kernel-test-local` — local E2E tests requiring external
  dependencies (Ollama).
- `kernel-ui` — control-panel UI for the kernel.

*Tooling:*
- `kernel-cli` — CLI.
- `repo-tools` — repo automation (including the
  `mock-endoify` test shim).
- `create-package` — scaffold for new monorepo packages.
- `template-package` — template the scaffold uses.
- `logger` — *lightweight logging package using
  @metamask/streams*.

*Experiments + samples:*
- `evm-wallet-experiment` — wallet integration prototype.
- `sample-services` — example service implementations.
- `omnium-gatherum` — *noun: a miscellaneous collection (as
  of things or persons)*.
