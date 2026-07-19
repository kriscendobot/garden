---
model: opus
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-19T07:55:03Z -->

---
model: opus
---
# stage10g child 0/3 — fix the s37 review findings F1/F2 (Object.assign integrity; sort receiver-mutation write-back)

**Repo/PR:** `endojs/endo-but-for-bots` #600 (DRAFT — keep DRAFT, no PR-state changes), branch `xs2rust-endor`, base `llm`. Sync to the REAL remote tip first (`git ls-remote origin xs2rust-endor`); multiple sessions advance the branch. Findings comment: issuecomment-5014930807. Get your isolated checkout with `scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots xs2rust-endor`; seed `rust/engine/target/` by `cp -al` from a same-commit sibling under `scratch/` (confirm tip sha + clean status first), `rmdir` the empty `c/moddable` and `cp -al` a sibling's pinned checkout (pin `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`, never `git add c/moddable`). `cargo` at `$HOME/.cargo/bin`. Workspace is `rust/engine`, NOT the repo root.

**REPRODUCE FIRST:** copy `~/tmp/s37-results/s37_probe.rs` (host endolin-garden2) into `rust/engine/endor-262/tests/`, run `cargo test -p endor-262 --test s37_probe -- --nocapture`, and confirm the 4 wrong-completion divergences before touching anything (frozen-target, nonwritable-own, accessor-target, sort-shrink-len). Do NOT commit the probe file as-is; land its cases as proper dual-run suites.

**F1 (binding): `Object.assign` ignores target integrity and accessors.** `NativeMethod::ObjectAssign` (interp.rs) writes each key via `set_own_unmetered`, which overwrites unconditionally — no `XS_DONT_SET_FLAG`/frozen check, no accessor detection on the TARGET. Oracle: `Object.assign(Object.freeze({a:1}),{a:2})` throws TypeError; a non-writable own property likewise; an accessor own property on the target invokes the setter. Fix shape: route assign's per-key write through a flag-honoring path — throw the oracle's TypeError for non-writable/frozen (bit-exact metering vs the oracle for the throwing case if reachable cheaply), and for an accessor-bearing target key either invoke the setter faithfully or self-name `Unsupported` — NEVER complete with a wrong result. Check whether `ObjectCopy`'s spread path (`{...src}` writes onto a fresh literal — safe) and `fromEntries` (fresh result — safe) share the helper; scope the fix to genuinely guest-reachable wrong paths, and sweep for OTHER callers of `set_own_unmetered`/`set_own_flagged_unmetered` whose target can be a guest object with flagged/accessor keys (the s34 F1 doctrine: enumerate EVERY mutation path).

**F2 (binding): `sort` write-back after a receiver-mutating comparator.** A comparator that shrinks the receiver (`a.length=2` mid-sort) yields endor `len=2` where the oracle regrows to `len=6` via `mxSetIndex` write-back — wrong completed result. Minimal doctrine-compliant fix: snapshot the receiver's length + density before the comparator loop; at write-back, if the receiver changed (length, density, or the `arrays` entry shape), self-name `Unsupported("sort:receiver-mutated-during-sort")`. Keep the unmutated path bit-exact (do not disturb the landed 29/29 calibration).

**Grounding:** dual-run suites for every fixed case (result + where feasible computron agreement vs the C-XS oracle at the pin); the four probe scenarios must flip to agreement (result_agrees=true, or an honest `Unsupported`/BothAbort-same-error class). Full bars green BEFORE EVERY PUSH, push-per-item (F1 then F2 as separate commits): engine workspace `cargo test --workspace -- --test-threads=1` all-0-failed EXIT=0 at the tip's binary count (821 at dispatch; grows with your tests — cite the measured number); `./target/debug/compile-diff` 1909/1909 + SYMB 1909/1909 EXIT=0; boot gate `cargo test -p endor-262 --test boot_bundle_gate` 30/0; ROOT `cargo test -p endo --lib` 0-failed (110 at dispatch with real bundles — seed the three gitignored bundles from `~/tmp/s10e/rust/endo/xsnap/src/` after verifying `diff -rq ~/tmp/s10e/packages <wt>/packages -x node_modules` is empty; never commit bundles); zero new non-oracle warnings; forbid 7 roots + oracle exempt intact; VARIANT_COUNT 35 unless you ledger a new table the day it lands. Verify pushes by git EXIT CODE. A cargo test piped to `tail` masks the exit code — capture to a file, check `$?`.

**Sizing/discipline:** fit one 2400s handler invocation; if time runs short, STOP at a pushed, bar-green checkpoint and report the honest partial with the exact remainder. Report via your tada completion report ONLY — never inbox-send the parked supervisor. Keep the PR DRAFT; no PR comments.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-19T07:55:07Z
