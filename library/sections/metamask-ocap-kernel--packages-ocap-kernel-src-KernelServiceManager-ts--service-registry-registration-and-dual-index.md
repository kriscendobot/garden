---
title: "The kernel-service registry: registration with kref pinning, unregistration, and the dual by-name / by-kref index"
source: packages/ocap-kernel/src/KernelServiceManager.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/KernelServiceManager.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/KernelServiceManager.ts
source_line_range: "10-134"
source_branch: main
source_commit: d979a06325666af32ca7f68b13e9c85486d89ab5
source_date: 2026-04-07
comment_subject: "The KernelServiceManager holds the kernel's service objects in two Maps keyed by name and by kref; registerKernelServiceObject dedups by name, provisions a stable pinned 'kernel'-owned kref (persisted through the kernel store) if the name has none yet, and records both indexes; unregister reverses all of it (delete both entries, unpin, delete the persisted kref); getKernelService / getKernelServiceByKref / isKernelService are the read surface KernelRouter uses to decide a message is kernel-bound."
source_authors: [Erik Marks, grypez, Dimitris Marlagkoutsos, Chip Morningstar]
ingested: 2026-07-06
ingested_by: scholar
topics: [capability-security, persistence]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo (same root, different code). Comment-fragment ingest of KernelServiceManager's registration + lookup surface. Fourteenth ocap-kernel ingest, sixth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`KernelServiceManager` "manages kernel services registration and invocation" — it is the kernel's registry of privileged in-kernel service objects that vats reach by `E()`-sending to a **kref**. This section covers the registry half: the `KernelService` record type, the **dual index** (two `Map`s, one keyed by service `name` and one keyed by `kref`, deliberately redundant so both "does this name exist" and "is this kref a service" are O(1)), and the register / unregister / lookup methods. `registerKernelServiceObject` **dedups by name** (a second registration of an existing name throws), and — the persistence-relevant move — provisions a **kref only if the name does not already have one**: it asks the kernel store `getKernelServiceKref(name)`, and on a miss `initKernelObject('kernel')` mints a fresh kernel-owned object ref, records it via `setKernelServiceKref`, and **`pinObject`s it** so garbage collection never reclaims a service the kernel advertises. `unregisterKernelServiceObject` reverses every step (delete both map entries, `unpinObject`, `deleteKernelServiceKref`). The three read methods (`getKernelService`, `getKernelServiceByKref`, `isKernelService`) are the surface [`KernelRouter`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts.md)'s `endpointId === 'kernel'` branch and `#invokeKernelService` lean on to recognize a kernel-bound target.

## Body

### The service record and the dual index

```ts
export type KernelService = {
  name: string;
  kref: KRef;
  service: object;
  systemOnly: boolean;
};
```

```ts
/** Objects providing custom or kernel-privileged services to vats, indexed by name */
readonly #kernelServicesByName: Map<string, KernelService> = new Map();

/** Objects providing custom or kernel-privileged services to vats, indexed by kref */
readonly #kernelServicesByObject: Map<KRef, KernelService> = new Map();
```

A `KernelService` bundles the human-facing `name`, the kernel-global `kref` that names it to vats, the actual JavaScript `service` object whose methods will be invoked, and the `systemOnly` flag (whether only **system subclusters** may reach it — the privileged-service gate the [[ocap-kernel]] kernel guide describes). The two `Map`s are the same records under two keys: **by name** answers registration/lookup by the string a host passes to `registerKernelServiceObject`, and **by kref** answers the router's "is the target of this message a kernel service?" question without a linear scan. Keeping both is a deliberate space-for-time trade — every register/unregister writes and deletes both, so they cannot drift.

### Registration: dedup by name, provision-and-pin a persistent kref

```ts
registerKernelServiceObject(
  name: string,
  service: object,
  { systemOnly = false }: { systemOnly?: boolean } = {},
): KernelService {
  if (this.#kernelServicesByName.has(name)) {
    throw new Error(`Kernel service "${name}" is already registered`);
  }
  let kref = this.#kernelStore.getKernelServiceKref(name);
  if (!kref) {
    kref = this.#kernelStore.initKernelObject('kernel');
    this.#kernelStore.setKernelServiceKref(name, kref);
    this.#kernelStore.pinObject(kref);
  }
  const kernelService = { name, kref, service, systemOnly };
  this.#kernelServicesByName.set(name, kernelService);
  this.#kernelServicesByObject.set(kref, kernelService);
  return kernelService;
}
```

