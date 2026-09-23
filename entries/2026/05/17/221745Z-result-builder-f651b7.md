---
ts: 2026-05-17T22:17:45Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--slot1-endor-npm-registry-proxy-phase2--20260517-215916--61bab6/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 276
    role: target
    title: "feat(endor): npm-registry HTTP fetch layer (Phase 2 of endor-npm-registry-proxy)"
refs:
  - entries/2026/05/13/222252Z-result-designer-2a4ab6.md
---

# Result: builder f651b7 — PR #276 Phase 2 of endor-npm-registry-proxy

Draft PR opened: <https://github.com/endojs/endo-but-for-bots/pull/276> against base `llm` on branch `feat/endor-npm-registry-fetch` at head `13d421778`.

## Base-branch deviation from dispatch text

The dispatch said "open against master", but Phases 1 and 3 (which Phase 2 builds on) exist on the `llm` branch only: the entire `rust/endo` crate landed via merged PR #17 (`Rust endor supervisor + makeArchive`) targeting `llm`, and the active Rust endor PRs (#166 TUI skeleton, #124 slot-machine) also target `llm` / `endor`. A master-base would not even compile (`rust/endo` is absent from `origin/master`; only `rust/ocapn_noise` is there). Per the design-status pre-flight in `roles/builder/AGENT.md` § Operating norms, branching off `llm` is the path that lets Phase 2 sit atop its declared prerequisites; the same norm calls for surfacing the deviation, which this entry and the PR body do.

## What landed

Two commits on top of `4a3dc92ce` (the `llm` HEAD at dispatch time):

| SHA | Subject | Files |
|-----|---------|-------|
| `bcfc93f6a` | `feat(endor): npm-registry HTTP fetch layer` | `rust/endo/src/fetch.rs` (new), `rust/endo/src/lib.rs`, `rust/endo/Cargo.toml` |
| `13d421778` | `chore: Update Cargo.lock` | `Cargo.lock` |

`fetch.rs` adds:

- `fetch_package(http, cas, registry, url, name, version) -> FetchResult` — the end-to-end seven-step flow (metadata fetch → version select → tarball download → SHA-512 integrity verify → tar+gzip extract with `package/` prefix strip → tree-manifest write to CAS → registry-table insert).
- `fetch_metadata_cached(...)` — short-circuits repeat metadata lookups against the `package_meta` table.
- `verify_integrity(sri, bytes)` — strict `sha512-<base64>` SRI parser and digest check.
- `extract_tarball_to_cas(tarball, cas)` — streaming gunzip + tar walk, writing each regular file as a blob and building tree manifests bottom-up.
- `HttpClient` trait with default `UreqClient` (thin wrapper over `ureq`'s blocking agent).

The tree-manifest JSON is serialised with sorted keys so the CAS tree hash is a stable function of the input tarball, independent of `HashMap` iteration order.

## Dependencies added to `rust/endo/Cargo.toml`

`base64 = "0.22"`, `flate2 = "1"`, `tar = "0.4"`, `ureq = "2"`. `base64` and `flate2` were already transitively in `Cargo.lock` via other crates. The lockfile commit is separate per the dispatch's directive.

## Test count and regression evidence

Twelve hermetic unit tests in `fetch::tests` (plus one network-gated `live_registry_fetch_is_odd` skipped unless `ENDOR_REGISTRY_LIVE_TEST=1`). Total `endo` lib tests now 80 (previously 68); the 12 new tests all pass.

Three load-bearing tests were verified by temporary breakage, per `skills/regression-evidence/SKILL.md`:

| Test | Bug introduced | Outcome |
|------|---------------|---------|
| `fetch_package_rejects_tampered_tarball` | `verify_integrity(...)?` commented out | FAILED with `expected IntegrityMismatch, got Ok(FetchResult { ... })`; restoring the call returned the test to PASS |
| `extract_strips_package_prefix` | the two-line `if components.peek().is_some() { components.next(); }` strip block removed | FAILED with `expected package.json at root, got ["package"]`; restoring the strip returned the test to PASS |
| `extract_is_deterministic` | `encode_manifest_sorted(&manifest)?` swapped for raw `serde_json::to_vec(&manifest)` | FAILED with `assertion left == right failed: tree hash drifted with tar order`; restoring the sorted serialiser returned the test to PASS |

The live registry probe was also run once with `ENDOR_REGISTRY_LIVE_TEST=1 cargo test -p endo --lib fetch::tests::live_registry -- --nocapture` and passed: fetched `is-odd@3.0.1` from `registry.npmjs.org`, verified the published `dist.integrity` SHA-512 against the downloaded tarball bytes, extracted the contents into a fresh CAS, and re-read `package.json` from the resulting tree hash with the expected `name` field intact.

## CI status

CI is running at PR-open time (head `13d421778`). The `rust/endo` crate has no CI workflow row of its own; the existing Rust step (`build-wasm`) builds `rust/ocapn_noise` only and is unaffected by this PR. Adding a `rust/endo` CI row is a natural follow-up alongside Phase 4's compartment-mapper wiring; it is out of scope for this PR.

## Changeset

None. The change is purely Rust-side (`rust/endo/*`) and does not affect any published JavaScript package; changesets here govern npm release notes only.

## Out-of-scope deferrals

- The very old `dist.shasum`-only fallback (npm packages predating 2017). The field is deserialised so the `Dist` struct accepts the wire shape; verification is skipped and the integrity column is left NULL when only `shasum` is present. Surfaced in the PR body's *Security Considerations*.
- A CI row for `cargo test -p endo --lib`. Out of scope for Phase 2; lands naturally alongside Phase 4.
- Wiring `fetch_package` into the compartment mapper. That is Phase 4.
- Private-registry authentication beyond default `https://registry.npmjs.org/`. Listed under the design's *Known gaps*; Phase 5.

## Local build environment note

The bot host had no Rust toolchain at dispatch start; this dispatch installed stable (rustc 1.95) via `rustup` and initialised the `c/moddable` git submodule to make `xsnap` (a dependency of the `endo` crate) compile. The `xsnap` JS-bundle files (`ses_boot.js`, `worker_bootstrap.js`, `daemon_bootstrap.js`) were stubbed with empty files locally to bypass the JS-side bundler dependency for `cargo check`; the stubs are `.gitignore`d and are not part of the PR. The compile path for builders without those bundles is the JS-side bundler in `packages/daemon/scripts/`.

Self-improvement: a small lesson for the `roles/builder/AGENT.md` *A design that lives on the roadmap branch is read, not branched-from* norm. The norm's current text covers the case where the design lives on `llm` and the implementation belongs on `master`; it does not address the case where the *implementation prerequisites* themselves live on `llm` (entire crate behind a not-yet-promoted feature branch). The right framing seems to be: "branch off the latest ancestor that contains the implementation prerequisites the design declares" — i.e., walk the design's *Depends On* table and pick the base that lets the next phase compile. For Rust-endor work today that ancestor is `llm`; for typical JS-side designs it stays `master`. Below the standalone-skill threshold (it is a refinement, not a new skill), but worth surfacing to the liaison as a one-line addition to the builder role's norm.
