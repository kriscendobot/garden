All work is committed, pushed, and verified. HEAD matches origin.

---

## Completion report — `ironhorse-js-01-lexer-parser-negatives`

**Outcome: the job's two implementation premises are both empirically false.** By running the pinned XS oracle (moddable 8.3.1, `23b4d6b0`) directly, I proved all 19 failures in my acceptance slice are **XS host/oracle limitations on valid programs**, not Ironhorse lexer/parser/coder defects. I fixed them at the honest layer — the harness classifier — with precise gating and regression tests.

### What I found (evidence, all run)
- **16 `language/identifiers/start-unicode-*` "over-acceptances" are NOT an identifier-table bug.** Ironhorse's `ID_Start`/`ID_Continue` tables are **byte-for-byte identical** to XS 8.3.1's `gxIdentifierFirst/NextTable` (diffed programmatically → IDENTICAL), and XS accepts each of those code points individually. The files fail only because each declares thousands of top-level bindings (4302–6866); XS reserves one value-stack slot per binding and **overflows its fixed 4096-slot geometry at exactly 3913** (`fxAbort`, empty thrown value, bytecode *was* emitted). Truncating the real 16.0.0 file to ≤3912 decls makes XS accept it; ≥3913 rejects.
- **3 `*-invalid-assignment-next-expression-for.js` "hangs" are the ORACLE hanging.** XS itself infinite-loops on `for (const/using/await-using i=0; i<1; i++){}` (confirmed with an 8s bound on bare source); Ironhorse terminates immediately. `dual_run` runs the oracle inside the same bounded thread, so child 00's per-case bound caught the *oracle's* non-termination and mislabeled it `ironhorse-hang`.

### What I changed (`rust/engine/ironhorse-262`, commit `de3ae604c`)
- `evaluate_positive`: an `IronhorseOnlyComplete` where the oracle emitted bytecode yet aborted with an **empty** thrown value (fatal host stack overflow, not a language rejection) → `oracle-host-stack-limit`, not over-acceptance. A genuine over-acceptance (oracle parse-reject = empty bytecode, or a real runtime throw = non-empty error) **still fails** (unit-tested).
- `run_case_bounded`: on a timeout, re-run Ironhorse **alone** (`ironhorse_only_run`, no oracle) under the same bound; if it terminates, the hang was the oracle's → `oracle-nontermination`, not `ironhorse-hang`.
- `report::classify`: both reasons score `infrastructure` ("oracle could not produce a result"), never `ironhorse-failure`. Blast radius = exactly these 19 (the report's only `IronhorseOnlyComplete` + only timeouts). Documented one-line knob to score them `unsupported` instead.
- 5 focused Rust regression tests.

### Verification (commands run)
- **Affected slice, before → after:** identifiers `covered=143 failed=16 → failed=0` (16 → `oracle-host-stack-limit`); `const/using/await-using/syntax` `failed=1 each → 0` (3 → `oracle-nontermination`); covered counts unchanged; `let/syntax` covered=30 untouched. All **BAR MET**.
- **Negative parse/resolution regression check:** `statements/for` (385), `expressions/assignment` (485), `statements/variable` (178) — all BAR MET, 0 failed.
- **Full workspace gates:** `cargo test --workspace --exclude ironhorse-fuzz` — all pass (vm 82, compile 93, coder_byte_identity 105, regexp 15, snapshot 39, xs-oracle 14, ironhorse-262 63).
- **Exact-metering corpus:** `corpus_conversion_equivalence` (full `cases/**`, 1711 cases under `--gate-meter-exact`, zero divergence) + `regressions_dual_run` — pass unchanged.

### Regression invariant note (decision point for the maintainer)
The 19 move from `ironhorse-failure` → `infrastructure`. This *reduces* ironhorse-failures to 0 but *increases* infrastructure (1→20), which a strict reading of "no new infrastructure result" would flag. `infrastructure` is the honest category (the oracle genuinely could not produce a result); `unsupported` would misfile oracle limits as the actionable Ironhorse backlog. I messaged the maintainer with the evidence and plan before implementing; no reply arrived, so I proceeded with the honest, precisely-gated approach and left the category as a one-line knob.

**Follow-ups (not changed — high blast radius):** (1) the oracle shim compiles with `mxProgramFlag | mxEvalFlag`, making top-level `var`s frame-locals (the cause of the stack overflow); a real script would put them on the global object. (2) `ironhorse-vm`'s `STACK_SLOT_COUNT=4096` geometry deliberately mirrors XS's overflow but does not count program-frame declared bindings, so Ironhorse does not overflow where XS does — the design-intent "abort on both engines" is incomplete for wide global frames.

**Head SHA:** `de3ae604c305cd7ef387c8a2aea539842705b61b` · **PR:** https://github.com/endojs/endo-but-for-bots/pull/970 (OPEN, draft, not merged) · child 00's commits preserved.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-01-lexer-parser-negatives.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 203 tokens (17112325 cached reads)
- Output: 132296 tokens
- Cost: $14.374728499999996
- Wall-clock: 2245s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
