---
title: Exos (Remotable Objects)
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [exo, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel wraps @endo/exo as makeDefaultExo and forbids Far(). See [[ocap-kernel]].
---

## Abstract

An **exo** is a remotable object — one that can be passed between vats, stored in baggage, and invoked via `E()`. All objects participating in the kernel's object-capability system must be exos. They are created with `makeDefaultExo(name, methods)`, where `name` is a debug/interface label and `methods` is an object of (sync or async) methods; `makeDefaultExo` wraps `@endo/exo`'s `makeExo` with permissive default guards (accepting any "passable" argument). Exos are **remotable** (sendable as args/returns), **durable** (storable in baggage, survive restarts), **hardened** (auto-frozen — methods cannot be modified after creation), and **interface-guarded** (arguments validated against a guard, default "passable"). The guide is emphatic: **do NOT use `Far()` from `@endo/far`** — this codebase uses `makeDefaultExo` instead. That prohibition is the single most prescriptive divergence from Endo: ocap-kernel deliberately funnels all remotable creation through one blessed wrapper.

## Body

An **exo** is a remotable object — one that can be passed between vats, stored in baggage, and invoked via `E()`. All objects that participate in the kernel's object capability system must be exos.

### Creating an exo

```ts
import { makeDefaultExo } from '@metamask/kernel-utils/exo';

const myObject = makeDefaultExo('MyObject', {
  greet(name: string): string {
    return `hello ${name}`;
  },
  async fetchData(id: string): Promise<unknown> {
    return someAsyncOperation(id);
  },
});
```

The first argument is a **name** (used for debugging and interface identification). The second is an object of methods. `makeDefaultExo` wraps `@endo/exo`'s `makeExo` with permissive default guards (accepting any "passable" arguments).

### Key properties of exos

- **Remotable**: Can be sent to other vats as arguments or return values.
- **Durable**: Can be stored in baggage and survive vat restarts.
- **Hardened**: Exos are automatically frozen/hardened — their methods cannot be modified after creation.
- **Interface-guarded**: Method arguments are validated against an interface guard (default: "passable", which accepts most serializable values).

### Do NOT use `Far()`

This codebase uses `makeDefaultExo` instead of `Far()` from `@endo/far`. Do not use `Far()`.

## Lineage note

The exo *machinery* is Endo's — `makeDefaultExo` is a thin wrapper over `@endo/exo`'s `makeExo` (compare the library's [[exo]] topic and `defineExoClass` / `defineExoClassKit` / `makeExo` factory trio). The *divergence is a policy, not a mechanism*: ocap-kernel forbids the `@endo/far` `Far()` primitive and requires the `makeDefaultExo` wrapper, promoting a contributor norm into a project-wide rule (see the glossary ingest's §forbid-direct-Far observation). The default "passable" guard is more permissive than Endo's typical `M.interface` shape guards, trading argument validation for ergonomics; a host application wanting tighter guards drops to the lower-level `@endo/exo` APIs.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
