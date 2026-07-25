Inbox empty. The job is complete.

## Completion report

**Job:** `design-endor-packaging` (designer) — design a packaging/release system for Endor as a Rust crate + cross-compiled npm packages, mining `kriskowal/yay`, considering Homebrew, excluding pip.

**Canonical repo identified:** `endojs/endo-but-for-bots` (roadmap branch `llm`). Endor is the native Rust daemon — a root Cargo workspace with crate `endo` / bin `endor`, plus `xsnap`, `endo_iroh`, `ocapn_noise`. Milestone M11.

**Prior art mined:**
- `kriskowal/yay` — per-platform npm packages gated by `os`/`cpu`, thin wrapper with `optionalDependencies`, native matrix `release.yml`, and a Homebrew-tap job regenerating a formula from Release tarballs + SHA-256.
- The repo's own `release.yml` (changesets → npm, strict security posture) and `familiar-release.yml` (tag-triggered native matrix build → draft Release) — reused as structural/security precedent.

**Key constraint surfaced:** `xsnap` compiles Moddable XS C (via the `c/moddable` submodule) and `rusqlite` bundles SQLite C, so artifact production must use **native runners with a C toolchain per target** (not pure-Rust `cross`/`zig`), and crates.io publication requires **vendoring** the XS sources (a submodule can't ship in a crate tarball).

**What changed (in the project worktree, on `endojs/endo-but-for-bots`):**
- Added `designs/endor-packaging.md` — full proposal covering package layout (npm `@endo/endor` wrapper + per-platform packages, crates.io with vendored xsnap, Homebrew binary formula), a tiered target/platform matrix, artifact production, single-version-source (`rust/endo/Cargo.toml`) release coordination via an `endor-v*` tag, CI automation (`endor-release.yml`), provenance/checksums (npm `--provenance`, build-provenance attestations, `SHA256SUMS`), installation UX, and a 6-phase incremental adoption path. Mermaid diagram parse-validated (browserless).
- Synced `designs/README.md` — summary table row, M11 milestone description, per-design estimate (M-L, 1–2 wks), M11 count 3→4 and week totals, and the top "Last updated" note.
- Committed on branch `design/endor-packaging` (bot identity), pushed to `origin`.

**Output:** Draft PR **[#855](https://github.com/endojs/endo-but-for-bots/pull/855)** against `llm` (`isDraft: true`).

**Follow-ups / open questions (in the design's *Known Gaps*):** crate name `endo`→`endor` rename + crates.io availability; whether `ci.yml` already builds the Rust workspace; Windows/MSVC XS build viability (gates win32); `ubuntu-24.04-arm` runner vs cross toolchain; xsnap-vendoring size/license vs crates.io limits; version-bump tooling choice (`release-plz`/`cargo-release`/manual — "to be filed" against M11); `@endo/endor-*` scope publish rights; SLSA/provenance depth. Un-drafting and any implementation build are the maintainer's decision.
