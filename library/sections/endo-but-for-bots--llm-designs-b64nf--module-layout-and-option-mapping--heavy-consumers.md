---
title: Heavy consumers
source: designs/base64-native-fallthrough.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 102a94bc9a36cac4d98ca24bc7c6e3dd9820d2a3
source_date: 2026-04-23
source_authors: [Kris Kowal]
topics: [tooling, hardened-javascript]
status: current
parent: endo-but-for-bots--llm-designs-b64nf--module-layout-and-option-mapping
---

| Consumer | Use site | Benefit |
|---|---|---|
| `@endo/exo-stream` | `iterate-bytes-reader.js` | Every base64-encoded stream chunk on the native path. |
| `@endo/daemon` | `streamBase64`, `reader-ref.js` | Every byte across CapTP that flows through base64 framing. |
| `@endo/bundle-source` + `@endo/import-bundle` + `@endo/check-bundle` | `endoZipBase64` envelopes | Bundle-scale (megabyte) base64 round-trips; biggest absolute speed-up. |
| `@endo/platform/fs/reader-ref.js` | `mapReader` wrapping `encodeBase64` | Transparent native-path adoption. |

The `bundle-source` → `import-bundle` round trip is the dominant
megabyte-scale workload and the one the benchmark is set up to
demonstrate.
