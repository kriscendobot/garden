All deliverables complete. Here is the completion report.

---

## Completion report: `endojs-endo-but-for-bots-pr282-registry-url-cache-key`

**Ask (fixer job):** ascertain whether the configured registry base URL participates in the `endor` registry/CAS cache key; fix if not.

### Finding
It did **not** — a real cross-registry cache-collision bug, confirmed by audit of `rust/endo`:
- `registry.rs`: `packages` keyed on `(name, version)`, `package_meta` on `name` alone — no registry column.
- `fetch.rs:341` `fetch_package` fast path and `fetch.rs:296` `fetch_metadata_cached` returned cached entries with no origin check.
- `bin/endor.rs:626`: one `{state_path}/registry.db` shared across all runs regardless of `--registry`.

So `foo@1.2.3` fetched from registry A would be served from cache for a run configured against registry B (worsened by per-scope `@scope:registry` routing, where one run hits several registries).

### Fix (commit `0d63d261fc`, pushed to `feat/endor-run-entry-point-deps`)
- Registry origin is now part of the key: `packages` PK `(registry, name, version)`, `package_meta` PK `(registry, name)`.
- `lookup`/`insert`/`get_meta`/`set_meta` take and normalize the registry URL (trailing slash stripped so `https://r/` ≡ `https://r`); fetch + resolver call sites thread `registry_url` / `config.registry_for(name)`.
- A `user_version` schema stamp discards a pre-v1 `registry.db` (regenerable cache; CAS blobs are immutable and survive) rather than fail on mismatched columns — backfilling an unknown origin would risk the same collision.
- `endor registry list`/`meta` now surface the origin; added `get_meta_all` for the CLI's cross-registry `meta` view.

### Tests (all green — 297 lib tests, `endor` binary builds)
`registry::tests::lookup_is_scoped_to_registry`, `meta_cache_is_scoped_to_registry`, `lookup_registry_key_normalizes_trailing_slash`, `pre_v1_schema_is_discarded_on_open`; `fetch::tests::fetch_package_does_not_serve_across_registries` (end-to-end through the fast path).

### Loose ends handled
- Diff is exactly 4 files. I initially ran `cargo fmt -p endo`, which reformatted the whole crate due to a rustfmt-version mismatch; I reverted and re-applied only my logical edits by hand (CI has no fmt/clippy gate — only build/test).
- Replied on the review thread: https://github.com/endojs/endo-but-for-bots/pull/282#discussion_r3796682591

No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr282-registry-url-cache-key.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 188 tokens (12094616 cached reads)
- Output: 74662 tokens
- Cost: $9.674055000000003 (2 engagement(s) unpriced)
- Wall-clock: 1471s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
