---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9c
priority: normal
posted_by: gardener
posted_at: 2026-07-18T08:44:18Z
---

---
model: opus
---
# Stage-9c child 5/9 — the HandledPromise / eventual-send shim body boots on endor

**Provenance:** stage-9b's handled-promise child landed the shim's install-guard agreement
(`typeof HandledPromise` pre-shim — the `typeof`-of-unresolvable fix) and scoped the shim BODY
as a follow-on: `makeHandledPromise()` from `@endo/eventual-send/shim.js` is **not
oracle-observable** (the C oracle never runs the shim bundle), so its surface is shim-defined
and is verified by **endor-side unit tests**, not dual-run. Your prerequisites landed serially
before you: rest/spread (child 1), `Object.is` + `String.replace` dollar-substitution +
`Proxy` binding (child 2), `Reflect.apply`/`construct` (child 3), Proxy construction + get
trap (child 4).

## The work

1. **Probe first.** Boot the SES worker bundle path (`bus-worker-xs-ses-boot.js` →
   `@endo/eventual-send/shim.js`) on endor and record exactly where it halts now. Every
   remaining `Unsupported`/missing-intrinsic is your work-list, in dependency order. (Likely
   candidates: `WeakMap` if absent — the handler side table is WeakMap-backed; promise
   machinery surface the shim touches; anything the probe surfaces.)
2. **Land the smallest sound slices** to get `makeHandledPromise()` executing to completion
   and `globalThis.HandledPromise` installed with its statics (`resolve`, `applyFunction`,
   `applyMethod`, `get`). A missing intrinsic that IS oracle-observable (e.g. WeakMap) gets
   the normal dual-run + corpus treatment; shim-internal behavior gets endor-side unit tests.
3. **Endor-side unit tests** proving: the shim installs under its guard; the constructor +
   four statics exist with correct arity/behavior on the happy path; the WeakMap-backed
   handler table associates and retrieves; an eventual-send round-trip at the shim level
   (applyMethod on a plain resolved value) behaves per the shim's contract.

**Honest remainder is welcome:** the full eventual-send op semantics over live CapTP delivery
belong to the worker-surface child (8/9) — your bar is the shim body booting and its statics
behaving at unit level, not end-to-end message delivery.

Any NEW VM side table (e.g. a WeakMap store) is ledgered the day it lands (GC-roots +
snapshot contract).

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
