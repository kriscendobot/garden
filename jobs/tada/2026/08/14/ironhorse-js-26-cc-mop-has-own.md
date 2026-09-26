All work complete and verified. Here is my completion report.

---

## Completion report: Object MOP residual 1/7 — `hasOwnProperty` receiver/key/exotic coverage

**Repository / PR:** `endojs/endo-but-for-bots`, branch `feat/ironhorse-262-language-completion`, draft PR https://github.com/endojs/endo-but-for-bots/pull/970 (no merge, no new PR). Pushed SHA: **`3afd793924320291bb4d87e8e87afb399872dc4e`** (rebased cleanly onto a concurrent peer commit before push).

### What I did
Implemented the full ECMA-262 20.1.3.2 `Object.prototype.hasOwnProperty` path in `rust/engine/ironhorse-vm/src/interp.rs`, replacing the two honest-skip exits (`hasOwnProperty:non-string-key`, `hasOwnProperty:index-key`) with real semantics:

- **`? ToPropertyKey(V)`** via the shared metered `to_property_id` (`fxAt`): symbol keys, number/boolean/null key coercion (ToPrimitive → ToString), and canonical index strings.
- **`? ToObject(this)`** boxing: a String primitive exposes its `[0, length)` indices + `length`; Number/Boolean/Symbol/BigInt box to a property-free wrapper; `null`/`undefined` throw a TypeError (XS `fxToInstance`-first order).
- **Receiver `[[GetOwnProperty]]` by resolved key *name*** (not a cached program-symbol id — a string-literal-only key interns a fresh runtime id that `length_id`/`name_id` never equal): ordinary slot chain, Array index/`length` side table, Function `length`/`name`/`prototype`, String-wrapper index/`length` + expandos, and the Proxy `getOwnProperty` trap/invariants via `mop_get_own_property`.
- **Typed-array residual recorded, not suppressed:** an index key on a TypedArray/ArrayBuffer/DataView honest-skips to `hasOwnProperty:typed-array-index` (with a comment deferring to the already-posted typed-array cluster); non-index keys on those receivers remain soundly answered.
- Preserved the pre-existing string-key native-body metering exactly (one `METHOD_HAS_OWN_PROPERTY_METERING` tick + `fxAt` intern).

Added oracle-backed regressions: `rust/engine/ironhorse-262/tests/has_own_property_mop.rs` (11 tests: ordinary/index/numeric/symbol keys, array index+length, function own props, string primitive/wrapper, boxed primitives, nullish-throws, proxy).

### Verification (PATH=$HOME/.cargo/bin, TMPDIR on exec mount; test262 `@be13516f`, Moddable XS oracle `@23b4d6b0a6`)
- **`cargo test --workspace --release`** — zero failures.
- **Proprietary `--gate-meter-exact` corpus** (`corpus_conversion_equivalence`, exercises `ironhorse-xst`): total=1711 covered=1711 **failed=0**; computron expectations unchanged.
- **New regression suite** `has_own_property_mop`: 11/11 pass.
- **Affected slice** `built-ins/Object/prototype/hasOwnProperty` (`--gate-meter-exact`): before 65/**53** covered / 0 failed / 12 skipped → after 65/**59** covered / 0 failed / 6 skipped; all 7 `hasOwnProperty:non-string-key` skips removed (6 now covered, 1 honestly reclassified to a deeper `to_primitive:non-callable` coercion gap). `full-run.sh --subtree built-ins/Object/prototype/hasOwnProperty --test262-dir <pinned>`: covered=58, ironhorse-failures=0, infrastructure=0.
- **Broad ripple check** `built-ins/Object` (harness `propertyHelper.js` calls hasOwnProperty), true baseline vs after: covered **1691 → 1737 (+46)**, skipped 1434 → 1388; **failures identical** (2 pre-existing `setPrototypeOf` non-terminating-dispatch hangs, semantically unrelated — present bit-for-bit before and after). No baseline-covered case regressed, no new failure/infrastructure result.

### Follow-ups
- The 49 `hasOwnProperty:index-key` + typed-array index own-checks are deliberately deferred to the already-posted typed-array cluster (recorded as `hasOwnProperty:typed-array-index`).
- Pre-existing, out-of-scope: `setPrototypeOf` cycle-detection hangs, and a `to_primitive:non-callable` coercion gap surfaced (not caused) by newly-reachable cases.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-26-cc-mop-has-own.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 175 tokens (11365572 cached reads)
- Output: 73117 tokens
- Cost: $9.343041999999997
- Wall-clock: 1383s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
