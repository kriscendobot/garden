Inbox is empty; PR #1278 head is my amended commit, draft, open. The job is complete with real-execution evidence at every gate. Writing the completion report.

---

## Completion report: Port the XS 65535-locals-per-frame limit to Iron Horse

**PR:** endojs/endo-but-for-bots **#1278** (draft, base `llm`, head `kriscendobot:ironhorse-frame-locals-limit` @ `b09834bac8`).

**1. Ceiling established — Iron Horse shares XS's exact 65535 (u16 slot index); memory safety, not mere conformance.** `ironhorse-compile` reserves frame locals with `RESERVE` and encodes every frame-slot operand (`RESERVE`/`RETRIEVE`/`UNWIND` + the `GET_LOCAL`/`SET_LOCAL`… families) as a `u16`. `width_select_index_family` (a faithful port of XS's `fxByteCodeSize`, `c/moddable@23b4d6b0a65f xsCode.c:302`) does `value > 65535 → id += 2` — a "_4" variant that **does not exist** (`RESERVE_1=158`, `RESERVE_2=159`, `160=RESET_CLOSURE_1`), so past 65535 the opcode is mislabeled and mis-sized → corrupt bytecode. XS's own source has the identical broken bump, confirming the shared ceiling. Max encodable frame = 65535 (`RESERVE_2`).

**2. Enforced at compile time.** The scoper now rejects any frame whose `scopeCount` (== `scopeMaximum`) exceeds 65535, returning `ParseError{kind: Syntax, message: "too many variables"}`, which propagates through `scoper::run` before the coder runs — a clean catchable error, never lowered to bytecode. No runtime trap, no debug assert.

**3. Every accumulation path covered.** Implemented as one helper `record_scope_count` replacing the **four** `scope_counts.insert` sites (function / program / module / field-init). `scopeMaximum` is the single chokepoint that folds in *every* path that reserves a slot — parameters, `var`/`let`/`const`, array/object destructuring, hoisted function declarations, `catch` bindings, closures, and the binder's statement temporaries — so one check covers them all.

**4. Regression tests (generated programmatically):**
- `ironhorse-compile/src/scoper/tests.rs` (`frame_*`, 8 tests): exact boundary (65535 accepted, 65536 rejected) + one over-limit case per path (var, let, array/object destructuring, function decls, catch destructuring, parameter contribution) + a module top-level frame.
- `ironhorse-vm/tests/compiler_frame_locals_limit.rs` (4 tests, companion to `compiler_symbol_limit.rs`): public-API rejection + a valid multi-path frame that **compiles and runs** to `55`, plus a 2000-slot frame that runs.

**5. Engine suites / CI (real-execution evidence):**
- Local: `cargo test -p ironhorse-compile` → 127 lib + all integration pass; `cargo test -p ironhorse-vm -p ironhorse-snapshot --features ironhorse-vm/store-integrity` → 0 failures. Pinned `cargo +1.88.0 fmt --check` → clean.
- CI on the current head: `format-ironhorse` **pass** and `test-ironhorse-calibration` **pass**; the longer ironhorse jobs are re-running. On the prior head (which differs only by a whitespace line-split in one test assertion), `test-ironhorse-release` — which compiles and runs `-p ironhorse-compile -p ironhorse-vm` including the new tests — **passed**, as did test-ironhorse-oracle, test-xs, and every non-ironhorse job. The sole prior failure was `format-ironhorse` (a stale "no fmt gate" assumption — CI pins rustfmt 1.88.0); fixed and confirmed green.

**test262:** no delta possible — the change is a purely additive guard reachable only above 65535 frame slots, altering no sub-ceiling program's bytecode. Standing floor `baseline/refresh-20260904` (30,233 covered / 0 failures) unaffected.

**Honest boundary (stated in the PR):** at the full-compile path the frame ceiling is currently *shielded* by two lower limits for hand-written source — the coder's 65534-distinct-name symbol cap trips first for named bindings, and the recursive-descent parser stack-overflows well below 65536-deep nesting. The check is still the correct XS-matching guard: it fires cleanly at the scoper (before the coder can corrupt the stream) and is defense-in-depth for any future parser/limit change and for any construct a fuzzer inflates past 65535.

**Follow-ups:** the upstream XS fix is not yet landed; the weekly `xs-frame-locals-limit-upstream-watch` schedule will reconcile this port once it does. The draft PR remains draft for the separate gauntlet/panel machinery. Memory `ironhorse-frame-locals-65535-ceiling` records the findings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-port-xs-frame-locals-limit.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 292 tokens (22111449 cached reads)
- Output: 102849 tokens
- Cost: $15.830678500000001
- Wall-clock: 2474s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
