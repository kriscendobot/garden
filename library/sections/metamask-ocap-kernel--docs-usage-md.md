---
title: "OCAP Kernel Usage Guide (MetaMask/ocap-kernel) — setup, vat bundles, cluster config, kernel API, CLI tools, testing"
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [getting-started, daemon, bundles, capability-security, eventual-send, exo, tooling, testing]
status: current
kind: index
section_count: 9
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Seventh ocap-kernel ingest (job `ingest-ocap-kernel-usage`). The operational companion to the model-level kernel-guide; covers setup, bundling, CLI, and testing. See [[ocap-kernel]] and the §ocap-kernel-mini-series.
---

## Abstract

The **OCAP Kernel Usage Guide** is MetaMask/ocap-kernel's 691-line operational guide — the setup-and-run companion to the model-level `docs/kernel-guide.md`. Where the kernel guide teaches the kernel/vat *model*, the usage guide teaches the *operator surface*: instantiating the kernel in a browser or Node.js host (the injected `platformServices` + `kernelDatabase` seam), bundling vat code with the `@metamask/kernel-cli` (`yarn ocap bundle`), the `ClusterConfig` JSON object (`bundleSpec` forms, the `globals` endowment field, the `network.allowedHosts` allowlist), the imperative kernel API (subcluster lifecycle, `queueMessage` + `kunser`, libp2p remote comms via `initRemoteComms`, status/debugging methods), the development tools (TypeDoc, the `ocap` CLI, Vitest), Playwright end-to-end testing, and two complete worked initialization examples. It is curated for the parts the kernel guide omits, cross-linking the guide for everything model-level.

This source is curated as a **reference-shelf / sibling-implementation entry**: the library reads ocap-kernel's choices to inform Endo work, never imports its code. Each child section carries an honest *Lineage note* (shared substrate `@endo/eventual-send` + `@endo/exo`; divergences in the four-scope name-space, first-class `kernel.revoke(kref)`, name-registered kernel services, and `makeDefaultExo` in place of `Far()`). Material the kernel guide and the identity-backup-recovery doc already cover (the kernel/vat model, BIP39 identity detail) is cross-linked, not duplicated.

## Sections

- [OCAP Kernel Usage Guide (overview)](metamask-ocap-kernel--docs-usage-md--overview.md)
- [Setting Up the Kernel](metamask-ocap-kernel--docs-usage-md--setting-up-the-kernel.md)
- [Vat Bundles](metamask-ocap-kernel--docs-usage-md--vat-bundles.md)
- [Cluster Configuration](metamask-ocap-kernel--docs-usage-md--cluster-configuration.md)
- [Kernel API (operational)](metamask-ocap-kernel--docs-usage-md--kernel-api.md)
- [Endo Integration](metamask-ocap-kernel--docs-usage-md--endo-integration.md)
- [Development Tools](metamask-ocap-kernel--docs-usage-md--development-tools.md)
- [End-to-End Testing](metamask-ocap-kernel--docs-usage-md--end-to-end-testing.md)
- [Implementation Example (browser and Node.js)](metamask-ocap-kernel--docs-usage-md--implementation-example.md)

## See also

- Source index: [metamask-ocap-kernel--docs-usage-md](../sources/metamask-ocap-kernel--docs-usage-md.md)
- Model companion: [kernel-guide](metamask-ocap-kernel--docs-kernel-guide-md.md) (writing vat code, kernel services, subclusters, endowments, exos, baggage, revocation)
- Identity detail: [identity-backup-recovery](../sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md)
- Synthesizing concept: [[ocap-kernel]]
- Shared substrate: [[eventual-send]], [[promise-pipelining]]; confinement: [[object-capability]], [compartments](../topics/compartments.md)

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
