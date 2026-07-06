The work is complete. Here is my completion report.

---

## Completion report — `xs2rust-endor-stage4-fuzz-decoder-hang`

**Diagnosis confirmed.** `cargo test --workspace` wedged on the endor-fuzz test `decoder_never_panics_on_arbitrary_bytes`. I reproduced cheaply (fuzz suite only, `--nocapture` to a file, last-printed-seed method) and isolated the offending input in one run:

- **Seed 1750** decodes to `[25 fe 86 1c 28 ee 59 08 a6 f7 ec c0 0d 17]`; minimal core `[25 fe]`.
- Byte `0x25` = `XS_CODE_BRANCH_STATUS_1` (generator/async resume epilogue), operand `0xfe` = offset **−2**. With a 2-byte instruction at pc 0, `branch_target(0,2,−2) = 0` — the branch **targets its own pc**, a zero-progress self-loop. `disassemble` completes fine; the hang is in the interpreter dispatch loop.
- **Root cause:** the interpreter only aborts a backward branch through the metering host, but the fuzz `run_program` arms **no** host (`meter_host: None`), so the self-branch never terminates. The pre-existing `[16 80]` case terminates only incidentally (its offset drives pc out of bounds). Made reachable by **`b41446ad7`** (generators, stage-4a child 3/8), which gave opcode 37 a real backward-branch handler — before it, byte `0x25` was an unimplemented `Halt::Unsupported`. This is why s8's `0b991a8b4` acceptance still passed 128/0.

**Fix (two layers).**
1. *Root — total interpreter for un-metered callers.* Added a dispatch-count ceiling: `Interp::run_bounded` / public `run_program_bounded` / `Halt::StepLimit(u64)`. Default `run` stays `u64::MAX`-unbounded, so **every oracle-differential path is byte-for-byte unchanged**; only the fuzz harness installs the finite `DECODER_STEP_LIMIT` (2,000,000 dispatches — far above any well-formed ≤40-byte program). A self-loop now aborts in single-digit ms.
2. *Lock.* Offending input added as a named regression case (14-byte seed + 2-byte core) in `decoder_never_panics_on_arbitrary_bytes`, plus a new wedge-proofing test `decoder_hang_is_bounded_not_infinite` asserting the self-branch hits the ceiling rather than completing or hanging.

**Verification.** `cargo test --workspace -- --test-threads=1` **completes green — 149 passed, 0 failed — in ~5 s** wall-clock (warm build; the endor-fuzz binary's own run including the 2000-seed sweep is 1.3 s). `#![forbid(unsafe_code)]` intact across the workspace. README evidence block updated with the trophy (input bytes, root cause, introducing commit, and the workspace wall-clock).

**Changed / pushed.** `endor-vm/src/interp.rs`, `endor-vm/src/lib.rs`, `endor-fuzz/src/lib.rs`, `rust/engine/README.md`. Committed `94d42d23f` with explicit pathspecs, pushed `e08b83ac3..94d42d23f` to `origin/xs2rust-endor` (rebase-CAS). **PR #600 left DRAFT.** The `c/moddable` gitlink change (local submodule population) was deliberately excluded from the commit.

**For the orchestration / stage-4b children behind me:** the workspace wedge is cleared — the bar now completes in ~5 s warm and fits the 2400 s handler budget with wide margin. The step ceiling means any *future* decode non-termination fails in milliseconds instead of hanging the whole suite.

**Follow-ups:** none required. (Note: the stage-4a **modules** child that died to this wedge can now have its workspace-green bar re-verified if the orchestration wants to confirm that acceptance retroactively.)