Two invariants live in this method. First, **name uniqueness**: a duplicate name is a programming error and throws immediately, before any store mutation. Second, and the persistence-relevant part, the kref is provisioned **at most once per name across the kernel's whole history**: `getKernelServiceKref(name)` consults the persistent kernel store, and only on a miss does the manager `initKernelObject('kernel')` (mint a new object owned by the kernel itself, `'kernel'` being the owner sentinel [`KernelRouter`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md) also special-cases), `setKernelServiceKref` (persist the name→kref binding), and **`pinObject(kref)`** (exempt it from GC). The pin is what lets a service kref be handed to vats and stored in their baggage indefinitely: because the kernel pins it, the ocap-kernel refcount GC will never retire it out from under a holder. On a kernel restart the same name resolves to the same persisted kref, so a vat's stored reference to a kernel service survives resuscitation — the in-memory `Map`s are rebuilt (a fresh `service` object bound to the persisted kref), but the *identity* the vats hold is stable.

### Unregistration mirrors registration exactly

```ts
unregisterKernelServiceObject(name: string): void {
  const service = this.#kernelServicesByName.get(name);
  if (!service) {
    return;
  }
  this.#kernelServicesByName.delete(name);
  this.#kernelServicesByObject.delete(service.kref);
  this.#kernelStore.unpinObject(service.kref);
  this.#kernelStore.deleteKernelServiceKref(name);
}
```

Unregistration is idempotent for an unknown name (early return, no throw) and otherwise reverses every registration step: drop both index entries, **`unpinObject`** (re-admit the kref to GC), and `deleteKernelServiceKref` (drop the persisted binding). Note the order — the in-memory indexes are cleared first, so no concurrent lookup can observe a half-unregistered service, and only then is the durable state released.

### The read surface the router consumes

```ts
getKernelService(name: string): KernelService | undefined {
  return this.#kernelServicesByName.get(name);
}
getKernelServiceByKref(kref: KRef): KernelService | undefined {
  return this.#kernelServicesByObject.get(kref);
}
isKernelService(kref: KRef): boolean {
  return this.#kernelServicesByObject.has(kref);
}
```

Three thin readers. `isKernelService(kref)` is the predicate that lets the routing layer classify a delivery target as kernel-bound rather than vat-bound — the by-kref index exists precisely so this is a `Map.has` rather than a scan. `getKernelServiceByKref` then recovers the full record (including the `service` object) for [`#invokeKernelService`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelServiceManager-ts--invoke-fire-and-forget-and-crank-deadlock-avoidance.md) to dispatch against.

## Notice / drift check

Each comment matches its code. The two field comments ("indexed by name" / "indexed by kref") describe exactly the two `Map`s. The class JSDoc ("Manages kernel services registration and invocation") is an accurate two-responsibility summary — registration here, invocation in the sibling section. The per-method JSDoc `@param`/`@returns` lines are accurate. No comment-versus-code contradiction in this cluster. One design observation worth a sibling reader's note (not a drift finding): the pin/unpin pairing is the whole GC-safety story for service krefs — a service is reachable only because the kernel pins its kref, so a caller that `unregister`s while a vat still holds the kref makes that held reference dangle (the vat's later send would splat as a no-owner target, handled gracefully by [`#deliverSend`](metamask-ocap-kernel--packages-ocap-kernel-src-KernelRouter-ts--deliver-send-refcount-and-endpoint-vanished-splat.md)). ocap-kernel is a read-only reference shelf (not a garden fork), so no boatman missive is available regardless.

## Lineage note

Pinning a kernel-owned object so it is GC-exempt is the SwingSet **`pinObject`** device (the kernel's "these krefs are roots" set), and the persisted name→kref binding is the SwingSet convention of giving well-known kernel objects stable identities across restart. The garden's comparative interest: Endo has no central kernel registry — a well-known capability is reached by its **formula** in the formula graph, and its persistence is by graph reachability rather than by an explicit pin bit in a kernel store. ocap-kernel's registry is a small, name-keyed, pinned table; Endo's equivalent is a named formula whose durability comes from being referenced. See [[ocap-kernel]], the store-backed pin/refcount substrate ([kernel-store README](metamask-ocap-kernel--packages-kernel-store-readme--storage-abstractions-and-implementations-package-purpose.md)), and the host-facing service-registration description ([kernel-guide kernel-services](metamask-ocap-kernel--docs-kernel-guide-md--kernel-services.md)).

Source: [packages/ocap-kernel/src/KernelServiceManager.ts](https://github.com/MetaMask/ocap-kernel/blob/d979a06325666af32ca7f68b13e9c85486d89ab5/packages/ocap-kernel/src/KernelServiceManager.ts) (lines 10-134) at commit `d979a06`.
