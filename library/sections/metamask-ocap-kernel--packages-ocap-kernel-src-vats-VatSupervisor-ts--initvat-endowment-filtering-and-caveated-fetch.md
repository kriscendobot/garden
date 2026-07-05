---
title: "The initVat sequence: once-only load, kernel-restricted endowment filtering, the no-implicit-allow-all caveated fetch, and the liveslots build"
source: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/packages/ocap-kernel/src/vats/VatSupervisor.ts
source_kind: comment-fragment
source_path: packages/ocap-kernel/src/vats/VatSupervisor.ts
source_line_range: "327-480"
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-24
comment_subject: VatSupervisor.#initVat loads the vat's user code exactly once and assembles its confined global environment — guarding against double-init and non-bundleSpec configs, intersecting a kernel-supplied allowedGlobalNames restriction against the full allowlist, rejecting any requested global not on the effective allowlist, wrapping a requested fetch in a per-vat host-allowlist caveat with no implicit-allow-all pathway, merging the disjoint endowment records (collisions become DuplicateEndowmentError), loading the bundle, and building the liveslots dispatch that finally receives the startVat delivery.
source_authors: [Dimitris Marlagkoutsos, Erik Marks, grypez]
ingested: 2026-07-05
ingested_by: scholar
topics: [capability-security, bundles]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel, a SwingSet-lineage object-capability kernel distinct from @endo. Comment-fragment ingest of the #initVat user-code-load + endowment-confinement sequence; the concrete enactment of the vat-endowments allowlist the kernel-guide ingest described. Twelfth ocap-kernel ingest, fourth kernel-internals comment-fragment. See [[ocap-kernel]].
---

## Abstract

`#initVat` is the kernel command (dispatched through the `RpcService` — see the dual-RPC section) that loads a vat's user code and stands up the liveslots instance that runs it. It is the **concrete enactment of the vat-endowment allowlist** the kernel-guide ingest described in the abstract, and its comments defend a chain of least-authority moves: it loads **exactly once** (a double-`initVat` and any non-`bundleSpec` config are hard errors), it **intersects a kernel-supplied `allowedGlobalNames` restriction against the vat's full allowlist** so the kernel can hand a vat *fewer* globals than the default, it **rejects any requested global not on the effective allowlist** (no silent drop), it **wraps a requested `fetch` in a per-vat host-allowlist caveat with no implicit-allow-all pathway** (requesting `fetch` with no `network.allowedHosts` is an error), it **merges the endowment records disjointly** so a name collision becomes a specific `DuplicateEndowmentError`, and only then does it fetch the bundle, build liveslots, and hand the vat its opening `startVat` delivery.

## Body

### Once-only load and config guards

```ts
if (this.#loaded) {
  throw Error('VatSupervisor received initVat after user code already loaded');
}
if (!isVatConfig(vatConfig)) {
  throw Error('VatSupervisor received initVat with bad config parameter');
}
// XXX TODO: this check can and should go away once we can handle `bundleName` and `sourceSpec` too
if (!('bundleSpec' in vatConfig)) {
  throw Error('for now, only bundleSpec is supported in vatConfig specifications');
}
this.#loaded = true;
```

`#loaded` makes user-code loading a one-shot: a second `initVat` throws rather than re-initializing a running vat. The config is validated (`isVatConfig`), and — flagged by an explicit `XXX TODO` — only the `bundleSpec` form of a vat config is currently accepted; `bundleName` and `sourceSpec` are future work. The `#loaded` flag is set before the (async) heavy lifting so a re-entrant call cannot slip past the guard.

### Kernel-restricted endowment filtering

The vat's *effective* allowlist is the intersection of its full allowlist with an optional kernel-supplied restriction:

```ts
// If the kernel specified a restricted set of allowed global names,
// filter the full allowlist down to only those names.
const effectiveAllowedGlobals = allowedGlobalNames
  ? Object.fromEntries(
      allowedGlobalNames
        .filter((name) => hasProperty(this.#allowedGlobals, name))
        .map((name) => [name, this.#allowedGlobals[name]]),
    )
  : this.#allowedGlobals;
```

`#allowedGlobals` is the full hardened allowlist the constructor built; `allowedGlobalNames` is a per-launch restriction the kernel may pass to hand *this* vat a narrower set. The intersection (`filter` by `hasProperty`, then reconstruct) means the kernel can only *subtract* from the allowlist, never add a global the endowment factory never produced.

### Reject unknown requested globals — no silent drop

The vat's own `globals` request list is then resolved against the effective allowlist, and an unknown name is a hard error:

```ts
const requestedGlobals: Record<string, unknown> = {};
if (globals) {
  for (const name of globals) {
    if (hasProperty(effectiveAllowedGlobals, name)) {
      requestedGlobals[name] = effectiveAllowedGlobals[name];
    } else {
      throw new Error(`Vat "${this.id}" requested unknown global "${name}"`);
    }
  }
}
```

A vat asking for a global it is not permitted (or that does not exist) fails loudly at init rather than silently running without it — a fail-closed posture consistent with the rest of the confinement design.

### The caveated fetch: no implicit-allow-all

The single richest comment in the file guards network authority:

