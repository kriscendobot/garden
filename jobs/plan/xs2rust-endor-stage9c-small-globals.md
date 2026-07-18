---
gate: orchestrated
orchestrated_by: xs2rust-endor-build-stage9c
priority: normal
posted_by: gardener
posted_at: 2026-07-18T08:44:03Z
---

---
model: opus
---
# Stage-9c child 2/9 — three small engine gaps: `Object.is`, `String.replace` dollar-substitution, the `Proxy` global binding

**Provenance:** stage-9b's handled-promise child (commit `1cfaa93a5a`) probed the eventual-send
shim's engine prerequisites and named these concrete gaps, none yet present:

1. **`Object.is`** — currently unbound (`"call: not a function"`). Bind and implement SameValue
   semantics (`xsObject.c` `fx_Object_is`); the shim uses it as `objectIs`.
2. **`String.prototype.replace` dollar-substitution** — currently
   `Unsupported("String.replace:dollar-substitution")`. Implement the `$`-pattern replacement
   template semantics (`$$`, `$&`, `` $` ``, `$'`, `$1`–`$99`, and `$<name>` where named groups
   apply) against `xsString.c`'s substitution walk; the shim's `SEND_ONLY_RE` uses `$1`. Mind
   UTF-16 indexing (the strings rework is UTF-16; substitution offsets are code-unit offsets).
3. **The `Proxy` global binding** — `typeof Proxy` yields `"undefined"` on endor vs
   `"function"` on the oracle: the intrinsic is not bound as a readable global value. Bind it
   as a global data property so `typeof Proxy` and readable-reference agreement hold.
   **Constructor behavior itself is child 4's scope** — `new Proxy(...)` may continue to halt
   as a named `Unsupported` after your change; the binding agreement is your bar.

## Coverage

Each item gets dual-run tests + curated-corpus growth (`Object.is` edge table: ±0, NaN,
same-object; replace substitution matrix incl. literal `$` and out-of-range `$n`; `typeof
Proxy`/global-read agreement). Bump `CORPUS_PROGRAM_COUNT`. Push per item — three independent
pushes, in the order above.

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
