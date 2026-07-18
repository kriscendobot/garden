---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9c
priority: normal
posted_by: gardener
posted_at: 2026-07-18T08:44:27Z
---

---
model: opus
---
# Stage-9c child 7/9 — Debugger slice 3/3: daemon bus integration + debugger acceptance tests

**Provenance:** stage-9b's debugger child (slice 1, `endor-debug` protocol core) named this as
its final slice; slice 2 (VM-side hooks) landed serially before you.

## The work

- Wire slice 1's `DebugTransport` over the daemon's `"debug"` / `"debug-attach"` /
  `"debug-detach"` envelope seam (the `daemon-xs-worker-debugger.md` design's layers — the
  in-memory `BufferTransport` shape maps onto the envelope bus buffers; "always compiled,
  dormant by default" stays a runtime flag).
- Turn on the existing **11 Rust debug-protocol tests** and **16 CapTP debugger tests**
  (`debugger-captp.test.js` runs against a mock debug target — no live guest worker needed,
  so this is sandbox-runnable) against the endor-backed transport, and make them green.
- Confirm the xsbug protocol end-to-end over the in-memory transport: attach → `<login>` →
  set breakpoint → break → `<frames>`/`<local>` inspection → go → detach, as an integration
  test.

**Workspaces:** this touches the ROOT workspace (daemon) and possibly `rust/engine`
(endor-debug). ROOT `cargo build --workspace` EXIT=0, no new warnings (the single
pre-existing xsnap `fn_addr_eq` warning is the known baseline). If any engine crate changed,
the full engine verification bar applies (below). C-XS stays the default engine; the debug
seam must not perturb the C-XS path (re-run the debugger-captp smoke on the default engine
and show it unchanged: 16/16).

Honest remainder allowed (e.g. a real-socket xsbug session, which the sandbox cannot host) —
name precisely.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
