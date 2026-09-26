All work verified and landed. Writing the completion report.

---

## Completion report: `ironhorse-js26-milestone-with-opcode`

**Outcome: verified partial gain committed and pushed; honest residual reported.** No gate broken; this is not an orchestration failure (residual cases remaining is explicitly expected for this milestone).

### Key finding — the VM prerequisite was already landed
The milestone's stated core ("the whole ~949-case cluster cascades off" the `XS_CODE_WITH`/`XS_CODE_WITHOUT` + scopable env-chain prerequisite) was **already on the shared branch** before I claimed the job: commit `c0bf422ed1` (`feat(ironhorse): with-statement environment-chain model + real execution`), an ancestor of the branch head. It had already cleared the bulk of the cascade — `language/statements/with` was at 158/181 covered when I started. So the prerequisite was not net-new work available to me; I worked the residual tail.

### What I changed (net-new, verified)
Implemented **ToObject-boxing of Number/Integer/Boolean primitives in `XS_CODE_TO_INSTANCE`** (`with(primitive)`, object-destructuring of a primitive RHS), which previously fell to an honest `to_instance:primitive-box` skip.
- New helper `box_primitive_to_instance` (interp.rs): mirrors XS's `fxToInstance → fxNewNumberInstance/fxNewBooleanInstance` — two `fxNewSlot` allocations, no constructor dispatch (distinct from `build_wrapper`'s `new Number()` path), primitive held in `wrapper_data`, `XS_DONT_PATCH_FLAG` in strict mode. Metering matched the oracle **exactly** on the first try (computron-gap=0).
- **String / Symbol / BigInt deliberately kept as honest skips** — a String wrapper's `length`/indexed own properties aren't materialized in the side-table model, so boxing it would mis-answer an own-property read (the exact divergence the original skip guarded).
- Added 3 focused differential regressions to `tests/with_statement.rs` (16 pass).

**Before/after (measured against the XS oracle, pin `be13516f`):**
- `language/statements/with`: **158 → 160 covered**, 0 failures (`12.10-2-1` Number, `12.10-2-2` Boolean now covered; `12.10-2-3` String correctly still skips).

### Gates (all green)
- `cargo test --workspace --release`: pass (pre and post).
- `ironhorse-xst --gate-meter-exact` over `cases/**` (1712 cases): **1661 covered / 51 failed / 0 skipped — byte-identical pre- and post-change** (I confirmed by rebuilding the pristine binary from a stash; the 51 off-by-1 drifts are pre-existing on the base branch, not introduced here).
- No new failures in `expressions/assignment/destructuring` (5/8, 0 failed) or `statements/for-of` (618/751, 0 failed) — the other `TO_INSTANCE`-boxing sites.

### Head / PR
- Shared-branch head after CAS-push: **`d3a40d0b63`** on `feat/ironhorse-262-language-completion`.
- **PR endojs/endo-but-for-bots#970 is already MERGED** (not by me; merged before I claimed the job), contradicting the spec's "keep #970 open and draft." The branch remains live and now carries my commit. I messaged the maintainer (via the liaison) flagging that a fresh draft PR would be needed if the ongoing language-completion line wants a review surface. I did not merge anything.

### Honest residual (what remains and where)
Every remaining bucket is a distinct, deep feature — none is a safe bounded increment, and each risks divergence if half-implemented:
- **`language/statements/with` (21 left):** 11 `ironhorse-aborted` + 5 `callback:non-user-function` (proxy-env) + 2 `abort-value-differs` — all need **re-entrant JS execution during name resolution** (running an `@@unscopables` getter or a Proxy has/get/set trap inside the synchronous `is_scopable_slot`/`resolve_env_reference` helpers, which cannot currently call back into the interpreter loop). 2 `eval:direct-scope`, 1 String `primitive-box`.
- **`annexB/language` (496 of 845 left):** dominated by direct-eval semantics — 247 `abort-value-differs` (Annex B 3.3 block-level function-declaration hoisting through direct eval), 144 `eval:direct-scope` (direct eval inside a **function** frame needs caller-local scope capture, unmodeled), 64 `defineProperty:global-object` (global block-decl eval). 26 `feature:IsHTMLDDA` are a legitimate proposal/host-only exclusion (document.all emulation), already feature-gated. 8 `negative-type-unmatched` (HTML-comment early errors), 6 `parse-or-decode`.
- **Built-ins tail / strict-with:** the named `built-ins/Proxy` (@@unscopables/trap-order) cases share the re-entrant-resolution blocker above; not converted.

The next milestone worker's highest-leverage targets are (1) re-entrant getter/Proxy-trap execution inside with-name-resolution (~20 cases in statements/with plus the built-ins tail) and (2) direct-eval-in-function-scope + Annex B 3.3 eval hoisting (~450 annexB cases) — both deep enough to warrant their own focused claims.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js26-milestone-with-opcode.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 200 tokens (12622716 cached reads)
- Output: 86634 tokens
- Cost: $10.278389999999998
- Wall-clock: 1358s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
