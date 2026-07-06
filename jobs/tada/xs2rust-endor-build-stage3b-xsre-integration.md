HEAD == origin/xs2rust-endor; all 7 commits pushed. The completion note was dead-lettered (supervisor job done) and will be promoted, preserving the record. The charter is fully delivered.

---

## Completion report

**Job: stage-3b child 9/9 — RegExp built-in + String integration over XSRE (PR #600, `endojs/endo-but-for-bots@xs2rust-endor`)**

Integrated child 8's XSRE matcher as the full JavaScript RegExp surface, bit-exact (result AND computron) against the pin `48ee02d8cfe0`. **7 commits, all pushed and green.**

**What I built**
- **RegExp core**: the `regexp` opcode + `/.../ ` literal (compiles to `new RegExp(pat,flags)`), the `RegExp` constructor, `exec`/`test`, `lastIndex` (side-table backed, get/set), `source`/`flags`/per-flag accessor getters, `toString`, and the `[whole,...captures]` match-result array with `index`/`input`/`groups`. New `Native::RegExp` + `regexps` side table + `RegExpData`.
- **All four String methods** via the `Symbol.{search,match,replace,split}` protocol to the RegExp workers: `search`, non-global `match`, non-global literal-replacement `replace`, and `split` (the species-constructor sticky-splitter walk).
- **Metering calibrated raw-exact end-to-end**: construction (the `fxNewRegExpInstance` slots, the compile meter, and the `fxCompileRegExp` `code`+`data` `fxNewChunk` buffers — modeling the `data` buffer closed a sub-computron gap the fuzz sweep caught), `exec`/`test` frames, the composite `flags` cascade + `toString`'s three concat chunks, and each String method's protocol-dispatch + worker residual.
- **Corpus + fuzz**: `stage3b-regexp.js` (79 programs, bar test) and a whole-program differential fuzz arm `differential_regexp_surface` (1200-seed sweep) — which drove out both the construction-metering gap and the split empty-match corner.

**Results** (all `divergent=0`): `built-ins/RegExp/prototype total=407 covered=50` (exec 33, test 15); `language/literals/regexp covered=21` (from 6); `String/prototype/{search=2,match=3,replace=3,split=1}`. Base corpus 86/86 (no regression), endor-fuzz 23/23, GC suite 9/9, `#![forbid(unsafe_code)]` intact (0 unsafe added).

**Honest named skips** (each `Halt::Unsupported`, never a wrong value or fitted meter): named groups, RegExp-valued pattern arg, syntax-error/unsupported-feature throw, non-ASCII stateful subject; global `match`/`replace` collection, the `$`-substitution grammar + function replacement in `replace`; limit-truncation, empty-matching separator, and non-ASCII subject in `split`; string (non-RegExp) argument to the String methods.

**Follow-ups** (future stage; all currently honest-skipped, `divergent=0` preserved): the global collection loops for match/replace/split, the `$`-substitution grammar, named-group result shaping, general RegExp-from-RegExp construction, and the unicode/`u`/`v`-flag paths.
