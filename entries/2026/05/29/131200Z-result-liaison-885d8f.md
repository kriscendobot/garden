---
ts: 2026-05-29T13:12:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/papers--drossopoulou-reasoning-about-risk-and-trust-2015.md
---

# liaison cycle 85 result — Reasoning about Risk and Trust ingest

Paper-lane ingest (cycle 85, **eighth Miller-coauthored paper**, per the three-lane rotation after cycle 84's `rankOrder.js` comment-fragment lane).

Ingested **Drossopoulou, Noble, Miller, Murray, *Reasoning about Risk and Trust in an Open World*** (~2015 workshop draft + technical report ECSTR-15-08 VUW). PDF SHA-256 `3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809`, 34 pages, fetched from `papers.agoric.com/assets/pdf/papers/reasoning-about-risk-and-trust-in-an-open-world.pdf`.

Three argument-cluster sections:

1. `trust-as-hypothetical-and-risk-via-may-access-may-affect` (§1 + §2.2) — the three new specification-language constructs `o obeys Spec`, `MayAccess(o, p)`, `MayAffect(o, p)`. Makes trust *explicit and dischargeable* and bounds risk via reachability + mutation closures.
2. `escrow-failure-and-four-case-valid-escrow-spec` (§2.1, §2.3-§2.6) — the §2.1 sprouted-malicious-purse attack on the naive `deal_version1`; the §2.3 `ValidPurse` five-policy spec; the §2.4 mutual-trust-via-reciprocal-deposit construction; the §2.5 `deal_version2` with explicit mutual-trust setup; the §2.6 **four-case `ValidEscrow` spec**. The central methodological surprise: *the return value of the escrow does not communicate trustworthiness of counterparties* — `true` may mean all-honest *or* matching pairs of jointly-conspiring untrustworthy participants.
3. `hoare-four-tuples-and-code-agnostic-rules` (§3) — `Focal` (Featherweight Object Capability Language) + `Chainmail` (named-policy spec language) + Hoare four-tuples (`A { stmts } A' ⋈ B` where `B` is the *during-execution* invariant) + the four code-agnostic rules `METH-CALL-2` (only-connectivity-begets-connectivity), `FRAME-METHCALL` (POLA framing), `CODE-INVAR-1` (reasoning under `obeys` hypothesis), `CODE-INVAR-2` (`obeys` preserved across statement execution). Soundness Theorem 3 (proven in [18]).

## Slug-correction note

The dispatch was originally planned to ingest *Stiegler 2006 Reasoning About Risk and Trust in an Open World*. The Agoric mirror's URL slug `reasoning-about-risk-and-trust-in-an-open-world` plus the cycle-84 result's notes-for-next-cycle pointer led to that initial naming. Reading the PDF revealed the actual paper is **Drossopoulou-Noble-Miller-Murray ~2015**. The slug was updated accordingly. Note: the paper's title page has a typo (`Open Word` instead of `Open World`); preserved in the source page's provenance section for archival faithfulness.

The pick still respects cycle-83 *cohesion-over-density* discipline: the paper is bounded (34 pages, three argument clusters), carries a body of formal-specification material the library lacks, and threads into existing concepts (`object-capability`, `principle-of-least-authority`, `four-ways-to-acquire-references`, `mint-purse-money`, `smart-contract`, `brand-and-trademark`) without requiring new concept pages this cycle.

## Three drafting-lessons confirmed

1. **Orchestrator-direct-draft remains the reliable path for Miller-coauthored capability papers.** Eighth consecutive successful use of the discipline. The pattern carries Mark Miller's mentor context per maintainer's 2026-05-26 standing authorization.
2. **Per-section commit discipline upheld** — each section committed as written, not batched. Cycle-67 mitigation continues to apply.
3. **Cohesion-over-density discipline upheld** — three sections rather than five-or-six-thinner-cuts; each section is a self-contained argument cluster the reader can land on.

## Library state after cycle 85

- Sources: 131 (was 130) — adds the new Drossopoulou paper.
- Sections: 564 (was 561) — adds 3 sections.
- Topics: 27 (unchanged) — threading into existing topics only.
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~1380 (was ~1260) — added ~120 aliases tied to this paper's vocabulary.

## Notes for next cycle (86)

Three-lane rotation pointer advances to chat-lane.

Chat-lane candidates: `chat-test-coverage`, `chat-playwright-smoke`, `chat-rename-dismiss-to-clear`. Verify via bare-clone listing before picking (cycle-73 / cycle-74 discipline).

Future-paper-lane candidates after this cycle:
- **Robust Composition** (Miller PhD 2006, ~250 pages, *multi-cycle chapter-by-chapter* — needs a dispatch-planning step, not a single-cycle ingest).
- **The Digital Path** (Stiegler + Miller 2002) — currently mis-identified in the cycle-84 notes; verify the actual PDF before picking.
- **Stiegler's *Reasoning About Risk and Trust*** (the original Stiegler 2006 paper — would *complement* this paper, not replace it).

Future-comments-lane candidates:
- `patterns/src/keys/checkKey.js`
- `pass-style/src/error.js`
- `marshal/src/marshal-justin.js`

## Decomposition campaign status

The cycle-76-79 decomposition campaign closed with 12 concept pages. This cycle's three sections thread into existing concept pages (the Drossopoulou paper does not introduce new cross-source concepts that would warrant their own pages yet — the `obeys`-`MayAccess`-`MayAffect` triad is paper-specific). Future decomposition rounds (cycle 90+?) may extract a `hypothetical-trust-predicate` or `code-agnostic-rule` concept page if a second formal paper grounds the same vocabulary.
