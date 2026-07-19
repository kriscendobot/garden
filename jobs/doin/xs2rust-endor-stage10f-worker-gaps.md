---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T05:58:03Z -->

---
model: opus
---
# stage10f child 1/3 — worker-bundle frontier gap round (resume at `Unsupported("Object.fromEntries")`)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `8eabbdefce` — **sync to the REAL remote tip first** (the hourly press advances the branch roughly one frontier gap per tick; the marker in the tree, not this body, is the authoritative frontier); verify pushes by git EXIT CODE. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`. Seed `rust/engine/target/` and the pinned `c/moddable` via `cp -al` from a same-commit sibling; `rmdir` the empty `c/moddable` first; confirm tip sha + clean status before trusting a seeded cache.

## Context

The daemon's REAL worker boot chain (real `polyfills.js` → generated `ses_boot.js` → generated `worker_bootstrap.js`, one `PersistentRealm`) is wired into `EndorGuest::boot` (`rust/endo/src/rust_worker.rs`). The two-eval SES prefix boots green including `lockdown()`. The ~1 MB worker bundle advances gap by gap; the **self-updating frontier marker** is `boot_drives_the_real_chain_to_the_worker_bundle_frontier` in `rust_worker.rs`. Frontier at cut: stage `worker_bootstrap`, halt **`Unsupported("Object.fromEntries")`** — the unbound static hit by `@endo/marshal`'s rank-order module (`fromEntries(entries(passStylePrefixes).sort(…).map(…))`).

Study the recent closes for the working pattern (find the halt, ground semantics with oracle dual-run snippets, implement, add a dual-run gate file, promote the marker, full bars, push): `ce02e60412` (symbol opcode + object-rest exclusion), `be00ac8efd` (`Object.assign`), `be4a8af13b` (to_string opcode), `98333bf528` (instantiate/`__proto__` initializer, bit-exact metering), `5e26986bd3` (harden-a-RegExp), `7f8686284f` (`Array.prototype.sort` user comparator, transliterated `fxSortArrayItems`), `8eabbdefce` (`String.split` string separator, transliterated `fx_String_prototype_split`).

Named sub-gaps already ledgered (likely soon on the frontier path): `Unsupported("set_property_at")` numeric-key destructuring (`{ 0: x, ...r }`); template-of-array `to_primitive`/`Array.prototype.join`; `Object.isExtensible`/`harden` over the remaining exotic classes; singular `Object.defineProperty`/`Reflect.defineProperty` redefine, accessor↔data conversion, catchable native `TypeError` construction. Advisory raw-level notes from the press (do not chase unless on-path): string-primitive `.length` under-charges 2·2¹⁴+2·2⁸; `join` over-charges 24 raw.

## Definition of done

Close worker-bundle frontier gaps **push-per-gap** (each gap: oracle-grounded dual-run snippets → implement → dual-run gate tests → promote the frontier marker → full bars → commit → push), for as many rounds as the clock allows. Ideal end state: the bundle evaluates to completion and `handle_command_registered` is true (the marker test's `halted_at` goes `None`). An honest partial — N gaps closed with the exact new frontier in the marker and your tada — is success.

## Bars that must stay green (before EVERY push; outputs to files, check `$?`)

Engine workspace EXIT=0 all-0-failed (797 passed at cut; binary count canonical); compile-diff 1909/1909 + SYMB 1909/1909; boot gate 30 (binary count canonical); ROOT `cargo test -p endo --lib` 0-failed (110 passed at cut with real bundles seeded bit-identically from `~/tmp/s9r`; ≥86 with gitignored placeholders — never commit bundles); zero new Rust warnings; forbid intact (7 anchored roots, endor-oracle exempt); any NEW side table ledgered the day it lands (VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f…` clean, never staged. Doctrine: accuracy-over-parity (result agreement gates; computron divergence is advisory).

## Discipline (BINDING)

- **Push-per-gap**; **STOP-and-checkpoint** at ~1800s-with-nothing-pushed: land an honest verified increment, push, tada with the exact frontier + resume point.
- `cargo` at `$HOME/.cargo/bin`; the Rust workspace is `rust/engine`, ROOT workspace for the `endo` crate. A `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`. `mkdir -p $HOME/tmp`; `TMPDIR=$HOME/tmp` (`/tmp` is noexec).
- Report via tada ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-19T05:58:07Z
