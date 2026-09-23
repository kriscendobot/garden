Inbox clear, tree clean, PR still DRAFT. Nothing to land safely; both gaps resolved to actionable recipes with hard evidence. Here is my report.

---

# Stage 7 child 7/7 — daemon-side boot-path PROBE — tada report

**Job:** `xs2rust-endor-stage7-daemon-boot-probe` · PR endojs/endo-but-for-bots #600 · branch `xs2rust-endor` (kept DRAFT) · gap-revealing probe, one 2400s invocation.
**Landed:** nothing (correct for this probe — see per-gap rationale). Project worktree clean, no engine-source touched, no upstream interaction.

## Headline correction to the stage-6 gap map

The stage-6 map called Gap #3 the "hard blocker" partly on the claim that the worker/SES boot generators are **"absent from the tree AND from git history"** (`rust/endo/README.md:164`, item 2). **The git-history half is false.** All four missing artifacts are recoverable verbatim from the sibling `slot-machine` branch:

| path | present on `xs2rust-endor` | present on `slot-machine` |
| --- | --- | --- |
| `packages/daemon/scripts/bundle-bus-worker-xs.mjs` (worker_bootstrap.js generator) | ✗ | ✓ |
| `packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs` (ses_boot.js generator) | ✗ | ✓ |
| `packages/daemon/src/bus-worker-xs.js` (worker entry) | ✗ | ✓ |
| `packages/daemon/src/bus-worker-xs-ses-boot.js` (SES-boot entry) | ✗ | ✓ |

`git show slot-machine:<path>` retrieves each. Shared merge-base `b1add07d8` (tag `endor`); `slot-machine` is that base + 1 commit (`5b56c36c9`), while `xs2rust-endor` is **1913 commits** past the base — so the recovered sources are structurally correct but API-stale (details below), not drop-in.

## Ground-truth mechanics of Gap #3

- `packages/daemon/package.json:51` `test:rust` runs `ava` with `ENDO_BIN=../../target/release/endor` and `ENDO_WORKER_BIN='../../target/release/endor worker'` — i.e. it needs a **built `target/release/endor`** (spelled "endot" in the task; it is `endor`, the single `[[bin]]` at `rust/endo/src/bin/endor.rs`).
- `endor` links the `xsnap` crate. `xsnap/src/lib.rs:868,873,882` do **compile-time** `include_str!("ses_boot.js")`, `include_str!("worker_bootstrap.js")`, `include_str!("daemon_bootstrap.js")`. **All three files are `.gitignore`d** (`.gitignore:34-36`) — they are generated bundler output, never committed. They are absent from the working tree, so **`cargo build` of `xsnap` fails at the `include_str!` before any test runs.** This is the true "even on C-XS" blocker, and it is upstream of the Moddable/libxs concern.
- Only `daemon_bootstrap.js`'s generator (`bundle-bus-daemon-rust-xs.mjs`) is in-tree; the `worker_bootstrap.js` and `ses_boot.js` generators are the missing pair.
- Second, independent C-side blocker for an actual test run (not just the JS-bundle blocker): `xsnap/build.rs` needs `c/moddable/xs/sources/xsAll.c` **or** `xsnap/prebuilt/libxs.a`. **Neither is present** (submodule unpopulated, no prebuilt) — it `panic!`s. Populating the `c/moddable` submodule (oracle pin `23b4d6b0…`) or dropping in a prebuilt lib is required, and `c/moddable` must never be `git add`ed.

