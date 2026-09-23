Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1082 from `probe/endor-git-libgit2-pr987` at `e51b94ef7dc256e5b5e3478e3fdd5075067a8b7f`. It remains draft; the normal gauntlet was not started.

Implemented a 1,186-line private `endor-git` Rust crate with the common `GitObjectDb` seam, SHA-1/SHA-256 support, filesystem repositories, external-handle ref CAS, bounded blocking execution, and a capability-selected custom ODB using vendored static libgit2. The confined 449-line FFI module has 6 callbacks, 13 unsafe blocks, 2 unsafe impls, and panic-to-error conversion.

Verification: debug and release tests pass 10/10; Clippy and rustdoc pass with warnings denied; all five deterministic pre-push probes pass. Rust-side nightly ASan passes 10/10. Two clean release builds were byte-identical. Full auto-fix lint is blocked by the repository forwarding unsupported `--fix` to shellcheck; full Rust-plus-C sanitizer coverage and dependency audit remain unverified.

Six structured gaps are documented in the PR: custom refdb result allocation is unavailable through the reviewed bindings; the approved dependency release is unspecified; the pinned Zig toolchain is absent; pack limits lack concrete policy; Windows release requirements conflict; and sanitizer scope across Rust and C is unspecified.

## Backend comparison

Host: Ubuntu 24.04.4 x86_64; Rust/Cargo 1.95.0; cargo-zigbuild 0.23.0. Zig, target C compilers, macOS SDK, QEMU, and Wine were unavailable.

| Target | Compile/link/run | Artifact or first failure |
|---|---|---|
| `x86_64-unknown-linux-gnu` | pass/pass/native pass | ELF PIE 1,507,672 B; stripped 1,291,288 B; staticlib 29,105,228 B; bundled libgit2; dynamic dependencies only libc/libgcc |
| `aarch64-unknown-linux-gnu` | fail/not reached/not run | Zig missing; fallback lacks cross GCC |
| `x86_64-unknown-linux-musl` | fail/not reached/not run | Zig missing; zlib-ng lacks musl GCC |
| `aarch64-unknown-linux-musl` | fail/not reached/not run | Zig missing; fallback lacks musl GCC |
| `x86_64-pc-windows-gnu` | fail/not reached/not run | Zig missing; MinGW GCC and Wine absent |
| `x86_64-apple-darwin` | fail/not reached/not run | Zig missing; Darwin compiler and SDK absent |
| `aarch64-apple-darwin` | fail/not reached/not run | Same Darwin infrastructure failure |

Every zigbuild stopped at `Failed to find zig`; direct builds preserved the target-native dependency failures. No cross runtime support was inferred. The stripped native probe adds 954,240 B over a matched empty Rust executable; the normal dependency graph has 9 packages and excludes OpenSSL/libssh2.

Follow-up: maintainer decisions on the six documented gaps are required before extending custom refs, pack handling, or release-matrix work.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-libgit2-probe-5456716519.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1750s

<!-- garden-usage-end -->
