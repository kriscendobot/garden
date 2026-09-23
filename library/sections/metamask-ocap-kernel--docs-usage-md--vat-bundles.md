---
title: Vat Bundles
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [bundles, daemon]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. The bundling/CLI step is operational; the vat contract it bundles is taught in the kernel guide's writing-vat-code.
---

## Abstract

A vat runs JavaScript bundled into a specific format. The operational step is one CLI invocation: write a vat module that default-exports `buildRootObject(vatPowers, parameters, baggage)` returning its root remotable via `makeDefaultExo`, then bundle it with `yarn ocap bundle ./path/to/vat.js` from the `@metamask/kernel-cli`. The bundle artifact is what a `ClusterConfig`'s `bundleSpec` then points at. This section captures the operator-facing bundling procedure and the `buildRootObject` example; the *semantics* of the vat contract (the once-only `bootstrap`, resuscitation from baggage) are the kernel guide's [writing-vat-code](metamask-ocap-kernel--docs-kernel-guide-md--writing-vat-code.md), cross-linked rather than duplicated here.

## Body

To create a vat bundle:

1. Write your vat code with a root object that exports methods.
2. Bundle the code using `@metamask/kernel-cli` with `yarn ocap bundle ./path/to/vat.js`.

Example vat code:

```javascript
import { makeDefaultExo } from '@metamask/kernel-utils/exo';

/**
 * Build function for a vat.
 *
 * @param {object} vatPowers - Special powers granted to this vat.
 * @param {object} parameters - Initialization parameters from the vat's config.
 * @param {object} _baggage - Root of vat's persistent state.
 * @returns {object} The root object for the new vat.
 */
export function buildRootObject(vatPowers, parameters, _baggage) {
  const { name } = parameters;
  return makeDefaultExo('root', {
    greet() {
      return `Greeting from ${name}`;
    },
    async processMessage(message) {
      return `${name} processed: ${message}`;
    },
  });
}
```

The bundle this produces is referenced from a cluster configuration's `bundleSpec` (see [cluster-configuration](metamask-ocap-kernel--docs-usage-md--cluster-configuration.md)).

### Lineage note

The `buildRootObject(vatPowers, parameters, baggage)` contract and `makeDefaultExo` are kernel-guide material; the **bundling step itself** (an explicit `ocap bundle` CLI pass that emits a deployable artifact) is the ocap-kernel operator surface. Endo's analog is `@endo/bundle-source` / `@endo/import-bundle` ([[bundles]]): Endo likewise compiles a module graph into a portable bundle that the daemon imports into a compartment. The vocabulary differs (ocap-kernel "vat bundle" via `ocap bundle`; Endo "bundle" via `bundle-source`), the substrate role is the same — a confined unit of code shipped as data.

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
