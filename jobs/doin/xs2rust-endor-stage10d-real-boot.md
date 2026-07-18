---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T21:46:07Z -->

---
model: opus
---
# stage10d child 1/4 — real two-eval SES boot in endor-vm (polyfills.js → ses_boot.js, the daemon's exact sequence)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `c345aa838`. **Sync to the REAL remote tip first** (the hourly press and peers advance the branch; verify pushes by git EXIT CODE). Get your isolated checkout with `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`.

## Context

Stage-10c/press rounds r1–r8 made the **prelude-stand-in single-eval dual-run** of the generated `ses_boot.js` bundle green end-to-end vs the C-XS oracle (boot_bundle_gate: 28/28). But the **daemon's real boot path is different**: it evaluates the REAL `rust/endo/xsnap/src/polyfills.js` and THEN the generated `ses_boot.js` as **two separate evals in one realm** (see `rust/endo/xsnap/src/lib.rs` `POLYFILLS`/`SES_BOOT` and the boot at ~line 1126). A single-program concatenation of the real polyfills + bundle is rejected by BOTH engines (XS's sticky program-scope `mxNotSimpleParametersFlag`, faithfully ported — the assert shim's rest-parameter arrows forbid a later `'use strict'`). The real path has never been driven on endor. This child closes that gap.

## Definition of done

1. In `endor_vm::PersistentRealm` (the daemon's realm shape — it already supports sequential evaluates; see the cross-turn tests `cargo test -p endor-vm persistent_realm`), evaluate the REAL `polyfills.js`, then the REAL generated `ses_boot.js`, as two separate evals. Target: **both complete cleanly and `lockdown()` finishes** — after boot, `typeof globalThis.Compartment === 'function'`, `typeof harden === 'function'`, `typeof HandledPromise === 'function'`, and `HandledPromise.resolve(7).then` agrees with expectations (the daemon's boot-probe steps).
2. Generate `ses_boot.js` the same way the build does (it is a **gitignored generated artifact** — `packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs` / the xsnap build; a same-tip sibling worktree may already hold a generated copy at `rust/endo/xsnap/src/ses_boot.js`, 70009 bytes at cut). **NEVER commit the bundle** (it stays gitignored; use placeholders for lib builds that do not drive it).
3. Add an endor-262 gate test for the real two-eval path (endor-only assertions on the boot result — the oracle cannot drive multi-script programs from the current test harness; each individual gap you fix must still be grounded by an **isolated oracle-reaching dual-run snippet**, the established ground-truth vehicle).
4. Close every `Unsupported`/wrong-`Throw` frontier you hit, **push-per-gap** (each verified fix is its own commit, pushed immediately with a CAS rebase loop). An honest named remainder with the exact halt signature (opcode/native-method + receiver kind + minimal repro snippet) is SUCCESS if the window ends — write it in your tada.

## Bars that must stay green (verify before EVERY push; capture outputs to files, check `$?` — a pipe to `tail` masks the exit code)

- Engine workspace (`rust/engine`, NOT the repo root): `cargo test --workspace --no-fail-fast` EXIT=0, **48 `test result:` lines all `0 failed`** (708 passed at cut; yours may add).
- `./target/debug/compile-diff` (no-arg = curated corpora + SYMB): **1909/1909 identical + SYMB 1909/1909, 0 divergent**, full accept/reject agreement. The metered single-shot path must be byte-identity-unperturbed.
- Boot gate `cargo test -p endor-262 --test boot_bundle_gate`: **28 passed at cut** (the test binary's own count is the canonical number — cite it, not a hand count); no regressions, additions welcome.
- **Zero new Rust warnings** (the ~346 `endor-oracle@`-prefixed moddable C warnings are pre-existing).
- `#![forbid(unsafe_code)]` intact at the 7 anchored engine crate roots (`endor-262/compile/debug/fuzz/regexp/snapshot/vm`); `endor-oracle` is the deliberate audited FFI seam (prior reports' "8" counted the oracle's NOT-forbid comment — cite 7+oracle-exempt).
- Any NEW side table must be ledgered in `endor-snapshot/src/sidetable.rs` the day it lands (VARIANT_COUNT 35 at cut).
- `c/moddable` at pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, clean, **never staged**; acceptance-grade runs need `cargo clean -p endor-compile -p endor-vm -p endor-oracle` and an oracle from that clean pinned checkout.

**Doctrine: accuracy-over-parity.** Result agreement gates; computrons are advisory; never back-fit meters.

## Environment notes

`cargo` at `$HOME/.cargo/bin`; `TMPDIR=$HOME/tmp` (mkdir it; `/tmp` is noexec). The worktree helper does NOT seed `rust/engine/target/` — `cp -al` from a same-commit sibling (confirm the sibling's tip sha first), `rmdir` the empty `c/moddable` before copying a pinned checkout in. The `endo` ROOT-workspace build needs the gitignored JS bundles — placeholders suffice for lib tests that do not drive them.

## Discipline (BINDING)

- **Push-per-item**: every verified item is its own commit, pushed immediately. Zero-push deadline deaths are the failure mode this discipline exists to prevent (two prior children died with zero pushes).
- **STOP-and-checkpoint**: if you are ~1800s in with NOTHING pushed, STOP opening new fronts; land what you have as an honest WIP that keeps all bars green (e.g. the two-eval harness + the first gap fix), push it, and write your tada with the exact resume point.
- Report via your tada completion report ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-18T21:46:11Z
