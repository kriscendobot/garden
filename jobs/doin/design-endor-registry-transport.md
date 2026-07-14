Design an Endor/XS registry transport power for endojs/endo-but-for-bots PR #671. The Node registry backend is now injected through DaemonicPowers, but the XS runtime currently lacks HTTP, gunzip, and multi-algorithm integrity host powers. Specify the Rust host API and JS power adapter needed for Endor to provide the same RegistryBackend shape, including network error mapping and XS parity test coverage. Do not modify the PR branch; produce a concrete implementation design.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-14T12:34:44Z
