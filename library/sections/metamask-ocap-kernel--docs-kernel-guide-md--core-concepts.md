---
title: Core Concepts
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, capability-security, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage ocap kernel distinct from @endo. See [[ocap-kernel]] concept for the lineage flag.
---

## Abstract

The host-developer-facing vocabulary of MetaMask's ocap-kernel: **kernel** (centralized manager of vats and distributed objects — routes messages, manages references, handles persistence and GC), **vat** (isolated unit of computation where user code runs; communicates only by async message passing via `E()`), **subcluster** (a group of vats launched together, whose **bootstrap vat** receives references to the other vats and requested kernel services), **system subcluster** (declared at kernel startup; may access privileged `systemOnly` services), **kernel service** (an object registered with the kernel and callable by vats via `E()`, but executing in the kernel's own context, not a vat), **kref** (a kernel-wide object identifier string like `ko42`), and **exo** (a remotable object made with `makeDefaultExo()`). This is MetaMask's vocabulary for the same SwingSet-derived kernel/vat architecture Endo and Agoric descend from; the terms map onto Endo equivalents but are *not* the same code (see Translation).

## Body

The **kernel** is a centralized manager of **vats** and **distributed objects**. It routes messages between vats, manages object references, handles persistence, and performs garbage collection.

A **vat** is an isolated unit of computation — think of it as a worker process. User code runs inside vats. Vats communicate with each other and with the kernel through asynchronous message passing. You never call methods on objects in other vats directly; you use `E()` (eventual send) to queue messages.

A **subcluster** is a logically related group of vats that are launched together. When you launch a subcluster, all its vats start, and then the **bootstrap vat** receives references to the other vats and to any **kernel services** the subcluster requested.

A **system subcluster** is a subcluster declared at kernel startup time. System subclusters can access privileged services (marked `systemOnly`) that regular subclusters cannot.

A **kernel service** is an object registered with the kernel that vats can call via `E()`. Services run outside of vats — they execute in the kernel's own context. Examples include the kernel facet (privileged kernel operations) and IO services.

A **kref** (kernel reference) is a string like `ko42` that uniquely identifies an object within the kernel. Krefs are the kernel's internal addressing system. When a vat exports an object or receives a reference to one, the kernel assigns and tracks krefs.

An **exo** is a remotable object created with `makeDefaultExo()` (or the lower-level `@endo/exo` APIs). Exos are the standard way to create objects that can be passed between vats, stored in baggage, and invoked via `E()`.

## Translation (ocap-kernel → Endo/Agoric lineage)

| ocap-kernel term | Endo / Agoric parallel | Divergence |
|---|---|---|
| kernel | Endo daemon (the capability-bus / message router) | ocap-kernel centralizes vat lifecycle + run-queue cranks; Endo's daemon routes capabilities but has no single run-queue crank model. |
| vat | Endo worker (bundle running in a compartment) | Same SwingSet root; see [[vat-and-compartment]]. ocap-kernel keeps the SwingSet "vat" name; Endo speaks of bundles + compartments. |
| subcluster | Endo bundle-group | ocap-kernel makes the launch-group a first-class object with a bootstrap vat; Endo composes bundles via the formula graph instead. |
| kernel service | Endo host methods / powers | ocap-kernel registers them by name on the kernel and validates access at subcluster launch. |
| kref | Endo formula identifier | ocap-kernel separates kref/vref/rref/eref into four explicit scopes (see [[ocap-kernel]]); Endo conflates these in the formula-identifier shape. |
| exo | `@endo/exo` `defineExoClass` / `makeExo` | ocap-kernel wraps `@endo/exo` as `makeDefaultExo` and *forbids* `Far()` from `@endo/far`. |

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
