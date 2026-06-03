---
section: monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate
source: metamask-ocap-kernel--overview
topics: [daemon, captp, persistence]
status: current
---

# Monorepo survey with SwingSet-derived kernel/vat architecture and Ken-protocol substrate

> *The OCAP Kernel is a powerful object capability-based system
> that enables secure, isolated execution of JavaScript code
> in vats (similar to secure sandboxes).*
>
> — `docs/usage.md` opening

`MetaMask/ocap-kernel` is a TypeScript monorepo implementing
an object-capability kernel-and-vat architecture derived from
the same Agoric SwingSet lineage as `@endo` and the garden's
slot-machine work in `endojs/endo-but-for-bots`. This source
is **ingested as a reference shelf entry**: the library will
draw on it for comparison, contrast, and synthesis of
requirements where ocap-kernel's choices differ from ours.

## The §why-ingested rationale (user-provided context)

The maintainer specified the ingest's purpose in the
ingestion request:

> *Let's ingest ocap-kernel into the library, as a reference
> for future work. The project and all its documentation are
> at https://github.com/MetaMask/ocap-kernel. This is
> relevant to our slot machine and OCapN, based on the same
> SwingSet work and CapTP. We will be interested in comparing
> and contrasting its approach and possibly synthesizing
> requirements from the gap. We will be interested in its
> tests and how they might be adapted to our OCapN and slot
> machine libraries.*

The §reference-for-future-work framing distinguishes this
ingest from the *active-library* ingests (designs we own,
@endo source files we comment-fragment). ocap-kernel is the
*sibling implementation* we read to *learn from and
position-against*. The §sibling-implementation-comparison
genre.

## The §monorepo-structure — 30 packages + 6 substantial docs

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

## The §single most structurally interesting move — §Ken-protocol-substrate

The most distinctive structural feature is `docs/ken-protocol-
assessment.md`'s explicit framing of the kernel against the
**Ken protocol** (HP Labs Tech Report HPL-2010-155: *Output-
Valid Rollback-Recovery* by Kelly, Karp, Stiegler, Close, and
Cho).

Ken's seven properties (from the doc):

1. **Exactly-once delivery** in process-pairwise FIFO order
2. **Output validity**: outputs *could* have resulted from
   failure-free execution
3. **Transactional turns**: one message delivered →
   processing → checkpoint → transmit outputs
4. **Consistent frontier**: most-recent per-process
   checkpoints always form a recovery line
5. **Local recovery**: crashes cause only local rollbacks,
   no domino effect
6. **Sender-based message logging**: messages persisted in
   sender's output queue until ACKed
7. **Deferred transmission**: outputs buffered during turn,
   transmitted only after checkpoint

The §self-assessment-against-named-protocol discipline:
ocap-kernel's doc *names* a published protocol and *tabulates
its own implementation against each property*. Twelve rows of
*Property | Status | Implementation*, each ✓ with a one-line
note on where the property is implemented.

