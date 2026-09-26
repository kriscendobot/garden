All work is complete and verified. Here is the completion report.

---

## Completion report — `ironhorse-js-00-report-harness-foundation`

**Job:** Establish the shared Ironhorse completion PR and make the full-suite oracle harness trustworthy (kriscendobot/garden#51). Repo: `endojs/endo-but-for-bots`.

### What I did

**Shared completion branch + draft PR.** Created `feat/ironhorse-262-language-completion` from current `llm` (`068bfc2d0`) and cherry-picked #969's reporting commit onto it (its `report.rs` / `full-run.sh` / workflow are byte-identical to #969). Opened **draft PR #970** — https://github.com/endojs/endo-but-for-bots/pull/970 — base `llm`, head `54a81fa53`. **Kept open, not merged.** This is the single branch all later children build on.

**1. Per-case wall-clock/dispatch bound.** `run_case_bounded` dispatches each case on a fresh thread joined with a deadline (`ironhorse-xst --case-timeout`, default 10s; threaded through `full-run.sh`). A non-terminating case (e.g. `for (const i=0; i<1; i++){}`, where a missing assign-to-const `TypeError` spins forever) is recorded as an `ironhorse-hang` failure in bounded time instead of wedging its per-directory batch. Non-hanging path shares no engine state (metering/determinism identical to unbounded); only a genuine hang leaks its uncancellable thread, reclaimed at batch exit. Resumability + atomic batch output unchanged.

**2. Removed `negative-{parse,resolution}:pending-compiler`.** The dual-run now captures ironhorse-compile's reaction (`DualRun::ironhorse_compile`: Accepted/Rejected/Panicked), and `evaluate_negative_early` keeps five outcomes distinct: compiler rejection → **covered**; accept-then-complete → **Fail** (over-acceptance); accept-then-abort → `negative-<phase>:runtime-reject`; oracle non-rejection → `negative-oracle-unexpected`; deferred coder panic → `compiler-unimplemented:<phase>` (a named compiler gap, never miscounted as covered or infrastructure).

**3. Re-audited the lone `negative-oracle-unexpected`** — `language/global-code/decl-lex-restricted-global.js` (`let undefined;`): a `phase: runtime` restricted-global SyntaxError the XS oracle shim doesn't reproduce (no real restricted-global global object). Confirmed it's a justified host/oracle-shim exclusion (infrastructure), not an engine gap; documented in `baseline/README.md`.

**4. Committed the immutable starting baseline** (`rust/engine/ironhorse-262/baseline/`): provenance, per-category totals, full failures/infrastructure lists, and the complete sorted covered set — enough for any child to check the invariant with no network fetch.

**5. Added 7 focused Rust unit tests** for the early-error trichotomy and the bounded-dispatch hang verdict.

### Commands + totals (before → after, official `language/**`, corpus `tc39/test262@be13516`)

`ironhorse-xst --test262-dir <test262> --case-timeout 10 language`

| metric | starting report | this branch |
|---|---|---|
| `language/**` covered | 2,719 | **6,528** (+3,809) |
| covered→uncovered regressions | — | **0** |
| ironhorse-failures | 19 (16 unicode + 3 hangs) | **19** (same set; 3 hangs now bounded in 10s) |
| infrastructure | 1 (`decl-lex-restricted-global`) | **1** (same case, re-audited) |

The ~4.4k parse/resolution negatives converted from a blanket skip to real verdicts (mostly covered). **No new `ironhorse-failure`, no new `infrastructure`.**

### Gates run before push
- `cargo test -p ironhorse-262 --release` — all pass (59 lib incl. 7 new; report/regression/corpus integration suites green).
- Exact-metering corpus `--gate-meter-exact` over `cases/` → **1712 covered, 0 failed, BAR MET** (computron expectations unchanged).
- Official `language/**` slice (table above), regression cross-checked against the baseline.
- clippy (no new warnings), rustfmt clean on changed files, shellcheck clean on `full-run.sh`, prettier clean.

### Changed pins
test262 (`be13516fb644`) and Moddable XS (`23b4d6b0`) pins **unchanged**. The engine base advanced from the report's `65959a5d5` to current `llm` `068bfc2d0` (4 non-engine daemon/cli/captp fixes); the failure/infra sets are identical to the published report, confirming those commits didn't perturb test262 behavior.

### Follow-ups (for later children)
- The 3 `ironhorse-hang` cases (`const`/`using`/`await-using` invalid-assignment-for) need the causal engine fix: assignment to a `const`/`using` binding must throw `TypeError` — that converts them from failure to covered.
- The 16 `language/identifiers/start-unicode-*` identifier-start over-acceptances remain the pre-existing engine gap.
- `compiler-unimplemented:*` gaps (e.g. class static blocks with lexical declarations) name specific ironhorse-compile constructs to implement.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-00-report-harness-foundation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 246 tokens (20416410 cached reads)
- Output: 107038 tokens
- Cost: $15.249297999999998
- Wall-clock: 1641s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
