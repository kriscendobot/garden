Work complete. Summary:

## Completion report

**Directive** (PR #600, endojs/endo-but-for-bots, from @dckc): *"How does this do exceptions? The C implementation uses longjmp."* — a design-clarity question on the xs2rust-endor (XS→Rust engine port) design+build PR.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer had resolved it).

**Finding:** The mechanism was already both designed and landed (stage-2b's `Vec<CatchJump>` in `endor-vm/src/interp.rs`), but the design doc only referred to it obliquely ("the exception machinery", "jump chain") — nothing a reviewer who knows XS uses `longjmp` could find. So the gap was discoverability, not implementation.

**What changed:**
- **`designs/xs2rust-endor-engine.md`** — added an `### Exceptions: a reified jump chain, not longjmp` subsection under *Interpreter and dispatch*. It states plainly that the port deliberately avoids `setjmp`/`longjmp` (UB across Rust frames; shipped crates are `forbid(unsafe_code)`), reifies XS's `txJump`/`firstJump` chain as an explicit `Vec<CatchJump>`, maps CATCH/UNCATCH/THROW/RETHROW onto ordinary control-flow unwinding, treats an uncaught throw as the empty-chain `Halt::Throw` at the host boundary, and notes the JS/host jump-flag and escaping-opcode metering quirks carry over.
- Committed (340ed9e058) under the bot identity and pushed to the PR branch `xs2rust-endor` via rebase-CAS (clean push).

**Reply posted:** issue comment #5025758052 answering @dckc directly with the full mechanism and a pointer to the new design section.

**Follow-ups:** none. No garden `main2` change; PR stays draft per its design-stage convention.
