Implemented the smallest independently shippable Phase 1 of the Endor Git CAS and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/872.

Changes:
- Added the `gix`-only, pure-Rust Git dependency with SHA-1 and SHA-256 support.
- Added `git_cas` with algorithm-tagged binary object IDs, a `Send + Sync` `GitCas` boundary, daemon-state-owned SHA-256 bare repository creation, idempotent blob writes, validating blob reads, and fail-closed format and integrity errors.
- Added load-bearing focused tests for state-directory storage, SHA-256 object identity, duplicate writes, and ordinary Git test-time cross-validation where Git writes an object that `GixGitCas` reads.

Validation executed:
- `cargo test -p endo git_cas --no-fail-fast` passed: 2 focused tests passed.
- `cargo build --release -p endo --bin endor` passed.
- All four staged deterministic pre-push probes and `git diff --cached --check` passed.
- `ldd ./target/release/endor | rg 'git|curl|ssl|ssh|zlib'` produced no matches.

Follow-up: PR CI is running; `zizmor` is currently failed while the remaining checks are in progress.

Self-improvement: sent liaison a project note about the currently broken documented xsnap-bundle prerequisite and the compile-only stub workaround.
