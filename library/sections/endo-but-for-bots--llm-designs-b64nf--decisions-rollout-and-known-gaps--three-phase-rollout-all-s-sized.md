---
title: Three-phase rollout (all S-sized)
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

| Phase | Scope |
|---|---|
| **Phase 1 — Module restructuring** | Split dispatch out of `src/encode.js` and `src/decode.js`. Drop the `globalThis.Base64` inline check. Move dispatch to top-level `encode.js`/`decode.js`. Add `src/native.js` and `src/select.js`. `harden` every named export. Full test suite continues to pass on both paths. **No public API change**; no version bump beyond patch. |
| **Phase 2 — Test split and CI matrix** | Rename `test/main.test.js`'s "invalid encodings" into `test/invalid-polyfill.test.js`. Add `test/invalid-native.test.js`. Add `package.json` scripts `test:native` / `test:polyfill`; default `test` runs both. Add `_runtime-gate.js` with the minimum Node version constant. CI runs both paths on all supported Node versions that ship the intrinsic. |
| **Phase 3 — NEWS and documentation** | `CHANGELOG.md` minor-version entry with the native fallthrough, the unchanged API, and the loosened error-message contract. `README.md` short section noting ponyfill status and the runtime floor for the native path. Benchmark numbers on one representative Node version go into the NEWS entry. |
