---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T11:55:05Z -->

---
model: opus
---
# Stage-9c child 8/9 — the endor-vm worker surface: CapTP deliver-envelope service + SES worker-bundle host

**Provenance:** stage-9b's daemon-wiring child (commits `021a53036fc` + `0c7b35bdd25`) landed
the path dependency and the `ENDO_ENGINE`/`-e rust` selection seam, and proved the
deterministic finding that gates the finish line: **the Rust worker boots endor-vm but cannot
serve the protocol** — endor-vm does not decode the netstring/CBOR CapTP `deliver` envelopes
the daemon routes, nor host the SES worker bundle. This child closes that gap. It is THE
critical finish-line capability; the measurement child (9/9) runs right after you and is
meaningless without you.

**Your prerequisites landed serially before you:** the SES boot bundle's engine gaps
(rest/spread, `Object.is`, replace-dollar, Reflect trampolines, Proxy get trap) and the
HandledPromise shim body (child 5). Start from the seam's own follow-up list:
`spawn_shared_rust_worker` / `endor worker -e rust` currently complete the transport init
handshake, boot endor-vm, then report the CapTP gap.

## The work (push per item; honest remainder welcome)

1. **SES worker-bundle host:** load and evaluate the worker boot bundle
   (`bus-worker-xs-ses-boot.js` product) in the endor-vm compartment the boot probe already
   constructs, to a completed lockdown+shim boot (child 5 proved the shim body executes).
2. **Envelope service:** decode the daemon's netstring/CBOR CapTP envelopes and dispatch
   `deliver` into the booted guest, encoding replies back — reusing the engine-agnostic
   channel scaffolding `inproc.rs` already routes through, mirroring how the xsnap worker
   services the same envelopes (the C-XS path is the reference; C-XS REMAINS THE DEFAULT —
   everything you do stays behind the opt-in seam).
3. **Definition of done for the slice:** at least ONE real daemon test that spawns a live
   guest worker passes end-to-end on the Rust engine (`ENDO_ENGINE=rust`), run serially from
   a REAL short path (the `~/tmp/s8cxs` recipe; AF_UNIX `sun_path` cap). Name the test and
   show its pass on Rust AND on default C-XS unregressed.
4. If the full envelope vocabulary does not fit the window, land the coherent prefix
   (handshake + deliver happy path) and name the remaining message classes precisely — the
   measurement child will quantify them.

**Workspaces:** ROOT workspace build EXIT=0, no new warnings; engine-workspace bar applies if
engine crates changed. No committed bundles (the boot bundle is a `.gitignore`d `makeBundle`
artifact — build it, never stage it).

## Standing discipline (binding, read fully)

**Repo:** `endojs/endo-but-for-bots`, PR **#600**, branch `xs2rust-endor` (base `llm`). **Keep the PR DRAFT; never comment on it.** Report via your tada completion report ONLY — never message the parked supervisor or the maintainer.

**Worktree:** `$HOME/scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`, then sync to the REAL remote tip (`git fetch origin xs2rust-endor && git checkout --detach FETCH_HEAD`) — the hourly press may have rebased the branch since this body was written (it did so on 2026-07-18: `cf45517211` → `8865953620`, rust/ byte-identical); never assume a sha, record the one you measured at.

**Environment (binding):** `cargo` at `$HOME/.cargo/bin`; the engine workspace is `rust/engine`, NOT the repo root. Before any acceptance-grade engine run: `cargo clean -p endor-compile -p endor-vm -p endor-oracle` (stale seeded `target/` false-passes AND false-fails; you MAY `cp -al` a same-commit sibling's `target/` to seed, but the three crates above must be cleaned after seeding). `c/moddable`: `rmdir` the empty dir, then `cp -al` from a same-pin sibling or shallow sha-fetch, `git -C c/moddable checkout --detach 23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, verify `git status` clean at the pin — **never `git add c/moddable`**. Capture cargo/test output to files and check `$?` (a pipe to `tail` masks the exit code). `/tmp` is noexec: use `TMPDIR=$HOME/tmp` (mkdir it first). The three environment-artifact classes behind mass failures: AF_UNIX `sun_path` overflow (socket tests need a REAL short path, e.g. under `~/tmp/`; symlinks do NOT work), provisioning-race uniform asserts (killed-mid-install; re-provision before believing), stale build caches (fresh-clean rule above). Prebuilt engine binaries are invoked WITHOUT `--` (e.g. `./target/debug/compile-diff language/<subtree>`); the module-corpora test is a LIB test (`cargo test -p endor-262 --lib module_corpora -- --nocapture`).

**Sizing + push discipline (binding):** you have ONE 2400s handler invocation. Push each coherent item AS IT COMPLETES (`git push origin HEAD:xs2rust-endor`; verify by git EXIT CODE; concurrent pushes race at the CAS — fetch, rebase, retry), so a deadline poison loses only the in-flight item. If you cannot finish everything, land what is verified and report the remainder honestly in your tada — an honest, precisely-named remainder is a GOOD outcome, not a failure.

**Verification bar for engine changes:** engine-workspace `cargo test` EXIT=0 captured to a file (every `test result:` line 0 failed); curated compile-diff all-identical + SYMB (report the count — **1759** at stage-9b close, may have grown); boot gate green (report the count and any skip→green conversions); **zero NEW Rust warnings**; `#![forbid(unsafe_code)]` intact at every engine crate root (grep and report the count — 7 incl. `endor-debug` at stage-9b close; `endor-oracle` stays the audited FFI seam); `c/moddable` clean at the pin, never staged; no committed bundles. Any NEW VM side table must be ledgered the day it lands (GC-roots + snapshot contract, the pattern of `template_cache`/`functions.home`). **DOCTRINE: accuracy-over-parity** — result agreement gates; computron-vs-oracle is advisory telemetry; never back-fit meters to oracle computrons or CESU-8 byte lengths.
