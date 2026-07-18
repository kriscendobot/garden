---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-18T23:34:04Z -->

---
model: opus
---
# stage10e child 1/3 — worker-bundle frontier gap round (resume at `Unsupported("symbol")`)

**Repo:** `endojs/endo-but-for-bots`, PR **#600** (DRAFT — keep it DRAFT, post NO PR comments), branch `xs2rust-endor`, base `llm`. Tip at cut: `cc158e5ff3` — **sync to the REAL remote tip first** (the hourly press can advance/rebase the branch); verify pushes by git EXIT CODE. Isolated checkout via `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`. Seed `rust/engine/target/` and the pinned `c/moddable` via `cp -al` from a same-commit sibling (`project-wt-port-xs-to-rust-memory-safe-engine-s35-*` is at `cc158e5ff3` with both seeded); `rmdir` the empty `c/moddable` first; confirm tip sha + clean status before trusting a seeded cache.

## Context

The daemon's REAL worker boot chain (real `polyfills.js` → generated `ses_boot.js` → generated `worker_bootstrap.js`, one `PersistentRealm`) is wired into `EndorGuest::boot` (`rust/endo/src/rust_worker.rs`). The two-eval SES prefix boots green including `lockdown()`. The ~1 MB worker bundle then advances gap by gap; the **self-updating frontier marker** is `boot_drives_the_real_chain_to_the_worker_bundle_frontier` in `rust_worker.rs`. Frontier at cut: stage `worker_bootstrap`, halt **`Unsupported("symbol")`** — an unmodeled `symbol`-related surface the bundle hits after the `BigInt` global (closed by `cc158e5ff3`). Prior gaps closed the same way: `defineProperties:redefine` (`c538390ce`), `BigInt` global (`cc158e5ff3`) — study those two commits for the working pattern (find the halt, ground the semantics with oracle dual-run snippets, implement, add a dual-run gate file, promote the marker, push).

Named sub-gaps already ledgered by child 2's tada (likely soon on the frontier path): singular `Object.defineProperty`/`Reflect.defineProperty` redefine, accessor↔data redefine conversion, catchable native `TypeError` construction (native throws currently unwind uncaught).

## Definition of done

Close worker-bundle frontier gaps **push-per-gap** (each gap: oracle-grounded dual-run snippets → implement → dual-run gate tests → promote the frontier marker → full bars → commit → push), for as many rounds as the clock allows. Ideal end state: the bundle evaluates to completion and `handle_command_registered` is true (the marker test's `halted_at` goes `None`). An honest partial — N gaps closed with the exact new frontier in the marker and your tada — is success.

## Bars that must stay green (before EVERY push; outputs to files, check `$?`)

Engine workspace EXIT=0 all-0-failed (50 `test result:` lines / 736 passed at cut); compile-diff 1909/1909 + SYMB 1909/1909; boot gate 30 (binary count canonical); ROOT `cargo test -p endo --lib` ≥86/0 (needs the generated bundles or gitignored placeholders — never commit bundles); zero new Rust warnings; forbid intact (7 anchored roots, endor-oracle exempt); any NEW side table ledgered the day it lands (VARIANT_COUNT 35 at cut); `c/moddable` at pin `23b4d6b0a65f…` clean, never staged. Doctrine: accuracy-over-parity (result agreement gates; computron divergence is advisory).

## Discipline (BINDING)

- **Push-per-gap**; **STOP-and-checkpoint** at ~1800s-with-nothing-pushed: land an honest verified increment, push, tada with the exact frontier + resume point.
- `cargo` at `$HOME/.cargo/bin`; the Rust workspace is `rust/engine`, ROOT workspace for the `endo` crate. A `cargo test` piped to `tail` masks the exit code — capture to a file, check `$?`. `mkdir -p $HOME/tmp`; `TMPDIR=$HOME/tmp` (`/tmp` is noexec).
- Report via tada ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  worker_kind: gardener
  claimed_at: 2026-07-18T23:34:08Z
