---
title: "makeDefaultExo and makeDefaultInterface: the passable-guards wrapper ocap-kernel mandates in place of @endo/far's Far()"
source: packages/kernel-utils/src/exo.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/kernel-utils/src/exo.ts
source_kind: comment-fragment
source_path: packages/kernel-utils/src/exo.ts
source_line_range: "1-30"
source_branch: main
source_commit: fa464ca40c63a1e37504fdfb16e70ccdac9021df
source_date: 2025-09-04
comment_subject: makeDefaultInterface builds a named @endo/patterns InterfaceGuard whose defaultGuards are 'passable', and makeDefaultExo wraps @endo/exo's makeExo with that permissive interface — the shorthand ocap-kernel's AGENTS.md mandates instead of Far() from @endo/far so every remotable is interface-guarded by construction.
source_authors: [Erik Marks]
ingested: 2026-07-06
ingested_by: scholar
topics: [exo, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of the makeDefaultExo/makeDefaultInterface wrapper. Sixteenth ocap-kernel ingest; the makeDefaultExo home flagged by the kernel-utils README and the kernel-guide exos-remotable-objects section. See [[ocap-kernel]].
---

## Abstract

`packages/kernel-utils/src/exo.ts` is the 30-line source of ocap-kernel's **`makeDefaultExo`** — the wrapper the repo's `AGENTS.md` mandates be used *instead of* `Far` from `@endo/far` when making a remotable object. It exports two shorthands. `makeDefaultInterface(name)` builds a named `@endo/patterns` `InterfaceGuard` with **`defaultGuards: 'passable'`** — an interface that admits any passable argument for every method rather than requiring a per-method guard. `makeDefaultExo(name, methods, interfaceGuard?)` then wraps `@endo/exo`'s `makeExo` with that permissive interface (defaulting the guard to `makeDefaultInterface(name)`), so a caller supplies just a name and a methods object and gets back a fully interface-guarded exo. The point is a **policy divergence, not a mechanism one**: ocap-kernel forbids the bare `Far()` remotable so that every cross-vat object is an interface-guarded exo by construction — the guards are permissive by default, but the *shape* (a named exo carrying a `GET_INTERFACE_GUARD`) is uniform.

## Body

### makeDefaultInterface: a passable-by-default interface guard

```ts
import { makeExo } from '@endo/exo';
import type { Methods } from '@endo/exo';
import { M } from '@endo/patterns';
import type { InterfaceGuard } from '@endo/patterns';

/**
 * Shorthand for creating a named `@endo/patterns.InterfaceGuard` with default guards
 * set to 'passable'.
 *
 * @param name - The name of the interface.
 * @returns An interface with default guards set to 'passable'.
 */
export const makeDefaultInterface = (name: string): InterfaceGuard =>
  M.interface(name, {}, { defaultGuards: 'passable' });
```

`M.interface(name, methodGuards, options)` is `@endo/patterns`'s interface-guard constructor. Here the method-guards record is **empty** (`{}`) and `defaultGuards: 'passable'` supplies the fallback: any method not explicitly guarded accepts any *passable* argument and returns a passable. This is the loosest useful guard — it enforces pass-invariance (no raw functions/promises leaking through) without constraining arity or argument shapes.

### makeDefaultExo: the Far() replacement

```ts
/**
 * Shorthand for creating an `@endo/exo` remotable with default guards set to 'passable'.
 *
 * @param name - The name of the exo.
 * @param methods - The methods of the exo (i.e. the object to be made remotable).
 * @param interfaceGuard - The `@endo/patterns` interface guard to use for the exo.
 * @returns A named exo with default guards set to 'passable'.
 */
export const makeDefaultExo = <Interface extends Methods>(
  name: string,
  methods: Interface,
  interfaceGuard: InterfaceGuard = makeDefaultInterface(name),
): ReturnType<typeof makeExo<Interface>> =>
  // @ts-expect-error We're intentionally not specifying method-specific interface guards.
  makeExo(name, interfaceGuard, methods);
```

`makeDefaultExo` is a thin adapter over `makeExo(name, interfaceGuard, methods)`: it defaults the `interfaceGuard` parameter to `makeDefaultInterface(name)`, so the common call is just `makeDefaultExo(name, methods)`. The `// @ts-expect-error` comment states the trade explicitly — "We're intentionally not specifying method-specific interface guards." `makeExo`'s types want a method-guards mapping keyed to the methods; because the default interface declares none (relying on `defaultGuards: 'passable'`), the types do not line up and the mismatch is suppressed on purpose. The generic `<Interface extends Methods>` and the `ReturnType<typeof makeExo<Interface>>` return type preserve the caller's method signatures through the wrapper, so a consumer of the returned exo still sees typed methods even though the runtime guard is permissive.

### Why a mandated wrapper rather than Far()

ocap-kernel's `AGENTS.md` forbids `Far()` from `@endo/far` and requires `makeDefaultExo`. `Far(name, methods)` produces a remotable with *no* interface guard; `makeExo` produces one *with* a guard and a `GET_INTERFACE_GUARD` introspection method. By funneling every remotable through `makeDefaultExo`, the kernel guarantees a **uniform exo shape** across all vat code — every cross-vat object is interface-guarded and introspectable — while keeping the default guards permissive so authors are not forced to write per-method patterns up front. Tightening a specific object's guards is a local change (pass an explicit `interfaceGuard`); the floor is "always an exo, never a bare Far."

## Notice / drift check

Both JSDoc blocks match the code: `makeDefaultInterface` does build `M.interface(name, {}, { defaultGuards: 'passable' })`, and `makeDefaultExo` does default its guard to `makeDefaultInterface(name)` and delegate to `makeExo`. The `@ts-expect-error` comment ("intentionally not specifying method-specific interface guards") correctly describes why the `makeExo` call does not typecheck without the suppression. No comment-versus-code drift. The `Far()`-forbidden mandate lives in `AGENTS.md`, not in this file's comments, and this wrapper is its enactment — consistent, not contradictory. ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

This is a pure-policy divergence from Endo built *entirely on Endo primitives*: `makeExo`, `Methods`, `M.interface`, and `InterfaceGuard` are all imported straight from `@endo/exo` and `@endo/patterns` — ocap-kernel adds no new mechanism, only a house rule ("always `makeDefaultExo`, never `Far`") and a two-function shorthand that bakes the rule in. Endo itself offers the full spectrum (`Far` for a quick guardless remotable, `makeExo`/`defineExoClass`/`defineExoClassKit` for guarded ones — see the [`exo` topic](../topics/exo.md)); ocap-kernel deliberately removes the `Far` end of that spectrum for its vat authors. The same divergence is described from the host-developer side in the kernel guide's [exos-remotable-objects section](metamask-ocap-kernel--docs-kernel-guide-md--exos-remotable-objects.md), and this file is the `makeDefaultExo` home flagged by the [kernel-utils README ingest](metamask-ocap-kernel--packages-kernel-utils-readme--ocap-kernel-utilities-package-purpose.md). See [[ocap-kernel]].

Source: [packages/kernel-utils/src/exo.ts](https://github.com/MetaMask/ocap-kernel/blob/fa464ca40c63a1e37504fdfb16e70ccdac9021df/packages/kernel-utils/src/exo.ts) (lines 1-30) at commit `fa464ca`.