```ts
// Post-wrap the Snaps-produced `fetch` with a per-vat host allowlist.
// The factory itself takes no allowlist, so restriction is applied here
// where `VatConfig.network.allowedHosts` is in scope. Requesting `fetch`
// without an allowlist is rejected — there is no implicit-allow-all
// pathway.
if (hasProperty(requestedGlobals, 'fetch')) {
  const allowedHosts = network?.allowedHosts;
  if (!allowedHosts) {
    throw new Error(
      `Vat "${this.id}" requested "fetch" but no network.allowedHosts was specified`,
    );
  }
  requestedGlobals.fetch = makeCaveatedFetch(
    requestedGlobals.fetch as FetchCapability,
    makeHostCaveat([...allowedHosts]),
  );
}
```

The endowment factory produces a raw `fetch` with *no* host restriction; the restriction is applied *here*, at init, where the vat config's `network.allowedHosts` is in scope. The comment's load-bearing sentence is the last one: **there is no implicit-allow-all pathway.** A vat that requests `fetch` but supplies no `allowedHosts` is rejected, so unrestricted network access can never be acquired by omission — network authority is always an explicit, host-scoped grant (`makeCaveatedFetch` + `makeHostCaveat`). This is distributed confinement (the kernel-guide's `network.allowedHosts` allowlist) enforced at the exact point of endowment.

### Disjoint endowment merge → DuplicateEndowmentError

The worker, platform, and liveslots endowment records are merged with a disjointness requirement:

```ts
try {
  // Ensure there are no endowment name collisions.
  endowments = mergeDisjointRecords(
    workerEndowments, platformEndowments, lsEndowments,
  );
} catch (error) {
  // If the error is caused by a duplicate endowment name, throw a more specific error.
  if (error instanceof Error && error.cause) {
    const { collidingIndex, key } = error.cause as {
      collidingIndex: number; key: PropertyKey;
    };
    throw new DuplicateEndowmentError(String(key), collidingIndex === 1);
  }
  throw error;
}
```

A name appearing in two of the three endowment sources is not silently overwritten — `mergeDisjointRecords` throws, and the catch upgrades a duplicate-name cause into a specific `DuplicateEndowmentError` naming the colliding key. This keeps the vat's global namespace unambiguous: every endowment has exactly one provenance.

### Build liveslots and hand over the opening delivery

Finally the bundle is fetched and run, liveslots is built over the syscall/dispatch machinery, and the vat receives its first delivery:

```ts
const liveslots = makeLiveSlots(
  syscall, this.id, this.#vatPowers, liveSlotsOptions, gcTools,
  this.#logger.subLogger({ tags: ['liveslots'] }), buildVatNamespace,
);
this.#dispatch = liveslots.dispatch;
const serParam = marshal.toCapData(harden(parameters)) as CapData<string>;
return await this.#deliver(harden(['startVat', serParam]));
```

`#dispatch` — the field the delivery path (`#deliver`) requires — is only set here, which is why a delivery before `initVat` throws "cannot deliver before vat is loaded." The vat's config `parameters` are smallcaps-marshalled to `CapData` and delivered as the opening `['startVat', serParam]` message, so `initVat` both loads the code and drives the vat's first crank.

## Translation

| ocap-kernel term | What it denotes | Endo / reader-side analog |
|---|---|---|
| endowment allowlist | the named globals a vat may receive | a Compartment's `globals` / endowments map |
| `allowedGlobalNames` (kernel-supplied) | a per-launch restriction intersected against the full allowlist | attenuating an endowment set at grant time |
| caveated `fetch` | a `fetch` wrapped by a per-vat host allowlist, no implicit-allow-all | a membrane/caretaker-attenuated network capability |
| `mergeDisjointRecords` | endowment merge that forbids name collisions | endowment assembly that refuses ambiguous provenance |
| `startVat` delivery | the vat's opening crank after code load | a bootstrap object's first message |

## Notice / drift check

Every comment in this cluster matches the code: the `XXX TODO` correctly describes the `bundleSpec`-only restriction the guard enforces; the "filter the full allowlist down" comment matches the intersection; and the fetch caveat comment's four claims — post-wrap the factory `fetch`, restrict here where `allowedHosts` is in scope, reject a `fetch` request with no allowlist, no implicit-allow-all pathway — each match the `if (hasProperty(requestedGlobals, 'fetch'))` block exactly. No comment-versus-code drift in this cluster.

## Lineage note

Loading a user-code bundle into a SES compartment with a confined, explicitly-granted endowment set is the SwingSet/liveslots vat model (`makeLiveSlots` from `@agoric/swingset-liveslots`; `loadBundle` from the local bundle loader). The comparative interest for Endo is the *shape* of the confinement: a two-level allowlist (constructor-built full set, kernel-narrowed effective set), fail-closed on unknown-global and on network-without-allowlist, and disjoint-merge to keep provenance unambiguous — a concrete alternative to Endo's compartment-mapper + endowment story. See [[ocap-kernel]], the host-facing description of this allowlist in the [kernel-guide vat-endowments section](metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments.md), and the config-side view in the [usage-md cluster-configuration section](metamask-ocap-kernel--docs-usage-md--cluster-configuration.md).

Source: [packages/ocap-kernel/src/vats/VatSupervisor.ts](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/packages/ocap-kernel/src/vats/VatSupervisor.ts) (lines 327-480) at commit `175b7c0`.
