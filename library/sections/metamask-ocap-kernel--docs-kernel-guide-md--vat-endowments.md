---
title: Vat Endowments
source: docs/kernel-guide.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/kernel-guide.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, MetaMask ocap-kernel team]
ingested: 2026-06-27
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. The endowment allowlist is a concrete distributed-confinement mechanism. See [[ocap-kernel]].
---

## Abstract

SES Compartments expose no host or Web APIs by default (`setTimeout`, `Date.now()`, `crypto`, `URL` are absent or tamed — `Date.now()`/`Math.random()` throw in secure mode). A vat names exactly the globals it needs in its `VatConfig.globals` array, and only those are installed in its compartment; requesting a name outside the kernel's allowed set fails `initVat` with `Vat "<id>" requested unknown global "<name>"`. The default set (sourced from `@metamask/snaps-execution-environments`) splits into **"plain hardened"** values (host implementation wrapped with `harden()`, identical semantics) and **"attenuated"** values (deliberate reimplementations: per-vat isolated timers cancelled on termination; `Date.now()` with up-to-1ms monotonic-clamped jitter to defeat sub-millisecond timing leaks; `Math.random()` sourced from `crypto.getRandomValues`). **Network access (`fetch` and friends) additionally requires a per-vat `network.allowedHosts` allowlist** — there is no implicit allow-all, host matching is case-sensitive exact against `URL.hostname`, and `file://` is rejected. This is ocap-kernel's concrete enactment of **distributed confinement**: a vat's authority is exactly the capabilities explicitly endowed, nothing ambient.

## Body

SES Compartments do not expose host or Web APIs by default — `setTimeout`, `Date.now()`, `crypto`, `Math.random()`, `URL`, and friends are either absent or deliberately tamed (e.g., `Date.now()` and `Math.random()` throw in secure mode). Vats that need them must request them explicitly through the `globals` field on their `VatConfig`.

### Requesting endowments from a vat

Name the host/Web APIs the vat needs in its cluster config:

```ts
await kernel.launchSubcluster({
  bootstrap: 'worker',
  vats: {
    worker: {
      bundleSpec: '...',
      parameters: {},
      globals: ['setTimeout', 'clearTimeout', 'Date', 'crypto', 'URL'],
    },
  },
});
```

Only names in the vat's `globals` array are installed in the vat's compartment. Names not in the kernel's allowed set cause `initVat` to fail with `Vat "<id>" requested unknown global "<name>"`.

### Default allowed globals

The kernel ships with a set sourced from `@metamask/snaps-execution-environments`. Highlights of the attenuation discipline:

- **`setTimeout` / `clearTimeout` / `setInterval` / `clearInterval`** — attenuated timers, isolated per vat, cancelled automatically on vat termination; clear only affects timers created by the same vat.
- **`Date`** — attenuated: each `Date.now()` read adds up to 1 ms of random jitter, clamped monotonic non-decreasing, so precise sub-millisecond timing cannot leak through.
- **`Math`** — attenuated: `Math.random()` is sourced from `crypto.getRandomValues`. **Not a CSPRNG** per the upstream NOTE — defends against stock-RNG timing side channels only.
- **`crypto` / `SubtleCrypto`** — hardened Web Crypto API.
- **`fetch` / `Request` / `Headers` / `Response`** — network (attenuated); teardown aborts in-flight requests and cancels open body streams on vat termination. `Response` overrides `[Symbol.hasInstance]` so wrapped fetch results still pass `instanceof Response`. **Requires `network.allowedHosts`.**
- **`TextEncoder` / `TextDecoder` / `URL` / `URLSearchParams` / `atob` / `btoa` / `AbortController` / `AbortSignal`** — plain hardened.

"Plain hardened" means the value is the host's implementation wrapped with `harden()` — it behaves identically to the browser/Node version. "Attenuated" means the value is a deliberate reimplementation with different semantics. The canonical list lives in `packages/ocap-kernel/src/vats/endowments.ts`.

### Network endowment

`fetch`, `Request`, `Headers`, and `Response` are only available when the vat also declares a per-vat host allowlist in `VatConfig.network.allowedHosts`:

```ts
await kernel.launchSubcluster({
  bootstrap: 'worker',
  vats: {
    worker: {
      bundleSpec: '...',
      globals: ['fetch', 'Request', 'Headers', 'Response'],
      network: { allowedHosts: ['api.example.com', 'api.github.com'] },
    },
  },
});
```

Requesting `'fetch'` without an `allowedHosts` entry fails `initVat` with `Vat "<id>" requested "fetch" but no network.allowedHosts was specified`. There is no implicit allow-all; an empty `allowedHosts: []` is legal but rejects every outbound host. Host matching is a case-sensitive exact comparison against `URL.hostname` — ports and schemes are not considered. `file://` URLs are **rejected** by fetch — use the `fs` platform capability for filesystem access.

### Restricting or replacing the allowed set

Two levers at different layers:

1. **Kernel-level allowlist via `Kernel.make({ allowedGlobalNames })`** — restrict the set of globals any vat may request; names outside the list fail `initVat` even if asked for. Omit to allow the full default set.
2. **Supervisor-level factory via `VatSupervisor({ makeAllowedGlobals })`** — replace the endowment factory entirely (tests, bespoke attenuations). The factory is invoked once per supervisor and must return `{ globals, teardown }`, where `teardown` releases any resources the custom endowments hold. Most host applications should keep the default `createDefaultEndowments()` factory.

## Lineage note

The endowment allowlist is the same discipline as Endo/SES *powerlessness by default* + explicit endowment ([[object-capability]] Property D, No Ambient Authority): a compartment/vat receives no authority it is not explicitly handed. ocap-kernel's distinctive additions are (a) a *declarative* per-vat globals array validated at launch and (b) per-vat network host-allowlisting with lifecycle teardown. This is **distributed confinement** in practice — confinement reduces to graph connectivity (Miller-Yee-Shapiro: capabilities travel only along capabilities), and the globals/network allowlist is the kernel-enforced boundary on which connections a vat starts with.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
