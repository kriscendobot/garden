---
title: Known gaps (open at time of writing)
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript, bundles]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--decisions-rollout-and-known-gaps
---

The design lists five open knowns for follow-up:

- **Minimum Node version**: confirm the floor that ships
  `Uint8Array.fromBase64` and record it in `_runtime-gate.js`. As
  of writing, Node 22 ships it; verify against the current
  `engines.node` floor in the monorepo root.
- **SES interaction**: confirm `ses` under `lockdown` does not
  attenuate or remove `Uint8Array.fromBase64`. If it does, the
  module can still capture the reference pre-lockdown, but the test
  suite needs a `lockdown`-on path to verify.
- **Benchmark numbers**: publish throughput for at least one short-
  string workload and one megabyte-scale workload, native and
  polyfill, on one representative Node version.
- **Shared `select.js`**: decide whether `@endo/hex` and
  `@endo/base64` share a single `select.js` or each carry their own
  (~10 lines duplicated vs. a cross-package dependency).
- **Drop `globalThis.Base64` XS path**: requires confirming no
  supported Endo runtime lacks `Uint8Array.fromBase64` while
  providing `globalThis.Base64`.
- **`name` parameter deprecation**: lift to a formal deprecation in
  a future major version? Continues to be accepted-and-ignored on
  the native path today.

The known-gaps list is exhaustive — the design's "what we still need
to confirm before merging" surface. Future readers picking up the
design should treat the bullets as gating items, not optional polish.
