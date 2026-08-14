---
orchestration-failed: true
---
All gates pass, changes pushed to the open PR #970 with zero regressions. Here is my completion report.

---

## Child 12 — RegExp: named captures, `$` substitution, and catchable SyntaxError

**Repo/PR:** `endojs/endo-but-for-bots` PR #970 (open, draft — not merged), shared branch `feat/ironhorse-262-language-completion`.
**Head SHA:** `868771971502af07a4f342c1a11e9862ba515b57` (3 commits on `4821c236…`; remote unchanged, no rebase needed).
**Pins unchanged:** test262 `be13516fb6441b950ba8a3df97eb34062c186972`, XS oracle Moddable `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`.

### What I implemented (real, XS-oracle-verified)
1. **Named capture groups `(?<name>…)` + `\k<name>` backreferences** (`ironhorse-regexp`). A named group codegens identically to its numbered peer plus a name-slot operand on its capture completion, which the matcher records into its runtime `names[]` array (the matcher already dispatched these steps; the compiler was the only thing bailing `Unsupported`). `\k<name>` emits `capture_index=-1` + the slot, resolved at match time. `Program::capture_group_names` exposes `(name, capture_index)` in pattern order.
2. **`RegExpBuiltinExec` `.groups` object** (`ironhorse-vm`): built with `ObjectCreate(null)` and one `CreateDataProperty` per name in pattern order (null-proto verified by the oracle).
3. **`GetSubstitution` in `String.prototype.replace`** (non-global): `$$`, `$&`, `` $` ``, `$'`, `$n`/`$nn`, and `$<name>`.
4. **Catchable `SyntaxError` for an invalid `new RegExp(pattern)`** via a new `catchable_syntax_error` (mirroring `catchable_type_error`), replacing an uncatchable `Unsupported` self-name.

### Totals before → after (real execution, `full-run.sh --oracle on`, XS differential)
| Official slice | covered | ironhorse-failure | unsupported |
|---|---|---|---|
| `built-ins/RegExp` (1879) | 400 → **563** (+163) | 185 → 185 | 1294 → 1131 |
| `language/literals/regexp` (238) | 202 → **203** (+1) | 0 → 0 | 36 → 35 |
| annexB RegExp subset (70) | 36 → 36 | 1 → 1 (pre-existing) | unchanged |

**+164 covered across the acceptance slice; 0 covered regressions; 0 new `ironhorse-failure`; 0 new `infrastructure`** (verified by path-level before/after diff of the full built-ins/RegExp report against a baseline captured at branch HEAD before my commits).

Changed skip reasons: `unsupported-opcode:(?<name>) named capture` (16 → 0), `RegExp:syntax-error-throw` (163 → 0, the dominant driver), `String.replace:dollar-substitution` (→ 0 on the non-`u` path). The single annexB failure (`RegExp.prototype/compile/this-subclass-instance.js`, over-acceptance) is **pre-existing and identical at base** — unrelated to this work.

### Regression invariant — verified
- `cargo test --workspace --release`: **all pass** (ironhorse-vm 90, ironhorse-regexp 20 + XS parity, ironhorse-262 dual-run/metering tests, ironhorse-compile, xs-oracle — 0 failures).
- **Exact-metering corpus** (`cases/**`, run via `ironhorse-xst --gate-meter-exact`): built-ins **1430/1430 covered, 87 advisory computron-gaps**; stage3b-regexp **72/79 gated**. I rebuilt the **base commit** and got **byte-identical** numbers (87 advisory, 72/79) — my changes introduce **zero** new meter divergence, and every previously-passing exact-metering case keeps its exact computron. (The 7 pre-existing stage3b-regexp advisory gaps are a prior branch condition, not mine.)
- Focused Rust tests added: 5 `ironhorse-regexp` unit tests (capture offsets, name exposure, forward refs, unset optional groups) and 13 named-capture/`\k` cases in the XS-differential parity corpus (asserted bit-exact incl. per-step meter).

### Honest disposition — orchestration gate unmet
The child's stated scope is essentially the whole RegExp surface. I fully closed **named captures/backreferences** and the **constructor syntax-error path**, and partially the replace protocol. **Not closed** (each a distinct, larger increment): `\p{}`/`\P{}` property escapes (needs a Unicode property DB; also the 185 pre-existing property-escape over-acceptance failures), `u`/`v` unicode-mode matcher (astral/CESU-8), inline modifiers `(?flags:)`, the `d`-flag `indices` array, `Symbol.match/matchAll/replace/search/split` real protocol dispatch + `Symbol.species`, global/functional replace, and the general-VM `apply:non-user-function-receiver` gap (453 cases, the largest remaining bucket, not RegExp-grammar). Because the complete-coverage gate for this slice is not met, I signal orchestration-failed while leaving the PR open with verified progress.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-12-regexp.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 305 tokens (24529957 cached reads)
- Output: 129319 tokens
- Cost: $19.934364500000004
- Wall-clock: 1993s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
