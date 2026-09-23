All three commits are on `origin/xs2rust-endor`. Work complete.

## Completion report

**Job:** Stage-5 fix 2/5 — port the named coder rejects for the XS→Rust Endor port (PR #600, branch `xs2rust-endor`, kept DRAFT; oracle pin `48ee02d8cfe0`).

**What I did** — ported each folded construct from xsCode.c at the pin, byte-identical, verified against the oracle by the differential harness:

- **`new.target`** (14 corpus rejects): `Target` node → single `XS_CODE_TARGET` byte (`fxValueNodeCode`).
- **Optional chaining `?.`** (3 rejects): added `Chain` (`fxChainNodeCode`) and `Option` (`fxOptionNodeCode`) with a saved/restored `chain_target` field and `BRANCH_CHAIN` short-circuit; handles member, computed-member, and nested links.
- **`for (let …)` declaring scope** (2 rejects): ported `fxScopeCodeRefresh` (`REFRESH_LOCAL`/`REFRESH_CLOSURE` per declared slot) in place of the assert.
- **Nested function declarations** (1 reject): allow `Define` declares in `scope_coding_block` (a `NEW_LOCAL`/`NEW_CLOSURE` slot with no value init; `fxScopeCodeDefineNodes` assigns the function value).
- **Extra fold closed:** the `addition` test262 subtree's 4 rejects were **not** `new.target` as the job spec assumed — they were a non-identifier name-inference fold (`o.m = function(){}`). Fixed so a member-LHS anonymous function stays unnamed (ES `NamedEvaluation` applies only to identifier LHS), which the harness confirmed byte-identical.

**Bar — all MET:**
- Curated corpora: endor-rejected **20 → 0** (1711/1711 identical, 0 divergent, full accept/reject agreement).
- test262 spot-checks: `addition` 48/48 (0 rej), `statements/if` (0 rej), `expressions/conditional` (0 rej), all 0 divergent.
- `cargo test --workspace -- --test-threads=1`: **EXIT=0**.
- In-crate gate tightened: documented-fold allowlist emptied, now asserts `endor_rejected == 0`.
- `#![forbid(unsafe_code)]` intact. Per-construct fixtures added to `coder_byte_identity.rs`.
- Also retargeted the endor-262 compiler-seam fold test off `new.target` (now ported) onto a still-deferred construct (private class field).

**Changed files:** `rust/engine/endor-compile/src/coder.rs`, `rust/engine/endor-compile/tests/coder_byte_identity.rs`, `rust/engine/endor-262/src/compile_diff.rs`, `rust/engine/endor-262/src/lib.rs`. Three commits pushed to `origin/xs2rust-endor` (tip `dd766cd22e`), each a green rebase-CAS push (EXIT=0).

**Follow-up (honest fold report):** Direct eval **inside a function** (the one in-scope item I did not complete). I attempted the parameter `with`/`STORE` dance but it diverged — the oracle needs the whole in-function eval-**body** slice (the `EVAL` opcode's environment plumbing + in-function sloppy-eval reference resolution), not just the param dance. I reverted the attempt and documented it as a self-naming assert (`eval-scope params deferred`) on `scope_coding_params`; program/block-level eval remains byte-identical. This is a larger follow-up slice than the job assumed. Reported to the orchestrator (`port-xs-to-rust-memory-safe-engine-s13`); that job had already completed, so the message was dead-lettered and will be promoted to a fresh job.
