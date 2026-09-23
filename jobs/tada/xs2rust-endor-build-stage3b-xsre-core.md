All 5 XSRE increments are pushed to `origin/xs2rust-endor` (PR #600), nothing unpushed. The job is complete: every bar item met and verified.

---

## Completion report — stage-3b child 8/9: XSRE core (RegExp matcher port)

Ported the pin's RegExp engine (`xsre.c`) as an **engine-internal** matcher module (no JavaScript surface — child 9 integrates) onto `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, still DRAFT). **5 green commits, each pushed immediately** (`0f96281aa` → `d211a1732`):

1. **Oracle shim** — `endor_oracle::regexp` calls `fxCompileRegExp` + `fxMatchRegExp` directly and returns captures + per-phase meter, so the matcher is pinnable in isolation.
2. **`endor-regexp` crate** (`#![forbid(unsafe_code)]`) — the XSRE compiler (`parse → measure → code`, byte-offset-exact like C so the graph and compile meter match) and the backtracking match VM (`fxMatchRegExp`), with backtrack states in a `Vec` (assertion save-points = length markers, `fxPopStates` = `truncate`). Metering hooks carried through: `Program::compile_meter_raw` + `MatchOutcome::match_meter_raw` for child-9 calibration.
3. **Structure-aware fuzz arm** — `endor_fuzz::regexp` + cargo-fuzz target `differential_regexp`, differential vs the pin.
4. **README evidence.**
5. **The `i` flag** — non-`u`/`v` case folding via `fxCharCaseCanonicalize` over `gxCharCaseIgnore0` (transcribed verbatim), wired exactly where `xsre.c` folds (single-char sets, ranges, `\w`, and the match loop).

**Bar met, all verified:**
- Matcher parity suite (`tests/parity.rs`): **`total=325 checked=325 skipped=0 divergent=0`** — bit-exact on matched answer, every capture's byte offsets, and per-step match meter, covering char classes, greedy/lazy quantifiers, groups/backreferences, anchors, alternation, lookahead+lookbehind, the `i`/`m`/`s` flags, and pathological backtracking.
- Fuzz arm: **3000-seed sweep, zero divergence**. It already earned its keep — caught a missing `fxCaptureReferenceMeasure` range check (`\11` with <11 groups), now ported.
- Workspace builds; **Miri clean** (`cargo +nightly miri test -p endor-regexp --lib`, 10 tests, no UB).

**Honest named skips** (`CompileError::Unsupported`, never wrong values/meters), reported to the supervisor inbox (dead-lettered → auto-promoted) as follow-up candidates: `u`/`v` flags (astral surrogate walk, `\p` property tables, V-mode string sets, `u`/`v` fold tables — the largest remaining piece), named captures (`(?<name>)`/`\k<name>`), inline modifiers (`(?flags:)` — VM support already present, only the parser branch stubbed), and astral (`>0xFFFF`) literals.

**Notes:** Compile meter is intentionally not asserted vs the shim (C's number folds in `fxNewChunk`'s allocation metering — a GC artifact the `Vec`-backed port never incurs; the match meter is the consensus number and *is* pinned exactly). A nested unbounded empty star `(a*)*b` is excluded from corpus+generator because it backtracks unbounded on the **pin too** (the shim leaves the meter interval unset) — a both-engines pathology, not a divergence.
