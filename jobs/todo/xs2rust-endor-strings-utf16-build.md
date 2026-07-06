<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-06T02:25:08Z -->

---
model: opus
roadmap: xs2rust-endor
---
# Builder: swap endor-vm string storage CESU-8→UTF-16, delete the O(1)-index hacks, PR #600

**Program:** `xs2rust-endor`. Repo `endojs/endo-but-for-bots`, branch `xs2rust-endor`
(PR #600 — keep DRAFT). Engine at `rust/engine/` (crates `endor-vm`, `endor-262`,
`endor-oracle`, `endor-fuzz`). Design: `designs/xs2rust-endor-engine.md` (revised to UTF-16
by child 1/3). Oracle: C-XS pin `48ee02d8cfe0` (see `rust/engine/README.md` for the
non-shallow-fetch fallbacks and the empty-gitlink footgun). `cargo` at `/home/kris/.cargo/bin`
(not on default PATH). This is child 2/3 of `xs2rust-endor-strings-utf16`.

**PRECONDITION — do not start until stage-3b is fully landed.** The string surface is the
active build front: stage-3b children 8 (xsre-core), 9 (xsre-integration = RegExp + String
methods), 7 (promises), and 5 (object-statics-intern, the string→id intern table) all touch
strings on this same branch. The orchestration gate ensures this child promotes only after
those land, but re-confirm on `git log`/PR state before touching string code — a concurrent
String-methods push would corrupt the swap.

## Work
Change endor-vm's JS string value from **chunk-backed CESU-8** to **UTF-16 code units**
(the `228ee790b` surface):
- **Storage:** UTF-16 code-unit chunk payload replacing the CESU-8 byte payload; keep the
  `txChunk` header discipline and GC slide-compaction (offsets rewritten as today).
- **Literals:** the `STRING_1/2/4` literal path — decode source into UTF-16 units.
- **Concat:** `fxConcatString` — concatenate code-unit sequences.
- **Comparison:** replace byte-content comparison with UTF-16 code-unit comparison
  (JS string ordering is over code units).
- **`typeof` / rendering:** the `from_utf8_lossy` rendering path → render from UTF-16
  (e.g. `String::from_utf16`/lossy) at the display/debug boundary.
- **DELETE the O(1)-index machinery** UTF-16 makes unnecessary: cached last-access cursors,
  ASCII/BMP fast paths, and any index side-tables — indexing is now direct.
- **Snapshot atoms:** string atoms must still round-trip under the new encoding — update the
  snapshot read/write for UTF-16 payloads; add/adjust a round-trip check.
- **C-FFI / xsnap boundary:** any place raw string bytes cross (endor-oracle shim, xsnap
  netstring boundary) must transcode UTF-16 ↔ the boundary's expected encoding explicitly.
- **Meter weights:** apply the re-based string-op cost-table weights from child 1's design
  (O(n) in code-unit length; O(1) single-index). Freeze them; do NOT back-fit to CESU-8 byte
  counts or to the oracle's computrons.

## Bar / discipline
`#![forbid(unsafe_code)]` outside endor-oracle; `cargo test --workspace` green; Miri GC suite
green; result parity (completion kind/value/error identity) vs the pin on all touched test262
String sections — **divergent=0 on RESULTS**; computron numbers may legitimately change (that
is expected and correct — update expectations to the recalibrated costs, do not chase parity).
Land each increment as its own green commit and PUSH immediately; if the handler wall nears,
push + note progress + exit WITHOUT the completion signal to requeue. Get an isolated checkout:
`/home/kris/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.
Report scope folds / rulings to the supervisor inbox `port-xs-to-rust-memory-safe-engine-s7`
(or its current successor).
