---
title: Key Types and Complete Example
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
notes: External sibling implementation — MetaMask/ocap-kernel. Consolidates the guide's "Glossary and Key Types" + "Complete Example" sections. See [[ocap-kernel]].
---

## Abstract

The configuration type surface that ties the kernel/vat model together: a **`ClusterConfig`** names a `bootstrap` vat, optional `forceReset`, requested `services`, `io` channel configs, the `vats` map, and named `bundles`. Each **`VatConfig`** carries one source spec (`sourceSpec` | `bundleSpec` | `bundleName`), `creationOptions`, static `parameters`, `platformConfig` (currently `fs` only), the `globals` endowment-request array, and the `network.allowedHosts` allowlist. **`SystemSubclusterConfig`** pairs a unique `name` with a `ClusterConfig`; launching returns **`SubclusterLaunchResult`** = `{ subclusterId, rootKref, bootstrapResult }`. **`KernelStatus`** reports vats, subclusters, and a `remoteComms` discriminated union (`disconnected` | `identity-only` | `connected`, the last carrying `peerId` + `listenAddresses`). The guide closes with an end-to-end weather example wiring a host-side kernel service into a system subcluster whose vat calls it via `E()` — the canonical shape of "host registers service → system subcluster bootstraps → vat invokes service".

## Body

### Key types

```ts
type ClusterConfig = {
  bootstrap: string;                  // Name of the bootstrap vat
  forceReset?: boolean;               // Force reset of persisted state
  services?: string[];                // Names of kernel services to inject
  io?: Record<string, IOConfig>;      // IO channel configurations
  vats: Record<string, VatConfig>;    // Vat configurations by name
  bundles?: Record<string, VatConfig>;// Named bundles
};

type VatConfig = {
  sourceSpec?: string;                // Path to source file
  bundleSpec?: string;                // Path to bundle file
  bundleName?: string;                // Name of a pre-registered bundle
  creationOptions?: Record<string, Json>;
  parameters?: Record<string, Json>;  // Static parameters passed to buildRootObject
  platformConfig?: Partial<PlatformConfig>; // Platform-specific (currently `fs` only)
  globals?: AllowedGlobalName[];      // Host/Web API globals the vat requests
  network?: { allowedHosts: string[] }; // Host allowlist required for `fetch`
};

type SystemSubclusterConfig = {
  name: string;                       // Unique name (used for retrieval)
  config: ClusterConfig;
};

type SubclusterLaunchResult = {
  subclusterId: string;
  rootKref: KRef;                     // Kref of the bootstrap vat's root object
  bootstrapResult: CapData<KRef> | undefined; // Return value of bootstrap()
};

type KernelStatus = {
  vats: { id: VatId; config: VatConfig; subclusterId: string }[];
  subclusters: Subcluster[];
  remoteComms?:
    | { state: 'disconnected' }
    | { state: 'identity-only'; peerId: string }
    | { state: 'connected'; peerId: string; listenAddresses: string[] };
};
```

For canonical term definitions (kernel, vat, subcluster, exo, baggage, kref, …) the guide defers to the [canonical glossary](metamask-ocap-kernel--docs-glossary-md.md) (separately ingested, cycle 163).

### Complete example: a system subcluster with a custom service

Host application side — create a service exo, declare a system subcluster that requests it, register the service, then drive the subcluster's root object by kref:

```ts
const weatherService = makeDefaultExo('weatherService', {
  async getTemperature(city) { return hostApp.weather.getTemp(city); },
  async getForecast(city, days) { return hostApp.weather.forecast(city, days); },
});

const kernel = await Kernel.make(platformServices, db, {
  systemSubclusters: [{
    name: 'weather-system',
    config: {
      bootstrap: 'weatherVat',
      services: ['weatherService', 'kernelFacet'],
      vats: { weatherVat: { sourceSpec: './weather-vat.ts', parameters: { defaultCity: 'London' } } },
    },
  }],
});

kernel.registerKernelServiceObject('weatherService', weatherService);

const rootKref = kernel.getSystemSubclusterRoot('weather-system');
const result = await kernel.queueMessage(rootKref, 'getWeatherReport', ['Paris']);
```

Vat side (`weather-vat.ts`) — `buildRootObject` captures the service from `bootstrap`, persists it in baggage for resuscitation, and calls it via `E()`:

```ts
export function buildRootObject(_vatPowers, parameters, baggage) {
  const defaultCity = parameters.defaultCity ?? 'London';
  let weatherService = baggage.has('weatherService') ? baggage.get('weatherService') : undefined;
  return makeDefaultExo('root', {
    async bootstrap(_vats, services) {
      weatherService = services.weatherService;
      baggage.init('weatherService', weatherService);
    },
    async getWeatherReport(city) {
      const target = city ?? defaultCity;
      const temp = await E(weatherService).getTemperature(target);
      const forecast = await E(weatherService).getForecast(target, 3);
      return `${target}: ${temp}C. Next 3 days: ${forecast.join(', ')}`;
    },
  });
}
```

## Lineage note

The `remoteComms` discriminated union (`disconnected` / `identity-only` / `connected` with `peerId` + `listenAddresses`) is the kernel's window onto its libp2p-based remote-messaging layer — the substrate the Ken-protocol-assessment doc audits (separately ingested). The `peerId` is the cryptographic identity derived per the identity-backup-recovery doc (cycle 164). The complete example is the canonical "host service → system subcluster → vat via `E()`" wiring; its Endo analog is a host that endows a guest bundle with a power through the formula graph, then drives the guest by its formula identifier — same three roles (host, mediated capability, confined guest), different plumbing.

Source: [docs/kernel-guide.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/kernel-guide.md) at commit `175b7c0`.
