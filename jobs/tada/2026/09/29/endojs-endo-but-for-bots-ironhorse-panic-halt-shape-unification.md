Draft PR **https://github.com/endojs/endo-but-for-bots/pull/1384** is open (head `ironhorse-panic-halt-shape-unification`, base `llm-7ff30af`, commit `7b7fd7adb3`). All seven old flat panic variants now sit under `Halt::Panic(PanicKind)` with their payloads kept, and the local test suites pass. I did not wait for CI; the gauntlet handles that.

**Open-question input:** the mentat report (`jobs/tada/2026/09/29/…-open-questions-mentat.md`, draft design PR #1370, not merged) answers Q8 with "adopt payload-preserving nesting of all panic variants". So this leg nests all seven, not just `StackOverflow` and `MeterAbort`. The PR body lists the Q8, Q1 and Q2 decisions as review items.

**What changed (86 files):**
- **The enum:** `PanicKind` now holds `StackOverflow`, `ReentryLimit`, `MeterAbort`, `HeapExhausted`, `EngineInvariant`, `Decode`, `StepLimit` and the existing `EngineFault`. The matching flat `Halt` variants are removed.
- **Classification:** `Halt::is_panic` is now a check for `Halt::Panic(_)`, and a new `Halt::panic_kind()` returns the payload.
  - `ExecutionOutcome::classify` in the `endo` crate handles every panic with one `Halt::Panic(_)` arm.
  - `NotImplemented`, `Refused` and the fail-closed fallback still classify as `Panicked`, but they carry no `PanicKind`, so diagnostics can tell them apart from real panics.
  - `describe_halt` hands panics to a new `describe_panic`. `HeapExhausted` now gets its own message instead of the debug fallback.
- **Mechanical migration:** 485 sites across the engine workspace, `endo`, and the fuzz and test262 harnesses. Files that were already rustfmt-clean were reformatted; nothing else was.
- **Label-registry test:** `tests/halt_label_registry.rs` now looks for `PanicKind::EngineInvariant(` and also rejects imports or aliases of `PanicKind`. The engine README is updated to match.
- **New tests:**
  - A test in `ironhorse-vm` matches every `PanicKind` with no catch-all arm, so a new variant won't compile until it's added.
  - A test in `endo` checks that each kind's payload comes through classification unchanged and renders its own message.
  - A second `endo` test checks that `NotImplemented` and `Refused` still classify as `Panicked` with no `PanicKind`.

**Test results:**
- `ironhorse-vm`, `ironhorse-snapshot`, `ironhorse-runtime`: 1795 passed, 0 failed.
- `ironhorse-262`, `ironhorse-fuzz`, `ironhorse-compile`: 1599 passed, 0 failed.
- `endo`: the ironhorse lib tests plus three integration test files all pass.
- `thixotrope-ironhorse-worker` checks clean.

**Follow-ups:**
- **#1364 (ResourceLimitPolicy)** hasn't merged, so this PR doesn't account for it. Whichever of the two lands second has to rename any flat `Halt::MeterAbort`, `Halt::HeapExhausted` or `Halt::StackOverflow` it uses.
- **Sibling PRs:** the open legs #1382 (Coda), #1374, #1375 and #1372 build or match halts, so each will conflict with this one. The fix in each is renaming to `Halt::Panic(PanicKind::…)`. I based this on current `llm` rather than stacking, because it doesn't depend on any of them.
- **Q1 provenance field** (load, execute, render or harness) is not added here. It belongs in the report from the adapter on the delivery path, which is a later leg.
- **Debug output** changes from `StackOverflow(n)` to `Panic(StackOverflow(n))`. The JS tests that match `/MeterAbort/` still match.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-halt-shape-unification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 148 tokens (7950696 cached reads)
- Output: 38102 tokens
- Cost: $3.5263312000000004
- Wall-clock: 1108s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
