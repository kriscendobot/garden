The research is done and all six items are confirmed in the commit range; I'm writing up the report now.

# Moddable 10.0.0 XS inventory, part b: completion report

This was research only. Nothing was built and no IronHorse ports were made, and I made no commits to the garden or to any project repo. The prior attempt left nothing committed, so this is a fresh run.

**Scope:** commits in Moddable-OpenSource/moddable from 2026-09-04 up to `5f215f776f93039755343dbe75a09aa2615045f4`. The compare API shows `db0490c5bc` → `5f215f77` as "ahead 4, behind 0", so all six items below are ancestors of the endpoint.

**Endpoint caveat:** the job calls `5f215f77` the "10.0.0 prerelease notes" commit, but that SHA is actually *"pebble: update platform glue for the current PebbleOS APIs"* (author date 2026-07-21, `xs/platforms/pebble/*` only). It may have been mislabeled. The `version 10.0.0` commit is `80a253cadc`.

**Issue status:** every linked issue (#1698, #1699, #1705, #1706, #1708, #1716) was still **open** on GitHub when I checked, even though the fixes have landed.

Commit URLs follow the form `https://github.com/Moddable-OpenSource/moddable/commit/<sha>`.

## Engine semantics

| # | Item | Commit (full SHA) | XS file / symbol | test262 / spec | Behavioral expectation |
|---|---|---|---|---|---|
| 1 | Math.round subnormals (#1698) | `7b3bd37515afff14b72fbe90a1e9c91591627efb` | `xs/sources/xsMath.c` `fx_Math_round`: the guard changed from `c_isnormal(arg)` to `c_isfinite(arg)` | Spec `sec-math.round`: if 0 < x < 0.5 → +0; if −0.5 ≤ x < −0 → −0. Existing tests `built-ins/Math/round/S15.8.2.15_A6.js` and `_A7.js` cover the range but not subnormals; I found no test262 test using `Number.MIN_VALUE` here. | `Math.round(Number.MIN_VALUE) === 0` (+0). `Math.round(-Number.MIN_VALUE)` is −0 (so `1/r === -Infinity`). Before the fix, subnormals came back unchanged. |
| 2 | Math.irandom integer math (XS extension, not ECMA-262) | `d17c0de3099bce4cab0601c6b0f4bfe9e657047d`; see also `5039f90720` and `07343f6938` below | `xsMath.c` `fx_Math_irandom`: now uses `txInteger`/`uint32_t`/`uint64_t` arithmetic instead of `double` plus floor/ceil. Retries while `c_rand()==C_RAND_MAX`; `delta = result*range/C_RAND_MAX` in 64 bits. | No test262 coverage because this is a Moddable extension. New XS tests: `tests/xs/built-ins/Math/irandom/{distribution,prop-desc,range,results}.js` | No arguments → [0, 2147483647). One argument `max` → [0, max). `(min,max)` with max ≥ min → **[min, max)**. With max < min it counts down → **(max, min]**. If min == max the result is min. A full int32 span is safe because the range is computed in uint32. Property is non-enumerable, writable, configurable; `length` 0, `name` "irandom", not a constructor. |
| 3 | charAt/charCodeAt 32-bit position truncation (#1699) | `6099bb0d146b7c7913c4f5780227b6e431551520` | `xsString.c`: new `static fxPositionToIndex` (ToNumber; NaN or 0 → 0; clamps to the int32 range; otherwise `c_trunc`). Used by `fx_String_prototype_charAt` and `fx_String_prototype_charCodeAt`. | Spec ToIntegerOrInfinity. Related tests: `built-ins/String/prototype/{charAt,charCodeAt}/pos-rounding.js`, `pos-coerce-*.js`. I found no upstream test for ±Infinity or 2**32+1. | `String.prototype.charCodeAt.call(2,-Infinity)` → NaN. `"ab".charCodeAt(2**32+1)` → NaN. `charAt` returns `""` in both cases. Before the fix these wrapped to 0 and 1. **Uncertainty:** the helper ignores its `argi` parameter and always reads `mxArgv(0)`. That is harmless today because both callers pass 0, but a port should not copy it. |
| 4a | String.prototype.repeat edge (#1705) | `4b1afbc46e3fe3111f1c4849568c40e52dab60aa` | `xsString.c` `fx_String_prototype_repeat` | `built-ins/String/prototype/repeat/empty-string-returns-empty.js` (only tests up to 2**31−1), `count-is-infinity-throws.js`, `count-less-than-zero-throws.js`, `count-coerced-to-zero-returns-empty-string.js` | NaN or ±0 → count 0. Negative → RangeError. ±Infinity → RangeError ("count infinite"). A finite count above 2**31−1 is **clamped** to 0x7FFFFFFF rather than throwing, so `"".repeat(Number.MAX_SAFE_INTEGER) === ""`. **Uncertainty:** for a non-empty receiver with a huge count, the failure now comes from `fxMultiplyChunkSizes`/`mxMeterSome` overflow, not "count too big". I did not confirm which error type that raises. |
| 4b | String.prototype.replace / replaceAll / RegExp `@@replace` / RegExpExec with a Proxy replacer (#1716) | `dca752b707d475f06742ee45ca266b1a956a12e1` | `xsString.c` `fx_String_prototype_replace` and `fx_String_prototype_replaceAll`; `xsRegExp.c` `fx_RegExp_prototype_replace` and `fxExecuteRegExp` (`exec` lookup). Each now uses `fxIsCallable` instead of `mxIsFunction`. | Spec IsCallable(replaceValue) and RegExpExec. I found no upstream test262 test with a Proxy-wrapped function as replacer. | `"a".replace("a", new Proxy(function(){return 42}, {}))` → `"42"`. replaceAll and `/a/[Symbol.replace]` call the Proxy too, and a callable Proxy `exec` is used by RegExpExec. |
| 4c | String "search" methods with an omitted argument (#1708) | `4340468ff9c8244d43d79d27a78f982b39f8cfc3` | `xsString.c`: `fx_String_prototype_{indexOf,lastIndexOf,includes,startsWith,endsWith}`. With no argument they now use `&mxUndefinedString`. | Spec step `ToString(searchString)`, so a missing argument means `"undefined"`. Neighbouring tests: `built-ins/String/prototype/indexOf/searchstring-tostring*.js`. I found no upstream test for the zero-argument call. | On the receiver `"undefined"`, all five methods with no argument give 0, 0, true, true, true (before: −1/false). An omitted argument now behaves the same as an explicit `undefined`. **Uncertainty:** `String.prototype.search` (RegExp) has no commit in this range. I read "search edge cases" as #1708. |
| 5 | String.prototype.replace capture-group memory-safety fix | `db0490c5bcd55842b95f4fa3f10b708fc34ad4c5` ("XS: regexp replace get capturing group value once"; no linked issue) | `xsString.c` `fxPushSubstitutionString`. Each `$<name>` value is now fetched and stringified once, in the sizing pass, and kept on the stack. The copy pass walks those stack slots (`group--`) instead of calling `Get(groups,name)` and `ToString` a second time. | Spec GetSubstitution `$<`: one `? Get(namedCaptures, groupName)` and one `? ToString(capture)` per occurrence. Related tests: `built-ins/RegExp/prototype/Symbol.replace/result-coerce-groups-prop.js`, `result-get-groups-prop-err.js`, `named-groups*.js`. | **Safety:** before the fix, a getter or `toString` on `groups.<name>` that returned a longer string the second time overflowed the buffer sized in the first pass (heap overflow). **Observable:** each `$<name>` occurrence triggers exactly one getter call and one `toString`. Unknown or over-long names give undefined → empty, consistently in both passes. |
| 6 | Symbol.for with no argument (#1706) | `912290f420e4497eec81690ba1cfd33002e124a8` | `xs/sources/xsSymbol.c` `fx_Symbol_for`: no argument → `&mxUndefinedString`; the old `mxSyntaxError("no key")` is removed. | Spec `sec-symbol.for` step 1 is ToString(key). Related tests: `built-ins/Symbol/for/{create-value,retrieve-value,description}.js`. I found no test for the zero-argument call. | `String(Symbol.for())` is `"Symbol(undefined)"`. `Symbol.for() === Symbol.for("undefined")` and `Symbol.keyFor(Symbol.for()) === "undefined"`. |

## Adjacent engine commits in the same files (outside the six items, for successors)

- `5039f90720`: `Math.imul` multiplies in uint32, which removes signed-overflow undefined behaviour.
- `07343f6938` ("overflows"): `Math.imod` remainder sign fix without overflow; `String.prototype.substr` length overflow guard. It also touches `xsBigInt.c` and `xsRun.c`, which I did not inspect.

## Not engine semantics (ECMA-419, device, Piu, board, TypeScript, xsdb)

None of the six items fall in this category; all are pure ECMA-262 or XS-extension engine behaviour. The rest of the window is non-engine work:

- ECMA-419 System object migration and config/keyValue (`5c1b3cdca8`, `e20be1c548`)
- typings and TypeScript 7 linting
- Pebble, Zephyr, Pico, nrf52 and ESP32 manifests and boards
- Piu MC outline
- xsdb unit tests (`71196ed5c8`)
- `xsLogDebug` fixes
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/moddable-10-0-0-xs-inventory-part-b-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 32 tokens (879150 cached reads)
- Output: 10852 tokens
- Cost: $1.3941622
- Wall-clock: 231s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
