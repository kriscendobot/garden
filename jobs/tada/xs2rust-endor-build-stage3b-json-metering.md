Both charter bullets are delivered bit-exact and pushed; the supervisor status dead-lettered (will be promoted/carried forward). The job is genuinely complete.

## Completion report — stage-3b child 6/9 (json-metering), PR #600

**COMPLETE.** Both charter items delivered bit-exact (result AND computron) vs pin `48ee02d8cfe0`, `divergent=0`. `built-ins/JSON: covered 2 → 15`. Six green commits pushed to `xs2rust-endor` (HEAD `00bfba1a5`); `#![forbid(unsafe_code)]` intact; full workspace test suite (incl. the covered-grammar bar) green.

**1) `JSON.parse` (`fx_JSON_parse`)** — tokenizer + recursive value construction + per-node allocation metering. The parse path calls **no** `mxMeter` (like `xsMapSet`), so every unit is the native-frame residual (`49152`, over the call trampoline the interpreter already meters) + exact `fxNewSlot`/`fxNewChunk` allocations, **decomposed, not fitted**: string tokenizer chunk; array = `fxNewArrayInstance` 2 slots + `33024`/element + linked slot + `fxCacheArray` item chunk (`len*32`+header); object = instance slot + `65792`/member + key intern (novel = 1 slot) + key chunk + recursive value. Numbers classify exactly as XS. Verified across primitives/arrays/objects/nesting/escapes/exponents.

**2) Structured `JSON.stringify` metering** (earlier sessions) — the child-4 "value-dependent gaps" fully decomposed (the wobble was the result `fxNewChunk`, metered once).

**Also:** curated `stage3b-json-metering.js` corpus + two differential fuzz arms (`gen_json_structured_program`, `gen_json_parse_program`), all bit-exact; README evidence updated; a guard so re-stringifying a parsed object's interned keys self-names (not a wrong `{}`).

**Honest named skips** (in the dual-run): `JSON.parse:reviver` / `:non-string` / `:astral` / `:syntax`; `JSON.stringify` replacer-or-space/toJSON/wrapper/callable-value/callable-top; `JSON.stringify:interned-key`.

**Follow-ups (named, not bar blockers):** (a) making runtime-interned keys renderable (a child-5 `intern_key`/`symbol_names` change I left untouched to avoid cross-child risk) would convert the `interned-key` skips to covered; (b) modeling `JSON.parse` `SyntaxError` partial metering (~24 malformed-input files); (c) **Miri GC suite couldn't run** here (host `/tmp` is `noexec` → Miri sysroot build-script `Permission denied`) — structurally safe: zero unsafe added, `gc.rs` untouched, its tests pass under normal `cargo test`; (d) pre-existing large/deep **object-literal construction** raw drift (independent of JSON) re-flagged for the object-literal/`SET_PROPERTY` path.
