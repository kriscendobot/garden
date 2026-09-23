---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-28T19:48:49Z
---
Opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1082 from `probe/endor-git-libgit2-pr987` at `e51b94ef7dc256e5b5e3478e3fdd5075067a8b7f`. It remains draft; I did not start the normal gauntlet.

Implemented a 1,186-line private `endor-git` Rust crate with the common `GitObjectDb` seam, SHA-1/SHA-256 tagged IDs, ordinary filesystem repositories, external-handle ref CAS, a semaphore-bounded blocking adapter, and a capability-selected custom ODB using vendored static libgit2. The 449-line confined FFI module has 6 callbacks, 13 unsafe blocks, 2 unsafe impls, and panic-to-error conversion. Cargo locks `git2 0.21.0` and `libgit2-sys 0.18.8+1.9.7` separately.

Verification: debug and release tests pass 10/10; Clippy with `-D warnings`, rustdoc with `-D warnings`, and all five deterministic pre-push probes pass. Rust-side nightly ASan passes 10/10 in 7.52 s. Two clean release builds took 13.99 s and 13.42 s and produced byte-identical binaries (`7f6099d…a9a00`). Full auto-fix pre-push lint is blocked by the repository command forwarding unsupported `--fix` to shellcheck; full Rust-plus-C sanitizer coverage and dependency audit are not verified.

Gaps surfaced: (1) `libgit2-sys` exposes custom refdb callbacks but not the internal reference allocators needed to return lookup results, blocking a supportable custom refdb; (2) the design does not name its “reviewed release”; (3) pinned Zig acquisition, wrappers, and SDK contract are absent; (4) pack limits have no numeric/configuration contract; (5) Windows is both a release gate and deferred; (6) sanitizer scope across Rust and vendored C is unspecified. The PR body gives each gap the required design quote, implementation need, candidate resolutions, and maintainer decision.

## Backend comparison

Host: Ubuntu 24.04.4 x86_64; Rust/Cargo 1.95.0; cargo-zigbuild 0.23.0; Zig, target C compilers, macOS SDK, QEMU, and Wine absent.

| Target | Compile/link/run | Artifact and dependencies | First failure/classification |
|---|---|---|---|
| `x86_64-unknown-linux-gnu` | pass/pass/native pass | ELF PIE 1,507,672 B; stripped 1,291,288 B; staticlib 29,105,228 B; bundled libgit2; dynamic only libc/libgcc | verified |
| `aarch64-unknown-linux-gnu` | fail/not reached/not run | none | Zig missing; fallback lacks cross GCC; infrastructure exposed by native backend |
| `x86_64-unknown-linux-musl` | fail/not reached/not run | none | Zig missing; zlib-ng lacks musl GCC; infrastructure exposed by native backend |
| `aarch64-unknown-linux-musl` | fail/not reached/not run | none | Zig missing; fallback lacks musl GCC; infrastructure exposed by native backend |
| `x86_64-pc-windows-gnu` | fail/not reached/not run | none | Zig missing; zlib-ng lacks MinGW GCC/Wine; infrastructure plus wrapper-design gap |
| `x86_64-apple-darwin` | fail/not reached/not run | none | Zig missing; GNU cc rejects `-arch`; compiler/SDK absent; infrastructure plus SDK-design gap |
| `aarch64-apple-darwin` | fail/not reached/not run | none | same as x86_64 Darwin; infrastructure plus SDK-design gap |

Every zigbuild attempt stopped at `Failed to find zig`; direct builds preserved the native-dependency failures above. No cross runtime support is inferred. The native stripped binary is 954,240 B (283.1%) above a matched 337,048 B empty Rust binary; the normal graph has 9 packages and excludes OpenSSL/libssh2.

Follow-up: maintainer decisions on the six documented gaps are needed before extending custom refs, packs, or release-matrix work.

Self-improvement: nothing this time.
