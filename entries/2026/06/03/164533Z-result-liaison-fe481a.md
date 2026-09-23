---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--fe481a
ts: 2026-06-03T16:45:33Z
ref_id: fe481a
---

# ocap-kernel first-pass overview ingest (user-directed manual ingest)

**User-directed manual ingest** between scheduled loop ticks
(between cycles 161 and 162). Maintainer requested: *Let's
ingest ocap-kernel into the library, as a reference for
future work ... relevant to our slot machine and OCapN, based
on the same SwingSet work and CapTP*.

## Source

`MetaMask/ocap-kernel` cloned bare to `/home/kris/garden/
worktrees/metamask-ocap-kernel.git/`. HEAD on `main` at
commit `a3eff0efb70ba5f4c5919290aa295fe32138df4f` 2026-05-28
by Chip Morningstar (`feat: agentmask + service discovery
infrastructure (#952)`). License: dual Apache-2.0 + MIT.

## What this ingest accomplishes

- Establishes the **§sibling-implementation-comparison
  genre** — a *fourth source genre* in the library alongside
  @endo source files (substrates we use), endo-but-for-bots
  designs (our forward roadmap), and external papers (formal
  foundations).

- Surveys the **30-package monorepo + 6 substantial docs +
  README + AGENTS.md** at a one-line-per-package level of
  detail. Each package categorized by role: kernel-core /
  runtime-hosts / streams+iterables / agents+LLM / service-
  discovery / testing / tooling / experiments.

- Identifies the **§Ken-protocol-substrate centerpiece**:
  `docs/ken-protocol-assessment.md` tabulates the
  implementation against the seven properties of the Ken
  protocol (HPL-2010-155 by Kelly/Karp/Stiegler/Close/Cho).
  Directly cross-comparable with cycles 100 / 119 / 137 / 149.

- Maps the **§canonical-vocabulary** of 22 terms with explicit
  Endo parallels:
  - kernel ↔ Endo daemon
  - vat ↔ Endo worker
  - baggage ↔ Endo pet store / formula graph
  - exo ↔ cycle 108's defineExoClass (via makeDefaultExo
    wrapper)
  - kernel service ↔ Endo's host methods
  - supervisor ↔ Endo daemon supervisor
  - clist ↔ cycle 156's finalize.js weak-value-map
  - channel ↔ Endo CapTP connection
  - stream ↔ cycle 137's daemon-message-streaming
  - **§kref-vref-rref-eref four-layer name-space** is the
    most distinctive divergence from Endo (which conflates
    many into formula-identifier).

- Captures **§AGENTS.md observations** for project-discipline
  comparison: §forbid-direct-Far in favor of `makeDefaultExo`
  wrapper / @metamask/superstruct for runtime types / type-
  not-interface / never-enum.

- Notes **§public-private-namespace-split** (@metamask/
  published vs @ocap/ private) as a discipline Endo doesn't
  have.

- Establishes the **§reference-not-substrate stance**: we
  read for comparison, not for direct import.

- Documents the **§queued-for-future-cycles ingestion plan**:
  per-doc ingests for each of the 6 docs, per-package README
  ingests for the cross-comparable packages, code-comment-
  fragment ingests for substantive source files
  (Kernel.ts / VatHandle.ts / VatSupervisor.ts / KernelQueue.ts
  / KernelRouter.ts / KernelServiceManager.ts /
  BaseDuplexStream.ts), and **test-file ingests** per the
  maintainer's explicit note about adapting tests to our
  OCapN and slot machine libraries.

## Most relevant cross-comparisons identified

| ocap-kernel concept | Garden cycle |
|---------------------|--------------|
| Ken protocol crank-buffering | cycle 119 (capability-bus envelope), cycle 100 (SES GC-rejection), cycle 149 (unhandled-rejection-display §error-path-cannot-depend-on-error-path), cycle 137 (daemon-message-streaming §cross-peer-streams-ride-CapTP) |
| clist (channel-scoped capability list) | cycle 156 (finalize.js weak-value-map for CapTP slot tables) |
| BaseDuplexStream | cycle 137 (daemon-message-streaming + cycle 156's gc-as-side-channel discipline) |
| makeDefaultExo wrapper | cycle 108 (defineExoClass), cycle 134 (remotable.js), cycle 136 (make-far.js) |
| kernel revoke(kref) | cycle 144 (dot-membrane.js revocation-via-WeakMap) |
| baggage persistent state | cycle 49 (retention-path-notation), cycle 105 (capability-bank) |
| crank turn model | (no direct Endo parallel; possible synthesis target) |
| vat/kernel/channel separation | cycle 119 (daemon-capability-bus), cycle 105 (capability-bank) |
| kernel-store SQLite WASM persistence | cycle 141 (daemon-cas-management Rust SQLite via supervisor) |
| streams package | cycle 137 (daemon-message-streaming) |

## Output summary

- **Source slug**: `metamask-ocap-kernel--overview`
- **Sections**: 1 cohesion-honest section
  - `metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate.md`
- **Topics**: daemon, captp, persistence (with rows added in
  daemon.md and captp.md topic pages)
- **Library totals**: 666 sections from 207 source documents
- **Genre**: first-ever ingest of the §sibling-implementation
  genre

## Lane rotation status

This ingest **runs between scheduled loop ticks** and does
*not* consume an autonomous lane-rotation slot. The next loop
tick (cycle 162) will resume normal papers/chat/designs/
comments rotation. The papers-lane block count remains at 55+
consecutive cycles.

## Future cycle queue (for the autonomous loop)

The §queued-for-future-cycles ingestion plan from the source
page records what future cycles can pick up:

- 6 doc-level ingests
- 8+ per-package README ingests
- 7+ code-comment-fragment ingests on substantive source files
- Test-file ingests (per maintainer's explicit interest)

Future cycles can either follow normal rotation (with
ocap-kernel docs/packages/code occasionally selected) or the
maintainer can direct subsequent manual ingests targeted at
specific ocap-kernel content.

Ingest closes; resuming autonomous loop on the next firing.
