PR head is at my fix commit `4db57b4ce`, all CI green, mergeable. The gauntlet FIX round 4 is complete.

## Completion report

Applied the panel-4 must-fix items to `designs/pass-style-symbol-condition.md` on PR #1156 (endojs/endo-but-for-bots, branch `design-pass-style-symbol-condition`), pushed as one review-feedback follow-up commit (`4db57b4ce`), and watched CI to terminal — **all 5 checks green** (build, lint, zizmor, test, browser-tests); PR mergeable.

**What changed (per must-fix seat):**
- **critic** — (1) Corrected the false "clean validation error" claim in the `HelperTable['symbol']` decision: `default`'s `nameForPassableSymbol` calls `Symbol.keyFor` unconditionally (symbol.js:66-73), which throws an engine `TypeError` on a non-symbol, so a naive probe crashes inside `assertValid`. Stated the implementation constraint (validator or `nameForPassableSymbol` must guard input shape before probing) parallel to the three-doors callout, and cross-referenced it from the default-module bullet. (2) Weighed the intern-table alternative's instance/vat-scoped growth as *the* granularity the threat model demands, versus the process-wide condition that (open question 9) reaches no vat granularity in this landing.
- **skeptic** — (1) Replaced the non-falsifiable `Symbol.for(sameName)` registry-growth sketch with a deterministic `Symbol.for`-spy (assert zero calls) test plus `--expose-gc` heap-growth corroboration; flagged that the `Symbol.keyFor(decoded)` companion check is not a growth proof. (2) Added the missing variant-world three-doors (validate-door) test: hand-build a `@@iterator` tagged object and assert `passStyleOf`/`SymbolHelper` rejects it.
- **copyeditor** — Defined "world" early (Background); fixed the buried `Its`/`that` antecedents and the `weights…above` / `value default code` / `at first statement` phrasings.
- **novice** — Defined OCapN and syrup in Background; glossed `HelperTable`/`SymbolHelper`/object dispatch in the Summary; collapsed the threefold "classified-but-unencodable" restatement into one statement plus a pointer.
- **pedant** — Normalized JS→JavaScript throughout; removed the `e.g.`/`i.e.` Latin shorthand.

Net: +144/−47 lines, docs-only. No follow-ups; the driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 86 tokens (3938193 cached reads)
- Output: 26325 tokens
- Cost: $3.7409744999999996
- Wall-clock: 521s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
