All three items complete, verified bit-exact, and pushed. Working tree clean, no stray files, inbox empty.

## Completion report

**Job:** PR #600 stage-9c child 2/9 — three small engine gaps in `endojs/endo-but-for-bots` branch `xs2rust-endor`. All three landed as independent pushes, each dual-run **bit-exact** (result AND computrons) against the C-XS oracle.

**Measured starting sha:** `9c11410e88` (child 1 had landed since the job body was written; body's `8865953620` was already superseded). Synced to the real remote tip before starting. Env: seeded `c/moddable` @ pin `23b4d6b0a` and `target/` from a same-pin sibling, cleaned the three acceptance crates, `TMPDIR=$HOME/tmp`.

**Item 1 — `Object.is` (SameValue)** — commit `4e226f945a`
- Bound `Object.is` as an own static of the `Object` constructor (`Native Method::ObjectIs`), implementing XS's `fxIsSameValue`: strict equality except NaN≡NaN and `+0`≢`-0`. Added `same_value` helper. The native residual is a single measured half-computron (`1<<15` raw), argument-shape independent.
- 18 curated cases (`stage9c-object-is/`) + `object_is.rs` behavioral gate. Corpus 1779→1797.

**Item 2 — `String.replace` `$`-substitution** — commit `850dbbfe25`
- Retired the `dollar-substitution` self-name; implemented XS's `fxPushSubstitutionString` grammar: `$$`, `$&`, `` $` ``, `$'`, `$n`/`$nn` (greedy two-digit), with literal fall-through for unrecognized/out-of-range/trailing tokens. Offsets are the UTF-8 code-unit offsets exec shares. Fixed a measured 24-raw first-pass residual gated on the recognized-token flag.
- 18 curated cases (`stage9c-string-replace-dollar/`) + `string_replace_dollar.rs`. Corpus 1797→1815.
- Honest remainder (out of scope): `$<name>` with a real `groups` object — endor's `RegExp.exec` self-names on a named-group pattern, so groups never reach substitution.

**Item 3 — `Proxy` global binding** — commit `58261fcbd4`
- Added `Native::Proxy`, bound through the ordinary intrinsic path so `typeof Proxy`, reference reads, identity, and `globalThis.Proxy` all agree ("function"). Constructor behavior stays child 4's scope — `new Proxy(...)` self-names `Unsupported("native-call:Proxy")` via the construct-dispatch fall-through.
- 10 curated cases (`stage9c-proxy-global/`) + `proxy_global_binding.rs`. Corpus 1815→1825.

**Verification bar (all met):** full-workspace `cargo test` EXIT=0 at each item (42 `test result` lines, every one 0 failed); corpus-conversion equivalence `covered==total` under `--gate-meter-exact`; boot gate green; **zero new Rust warnings**; `#![forbid(unsafe_code)]` intact at all **7** engine crates (`endor-oracle` remains the FFI seam); `c/moddable` clean at pin `23b4d6b0a`, never staged; no new VM side tables (nothing to ledger); no committed bundles. Note: `Proxy.name`/`Proxy.prototype` diverge, but that's the pre-existing uniform intrinsic `.name`/prototype gap (`Object.name` shares it) — out of scope.

**Remainder:** none for this child's three items — all landed and verified. This was a 3-item child of a 9-child orchestration; the other 8 children are separate jobs.
