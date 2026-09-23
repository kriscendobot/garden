---
source: docs/platform-specific.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/platform-specific.md
source_branch: main
source_commit: a3eff0efb70ba5f4c5919290aa295fe32138df4f
source_date: (last touched in commit `a3eff0efb`)
source_authors: [MetaMask ocap-kernel team]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 165. **Fifth ocap-kernel ingest** (cycles 161 / 162 /
  163 / 164 / 165 form the §ocap-kernel-mini-series).
  §Queued-doc-4 from cycle 161's plan.

  §Contributor-onboarding-document — 92 lines, the smallest
  doc in the queue so far. §Distinctively-not-about-the-
  system; §about-the-development-workflow.

  §Doc-as-contract-with-future-contributors. §Two-audience-
  surface observation: ocap-kernel docs split into user-
  targeted (cycle 164's identity-backup-recovery.md) and
  contributor-targeted (this doc).

  §Two-platforms-Node-and-browser as canonical targets.
  §Endo-comparison: same shape, more coupled (kernel runs
  on both as alternates) vs Endo's split-roles (daemon-on-
  Node + tether-on-browser as cooperating components).

  §Layered-architecture: §core-packages-contain-both-
  abstraction-and-platform-impls; §runtime-packages-
  orchestrate-by-choosing. §Single-source-of-truth-for-
  the-abstraction discipline.

  §Platform-obvious-vs-platform-implicit-exports — the
  naming convention tells platform. §Obvious: `nodejs`,
  `browser` segments. §Implicit: `wasm` (mechanism implies
  browser). §Reader-literacy-prerequisite acknowledged as
  §discipline-by-disclosure.

  §Mermaid-diagram-of-package-relationships: core →
  runtime → e2e-test layered. Four packages named.

  §Single-most-structurally-interesting-move: §six-step-
  development-guideline:
  1. Package Creation
  2. Platform-Agnostic Implementation
  3. Platform-Specific Implementation
  4. Package Configuration
  5. Platform Integration
  6. End-to-End Testing

  §Steps-are-ordered-with-explicit-dependency. §Abstraction-
  first-then-platforms-then-integration-then-tests.

  §Two-directory-structure-choices: simple (`<platform>/`)
  or complex (`<feature>/<platform>/`). §Convention-with-
  justified-flexibility.

  §Directory-structure-becomes-export-paths discipline.
  §No-mismatch-between-filesystem-and-package-graph.
  §Reduce-cognitive-overhead-by-removing-renames.

  §Integration-points-named-explicitly: vat-worker.ts +
  make-kernel.ts (Node); kernel-worker.ts + iframe.ts
  (browser). §Don't-leave-the-contributor-guessing-where-
  to-wire-things-in.

  §E2E-testing-per-platform: extension (browser) + kernel-
  test (Node) as canonical per-platform test packages.
  §Per-platform-e2e-package amortizes platform setup.

  §Cycle-145-formula-inspector + §cycle-147-workers-panel +
  §cycle-137-daemon-message-streaming all touch the Node-
  browser line; this doc would have been useful as a
  contributor reference for those work-streams.

  §Synthesis-target: Endo could borrow §named-core-vs-
  runtime-layering convention, §platform-obvious-vs-
  platform-implicit-exports naming, §six-step-development-
  flow, §canonical-per-platform-test-package, §name-the-
  integration-file discipline.

  §Tier-1 borrowing candidates: §core-vs-runtime-package-
  layering, §platform-obvious-vs-platform-implicit-exports,
  §six-step-development-flow, §directory-structure-becomes-
  export-paths, §canonical-per-platform-test-package,
  §name-the-integration-file.

  §Tier-2: §two-audience-surface (user docs vs contributor
  docs), §doc-as-contract-with-future-contributors.

  §Small-doc-doesn't-mean-shallow-ingest. §Cohesion-honest-
  section-count is one: the six-step-flow is the spine of
  the doc.

  Cycle 165 is comments-lane. Papers-lane blocked 59+
  consecutive cycles.
---

> Abstract: `docs/platform-specific.md` (92 lines) is the
> **§contributor-onboarding-document** for ocap-kernel's
> Node-vs-browser split.
>
> **Fifth ocap-kernel ingest** after cycles 161 / 162 / 163
> / 164. §Queued-doc-4 from cycle 161's plan.
>
> §Doc-as-contract-with-future-contributors. §Two-audience-
> surface observation: this doc is contributor-targeted
> (contrasts with cycle 164's user-targeted identity-
> backup-recovery.md).
>
> §Two-platforms-Node-and-browser canonical. §Layered-
> architecture: §core-packages-contain-both-abstraction-
> and-impl; §runtime-packages-orchestrate.
>
> §Platform-obvious-vs-platform-implicit-exports — naming
> convention tells platform. §Mechanism-named-when-platform-
> is-implied (`wasm` for browser).
>
> §Single-most-structurally-interesting-move: §six-step-
> development-guideline (§abstraction-first-then-platforms-
> then-integration-then-tests).
>
> §Directory-structure-becomes-export-paths discipline.
> §Integration-points-named-explicitly (vat-worker.ts,
> make-kernel.ts; kernel-worker.ts, iframe.ts).
> §Per-platform-e2e-package amortizes setup.
>
> §Tier-1 borrowing candidates: §core-vs-runtime-package-
> layering, §platform-obvious-vs-platform-implicit-exports,
> §six-step-development-flow, §directory-structure-becomes-
> export-paths, §canonical-per-platform-test-package,
> §name-the-integration-file.
>
> §Small-doc-doesn't-mean-shallow-ingest. §Cohesion-honest-
> section-count is one: the six-step-flow is the spine.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split](../sections/metamask-ocap-kernel--docs-platform-specific-md--platform-obvious-vs-platform-implicit-exports-with-six-step-contributor-guide-for-Node-browser-split.md) | daemon, tooling, getting-started | current |

One cohesion-honest section. §The-six-step-flow-is-the-
spine-of-the-doc; splitting would fragment the §contributor-
onboarding-shape.

## Provenance

- Fetched 2026-06-03 from `MetaMask/ocap-kernel@a3eff0efb`.
- License: dual Apache-2.0 + MIT.
- **Fifth ocap-kernel ingest**. §Queued-doc-4 from cycle
  161's plan.
- Cycle 165 was nominally **comments-lane** (continuing the
  §ocap-kernel-mini-series). Papers-lane has been blocked
  for **59+ consecutive cycles**.
- One cohesion-honest section.
