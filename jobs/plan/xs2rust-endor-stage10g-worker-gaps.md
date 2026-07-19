---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage10g
priority: normal
posted_by: producer
posted_at: 2026-07-19T07:54:17Z
---

---
model: opus
---
# stage10g child 1/3 — worker-bundle frontier gap round (resume at the in-tree marker; push-per-gap)

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT — keep DRAFT, no PR comments), branch `xs2rust-endor`, base `llm`. Sync to the REAL remote tip first (`git ls-remote origin xs2rust-endor`) — the fixer child and the hourly press advance the branch; read the latest `xs2rust-endor-press-*` tadas in `journal/jobs/tada/` before measuring anything. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`; seed `rust/engine/target/` by `cp -al` from a same-commit sibling (confirm tip sha + clean status), `c/moddable` from a sibling at pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d` (`rmdir` the empty gitlink dir first; never `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`; workspace is `rust/engine`.

**The task:** walk the worker-bundle boot frontier down, one verified gap per push. The AUTHORITATIVE frontier is the in-tree self-updating marker test in `rust/endo/src/rust_worker.rs` (`boot_drives_the_real_chain_to_the_worker_bundle_frontier`) — run it at the synced tip and trust IT, not this body (at dispatch it reads `getOwnPropertyDescriptor:exotic-object`: the SINGULAR `Object.getOwnPropertyDescriptor([1,2,3],'length')` on an array receiver — oracle descriptor `{value: len, writable: true, enumerable: false, configurable: false}` at **72 computrons** vs the ordinary path's 55, a +17 XS array-own-property-lookup delta; the array-index gopd `[9]['0']` → `{value,true,true,true}` 72→61 is the adjacent case; `Object.isExtensible` over arrays is a ledgered adjacent sub-gap). Real bundles for the marker: seed the three gitignored `.js` bundles from `~/tmp/s10e/rust/endo/xsnap/src/` (host endolin-garden2) after verifying `diff -rq ~/tmp/s10e/packages <wt>/packages -x node_modules` is empty; never commit bundles.

**Per gap (push-per-gap discipline, s26):** transliterate the C-XS path at the pin (cite file/function), ground with a dual-run suite bit-exact vs the oracle (result + computrons; a ledgered result-exact metering remainder is acceptable when the C-XS attribution is documented — cite the s36 `indexOf_aux` unparenthesized-`mxMeterSome` precedent: transliterate C-XS artifacts bit-exactly, never "fix" them), honest-skip every uncovered shape with a named `Unsupported`, promote the marker, run the FULL bars, push, verify by git EXIT CODE. **Binding s37-review doctrine:** any new write/mutation path must honor the integrity flags (`XS_DONT_SET_FLAG`, frozen arrays) and never route through `set_own_unmetered` onto a guest-reachable target with flagged/accessor keys — the s37 findings came from exactly that miss.

**Bars (green before every push):** engine workspace `cargo test --workspace -- --test-threads=1` all-0-failed EXIT=0 at the tip's binary count (cite the measured number; 821 at s37 review + the fixer's additions); `./target/debug/compile-diff` 1909/1909 + SYMB 1909/1909 EXIT=0; boot gate `--test boot_bundle_gate` 30/0 (binary count); ROOT `cargo test -p endo --lib` 0-failed with real bundles; zero new non-oracle warnings; forbid 7 roots + oracle exempt; VARIANT_COUNT 35 unless a new side table is ledgered the day it lands; capture test output to a file and check `$?` (a pipe to `tail` masks it).

**Sizing/STOP:** fit one 2400s handler invocation — expect ~2-3 gaps; STOP at a pushed, bar-green checkpoint rather than over-reach (three prior live-captp children died at deadline chasing one more gap). An honest partial WITH the exact frontier in the marker is SUCCESS. Report via tada ONLY (never inbox-send the parked supervisor). Keep the PR DRAFT.
