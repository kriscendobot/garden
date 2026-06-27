---
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
section_count: 9
status: current
notes: |
  **Seventh ocap-kernel ingest** (job `ingest-ocap-kernel-usage`, 2026-06-27),
  the follow-on to the sixth ingest (`ingest-ocap-kernel`, docs/kernel-guide.md).
  This is the 691-line **operational usage guide** — the setup-and-run companion
  to the model-level kernel-guide. Curated for the operator surface the kernel
  guide omits: browser/Node.js kernel instantiation, vat bundling via the
  `ocap` CLI, the `ClusterConfig` JSON shape, the imperative kernel API
  (subcluster lifecycle, `queueMessage`/`kunser`, libp2p remote comms), the
  development tools (TypeDoc, `ocap` CLI, Vitest), Playwright e2e testing, and
  two complete worked initialization examples.

  External sibling implementation: MetaMask/ocap-kernel is a SwingSet-lineage
  object-capability kernel **distinct from @endo** (same root, different code).
  Every section carries an honest *Lineage note*:
  - **Shared substrate**: `E()` imported directly from `@endo/eventual-send`;
    exos via `makeDefaultExo` (a `@endo/exo` wrapper); the injected
    `platformServices` + `kernelDatabase` seam mirrors Endo's platform/store
    abstraction.
  - **Divergences**: kref/vref/rref/eref four-scope name-space; first-class
    `kernel.revoke(kref)`; kernel services registered by name; `Far()` forbidden
    in favor of `makeDefaultExo`; SQLite-backed `kv` store vs Endo's formula
    graph.

  No-duplication discipline: the kernel/vat **model** (writing vat code, kernel
  services, subclusters, endowments, exos, baggage, revocation) is cross-linked
  to [kernel-guide](metamask-ocap-kernel--docs-kernel-guide-md.md), not
  re-ingested. BIP39 **identity** detail is cross-linked to
  [identity-backup-recovery](metamask-ocap-kernel--docs-identity-backup-recovery-md.md).
  The usage guide's "Common Use Cases" (recipe recaps) and the standalone
  "Identity Backup and Recovery" pointer are folded into the overview and
  kernel-api sections rather than given their own pages. Synthesizing concept
  page: [[ocap-kernel]].
---

## Abstract

The **OCAP Kernel Usage Guide** is MetaMask/ocap-kernel's 691-line operational guide to running the kernel in a host application — the setup-to-test arc the model-level `docs/kernel-guide.md` leaves out. It walks browser and Node.js kernel instantiation (the injected `platformServices` + `kernelDatabase` dependency seam, with `makeKernel` as the Node convenience path and worker remote-comms query-string config), vat bundling with the `@metamask/kernel-cli` (`yarn ocap bundle`), the `ClusterConfig` object (`bundleSpec` URL/`file://`/data-URL forms, the `globals` host-API endowment array, and the fail-closed `network.allowedHosts` allowlist), the imperative kernel API (`launchSubcluster`/`reloadSubcluster`/`terminateSubcluster`, `queueMessage` + `kunser`, `pingVat`/`terminateVat`/`restartVat`, `initRemoteComms` over libp2p relays, `getStatus` and a fenced testing/debugging-only group), the development tools (TypeDoc `build:docs`, the `ocap bundle`/`serve` CLI, Vitest), Playwright end-to-end testing for the extension, and two complete browser/Node.js worked examples.

This source is ingested as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo work, never imports its code. It is the operational complement to the sixth ingest (the kernel guide); together they cover ocap-kernel's developer-facing surface end to end.

## Sections

| Section | Topics | Status |
|---|---|---|
| [overview](../sections/metamask-ocap-kernel--docs-usage-md--overview.md) | getting-started, daemon | current |
| [setting-up-the-kernel](../sections/metamask-ocap-kernel--docs-usage-md--setting-up-the-kernel.md) | getting-started, daemon | current |
| [vat-bundles](../sections/metamask-ocap-kernel--docs-usage-md--vat-bundles.md) | bundles, daemon | current |
| [cluster-configuration](../sections/metamask-ocap-kernel--docs-usage-md--cluster-configuration.md) | daemon, capability-security | current |
| [kernel-api](../sections/metamask-ocap-kernel--docs-usage-md--kernel-api.md) | daemon | current |
| [endo-integration](../sections/metamask-ocap-kernel--docs-usage-md--endo-integration.md) | capability-security, eventual-send, exo | current |
| [development-tools](../sections/metamask-ocap-kernel--docs-usage-md--development-tools.md) | tooling, testing | current |
| [end-to-end-testing](../sections/metamask-ocap-kernel--docs-usage-md--end-to-end-testing.md) | testing | current |
| [implementation-example](../sections/metamask-ocap-kernel--docs-usage-md--implementation-example.md) | getting-started, daemon | current |

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
