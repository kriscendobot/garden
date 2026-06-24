---
ts: 2026-05-17T22:39:13Z
kind: result
role: cleaner
project: endo-but-for-bots
worktree: dispatches/cleaner--slot1-cleaner-pr276--20260517-221955--d4a828/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 276
    role: target
    title: "feat(endor): npm-registry HTTP fetch layer (Phase 2 of endor-npm-registry-proxy)"
refs:
  - entries/2026/05/17/221745Z-result-builder-f651b7.md
---

# Result: cleaner b964a9 — PR #276 coverage pass on rust/endo/src/fetch.rs

PR #276 is MERGEABLE and draft. One coverage commit pushed to `feat/endor-npm-registry-fetch`; CI is green on the cleaner's HEAD (`21885686d`).

## Coverage delta

Added ten hermetic tests to `rust/endo/src/fetch.rs`, raising the file's local test count from 12 (11 hermetic + 1 live probe) to 22 (21 hermetic + 1 live probe). All 22 pass under `cargo test --lib fetch::` from `rust/endo/`. No coverage tool is installed on this host (`cargo-llvm-cov` and `cargo-tarpaulin` both absent) and the project has no `rust/endo` CI workflow per the builder's note, so the delta is reported as branch-coverage analysis rather than a percent.

Gaps closed:

1. **`fetch_package` fast-path** (lines 246-253): a pre-seeded registry entry must short-circuit before any HTTP call. Previously untested; new `fetch_package_fast_path_returns_cached_entry`. Regression-evidence verified by spot-mutation (`if false { ... }` around the early return → test fails with "no mock for ...").
2. **`fetch_package` with missing `dist.integrity`** (lines 267-269 branch): legacy packages publish only `shasum`. New `fetch_package_accepts_missing_integrity` exercises the None branch and asserts the registry row carries NULL integrity.
3. **`fetch_package` on malformed JSON metadata** (lines 256-257): `BadMetadata("parse metadata: ...")` path. New `fetch_package_reports_malformed_metadata`.
4. **`fetch_metadata_cached` on non-UTF8 body** (lines 218-219): `BadMetadata("non-utf8 body: ...")` path; also asserts cache stayed empty. New `fetch_metadata_cached_rejects_non_utf8_body`.
5. **`verify_integrity` missing `-` separator** (lines 302-304): the only existing test hit the wrong-algorithm branch (`sha1-...`); the no-separator branch was uncovered. New `verify_integrity_rejects_missing_separator`.
6. **`verify_integrity` invalid base64 payload** (lines 308-312): `.decode().map_err(...)` path was uncovered. New `verify_integrity_rejects_invalid_base64`.
7. **`extract_tarball_to_cas` corrupt gzip** (lines 350-351): the `archive.entries().map_err(FetchError::Io)?` error path. New `extract_tarball_to_cas_rejects_corrupt_gzip`.
8. **`extract_tarball_to_cas` bare top-level entry** (lines 374-377): the `parts.is_empty()` guard. New `extract_skips_bare_top_level_directory_entry`. (The guard is defensively redundant with `DirNode::insert([], ...)`'s no-op arm; the test pins both halves of the contract.)
9. **`FetchError::Display` for every variant** (lines 106-124): five of six variants were unexercised through Display. New `fetch_error_display_covers_every_variant` also exercises the `From<io::Error> for FetchError` conversion (lines 128-132).
10. **`UreqClient::new` and `Default::default`** (lines 155-167): constructor was unreachable from hermetic tests (only the live test instantiated it). New `ureq_client_constructs_via_new_and_default`.

Intentionally not added:

- **`UreqClient::get_metadata` / `get_tarball` HTTP-error formatting** (lines 170-193): contortion-tier without a mock-server fixture; the live test covers the happy path. Left uncovered with the existing live probe documenting the contract.
- **CAS-write Io errors** through `extract_tarball_to_cas`: would require a read-only or full-disk filesystem fixture; out of scope per the skill's contortion guidance.
- **`Dist.shasum`** field: marked `#[allow(dead_code)]` in the source and never read; not coverage gap, by-design.

## Commits pushed

- `21885686d` — `test(endor): coverage for fetch.rs error paths and edge cases` (+298 / -0 in `rust/endo/src/fetch.rs`, no other files).

No test dependencies added; no `Cargo.lock` churn, so no separate lockfile commit. No dead code removed (the file is new-in-PR and the dead-code threshold's "no live callers in the package's own source" condition does not apply to a fresh module whose callers will land in later phases).

## CI status

All 23 checks pass on `21885686d`:

```
browser-tests build build-wasm check-action-pins
cover (20.x, ubuntu-latest) cover (24.x, ubuntu-latest)
familiar-bundle lint sandbox-drivers
test (20.x, macos-15) test (20.x, ubuntu-latest)
test (22.x, macos-15) test (22.x, ubuntu-latest)
test (24.x, macos-15) test (24.x, ubuntu-latest)
test-async-hooks (20, ubuntu-latest) test-hermes (ubuntu-latest)
test-ocapn-python test-xs (20.x, 5.0.0, ubuntu-latest)
test262 (20.x, ubuntu-latest) test262 (24.x, ubuntu-latest)
viable-release (20.x, ubuntu-latest) viable-release (24.x, ubuntu-latest)
```

No Rust workflow runs in CI (confirmed: none of the 23 checks compile `rust/endo`). The local `cargo test --lib fetch::` is the only signal that the new tests pass; it does. Local `cargo test` of `rust/endo` requires `git submodule update --init c/moddable` and stub JS bootstrap files at `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` (these are gitignored and generated by `packages/daemon/scripts/bundle-bus-*.mjs`; touched-but-empty stubs sufficed to compile-and-test `fetch.rs` since the test runner does not actually evaluate the bootstrap bundles for these tests).

## Infra red

None affecting this PR. (GitHub's push hook reported 45 Dependabot vulnerabilities on default branch — unrelated to this PR's code changes.)

## Next stage owed

Judge (panel + fixer loop). The PR is still in draft per cleaner norms; judge un-drafts on termination per `roles/judge/AGENT.md`. The judge will detect this is a source-touching (not design-only) PR and dispatch the code panel.

## Notes from the field

A note for any future Rust-side cleaner on this repo: the `endo` crate's tests transitively require `xsnap`, which requires the Moddable XS submodule and three JS bootstrap bundles (`ses_boot.js`, `worker_bootstrap.js`, `daemon_bootstrap.js`). For a coverage pass that only touches `rust/endo/src/fetch.rs` (which does not depend on xsnap at runtime), placing empty stub files at `rust/endo/xsnap/src/{ses_boot,worker_bootstrap,daemon_bootstrap}.js` is sufficient to compile the crate's tests. The stubs are gitignored. This shortcut avoids a full `yarn install` + bundler run for a pass that does not exercise the XS engine.

Self-improvement: lesson submitted as separate message to liaison (rust-side test-only build shortcut for fetch.rs-style isolated modules).
