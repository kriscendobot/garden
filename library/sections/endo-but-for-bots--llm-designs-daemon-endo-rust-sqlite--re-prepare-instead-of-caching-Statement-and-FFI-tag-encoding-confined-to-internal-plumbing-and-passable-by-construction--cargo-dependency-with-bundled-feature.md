---
source: designs/daemon-endo-rust-sqlite.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endo-rust-sqlite.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
status_at_ingest: Complete
genre: §endo-but-for-bots-design §host-function-package-for-XS-rust
cycle: 194
lane: designs
status: current
title: §Cargo-dependency-with-bundled-feature
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```
rusqlite = { version = "0.31", features = ["bundled"] }
```

```
The `bundled` feature compiles SQLite from C source,
eliminating system library dependencies. Adds ~2 MB to the
binary and ~30 s to the first build (cached thereafter).
```

§The-§bundled-feature discipline: §no-system-library-
dependencies; §binary-is-self-contained.

§The-§cost-named-explicitly: §2-MB-binary-size + §30s-first-
build. §Honest-cost-disclosure.

§Compare-to-cycle-176-endor-architecture's §five-embedded-JS-
bundles-via-include_str! pattern. §Both-are-§self-contained-
binary-via-embedded-source patterns.

§The-§"bundled" feature in `rusqlite` is a §Cargo-feature-flag;
the design names which-features-to-enable explicitly. §Compare-
to-cycle-186-break-dev-deps' §package-namespaced-conditions
(`test-endo-foo` not bare `test`).
