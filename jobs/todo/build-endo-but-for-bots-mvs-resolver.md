---
role: builder
---

Build the JS reference Minimum Version Selection resolver in endojs/endo-but-for-bots per the `mvs-resolver` design (plan/designs/endo-but-for-bots/mvs-resolver.md): a Node-side algorithm that walks a `package.json`'s transitive dependency graph, fetches each transitive `package.json` from the configured registry, selects the greatest mentioned minor/patch per major (Go-like MVS, major coexistence), and returns the single-pass `RegistryResolution` shape consumed by the just-landed EndoRegistry capability (PR #671) — the Algorithm layer that unblocks snapshot-mapper and daemon-worker-import-from-mount.