### Why nothing was landed for Gap #3
The only committable slice is the four generator/source files. But (a) the boot `.js` outputs are gitignored and generating them needs a full `yarn install` of the endo monorepo (no `node_modules` present) plus a working daemon bundle — and README item 1 documents that the daemon bundle *currently fails* on eager Node-only imports (`@endo/git`'s `makeNativeGitBackend` in `daemon.js`, and a `@endo/platform/fs/lite` path hitting `node:` builtins not in `EXCLUDED_PACKAGES`); (b) the recovered `bus-worker-xs.js` is slot-machine-coupled — it imports `@endo/slots` (`makeMessageSlots`, `isSlotVerb`) and `./interfaces.js`, **neither of which exists on `xs2rust-endor`** (`packages/slots` absent), and it targets a `bus-xs-core.js` API that has since drifted. So a landable "make endor build" slice is not honestly reachable in one invocation.

### Precise reconstruction recipe (for the daemon-integration stage)
1. **ses_boot.js path (cheapest, clean):** restore `bundle-bus-worker-xs-ses-boot.mjs` + `bus-worker-xs-ses-boot.js` from `slot-machine` **verbatim** — the boot entry only pulls `@endo/harden` + `@endo/eventual-send/shim.js`, no slot-machine coupling; compatible with the current tree as-is.
2. **worker_bootstrap.js path:** restore `bundle-bus-worker-xs.mjs` verbatim, but **author a current-tree `bus-worker-xs.js`** using slot-machine's as a template — strip the `@endo/slots`/`ENDO_USE_SLOT_MACHINE` branch and `./interfaces.js` import, keep the CapTP path, and realign the `./bus-xs-core.js` imports (`makeXsNode`, `markShouldTerminate`, …) to the current API (a ~5-line drift vs. slot-machine).
3. Unblock the daemon bundle (README item 1): make the git backend injectable like `better-sqlite3-xs.js` already is, and extend `EXCLUDED_PACKAGES` to cover the `@endo/platform/fs/lite` `node:` transitive.
4. `yarn install`; run all three bundlers → emit the three gitignored `.js` into `rust/endo/xsnap/src/`.
5. Populate `c/moddable` (oracle pin) or supply `xsnap/prebuilt/libxs.a`; `cargo build --release --bin endor`.
6. Then `cd packages/daemon && yarn test:rust`.

## Gap #2 — the `rust/endo → rust/engine` workspace edge — RECOMMENDATION + evidence

**Recommendation: a path dependency `endor-vm = { path = "../engine/endor-vm" }` from `rust/endo`, keeping `rust/engine` excluded from the root workspace. Do NOT un-exclude and do NOT build a bridge crate.**

Structure confirmed: root `Cargo.toml` members `= [rust/ocapn_noise, rust/endo, rust/endo/xsnap, rust/endo_iroh]`, `exclude = ["rust/engine"]`; `rust/engine` is its own resolver-2 workspace (members endor-vm/oracle/262/fuzz/regexp/compile/snapshot) with its own oracle-locked `Cargo.lock`.

The feature-unification / `forbid(unsafe_code)` fear does **not** apply to the edge the daemon actually needs, because the consumed subgraph is dependency-isolated:
- `endor-vm`'s only dep is `endor-regexp`; `endor-regexp` has **zero** `[dependencies]`. So the daemon consumes **`{endor-vm, endor-regexp}` — no external registry crates at all.**
- The external crates in `rust/engine/Cargo.lock` (`yaml-rust2`, `hashbrown`, `hashlink`, `arraydeque`, `cc`, `foldhash`, `shlex`) belong to *other* engine members (oracle/262), **not** to endor-vm — so a path-dep does not drag the oracle-pinned deps into the daemon lock, and oracle determinism is untouched.
- `forbid(unsafe_code)` is per-crate, so linking safe `endor-vm` into the same workspace as the unsafe C-FFI `xsnap` is fine — the attribute stays on endor-vm/endor-regexp.

**Hard evidence (scratch, `$HOME/tmp/gap2-scratch`):** a crate path-depending on `endor-vm` **and** on the daemon's heavy unsafe-transitive stack (`tokio` full features, `rusqlite` `bundled`, `zip`):
- `cargo tree -e features` → **EXIT 0**; the `endor-vm → endor-regexp` subtree resolves fully disjoint from the `tokio`/`rusqlite`/`zip` subtrees (no shared node to unify).
- `cargo check` → **EXIT 0** in 4.49s (`endor_vm::run_program` reachable across the edge, tokio+rusqlite-bundled+zip all compiled alongside).

**Why not the alternatives:** un-excluding the nested workspace forces one shared `Cargo.lock` + one feature-resolution graph across all seven engine members and the daemon stack, re-locking the oracle-pinned deps (`yaml-rust2` etc.) against the root lock — a determinism regression for zero benefit, since the daemon needs only endor-vm. A bridge crate adds indirection without removing any real constraint. **Do not land the edge now:** it is only meaningful once the daemon calls into endor-vm (future integration); a bare unused path-dep would be dead code and can't even be validated end-to-end because `rust/endo` won't build until Gap #3's xsnap/libxs blockers clear.

## Dependency order for the future daemon-integration stage
1. Fix the daemon bundle's Node-only imports (README item 1) — prerequisite to generating any bundle.
2. Restore/author the `ses_boot.js` + `worker_bootstrap.js` generators & sources (Gap #3 recipe steps 1–2).
3. Provide Moddable XS (submodule oracle pin, or prebuilt `libxs.a`).
4. Generate the three boot bundles; `cargo build --bin endor`; run `packages/daemon` `test:rust` on the C-XS engine — establishes the C-backed baseline **before** any pure-Rust swap.
5. Only then land Gap #2's `endor-vm` path-dep and wire the daemon's spawn path to the Rust engine boot surface (`run_program_with_symbols` / `link_intrinsics`, the stage-7 child-4/5 lockdown + shared-frozen-intrinsics work).

## New gaps discovered
- **N1 (worker-entry rewrite, M):** there is no current-tree `bus-worker-xs.js`; the slot-machine one is CapTP+slots-coupled against a stale `bus-xs-core.js`. A fresh CapTP-only worker entry must be authored (recipe step 2), not just copied.
- **N2 (dual C-XS blockers are sequential, not parallel):** the gitignored-bundle blocker (JS side) is upstream of the Moddable/libxs blocker (C side). Even a fully populated `c/moddable` cannot build `endor` until the three boot `.js` exist. Sequence accordingly.
- **N3 (`packages/slots` absence):** slot-machine mode (`ENDO_USE_SLOT_MACHINE=1`) is unavailable on this branch (`@endo/slots` not present); the reconstruction should target the CapTP path only unless the slots package is also ported.

**Verification:** none required — nothing landed, no engine-crate source changed, PR remains DRAFT/OPEN (`isDraft:true`). Gap #2 evidence captured to `$HOME/tmp/gap2-check.log` (`cargo check` EXIT 0).
