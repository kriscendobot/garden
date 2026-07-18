---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T09:40:03Z -->

---
model: opus
---
# Stage-9c child 3/9 — `Reflect.apply` / `Reflect.construct` re-entrant trampolines

**Provenance:** a carried review-ledger item since stage 9: the `Reflect.apply`/`construct`
re-entrancy did NOT fall out of the stage-9 ToPrimitive trampoline — it needs its own
argument-list framing/metering. Currently both halt `Unsupported("Reflect.apply:reentrant-trampoline")`.
The eventual-send shim (child 5 after you) calls both.

## The work

Implement `Reflect.apply(target, thisArg, argList)` and `Reflect.construct(target, argList
[, newTarget])` with native→JS re-entry, following the proven trampoline shape from stage-9
child 1 — the `op_add` ToPrimitive trampoline with a **jump barrier** for throwing callees
(commit `7bc7b4f2aa` is the precedent; find its equivalent at the current tip by subject if the
press rebased). Transliterate the argument-list framing against `xsProxy.c`/`xsFunction.c`
(`fx_Reflect_apply`/`fx_Reflect_construct`, `fxCallInstance`/`fxConstructInstance`): the
array-like `argList` is materialized onto the frame (CreateListFromArrayLike semantics —
length coercion, index reads, non-object rejection), `newTarget` retargeting per spec.

Child 1 (serial, already landed by the time you run) brought spread-call framing — reuse its
machinery where the shapes coincide rather than duplicating.

**Metering:** the trampoline's own framing costs follow endor's frozen cost table
(`endor-meter-N`), NOT back-fit to oracle computrons; result agreement is the gate, computron
deltas are advisory (record them, the native→JS host-frame residual class from stage 9 may
recur here).

## Coverage

Dual-run curated-corpus cases: apply with array/array-like/empty/holey argLists, non-callable
target (BothAbort), throwing getters on argList indices (BothAbort agreement), construct with
and without newTarget, construct of non-constructor (BothAbort). Honest skips where a
soundness gate forces them (name each). Bump `CORPUS_PROGRAM_COUNT`.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
