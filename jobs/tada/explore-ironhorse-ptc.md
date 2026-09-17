The job is complete. The draft PR is open and verified, the stray branch is cleaned up, and the inbox is empty.

## Completion report

**Job:** `explore-ironhorse-ptc` (designer, exploratory feasibility survey for Proper Tail Calls in Ironhorse).

**What I did.** Read the three named references from `origin/llm` (the engine design, the debugger-recovery-and-uncaught design, and `xst.rs`'s skip-list machinery), then read the actual engine source to ground every claim — `interp/frames.rs` (`enter_call`/`leave_call`), `interp/dispatch.rs` (call/return arms), `ironhorse-compile/src/coder.rs` (`code_return`), `cost.rs` (work models), and `ironhorse-262/src/xst.rs` (`evaluate_positive`/agreement classification). Wrote `designs/ironhorse-proper-tail-calls.md` (Proposed), added the required `designs/README.md` summary-table row, validated the one mermaid diagram parses, and opened it as **draft PR kriscendobot/endo-but-for-bots#5** (head `design/ironhorse-proper-tail-calls`, frozen base `llm-387ea66`, diff = the two design files only).

**Key findings (evidence-grounded, not asserted).**
- The two assumed hard costs are already paid: the oracle-locked compiler already emits `XS_CODE_RUN_TAIL*`/`EVAL_TAIL` in exactly the strict spec tail positions (`mxTailRecursionFlag`, threaded through `&&`/`||`/`??`/`?:`/comma), so **no compiler change and no byte-identity break**; and Ironhorse's frame model is a split (live registers on `Interp` + suspended `CallerState` in `call_stack: Vec`), so a tail call is `enter_call` **minus two operations** (no `CallerState` push, no `frame_slots` accrual).
- The debugger-geometry "conflict" resolves in PTC's favor: the exception chain binds to frames by `CatchJump.call_depth` (an index, unchanged by reuse), genuine tail positions carry no in-frame handler (coder-enforced), and the debugger row isn't even on the branch — it's being re-derived, so the only real coupling is *sequencing* (author the frame-walk knowing frames can be tail-elided).
- Metering is **provably neutral** (`RUN_TAIL*` already costs `CallArgs`; frame push/pop is unmetered) — no meter-version bump. Snapshot interaction is **nil**. test262 validation is **already carried** by the harness's `oracle-host-stack-limit` carve-out under `IronhorseOnlyComplete`; the 38 tagged cases self-validate single-engine, so just unskip `tail-call-optimization`.
- One **verified real hazard**: a strict async function's `return f()` is over-broadly tail-marked; reusing an async frame would drop its promise-resolution continuation, so the VM tail-enter must gate on an ordinary sync activation.
- **Recommendation: worth building, sequenced with the debugger row, not urgent** (consistent with the deferred posting).

**What changed.** Two new/edited files on the draft PR; no code. A frozen base `llm-387ea66` was pushed to the fork; a stray branch accidentally pushed to `endojs` was deleted.

**Follow-ups (owned by the maintainer / doc, not by me).** The PR is left **draft** per the manual-gauntlet regime — the maintainer promotes it with **run the gauntlet #5** when ready. Three open questions are recorded in the doc (async coder-tightening vs. runtime gate; `EVAL_TAIL` reuse safety; whether to add a positively-counted `single-engine-covered` verdict). The hardened262 annotation (PR 1040) is noted as available to ratchet coverage once merged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/explore-ironhorse-ptc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5131456 cached reads)
- Output: 47045 tokens
- Cost: $5.285823000000001
- Wall-clock: 935s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
