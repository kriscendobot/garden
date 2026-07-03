# Topic: engine-implementation

> Abstract: Engine-level (interpreter/C/native) implementation techniques for
> realizing SES/HardenedJS and ocap primitives *inside* a small JavaScript
> machine, rather than in a JS shim on top of it — how `harden`, `lockdown`,
> intrinsics isolation, and Compartment/realm semantics can be built into the
> bytecode interpreter, and the performance-vs-safety tradeoffs of doing so on
> a JIT-free, deterministic, memory-safety-conscious machine (XS, quickjs-ng).
> This is the cross-cutting home for sibling-engine comparisons read for the
> XS→Rust (Endor) evolution program. Distinct from `hardened-javascript` (the
> SES *semantics*) and `compartments` (the isolation *model*): this topic is
> about how an engine *implements* them natively.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [danfinlay-quickjs--native-ses--architecture-overview](../sections/danfinlay-quickjs--native-ses--architecture-overview.md) | danfinlay/quickjs @ native-ses | Native SES in quickjs-ng = three C primitives (`harden`, `lockdown`, `Compartment`) that realize SES's freeze half but omit its taming/permits half; JIT-free, so speed comes from moving work into C, not code generation. |
| [danfinlay-quickjs--native-ses--harden-c-deep-freeze](../sections/danfinlay-quickjs--native-ses--harden-c-deep-freeze.md) | danfinlay/quickjs @ native-ses | `harden()` as `JS_DeepFreeze`: a recursive C deep-freeze over props/getters/setters/prototype with a visited set (a linear-scan O(n²) array — copy the idea, not the structure); skips proxies/module-ns, re-reads moved pointers, preserves identity. |
| [danfinlay-quickjs--native-ses--lockdown-freeze-intrinsics](../sections/danfinlay-quickjs--native-ses--lockdown-freeze-intrinsics.md) | danfinlay/quickjs @ native-ses | `lockdown()` as two-phase `JS_FreezeIntrinsics`: force-resolve lazy AUTOINIT intrinsics, then deep-freeze the reachable graph while keeping the global extensible — freezes but does NOT tame (no permits, no determinism scrub, no eval/Error taming). |
| [danfinlay-quickjs--native-ses--compartment-context-model](../sections/danfinlay-quickjs--native-ses--compartment-context-model.md) | danfinlay/quickjs @ native-ses | Compartment = a fresh `JSContext` on the shared `JSRuntime` (realm-level isolation, not heap-level); standard intrinsics only, strict eval, endowments copied as LIVE parent-heap references with no membrane. |
| [danfinlay-quickjs--native-ses--xs-transferable-strategies](../sections/danfinlay-quickjs--native-ses--xs-transferable-strategies.md) | danfinlay/quickjs @ native-ses | Seven transferable strategies with perf-vs-JIT/memory-safety verdicts: adopt engine-native deep-freeze + lazy-resolve + snapshot-primed realms; reject shared-heap object passing, freeze-only lockdown, and the string-splice import loader. Cross-linked to the Endor cluster. |

## See also

- [`hardened-javascript`](hardened-javascript.md): the SES semantics these engines implement natively.
- [`compartments`](compartments.md): the isolation model; native Compartment realizes it at realm level.
- [`pass-style`](pass-style.md): the membrane/marshaling discipline a separate-heap engine (XS) enforces at the compartment boundary.
