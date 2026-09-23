---
title: OCAP Kernel Usage Guide (overview)
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [getting-started, daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. The operational companion to the model-level [kernel-guide](metamask-ocap-kernel--docs-kernel-guide-md.md); this doc covers setup, bundling, CLI, and testing that the guide omits.
---

## Abstract

`docs/usage.md` is MetaMask/ocap-kernel's **691-line operational usage guide** — the setup-and-run companion to the model-level `docs/kernel-guide.md`. Where the kernel guide teaches the *kernel/vat model* (writing vat code, kernel services, subclusters, endowments, exos, baggage, revocation), the usage guide teaches the *operator surface*: how to instantiate the kernel in a browser or Node.js host, how to bundle vat code with the `@metamask/kernel-cli`, the shape of a `ClusterConfig` JSON object, the imperative kernel API for launching subclusters and queuing messages, the development tools (TypeDoc, the `ocap` CLI, Vitest), Playwright end-to-end testing, and two complete worked initialization examples. This overview names the document's audience (a host-application developer wiring up the kernel) and its relationship to the kernel guide so a reader lands on the operational page when their question is "how do I run this" rather than "what is the model".

## Body

The OCAP Kernel is described in this guide as "a powerful object capability-based system that enables secure, isolated execution of JavaScript code in vats (similar to secure sandboxes)". The usage guide is organized as a setup-to-test arc:

1. **Setting Up the Kernel** — browser and Node.js instantiation, plus configuring remote comms for kernel workers. See [setting-up-the-kernel](metamask-ocap-kernel--docs-usage-md--setting-up-the-kernel.md).
2. **Vat Bundles** — bundling vat code with the `ocap` CLI. See [vat-bundles](metamask-ocap-kernel--docs-usage-md--vat-bundles.md).
3. **Cluster Configuration** — the `ClusterConfig` object, `bundleSpec` forms, the `globals` endowment field, and the `network.allowedHosts` per-vat allowlist. See [cluster-configuration](metamask-ocap-kernel--docs-usage-md--cluster-configuration.md).
4. **Kernel API** — launching/reloading/terminating subclusters, sending messages, vat management, remote communications, status and debugging methods. See [kernel-api](metamask-ocap-kernel--docs-usage-md--kernel-api.md).
5. **Identity Backup and Recovery** — a short pointer to the dedicated BIP39 mnemonic doc already ingested as [identity-backup-recovery](../sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md). The usage guide only shows the `Kernel.make({ mnemonic })` call shape; the detail lives in that source.
6. **Common Use Cases** — recipe summaries (creating a vat, vat-to-vat communication, persistence). These are thin pointers back into the rest of the doc and into the kernel guide's [baggage-persistent-state](metamask-ocap-kernel--docs-kernel-guide-md--baggage-persistent-state.md); not given their own section here to avoid duplicating the guide.
7. **Endo Integration** — the object-capability model and eventual sends, restated operationally. See [endo-integration](metamask-ocap-kernel--docs-usage-md--endo-integration.md).
8. **Development Tools** — TypeDoc API docs, the `ocap` CLI, Vitest testing, debugging. See [development-tools](metamask-ocap-kernel--docs-usage-md--development-tools.md).
9. **End-to-End Testing** — Playwright extension tests. See [end-to-end-testing](metamask-ocap-kernel--docs-usage-md--end-to-end-testing.md).
10. **Implementation Example** — complete browser and Node.js initialization. See [implementation-example](metamask-ocap-kernel--docs-usage-md--implementation-example.md).

### Lineage note

MetaMask/ocap-kernel is a **SwingSet-lineage object-capability kernel distinct from `@endo`** (same root, different code). The usage guide's operator surface is the most concrete cross-comparison point for any Endo daemon work: the kernel is instantiated with injected `platformServices` and a `kernelDatabase`, exactly the dependency-injection shape that lets one kernel core run on Node.js and in the browser. Vat code imports `E()` straight from `@endo/eventual-send` and builds remotables with `makeDefaultExo` (a `@endo/exo` wrapper). The divergences the kernel guide records (kref/vref/rref/eref four-scope name-space, first-class `kernel.revoke(kref)`, name-registered kernel services, `Far()` forbidden) all surface again here at the API call sites.

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
