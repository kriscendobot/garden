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
title: §BLOB-as-Uint8Array-not-sentinel (Decision 2)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```
- **BLOB is Uint8Array, not a JSON sentinel.**
  There is no `$blob` encoding, no smallcaps, no fancy JSON
  encoding of any kind in the user-facing API.
  The JS wrapper presents clean `Uint8Array` values to
  callers.
```

§The-§user-facing-clean-API discipline. §The-§FFI-tags-
(`$bigint`/`$bytes`)-live-inside-the-plumbing; §the-JS-
wrapper-decodes-them before returning to callers.

§Why: callers shouldn't have to know about the FFI's JSON-
transport limitations. §A-`Uint8Array`-in-the-database round-
trips to a `Uint8Array` in the JS code — no `{$bytes: "base64"}`
ever appears in user code.

§Compare-to-cycle-189-marshal-justin's §`__proto__`-bracket-
escape (preserve JSON vs JS prototype-set semantics). §Both-
are-§internal-representation-distinct-from-user-API patterns.

§Compare-to-cycle-178-snapshot's §snapshot-as-internal-
implementation-detail-not-user-visible-formula. §Both-are-
§hide-the-plumbing-from-the-user-API discipline.

§Tier-1-borrowing: §user-facing-clean-API-with-FFI-tags-
confined-to-internal-plumbing. §The-encoding-tax is paid by
the wrapper, not the caller.
