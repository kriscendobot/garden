---
title: Cluster Configuration
source: docs/usage.md
source_repo: MetaMask/ocap-kernel
source_url: https://github.com/MetaMask/ocap-kernel/blob/main/docs/usage.md
source_branch: main
source_commit: 175b7c0663ce37c2626d33e08134346d4cdd17bf
source_date: 2026-04-23
source_authors: [Dimitris Marlagkoutsos, Erik Marks]
ingested: 2026-06-27
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: External sibling implementation — MetaMask/ocap-kernel. See [[ocap-kernel]]. The JSON cluster shape and bundleSpec forms are operational; the globals/network allowlist is the operator view of the kernel guide's vat-endowments.
---

## Abstract

Vats are launched in **clusters**, declared by a `ClusterConfig` JSON object naming: the `bootstrap` vat (entry point), a `forceReset` flag, and a `vats` map keyed by vat name. Each vat entry carries a `bundleSpec` (a bundle URL, a `file://` path for Node.js, or a data URL), per-vat `parameters`, an optional `globals` array (host/Web API names the SES compartment should expose — `setTimeout`, `Date`, `crypto`, `URL`, …, none exposed by default), and, when a vat requests `fetch`, a mandatory `network.allowedHosts` allowlist without which `initVat` rejects the vat. This section captures the JSON shape and the `bundleSpec` forms (the operational surface); the *security model* of `globals` + `network.allowedHosts` as distributed confinement is the kernel guide's [vat-endowments](metamask-ocap-kernel--docs-kernel-guide-md--vat-endowments.md), cross-linked.

## Body

A cluster configuration specifies which vats to launch, where to find their bundles, parameters to pass each vat, and the bootstrap vat.

```json
{
  "bootstrap": "alice",
  "forceReset": true,
  "vats": {
    "alice": {
      "bundleSpec": "http://localhost:3000/sample-vat.bundle",
      "parameters": { "name": "Alice" }
    },
    "bob": {
      "bundleSpec": "http://localhost:3000/sample-vat.bundle",
      "parameters": { "name": "Bob" }
    }
  }
}
```

The `bundleSpec` can be:

- A URL to a bundle file (`http://localhost:3000/sample-vat.bundle`).
- A file path for Node.js (`file:///path/to/sample-vat.bundle`).
- A data URL containing the bundle content.

### Requesting host globals

A vat can request host/Web API globals (timers, `Date`, `crypto`, `URL`, …) via the `globals` field. SES compartments do not expose these by default, so anything the vat needs must be named explicitly:

```json
{
  "bootstrap": "alice",
  "vats": {
    "alice": {
      "bundleSpec": "http://localhost:3000/sample-vat.bundle",
      "globals": ["setTimeout", "clearTimeout", "Date", "crypto"]
    }
  }
}
```

### Network access is a special case

Requesting `fetch` (and optionally `Request` / `Headers` / `Response`) also requires a per-vat host allowlist under `network.allowedHosts`. Without it, `initVat` rejects the vat:

```json
{
  "bootstrap": "alice",
  "vats": {
    "alice": {
      "bundleSpec": "http://localhost:3000/sample-vat.bundle",
      "globals": ["fetch", "Request", "Headers", "Response"],
      "network": { "allowedHosts": ["api.example.com"] }
    }
  }
}
```

The usage guide points to the kernel guide's Vat Endowments for the full global list and for narrowing the kernel-wide set with `Kernel.make({ allowedGlobalNames })`.

### Lineage note

The `globals` array plus the `network.allowedHosts` allowlist is ocap-kernel's enactment of **distributed confinement**: a vat gets *no* ambient host authority, only the named globals and named hosts its config grants — Property D (No Ambient Authority) of the object-capability model ([[object-capability]]). The double gate on network (`fetch` in `globals` *and* a non-empty `allowedHosts`, or the vat is rejected) is a deliberate fail-closed default. Endo's compartment endowments serve the same role through a different mechanism: powers are handed in through the compartment's module map / endowments object rather than declared in a JSON cluster file ([[compartments]]). Both deny by default and require explicit grant.

Source: [docs/usage.md](https://github.com/MetaMask/ocap-kernel/blob/175b7c0663ce37c2626d33e08134346d4cdd17bf/docs/usage.md) at commit `175b7c0`.
