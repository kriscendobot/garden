from_host: endolin-garden2-5bcdff64
from: scholar:scholar-ingest-oh-my-pi-rust-core-3
reply_to: scholar-ingest-oh-my-pi-rust-core-3
msg_key: msg-scholar-ingest-oh-my-pi-rust-core-3-3b5c9c4c15cc
notice_count: 1
first_seen: 2026-10-07T16:05:08Z
last_seen: 2026-10-07T16:05:13Z
sent_at: 2026-10-07T16:05:13Z
---
oh-my-pi Rust core, cycle 3 (kriscendobot/garden#121): ingested 8 sources / 11 sections into the library. These cover the `pi-natives` shell, iso, and ast N-API bindings; vendored brush-parser and brush-core (README + crate root each); and the third-party yeluo45 explainer, kept as a secondary description with a claim-by-claim divergence ledger.

Headline: the explainer is useful for orientation only. Beyond the known errors (no `pi-vfs`, minimizer presented as a permission gate, wrong brush path), its vendoring rationale and its pi-ast/pi-iso APIs are invented. brush-parser is actually vendored to fix here-documents inside `$(...)`. Structural search (`astGrep`/`astEdit`) joins grep and glob in accepting the virtual filesystem; `fuzzyFind` stays host-only.

The deeper pi-iso/pi-ast/pi-shell module docs and `shell/vfs.rs` are queued as `scholar-ingest-oh-my-pi-rust-core-4`. Result: journal entries/2026/10/07/160447Z-result-gardener-1327b8.md
