Empty inbox. All work is complete and verified. Let me write the completion report.

---

## Completion report

**Job:** `ironhorse-js-26-ca-regexp-u-core` — implement real XS-compatible RegExp Unicode (`u`) core execution in `ironhorse-regexp`.

**What I did** — ported the `u`-flag core matcher from the pinned Moddable XS oracle (`c/moddable` @ 23b4d6b0) into `rust/engine/ironhorse-regexp`:

- **`charcase.rs`**: added the `gxCharCaseFold0` (200-row BMP) and `gxCharCaseFold1` (12-row astral) tables verbatim from `xsre.c`, and made `canonicalize(character, fold)` a faithful `fxCharCaseCanonicalize(character, flag)` — `fold=true` selects the `u`/`v` lower-ward fold (astral through `Fold1` by low-16-bits) vs the existing non-`u` upper-ward `Ignore0` fold.
- **`encoding.rs`**: `get_character` now folds through the `u`/`v` table under `iu`. Documented that a well-formed UTF-8 subject decodes identically in CESU-8/plain modes, so `find_character` needs no `UV` branch and only the fold table differs.
- **`compile.rs`**: astral pattern scalars were already delivered whole under `u`; threaded the fold flag into `charset_canonicalize_single` and `charset_range`, added the `iu` branch of `\w` (keeps `a-z`, drops `A-Z`), and removed the blanket `CompileError::Unsupported("u/v flag")`. Only `v` (string sets) and `\p{}`/`\P{}` remain honest named skips — never relabelled or suppressed.
- **Tests**: added 8 focused lib unit tests (astral match/consume, `\u{}` + surrogate-pair escapes, astral classes, `iu` lower-ward fold incl. Kelvin/sigma/Deseret via `Fold1`, `\w` under `iu`, backreference folding, and `v`/`\p` staying skips) plus a `u`-mode differential block and a `deferred_surfaces_remain_named_skips` test in the oracle parity suite.

**Verification (all against the pinned XS oracle; test262 pinned at be13516f):**
- `cargo test -p ironhorse-regexp`: 27 lib + 2 parity tests pass. Parity corpus **420 cases checked bit-exact (was 211)**, 0 skipped, 0 divergent.
- `cargo test --workspace --release`: all green, 0 failed.
- `ironhorse-xst … built-ins/RegExp`: covered **563 → 584 (+21 `u` cases now executed)**; failed **185 → 185** (all pre-existing `\p{}` property-escapes + `v` `unicodeSets` parse-early-error over-acceptances — proven identical to the stashed baseline; zero non-deferred failures).
- `ironhorse-xst … language/literals/regexp`: 211 covered, **0 failed**.
- `ironhorse-xst --gate-meter-exact ironhorse-262/cases`: **1712 total, 1661 covered, 51 failed — byte-identical to the baseline** (same 51 pre-existing off-by-one violations, same 7 `stage3b-regexp` files). Every starting covered case and every computron expectation preserved.
- Temporal not impacted: the change is confined to the `ironhorse-regexp` crate (Temporal parsing does not route through it); workspace Temporal unit tests pass.

**Head SHA:** `e862a560b3b3d1cd55f801f6f3a4fe30ea9049e6` (pushed to `feat/ironhorse-262-language-completion` via fetch/rebase/CAS, first attempt). Draft PR left as-is (not undrafted/merged): https://github.com/endojs/endo-but-for-bots/pull/970

**Follow-ups (out of scope, deferred surfaces):** `\p{}`/`\P{}` property escapes and the `v`-flag string-set grammar (`\q{}`, `&&`, nested `[[...]]`) remain named skips; the lexer's 185 parse-early-error over-acceptances for those and the 51 pre-existing exact-metering off-by-ones are unchanged by this increment and belong to their own future children.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-ca-regexp-u-core.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 218 tokens (24037944 cached reads)
- Output: 81017 tokens
- Cost: $16.999168999999995
- Wall-clock: 1443s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
