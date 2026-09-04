Inbox empty. Job complete.

## Completion report

**Job:** design an alternate, Node-condition-gated reified representation for passable symbols, delivered as a design-doc PR against `endojs/endo-but-for-bots`'s `llm` branch.

**Delivered:** `designs/pass-style-symbol-condition.md`, opened as **PR [#1156](https://github.com/endojs/endo-but-for-bots/pull/1156)** (ready for review, base `llm`), in the repo's `Created/Updated/Author/Status` header convention.

**What the design settles, grounded in the actual source (not asserted):**
- **Threat model sharpened** — traced `passableSymbolForName`'s `return Symbol.for(name)` as the shared decode leaf of all three codecs (smallcaps/capdata/`encodePassable`); the global registry is unbounded, process-lifetime, un-GC'd, un-scoped → durable cross-compartment/cross-vat memory-exhaustion vector.
- **Swap unit resolved** — one package-private `imports` alias `#pass-style-symbol-impl` (→ `src/symbol.js` default / new `src/symbol-tagged.js` under `pass-style-symbol`), with concrete `package.json` `imports` wiring. Two specifier edits (`index.js`, `passStyleOf.js`) swap the `passStyleOf` `case 'symbol'` arm **and the entire marshal encode/decode chain transitively, with zero marshal changes**, because the wire format is invariant — only local reification changes.
- **`HelperTable['symbol']`** recommended registered **unconditionally** (harmless under default; keeps `passStyleOf` single-path), riding the existing `[PASS_STYLE]`-tagged-object dispatch.
- **The per-process `-C` caveat** addressed with a concrete two-process CI strategy via `ses-ava`'s `sesAvaConfigs` + a new Ava config carrying `-C pass-style-symbol`.
- **Empirical confirmations** rather than assumptions: proved in-repo that Ava already forwards `-C` to workers (the load-bearing `ses-ava:endo` path); **ran a Node-22 test** confirming repeated `-C` unions and that **imports-map key order (not flag order)** picks the target.
- **`t.deepEqual` advantage** with a worked example; **OCapN selectors** flagged as on-path with `selector.js`'s `typeof === 'symbol'` guards named as the breakage; **typecheck/`.d.ts`/eslint** covered via NodeNext `customConditions` second tsconfig.
- **Open questions** section carries six genuinely-unresolved tensions.

**Follow-ups (out of scope, noted in the doc):** implementation of `symbol-tagged.js` + `SymbolHelper`, the wiring/tests, OCapN `selector.js` de-primitivization, and the one end-to-end Ava-worker observation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-pass-style-symbol-condition-variant.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 64 tokens (2559312 cached reads)
- Output: 28243 tokens
- Cost: $2.5837885
- Wall-clock: 481s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
