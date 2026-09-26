Job complete. Draft probe PR #1081 is open and stays draft per gap-revealing-build discipline.

## Completion report

**Probe: Endor Git seam on `gix` — gap-revealing prototype of #987**

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1081 (DRAFT, base `llm`, head `45ee941e7`). One commit; no dependency/lockfile churn (gix/tokio/hex/tempfile already present).

**What I did.** Extended the merged Phase-1 gix work (`git_cas.rs`) with a new `rust/endo/src/git_odb.rs` (667 LOC) attempting the design's full `GitObjectDb` seam on the pure-Rust gix stack, for side-by-side comparison with the sibling libgit2 probe. The `endo` crate can't compile in-tree without the Moddable-XS submodule (`xsnap` build gate — backend-agnostic), so I verified the skeleton in an isolated crate with the identical gix feature set: **7/7 tests pass**. I then ran a real cross-build matrix (7 targets) and measured dependency graph, unsafe/FFI surface, and artifact size.

**Gaps surfaced (6):**
1. **Custom object/reference backend has no stable gix seam** (the central finding) — verified: gix hardwires `Repository.objects`/`refs` to concrete stores; low-level `gix_object::{Find,Exists,Write}` exist but can't mount into the porcelain. Confirms the design's decisive reason for libgit2.
2. `update_ref_if(expected=None)` semantics unspecified (chose create-only).
3. `verify(scope)` types undefined; gix has no stable `fsck`/connectivity API.
4. Object-ID parity proven for blobs only; tree/commit SHA-256 interop unverified.
5. Sync-to-async concurrency model differs (gix `ThreadSafeRepository` handle-per-thread vs design's mutex-per-repo).
6. Bounded pack ingestion (the one guest-controlled path) not wired on gix.

**Skeleton implemented (8 items, all tested):** `GitObjectDb` trait; `GixObjectDb` filesystem adapter; object read/write of all kinds with boundary hash-checking; tree decode; reference CAS over `refs/endor/` (create-only + wrong/right-expected + namespace/dangling/symbolic rejections); SHA-1 + SHA-256; bounded blocking async pool; `CustomGitObjectSource` evidence trait.

**Skeleton abandoned (6 items):** custom backend (Gap 1); graph-scope verify (Gap 3); bounded pack ingestion (Gap 6); tree/commit ID cross-validation (Gap 4); `GitTreeToContentStore`/state wiring; in-tree compilation (xsnap gate).

**Backend comparison (the maintainer's stated curiosity — cross-platform artifacts).** Measured with **no Zig and no MinGW/musl C toolchains installed**. gix codegen succeeds on 6/7 targets (Linux gnu+musl x86_64/aarch64, macOS x86_64/aarch64) with only `rustup target add`; `x86_64-unknown-linux-musl` links a **fully static ~4.3 MiB binary with zero external toolchain**. Every failure is a missing linker/SDK/binutils (aarch64 cross-linker; macOS SDK; Windows-GNU `dlltool` for transitive `getrandom`/`windows-sys`) — never a C cross-compile, and strictly a **subset** of the libgit2 lane's needs (which the design concedes require `cargo-zigbuild`, hand-maintained Zig wrappers, and a pinned SDK). Graph: 113 crates, 38 `gix-*`, **0** `-sys`/`cc`/libgit2 crates; **0 `unsafe`, 0 `extern "C"`** in the binding. Net: gix wins on cross-platform artifacts; libgit2 wins on the custom-backend capability (Gap 1) — reproducing the design's own trade rather than overturning it.

**Follow-ups for the maintainer:** revise the shared trait for Gaps 2/3/5 (bind both probes); Gap 6 is the largest remaining build on either backend; Gap 4 is an implementation-time release gate. No gauntlet runs — PR stays draft pending the side-by-side read against the libgit2 probe.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr987-gix-probe-5456716519.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 115 tokens (6787220 cached reads)
- Output: 64411 tokens
- Cost: $6.54203
- Wall-clock: 1128s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