The §crank-buffering centerpiece (Issue #786):

> *crank_start(deliver one item from run queue)*
>   *→ create database savepoint*
>   *→ vat processes message*
>   *→ vat syscalls buffer outputs (sends, notifications) in CrankBuffer*
> *crank_end:*
>   *→ if success: atomically flush buffer to run queue + commit state*
>   *→ if failure: rollback to savepoint, discard buffer*

The §atomic-output-or-rollback discipline. *Outputs are only
externalized after successful turn completion*. Compares
directly with:

- **Cycle 100** (`unhandled-rejection.js`) — SES's GC-driven
  rejection-tracking. Ken's exactly-once shape *would
  subsume* the rejection-tracking gap.
- **Cycle 137** (`daemon-message-streaming`) — the
  §cross-peer-streams-ride-CapTP observation. Ken's
  deferred-transmission shape is the symmetric piece on the
  *sender* side.
- **Cycle 149** (`unhandled-rejection-display`) — the
  §error-path-cannot-depend-on-error-path insight. Ken's
  output-validity property gives that insight a formal
  framework.
- **Cycle 119** (`daemon-capability-bus`) — the daemon's
  envelope-protocol-and-handle-rewriting machinery is the
  *transport substrate*; Ken's properties are *what runs on
  top*.

The §named-protocol-as-acceptance-criterion discipline gives
the design discipline a *citable formal target*.

## The §canonical-vocabulary survey

The glossary defines the canonical SwingSet-derived
vocabulary that the rest of the codebase uses:

| Term | Definition | Endo parallel |
|------|------------|---------------|
| **kernel** | centralized manager of vats and distributed objects | Endo daemon (cycle 119's daemon-capability-bus) |
| **vat** | unit of compute managed by the kernel; isolated process | Endo worker |
| **baggage** | persistent key-value storage for a vat's durable state | Endo pet store + formula graph |
| **bootstrap** | init method on bootstrap vat's root object | Endo daemon's *Familiar* root |
| **distributed object** | persistent object in a vat, async-accessible to other vats | Endo's remotable + formula identifier |
| **exo** | remotable created with `makeDefaultExo()` from `@metamask/kernel-utils/exo` (not `Far` from `@endo/far`) | cycle 108's `defineExoClass` directly |
| **endowment** | initialization-time capability handed to a vat | Endo's *powers* |
| **kernel service** | object registered with kernel; vats call via `E()`; runs in kernel context | Endo's host methods |
| **supervisor** | kernel-space component managing vat lifecycle + messages | Endo's daemon supervisor (cycle 119) |
| **kref** (kernel reference) | string like `ko42` identifying an object kernel-wide | Endo's formula identifier |
| **vref** (vat reference) | identifier of an object within a vat's scope | (no direct Endo parallel — Endo runs without vat-scoping) |
| **rref** (remote reference) | identifier of an object within a remote channel's scope | Endo's CapTP slot index |
| **eref** (endpoint reference) | union of vref and rref | (no parallel) |
| **clist** | bidirectional mapping between channel-specific identifiers and refs | Endo's CapTP slot table (cycle 156's `finalize.js` weak-value-map) |
| **channel** | communication pathway between components | Endo's CapTP connection |
| **stream** | remote async iterator from `BaseDuplexStream` (uses `@endo/stream`'s Reader interface) | cycle 137's daemon-message-streaming |
| **subcluster** | logically-related group of vats launched together | Endo's *bundle* |
| **system subcluster** | privileged subcluster declared at kernel startup | Endo's *host* posture |
| **run queue** | kernel's main execution queue, one item per crank | (no direct Endo parallel — different concurrency model) |
| **crank** | one item dispatched from run queue (one message delivery) | (Ken protocol concept; no Endo parallel yet) |
| **GC** | reference-count-based; kernel/liveslots/JS gc are *mutually independent* | cycle 156's gc-driven finalization + Endo's retention paths (cycle 49) |
| **revocation** | invalidating an object reference | Endo's revoke (cycle 144's dot-membrane.js) |

The §kref-vref-rref-eref four-layer name-space is the most
distinctive divergence from Endo. Endo conflates many of these
into the formula-identifier shape; ocap-kernel separates them
*explicitly* and the doc spells out which scope each ref
operates in.

## The §AGENTS.md style + ocap-discipline observations

`AGENTS.md` (72 lines) is the project's developer-discipline
manifesto. Several rows are *directly comparable* with the
garden's CLAUDE.md disciplines:

- **§Lockdown is the first thing that runs**: same as @endo
  + Agoric SES discipline.
- **§Use `harden()` for immutability where feasible**: same
  pattern; explicit instruction to `harden(this)` at end of
  constructors, `harden(ClassName)` after class definition,
  `harden({...})` for inline returns.
- **§`E()` from `@endo/eventual-send`**: same surface as
  cycle 146's `E.js`.
- **§If an object is to be made remotable, turn it into an
  exo using `makeDefaultExo`** — *Do not use `Far` from
  `@endo/far`*. The §forbid-direct-Far observation: this is
  the project's wrapper *replacing* the Endo primitive. Worth
  comparing with cycle 134/136's *Alleged: prefix* +
  cycle 108's *defineExoClass*.
- **§Use `@metamask/superstruct` for runtime type checking**:
  parallel to @endo's `M.interface` shape guards.
- **§Prefer `type`; do not use `interface`** — TypeScript-
  side discipline.
- **§Never use `enum`s; always use string literal unions** —
  same as the garden's TypeScript discipline.
- **§Tests co-located with covered source** — same as @endo
  convention.

## The §package-naming-convention `@metamask/` vs `@ocap/`

> *Published packages are prefixed with `@metamask/`, private
> packages with `@ocap/`.*

The §public-private-namespace-split discipline. The published
surface (`@metamask/ocap-kernel`, `@metamask/kernel-utils`,
`@metamask/streams`, etc.) is *what downstream consumers
import*. The `@ocap/` namespace is project-internal
(`@ocap/extension`, `@ocap/repo-tools`, `@ocap/test-utils`).

The §two-namespace-split clarifies *what's API-stable* vs
*what's project-internal*. Endo doesn't have this split —
everything in `@endo/` is published; project-internal helpers
must live in a different namespace or be in `packages/x/test/`.

## The §queued-for-future-cycles ingestion plan

This first-pass overview ingest cycle (cycle 161 dispatch)
establishes the *reference-shelf entry*. Future cycles can
ingest deeper:

**Doc-level ingests** (each gets its own source page):

1. `docs/ken-protocol-assessment.md` — the most directly
   cross-comparable doc; would pair with cycle 149's
   unhandled-rejection-display and cycle 119's
   daemon-capability-bus.
2. `docs/kernel-guide.md` — host-app developer guide (689
   lines).
3. `docs/usage.md` — usage guide (691 lines).
4. `docs/glossary.md` — canonical vocabulary (240 lines).
5. `docs/identity-backup-recovery.md` — BIP39 backup/recovery
   (289 lines).
6. `docs/platform-specific.md` — Node.js vs browser split
   (92 lines).

**Per-package README ingests** for the cross-comparable
packages: `ocap-kernel`, `kernel-store`, `streams`,
`remote-iterables`, `kernel-utils/exo`, `kernel-rpc-methods`,
`kernel-test`, `service-discovery-types`.

**Code-comment-fragment ingests** for substantive source
files: `Kernel.ts`, `VatHandle.ts`, `VatSupervisor.ts`,
`KernelQueue.ts`, `KernelRouter.ts`, `KernelServiceManager.ts`,
`BaseDuplexStream.ts`.

**Test-file ingests** (per the maintainer's note about
adapting tests to our OCapN and slot machine libraries):
selected test files showing how ocap-kernel exercises
kernel/vat/channel scenarios.

The §queued-for-future-cycles discipline: this overview names
*what would come next* without committing to a sequence; the
loop can pick up any of these as future cycles see fit.

## The §sibling-implementation-comparison genre

This is the library's **first ingest of a sibling
implementation** — a body of work running parallel to ours,
descended from the same root, but with different choices. The
library has previously ingested:

- **@endo source files** — substrates we *use*.
- **endo-but-for-bots designs** — our own forward roadmap.
- **External papers** — formal foundations.

ocap-kernel is *a fourth genre*: a *sibling project* in the
ocap lineage. The §sibling-implementation-comparison genre
opens with this ingest.

Future cycles that draw on ocap-kernel content should preserve
the §reference-not-substrate stance: we don't *import* their
code; we *read* their choices to inform ours.

## Related sections

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the Endo daemon's *capability-bus* is the transport
  layer; ocap-kernel's kernel/vat/channel architecture sits on
  top of an analogous wire substrate.
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — the §cross-peer-streams-ride-CapTP observation parallels
  ocap-kernel's `BaseDuplexStream` channel substrate.
- cycle 149
  [[endo-but-for-bots--llm-designs-unhandled-rejection-display--two-coordinated-changes-with-error-shape-sentinel-and-four-case-rendering-fallback]]
  — the §error-path-cannot-depend-on-error-path insight is
  the same family of concern as Ken's output-validity property.
- cycle 156
  [[endo--packages-captp-src-finalize-js--weak-value-map-via-WeakRef-and-FinalizationRegistry-with-gc-as-side-channel-warning-and-end-of-turn-stability]]
  — the §weak-value-map for CapTP slot tables; ocap-kernel
  uses *clist* for the analogous role.
- cycle 144
  [[endo--packages-marshal-src-dot-membrane-js--membrane-via-marshal-with-mirror-converters-and-revocation-by-undefining-the-mineToYours-WeakMap]]
  — Endo's revocation-via-membrane; ocap-kernel has explicit
  `revoke(kref)` on the kernel API.
- cycle 108
  [[endo--packages-exo-src-exo-makers-js--defineExoClass-defineExoClassKit-and-makeExo-factory-trio]]
  — Endo's exo factory; ocap-kernel wraps this in
  `@metamask/kernel-utils/exo` `makeDefaultExo` (per AGENTS.md
  `Do not use Far from @endo/far`).
