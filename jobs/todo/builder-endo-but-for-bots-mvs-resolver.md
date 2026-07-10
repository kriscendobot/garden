---
role: builder
---

Build the `mvs-resolver` design in endojs/endo-but-for-bots (base `llm`): a JS reference implementation of Go-like Minimum Version Selection that walks a `package.json`'s transitive dependency graph through the registry and emits a `RegistryResolution`. This is layer 2 of the module-loading four-layer stack just sequenced in PR #659; stack it on the freshly-built registry-capability layer (PR #671), rebuilding fresh since the prior attempt (#564) was closed.
