---
title: Endo Integration
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security, eventual-send, exo]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. Soft-flag cross-source overlap with the kernel guide's exos-remotable-objects and eventual-send-with-e; this section keeps only the operational restatement plus the further-resources pointer list.
---

## Abstract

The usage guide states the Endo dependency directly: the OCAP Kernel **builds on the Endo project**, which supplies the core object-capability patterns and tools, and vat development depends on understanding them. Operationally this reduces to two imports a vat author always uses — `makeDefaultExo` (from `@metamask/kernel-utils/exo`) to create shareable capability objects, and `E()` (from `@endo/eventual-send`) for asynchronous cross-vat sends — plus a curated **Further Resources** link list (the ocap-kernel design wiki, Endo docs, SES, marshal, the Wikipedia object-capability article, and Agoric docs). The object-capability and eventual-send *mechanics* are taught in depth in the kernel guide's [exos-remotable-objects](metamask-ocap-kernel--docs-kernel-guide-md--exos-remotable-objects.md) and [eventual-send-with-e](metamask-ocap-kernel--docs-kernel-guide-md--eventual-send-with-e.md); this section keeps the operational restatement and the pointer list rather than duplicating them.

## Body

> The OCAP Kernel builds on the [Endo project](https://github.com/endojs/endo), which provides core object capability patterns and tools. Understanding these fundamental concepts is essential for effective vat development.

For in-depth coverage of writing vat code, kernel services, system subclusters, and persistence patterns, the usage guide refers readers to the Kernel Guide (ingested as [metamask-ocap-kernel--docs-kernel-guide-md](metamask-ocap-kernel--docs-kernel-guide-md.md)).

### Object-capability model (operational)

Vats use Endo's object-capability model through `makeDefaultExo` to create shareable objects. The root object a vat returns must itself be made with `makeDefaultExo`; nested service objects are made the same way and returned from root methods:

```javascript
import { makeDefaultExo } from '@metamask/kernel-utils/exo';

export function buildRootObject(vatPowers, parameters, _baggage) {
  const { name } = parameters;
  const service = makeDefaultExo('service', {
    getData() {
      return { value: 'some data' };
    },
  });
  return makeDefaultExo('root', {
    getService() { return service; },
    bootstrap() { return 'bootstrap complete'; },
  });
}
```

### Eventual sends (operational)

Vats communicate asynchronously using `E()` from `@endo/eventual-send`. A vat that holds another vat's provider awaits `E(provider).getService()`, then calls methods on the returned reference with `E(service).getData()`:

```javascript
import { makeDefaultExo } from '@metamask/kernel-utils/exo';
import { E } from '@endo/eventual-send';

export function buildRootObject(vatPowers, parameters, _baggage) {
  return makeDefaultExo('root', {
    async useRemoteService(serviceProvider) {
      const service = await E(serviceProvider).getService();
      const data = await E(service).getData();
      return data;
    },
  });
}
```

### Further resources (as listed)

- Notes On The Design Of An Ocap Kernel (the ocap-kernel wiki).
- Endo Documentation; SES (Secure ECMAScript); Endo Marshal.
- The Object Capability Model (Wikipedia).
- Agoric Documentation (Endo is based on technology developed for Agoric).

### Lineage note

This is the clearest shared-substrate point in the whole usage guide: `E()` is imported **directly** from `@endo/eventual-send` — ocap-kernel does not reimplement eventual send, it consumes Endo's shim (the kernel adds target demultiplexing by kref scope, not a new promise model). `makeDefaultExo` is a `@endo/exo` wrapper, with ocap-kernel's policy that `Far()` from `@endo/far` is forbidden in vat code (a policy divergence, not a mechanism one — see the [glossary](../sources/metamask-ocap-kernel--docs-glossary-md.md) and [[ocap-kernel]]). Promise pipelining ([[promise-pipelining]]) applies verbatim because the shim is the same.

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
