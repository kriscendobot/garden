CI is GREEN (rc 0). The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1156-gauntlet-fix-1 (gauntlet FIX round 1) — PR #1156, a design doc `designs/pass-style-symbol-condition.md`.

**Panel verdict applied (request-changes from critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice):**

- **critic** — Reconciled the internal inconsistency: `src/symbol.js` now explicitly gains one `SymbolHelper` export (sourced through the `#pass-style-symbol-impl` alias), so the "unchanged" framing is corrected to "five behavioral functions unchanged." Dropped the "costs nothing" safety claim and documented the concrete classified-but-unencodable asymmetry, with a `nameForPassableSymbol`-probe option, folded into open question 1.
- **skeptic** — Downgraded the "confirmed empirically" Node condition-resolution claims to "expected, not yet observed," folded into open question 6; added cross-variant interop tests to the catalog (both directions as literal-wire-payload in-process tests); scoped the vat/compartment motivation to what this landing delivers and added the `bundle-source` `conditions` path as open question 7.
- **decomplector** — Added an "Alternative considered: value parameter" section evaluating the `makePassStyleOf`/`makeMarshal` option vs. the ambient condition, with honest reasoning for the condition-as-migration-lever choice; recorded process-vs-vat granularity as open question 9 and the value-parameter shape as open question 8.
- **ergonomist** — Clarified the Summary's transitive-swap claim and its `typeof`-guard limit (unaudited latent breaks); resolved the variant `.d.ts` mismatch concretely (variant consumers set `customConditions` in their own tsconfig, documented in the README opt-in) rather than "record this."
- **novice** — Added same-paragraph forward pointers for the first code example's apparent contradiction; motivated the `Symbol.toStringTag` choice at introduction; replaced the prose set-brace disjunction with plain prose.
- **copyeditor/pedant** — Stripped all em-dashes and non-ASCII code points (`→ ⇒ … ≥ ✅`), verified clean by scan; glossed "Hilbert Hotel" on first use.

**Changed:** one commit `0a4de60af` on branch `design-pass-style-symbol-condition`, pushed to `origin` (endojs/endo-but-for-bots) via safe-push-pr-head.sh.

**CI:** GREEN — 5/5 checks passed, 0 failed (rc 0).

**Follow-ups:** none for this stage. Per the gauntlet protocol I did not re-run the panel; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1156-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 32 tokens (1070475 cached reads)
- Output: 24683 tokens
- Cost: $1.9760425
- Wall-clock: 766s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
