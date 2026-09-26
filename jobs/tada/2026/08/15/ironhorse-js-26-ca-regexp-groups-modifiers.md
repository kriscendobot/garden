All work is complete and pushed. Here is my completion report.

---

## Completion report: `ironhorse-js-26-ca-regexp-groups-modifiers`

**Repository:** endojs/endo-but-for-bots · **Branch:** `feat/ironhorse-262-language-completion` · **PR #970** (open/draft, preserved) · **New head:** `8bcd9ac6f`

### What I did

Closed the RegExp named-group/backreference and modifier gaps with real XS-compatible execution, oracle-locked bit-exact to Moddable XS pin `23b4d6b0` / test262 `be13516f`. No reasons were changed and no cases suppressed.

**Inline modifiers `(?ims-ims:...)`** (`ironhorse-regexp/src/compile.rs`, faithful port of `fxModifiersParse/Measure/Code`): a new `Modifiers` term node parses the scoped add/remove flag sets with XS's exact accept/reject (≥1 flag; disjoint add/remove; empty remove after `-` legal; a modifier group is not itself quantifiable). It emits the two `cxModifiersStep` blocks (the matcher already interpreted them); the scoped flag word drives compile-time charset folding for `i` and the runtime `flags` register for `s`/`m`, restored at the sequel step.

**Duplicate named groups (ES2025)** (compile.rs): ported `fxCaptureNamePut` (unique shared slots), `fxCaptureNameParticipate` (in-scope liveness → `SyntaxError` within one alternative), and the `fxDisjunctionParse` alternative-boundary detach/reattach so a name may recur across mutually-exclusive alternatives. The matcher (`matcher.rs`) now exposes the runtime name→capture map (`MatchOutcome.names`).

**JS surface** (`ironhorse-vm/src/interp.rs`): `.groups` and `$<name>` replacement resolve through the runtime name map (so a duplicate name yields the matched alternative); the `d`-flag `.indices` array and `.indices.groups` object are now built (previously absent).

### Verification (all 0 failed, oracle-locked)
- **Official slices** (before → after): `regexp-modifiers` 0 → **62**; `named-groups` 14 → **21**; `match-indices` 1 → **8**.
- **Full `built-ins/RegExp` tree: 979 covered, 0 failed**; `language/literals/regexp` 212 covered, 0 failed — no regressions.
- **Oracle parity** (`ironhorse-regexp/tests/parity.rs`): emitted program, captures, and per-step meter pinned bit-exact for modifier and duplicate-name corpora.
- **`cargo test --workspace --release`**: green (exit 0). New end-to-end dual-run suite `ironhorse-262/tests/regexp_groups_modifiers.rs` (7 tests) + 30 regexp lib tests pass.
- **`ironhorse-xst --gate-meter-exact`**: exit 0, 0 failed. Baseline computron expectations **unchanged** — verified by stashing my diff and confirming the 13 pre-existing named-groups computron-gaps are identical before/after; new advisory gaps are confined to the newly-covered surfaces.

### Follow-ups (pre-existing, out of this child's scope)
- `RegExpStringIteratorPrototype` / `String.prototype.matchAll` / `replaceAll` remain skipped — they need global-iteration (`matchAll`) support, a separate feature. My changes did not regress them (still 0 failed).
- A few modifier cases still skip on non-ASCII/astral subjects in non-`u` mode and `new RegExp(regexpObject, flags)` — separate pre-existing engine gaps.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-groups-modifiers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 310 tokens (31850355 cached reads)
- Output: 140877 tokens
- Cost: $22.464255499999993
- Wall-clock: 2300s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
