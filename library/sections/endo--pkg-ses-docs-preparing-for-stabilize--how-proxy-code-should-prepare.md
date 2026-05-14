---
title: How proxy code should prepare
source: packages/ses/docs/preparing-for-stabilize.md
source_repo: endojs/endo
source_commit: 07ff084c87af4e567f6bf4f5e331742be94b6587
source_date: 2025-01-18
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, persistence]
status: current
---

> Abstract: Specific guidance for code that wraps values in Proxy objects: which traps need to be aware of the new integrity-trait semantics, and what changes to make ahead of the language change.

## How proxy code should prepare

[#2673](https://github.com/endojs/endo/pull/2673) will *by default* produce proxies that refuse to be made non-trapping. An explicit handler trap (perhaps named `stabilize` or `suppressTrapping`) will need to be explicitly provided to make a proxy that allows itself to be made non-trapping. This is the right default, because proxies on frozen almost-empty objects can still have useful trap behavior for their `get`, `set`, `has`, and `apply` traps. Even on a frozen target
- the `get`, `set`, and `has` traps applied to a non-own property name are still general traps that can have useful trapping behavior.
- the `apply` trap can ignore the target's call behavior and just do its own thing.

However, to prepare for these changes, we need to avoid hardening both such proxies and their targets. We need to avoid hardening their target because this will bypass the traps. We need to avoid hardening the proxy because such proxies will *by default* refuse to be made non-trapping, and thus refuse to be hardened.

Some proxies, such as that returned by `E(...)`, exist only to provide such trapping behavior. Their targets will typically be trivial useless empty frozen objects or almost empty frozen functions. Such frozen targets can be safely shared between multiple proxy instances because they are encapsulated within the proxy.
- Before `stabilize`/`suppressTrapping`, this is safe because they are already frozen, and so they cannot be damaged by the proxies that encapsulate them.
- After `stabilize`/`suppressTrapping`, this is safe because the only damage that could be done would be by `stabilize`/`suppressTrapping`. These proxies do not explicitly provide such a trap, and thus will use the default behavior which is to refuse to be made non-trapping.

Because such trivial targets, when safely encapsulated, can be safely shared, their definitions should typically appear at top level of their module.


Source: [packages/ses/docs/preparing-for-stabilize.md](https://github.com/endojs/endo/blob/07ff084c87af4e567f6bf4f5e331742be94b6587/packages/ses/docs/preparing-for-stabilize.md) at commit `07ff084c`.
