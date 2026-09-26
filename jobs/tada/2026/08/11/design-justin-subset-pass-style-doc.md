The work is complete. Here is my report.

---

## Completion report: document the Justin subset and lock the pass-style dialect

**Frozen base cut / used:** `master-6ee3fda`, sha `6ee3fda77bf28a4fe4a81c6269fe33655f162b9e`. The job noted no `master-*` branch existed as of 2026-08-11, but one already exists at exactly the current upstream-tracking `master` tip and matches the `master-<sha7>` convention, so cutting a fresh snapshot would have been redundant — I branched from it. This is upstream-`endojs/endo` material (`docs/` is upstream's tree), so I targeted the frozen base, not `llm`, and left `master` untouched (ferry-only).

**Document:** `docs/justin.md` (new), registered in `typedoc.json` `projectDocuments` (the docs index). No runtime code changed.

**PR:** https://github.com/endojs/endo-but-for-bots/pull/972 — **DRAFT**, base `master-6ee3fda`, head `design/justin-subset-pass-style`. Left draft on purpose so the maintainer locks the dialect in review.

**Method:** I read `marshal-justin.js`, its test suite, and the `jsonJustinPairs` fixtures before writing, then fanned out two research agents (jessica grammar; full pass-style category catalogue) and verified the interesting edges directly against the code. The spec describes what the shipped renderer actually emits, cross-checked against `packages/pass-style/src` and its `doc/`, not an idealized grammar. It covers the containment ladder, the grammar (citing jessica grammar commit `e8ab6f7`, 2021-10-18), the per-category pass-style correspondence, what Justin cannot express, and the evaluation/capability story (Justin is write-only in production via `qp`; evaluated only by the round-trip test's Compartment). I matched the fork's docs style (zero em-dashes, no Latin shorthand).

**Divergences found between the jessica grammar and `marshal-justin.js` — the decisions the PR needs:**

1. **D1 (headline): `__proto__` record keys are outside the Justin grammar.** The renderer emits a computed key `{["__proto__"]:8}` for a `copyRecord` with a genuine `__proto__` own key, but jessica admits **no computed property names** and forbids `__proto__` as both identifier and quoted property name (prototype-pollution guard). The emitted form is valid Jessie/JavaScript but **not** valid Justin. Decision: admit computed keys for this case, or forbid rendering `__proto__`-keyed records?
2. **D2: symbols render as `passableSymbolForName("@@…")` calls, never `Symbol.iterator`.** The `Symbol.${suffix}` branch is **unreachable dead code**, yet the deprecated dedicated `@@asyncIterator` qclass *does* emit `Symbol.asyncIterator` — the same symbol renders two ways. Decision: is the call form canonical (clean up dead branch + deprecated path separately), or use `Symbol.` member access?
3. **D3: bigint literals (`4n`) are ahead of the pinned grammar** (jessica `NUMBER` has no `n` suffix; header only promises BigInt "once available"). Presumably confirm inclusion.
4. **D4: error `cause`, aggregate `errors`, and `stack` are unrepresented** — the renderer throws on `cause`/`errors`/`AggregateError` and drops `stack`; the Justin error form is lossy. Decision: permanent, or grow forms (separate job)?
5. **D5: `byteArray` has no Justin form** — marshal's capdata/smallcaps encoders throw "not yet implemented", so the category never reaches Justin. Out of scope until marshalling lands.

**Pass-style categories with no determinable Justin form:** only the two implementation gaps above — `byteArray` (D5) and the `cause`/`errors`/`stack` error sub-cases (D4). Every other category (all atoms including `-0` which collapses to `0`, symbols, `copyArray`/`copyRecord`/`tagged`, `remotable`/`promise` both denoted as indistinguishable slots, base `error`) has a confirmed Justin form documented and fixture-verified.

**Follow-ups (separate jobs, not fixed here per scope):** the unreachable `Symbol.${suffix}` branch and duplicated deprecated `@@asyncIterator` symbol path in `marshal-justin.js` (a latent inconsistency, contingent on the D2 decision); and any future work to render error `cause`/`errors`/`stack` or `byteArray`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-justin-subset-pass-style-doc.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 81 tokens (4119751 cached reads)
- Output: 56456 tokens
- Cost: $6.342725000000002
- Wall-clock: 829s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
