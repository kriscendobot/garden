---
title: Writing Vat Code
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]].
---

## Abstract

Every vat exports a `buildRootObject(vatPowers, parameters, baggage)` function returning a root exo. The three arguments are the vat's entire initial authority: **`vatPowers`** (special powers like a logger), **`parameters`** (static config from `VatConfig.parameters`), and **`baggage`** (durable key-value store surviving restarts). The root exo's `bootstrap(vats, services)` method is the **introduction point** — called *exactly once* when the subcluster first launches, it is handed a record of references to the other vats and a record of the requested kernel services. This is the concrete enactment of capability **introduction** (one of the four ways to acquire references): the bootstrap vat receives, by initial conditions and endowment, the only references it will ever get unless later passed more. Critically, after a vat restart (**resuscitation**) `bootstrap` is **not** called again — the vat must restore its references and state from baggage, which is why services are typically `baggage.init`'d during bootstrap.

## Body

Every vat exports a `buildRootObject` function. This is the entry point for the vat's code.

```ts
import { makeDefaultExo } from '@metamask/kernel-utils/exo';
import type { Baggage } from '@metamask/ocap-kernel';

export function buildRootObject(
  vatPowers: unknown,
  parameters: Record<string, unknown>,
  baggage: Baggage,
) {
  return makeDefaultExo('root', {
    async bootstrap(
      vats: Record<string, unknown>,
      services: Record<string, unknown>,
    ): Promise<void> {
      // Called once when the subcluster is first launched.
      // `vats` contains references to other vats in the subcluster.
      // `services` contains references to kernel services requested in the cluster config.
    },

    async myMethod(arg: string): Promise<string> {
      return `hello ${arg}`;
    },
  });
}
```

### The three arguments

1. **`vatPowers`** — Special powers provided to the vat (e.g., a logger). Contents vary by vat configuration.
2. **`parameters`** — Static parameters from the vat's config (`VatConfig.parameters`). Useful for passing configuration like names or settings.
3. **`baggage`** — Persistent key-value storage that survives vat restarts.

### The bootstrap method

The `bootstrap` method is called exactly once when the subcluster is first launched. It receives:

- **`vats`** — A record mapping vat names to their root object references. Use `E()` to call methods on them.
- **`services`** — A record mapping service names to kernel service references. Use `E()` to call methods on them.

```ts
async bootstrap(
  vats: { alice: unknown; bob: unknown },
  services: { kernelFacet: unknown; myService: unknown },
): Promise<void> {
  // Store service references in baggage for use after restart
  baggage.init('kernelFacet', services.kernelFacet);

  // Communicate with other vats
  const greeting = await E(vats.alice).hello('world');
}
```

After a vat restart (resuscitation), `bootstrap` is **not** called again. The vat must restore its state from baggage.

## Lineage note

The `bootstrap`-receives-`vats`-and-`services` shape is the SwingSet bootstrap-vat pattern, and it is also the *three-party introduction* primitive in ocap terms: the kernel acts as the introducer that wires up the initial reference graph. Compare the library's [[granovetter-operator]] and [[four-ways-to-acquire-references]] (Introduction, Parenthood, Endowment, Initial Conditions). In ocap-kernel, `vats`/`services` references arrive by **endowment + initial conditions**; any reference passed in a later `E()` message arrives by **introduction**. Endo realizes the same acquisition taxonomy through the formula graph and CapTP message-passing rather than a single bootstrap callback.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
