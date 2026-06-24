---
source_kind: external-monorepo-overview
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel
source_branch: main
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
source_date: 2026-05-28
source_authors: [Chip Morningstar, MetaMask team]
ingested: 2026-06-03
ingested_by: liaison (user-directed manual ingest)
section_count: 1
status: current
notes: |
  **First-pass reference-shelf ingest** of the MetaMask/ocap-
  kernel monorepo, directed by the maintainer as a reference
  for future work. The §reference-for-future-work framing:
  comparison, contrast, and synthesis of requirements where
  ocap-kernel's choices differ from ours.

  **First ingest of a §sibling-implementation** — a fourth
  source genre alongside @endo source files (substrates we
  use), endo-but-for-bots designs (our forward roadmap), and
  external papers (formal foundations).

  §Monorepo-structure: 30 packages + 6 docs (~2000 lines) +
  README + AGENTS.md. Top-level HEAD at commit `a3eff0efb`
  2026-05-28 by Chip Morningstar (`feat: agentmask + service
  discovery infrastructure (#952)`).

  **30 packages** in five categories:
  - **Kernel core**: ocap-kernel (Kernel.ts, VatHandle.ts,
    VatSupervisor.ts, KernelQueue.ts, KernelRouter.ts,
    KernelServiceManager.ts, SubclusterManager.ts) /
    kernel-store / kernel-shims / kernel-utils (with
    makeDefaultExo) / kernel-errors / kernel-rpc-methods /
    kernel-platforms.
  - **Runtime hosts**: kernel-browser-runtime / kernel-node-
    runtime / extension / nodejs-test-workers.
  - **Streams + iterables**: streams (lineage of @endo/stream
    with BaseDuplexStream.ts) / remote-iterables.
  - **Agents + LLM**: kernel-agents / kernel-agents-repl /
    kernel-language-model-service / llm-bridge / agentmask.
  - **Service discovery** (newest, May 2026): service-
    discovery-types / service-matcher.
  - **Testing**: kernel-test / kernel-test-local / kernel-ui.
  - **Tooling**: kernel-cli / repo-tools / create-package /
    template-package / logger.
  - **Experiments**: evm-wallet-experiment / sample-services /
    omnium-gatherum.

  Single most structurally interesting move: §Ken-protocol-
  substrate. `docs/ken-protocol-assessment.md` (203 lines)
  explicitly tabulates ocap-kernel's implementation against
  the Ken protocol (HPL-2010-155: *Output-Valid Rollback-
  Recovery* by Kelly/Karp/Stiegler/Close/Cho). Seven
  properties: exactly-once delivery / output validity /
  transactional turns / consistent frontier / local recovery /
  sender-based message logging / deferred transmission.
  §Named-protocol-as-acceptance-criterion discipline. §Self-
  assessment-against-named-protocol pattern.

  §Crank-buffering centerpiece (Issue #786): turn-scoped
  output queue with database-savepoint atomicity. §Atomic-
  output-or-rollback discipline. Directly cross-comparable
  with cycle 119 (capability-bus envelope) / cycle 137
  (daemon-message-streaming) / cycle 149 (unhandled-rejection-
  display §error-path-cannot-depend-on-error-path) / cycle
  100 (SES GC-driven rejection tracker).

  §Canonical-vocabulary survey: 22-row glossary table mapping
  ocap-kernel terms to Endo parallels. §Kref-vref-rref-eref
  four-layer name-space is the most distinctive divergence
  from Endo (which conflates many into formula-identifier).

  §AGENTS.md style observations: lockdown first / harden() at
  end of constructors / E() for messaging / *Do not use Far
  from @endo/far* (§forbid-direct-Far in favor of
  makeDefaultExo wrapper) / @metamask/superstruct for runtime
  type checking / type-not-interface / never-enum.

  §Public-private-namespace-split: `@metamask/` published vs
  `@ocap/` private. Endo doesn't have this split.

  §Queued-for-future-cycles ingestion plan: per-doc ingests
  (ken-protocol-assessment / kernel-guide / usage / glossary /
  identity-backup-recovery / platform-specific) / per-package
  README ingests / code-comment-fragment ingests on key
  source files / **test-file ingests** (per maintainer's note
  about adapting tests to our OCapN and slot machine
  libraries).

  §Reference-not-substrate stance: we don't *import*
  ocap-kernel's code; we *read* their choices to inform ours.

  §Sibling-implementation-comparison genre opens with this
  ingest. Future cycles drawing on ocap-kernel content should
  preserve the stance.

  This ingest is **not part of the autonomous papers/chat/
  designs/comments rotation** — it's a user-directed manual
  task running between scheduled loop ticks. The next loop
  tick (cycle 162) will resume normal rotation.
---

> Abstract: `MetaMask/ocap-kernel` is a TypeScript monorepo
> implementing an object-capability kernel-and-vat
> architecture derived from the same Agoric SwingSet lineage
> as `@endo` and the garden's slot-machine work in
> `endojs/endo-but-for-bots`. **First-pass reference-shelf
> ingest** directed by the maintainer for future comparison/
> contrast/synthesis work.
>
> §First ingest of a §sibling-implementation: a fourth source
> genre alongside @endo source files / endo-but-for-bots
> designs / external papers. §Reference-not-substrate stance.
>
> §Monorepo-structure: 30 packages + 6 docs + README +
> AGENTS.md. Five package categories (kernel-core / runtime-
> hosts / streams+iterables / agents+LLM / service-discovery /
> testing / tooling / experiments).
>
> **Single most structurally interesting move**: §Ken-protocol-
> substrate. `docs/ken-protocol-assessment.md` tabulates the
> implementation against HPL-2010-155's seven properties.
> §Named-protocol-as-acceptance-criterion discipline.
> §Crank-buffering centerpiece directly cross-comparable
> with cycles 100 / 119 / 137 / 149.
>
> §Canonical-vocabulary survey mapping 22 terms to Endo
> parallels. §Kref-vref-rref-eref four-layer name-space is
> the most distinctive divergence from Endo.
>
> §AGENTS.md style observations (lockdown / harden / E /
> forbid-direct-Far in favor of makeDefaultExo wrapper /
> @metamask/superstruct / type-not-interface / never-enum).
>
> §Public-private-namespace-split: @metamask/ published vs
> @ocap/ private.
>
> §Queued-for-future-cycles ingestion plan: per-doc / per-
> package / code-fragment / test-file ingests. The §sibling-
> implementation-comparison genre opens with this ingest.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate](../sections/metamask-ocap-kernel--overview--monorepo-survey-with-SwingSet-derived-kernel-vat-architecture-and-Ken-protocol-substrate.md) | daemon, captp, persistence | current |

First-pass reference-shelf overview. One cohesion-honest
section. Future cycles will add per-doc / per-package / code-
comment / test-file ingests.

## Provenance

- Cloned 2026-06-03 from `https://github.com/MetaMask/ocap-
  kernel.git` (HEAD on `main` at commit `a3eff0efb70ba5f4c5919290aa295fe32138df4f`).
- Bare clone at `/home/kris/garden/worktrees/metamask-ocap-
  kernel.git/`.
- Latest commit 2026-05-28 by Chip Morningstar: `feat:
  agentmask + service discovery infrastructure (#952)`.
- License: dual Apache-2.0 + MIT.
- **First-pass reference-shelf ingest** — directed by
  maintainer as a reference for future comparison/contrast/
  synthesis work.
- **First ingest of §sibling-implementation** genre.
- Ingest happens between scheduled loop ticks (between cycles
  161 and 162); does not consume an autonomous lane-rotation
  slot.
- One cohesion-honest section. Future cycles add more.
