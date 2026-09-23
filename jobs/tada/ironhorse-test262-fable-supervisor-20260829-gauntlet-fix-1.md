CI is **GREEN** (rc 0, 27/27 checks, 0 failed) with my fix commit `ba236d722d` on the head. The fix stage is complete.

---

## Completion report — Gauntlet FIX round 1, endojs/endo-but-for-bots PR #1113

Applied the panel round-1 must-fix items once, pushed as a review-feedback follow-up commit (`be5eef82cc..ba236d722d`), and watched CI to terminal GREEN.

**What changed** (commit `ba236d722d`, 3 files):

1. **TypedArray-from-array source snapshot** — the dominant must-fix, unanimous across 7 seats (assessor/typist/locksmith/warden/saboteur/breaker/purist) and measured. The snapshot collected `(0..length)` into a dense `Vec<Slot>` sized by the *declared* length (32 B/declared element, unmetered), re-arming the wave-5 hazard: a within-cap sparse source reserved ~8.6 GB the meter never saw, reachable to `handle_alloc_error`. Now clones the source's **sparse `items()` map** (present entries only), proportional to already-charged storage; absent indices read `undefined` from the clone. Deleted the guard-unreachable `(None, None)` arm. Added `the_array_snapshot_precedes_element_coercion` to lock the IteratorToList immunity.

2. **`Halt::Resume` / native `mxTry` fence** (saboteur must-fix) — **empirically confirmed real**: without the fix, `new Promise(function(){ Math(); })` inside an outer `try` returned `"caught"` where XS returns `"no"` (oracle divergence reproduced, then resolved). `run_callback_catching_throw` left the caller's jump chain unfenced, so a native-validation raise inside a promise executor / thenable `then` / finally / dispose handler consumed the outer handler and leaked the `Resume`, landing the throw in a guest `catch` with the promise never settling. Now fences `self.jumps` for the callback's duration (mirrors the async-generator body fence at `resume_async_generator`), restored on every exit. New suite `tests/native_mxtry_boundary.rs` (4 dual-run cases).

3. **`catchable_type_error_msg` → `catchable_type_error_with_message`** + sibling `catchable_syntax_error_msg` → `catchable_syntax_error_with_message` (stylist must-fix: freshly-authored bare-abbreviation, disagreeing with its own `message` parameter).

4. **Dropped the `.as_deref()` no-op** on `Option<&u16>` in `array_generic_has` (typist/warden/saboteur/purist nit).

**Dismissed as false positive:** the archivist's must-fix (README `1 ironhorse-aborted` skip name gone stale) — verified by re-running the ses-xs-parity bar, which still prints `1 ironhorse-aborted`. The bar classifies through `test262.rs:173`, which the round-2 diff left emitting the bare reason; the `:<kind>` split lives only in `xst.rs` (as curator/migrator/prover independently noted).

**Verification:** ironhorse-vm 180 tests green; promise/async/typed-array dual-run suites 85 green; targeted regression suites (native_mxtry_boundary, typed_array_source_length, not_callable_caught_raise, inherited_floor_regressions) 25 green. **CI terminal GREEN: 27/27 checks, 0 failed.**

**Follow-ups (deferred should-fix, for panel-2 / driver):** the taxonomy-drift cluster (curator/migrator — unify `test262.rs:173` with `xst.rs`'s abort-kind split via a canonical `abort_skip_reason`), the `wrong-throw:<ctor>` unbounded-key clamp, prover's per-call-site regression-evidence gaps (truthy sites, has-guards), and packager's commit-splitting — all out of scope for a bounded fix-once stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-test262-fable-supervisor-20260829-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 156 tokens (10468438 cached reads)
- Output: 65173 tokens
- Cost: $8.633655
- Wall-clock: 1262s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
