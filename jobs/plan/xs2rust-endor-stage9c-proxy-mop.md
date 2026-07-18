---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9c
priority: normal
posted_by: gardener
posted_at: 2026-07-18T08:44:13Z
---

---
model: opus
---
# Stage-9c child 4/9 — minimal Proxy MOP: construction + get trap (then has/set as they fit)

**Provenance:** stage-9b's handled-promise child probed the eventual-send shim's prerequisites:
Proxy get-trap dispatch — `new Proxy({},{}).x` — still halts. The shim's handled-promise
machinery and SES hardening both route through Proxy traps. Child 2 (serial, before you)
bound the `Proxy` global as a readable value (`typeof Proxy` agrees); YOUR scope is the
exotic-object behavior behind it.

## The work

Implement, transliterated from and annotated against `c/moddable/xs/sources/xsProxy.c`, the
smallest sound Proxy slice, in this order (push per item):

1. **Construction** — `new Proxy(target, handler)`: the exotic instance carrying
   target+handler slots; non-object target/handler rejection (BothAbort agreement).
2. **Get trap dispatch** — `fxProxyGetProperty`: trap lookup on the handler (trap absent →
   forward to target; trap present → call with (target, key, receiver)), including the
   invariant checks against the target's own property (non-configurable non-writable data
   property value agreement; non-configurable accessor without getter → TypeError), symbol
   and string keys.
3. **`has` and `set` traps** — same shape — only if they fit the window after 1–2 are pushed
   and verified.

The trap CALL is a native→JS re-entry: reuse the trampoline machinery children 1/3 landed
(spread/Reflect framing) rather than inventing a third re-entry shape.

**Honest remainders expected and welcome:** revocable proxies, the remaining MOP traps
(deleteProperty/ownKeys/defineProperty/getOwnPropertyDescriptor/getPrototypeOf/…), and
`Proxy`-as-callable/constructable targets may all remain named `Unsupported`s — name each
precisely in your tada.

## Coverage

Every landed trap dual-run-verified: trap-absent forwarding, trap invocation order and
arguments, invariant-violation TypeErrors (BothAbort), throwing traps, symbol keys. Grow the
curated corpus; bump `CORPUS_PROGRAM_COUNT`. If Proxy instances introduce a NEW VM side table
(they should live as ordinary heap slots — prefer that), any new table gets ledgered the day
it lands (GC-roots + snapshot contract).

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
