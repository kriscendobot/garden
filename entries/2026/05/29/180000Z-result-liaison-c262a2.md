---
ts: 2026-05-29T18:00:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011.md
---

# liaison cycle 91 result — Taly et al 2011 ingest

Papers-lane ingest (cycle 91, **ninth Miller-coauthored paper**, per the three-lane rotation after cycle 90's comments-lane).

Ingested **Taly, Erlingsson, Mitchell, Miller, Nagra, *Automated Analysis of Security-Critical JavaScript APIs*** (IEEE S&P 2011). PDF SHA-256 `4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95`, 16 pages, from `papers.agoric.com/assets/pdf/papers/automated-analysis-of-security-critical-javascript-apis.pdf`.

Three argument-cluster sections:

1. `api-confinement-problem-and-ses-light-language-design` (§1, §2) — the API+Sandbox approach (Facebook FBJS, Yahoo! ADSafe, Google Caja); the §1 store-method motivating example; ES5-strict's three properties (Lexical Scoping; Safe Closure-Based Encapsulation; No Ambient Access to Global Object); SES_light adds transitively-immutable built-in objects + variable-restricted eval to close the remaining ES5S gaps.
2. `static-analysis-procedure-and-soundness-theorem` (§3, §4, §5) — SES_light's formal small-step operational semantics; labeled semantics with α-renaming bisimilarity (Theorem 1); Confinement Property `PtsTo(un, Reach(S_0(t))) ∩ P = ∅` (Definition 4); flow-insensitive context-insensitive Datalog points-to with 14-rule inference system (Figure 6); Soundness Theorem 2: `D(t, P) ⟹ Confine(t, P)`.
3. `applications-adsafe-vulnerability-sealer-unsealer-and-mint` (§6, §7, §8) — ENCAP applied to Yahoo! ADSafe (1700 LOC; 5:27 runtime) finds previously-undiscovered confinement-leak via `lib`+`go` triple-underscore-property write (reported to Yahoo!, fix adopted immediately, exploitable on Firefox/Chrome/Safari); Sealer-Unsealer (Morris 1973) verified; Mint conservation-of-currency verified. Future work: object-sensitive analysis, CFA2, better diagnostics.

## Pick rationale

Per cycle 90 notes-for-next-cycle, six unexplored Agoric-mirror papers identified. URL probing on `papers.agoric.com/assets/pdf/papers/`:
- `the-digital-path-smart-contracts-and-the-third-world.pdf` → **404**
- `tahoe-lafs.pdf` → **404**
- `automated-analysis-of-security-critical-javascript-apis.pdf` → 200 (316 KB, 16 pages)
- `incentive-engineering-for-computational-resource-management.pdf` → 200 (608 KB)
- `comparative-ecology-a-computational-perspective.pdf` → 200 (455 KB)
- `robust-and-compositional-verification-of-object-capability-patterns.pdf` → 200 (715 KB; Drossopoulou-adjacent)

The Taly et al 2011 paper was the cohesion-density winner among the four reachable: 16 pages (single-cycle-appropriate; vs Incentive Engineering's likely 60+ pages and Comparative Ecology's likely 80+ pages), cited as ref [35] in cycle-85's Drossopoulou paper, and bridges the Miller-cluster's *informal capability discipline* with the *formal-static-analysis-verification* foundation.

## Three drafting-lessons confirmed

1. **URL-probing-before-drafting upheld** — six candidates probed; two 404'd; four reachable.
2. **Source-slug duplicate-check upheld** — `ls library/sources/ | grep taly\|automated-analysis` confirmed no prior ingest.
3. **Per-section commit discipline upheld** — each section committed as written.
4. **Cohesion-over-density discipline upheld** — three sections cleanly decompose the eight-section paper.

## Library state after cycle 91

- Sources: 137 (was 136) — adds the Taly et al 2011 paper.
- Sections: 582 (was 579) — adds 3 sections.
- Topics: 27 (unchanged) — threading into hardened-javascript (95 → 98), capability-security (153 → 156), capability-theory (32 → 35).
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~1900 (was ~1820) — added ~85 aliases tied to this paper's vocabulary.

## Cross-source linkage

This ingest creates the *static-analysis + formal-Hoare-logic complement pair* with cycle 85's Drossopoulou paper:

- **Cycle 85 Drossopoulou-Noble-Miller-Murray 2015** — formal Hoare logic for *trust and risk* via `obeys` / `MayAccess` / `MayAffect` + four-tuple Hoare logic.
- **Cycle 91 Taly-Erlingsson-Mitchell-Miller-Nagra 2011** — formal static-analysis for *API confinement* via SES_light + Datalog points-to + Soundness Theorem.

Both papers have Mark Miller as coauthor, both ground the contemporary Hardened JavaScript stack on a formal foundation, and they are *complementary* (one handles dynamic-trust-and-risk; one handles static-confinement). The library now has both.

Other linkages:
- **Cycle 88 Close 2009 *ACLs Don't*** — the §1 store-method example is the same flavor of programming-language-idiosyncrasy attack Close illustrated; the §2.7 Close caveat (capability applications can recreate ACL vulnerabilities) is the qualitative version of what ENCAP catches quantitatively.
- **Cycle 75 Miller-Morningstar-Frantz 2000** — the canonical Mint pattern this paper formally verifies. The capability-money thread (1988 → 2000 → 2013 → 2011-verified) is now historically and formally complete.
- **Cycle 87 endo packages/pass-style/src/error.js** — the transitively-immutable-built-in-objects claim is realized at the package level.
- **Cycle 82 Miller-Van Cutsem-Tulloh 2013** — Dr. SES = SES + Q + NodeKen. SES_light's 2011 specification grounds the 2013 paper's *Dr. SES* foundation.

## Notes for next cycle (92)

Three-lane rotation pointer advances to **chat-lane**.

Future chat-lane candidates:
- All currently-known `origin/design/chat-*` branches ingested. Need a bare-clone listing of any newly-merged chat designs. Cycle should start with: `git --git-dir=worktrees/endojs-endo-but-for-bots.git branch -a | grep design/chat-` and cross-reference against `library/sources/ | grep chat-`.

Future comments-lane candidates after cycle 92:
- `packages/exo/src/exo-makers.js` (verified present cycle 90; mostly JSDoc).
- `packages/patterns/src/keys/checkKey.js` (verified present cycle 87; lower density).
- `packages/marshal/src/marshal-justin.js` (verified present cycle 87; utility-code).
- `packages/captp/src/captp.js` (verified present cycle 90; 1012 lines, would need multi-section selective ingest plan).
- New candidates to survey: `packages/lockdown/src/lockdown-shim.js`, `packages/ses/src/error/*.js`, `packages/daemon/src/daemon-node.js`.

Future paper-lane candidates after cycle 93 (which would be papers-lane):
- *Incentive Engineering for Computational Resource Management* (Miller/Drexler ~1988; 608 KB) — agoric-systems companion.
- *Comparative Ecology: A Computational Perspective* (Huberman/Hogg; 455 KB).
- *Robust and Compositional Verification of Object Capability Patterns* (715 KB; likely Drossopoulou-adjacent; may overlap with cycle 85).
- *Robust Composition* (Miller PhD 2006; multi-cycle plan).

URL probing failed for *The Digital Path* and *Tahoe-LAFS* — both 404 on the obvious slugs. Future cycles may try alternative slug forms or other mirrors.

## Capability-theory cluster status

After cycle 91, the capability-theory topic page contains **35 sections** spanning:
- **1988 Miller-Drexler** — Markets and Computation; agoric vision.
- **2000 Miller-Morningstar-Frantz** — Capability-Based Financial Instruments.
- **2003 Miller-Yee-Shapiro** — Capability Myths Demolished.
- **2003 Miller-Shapiro** — Paradigm Regained.
- **2004 Miller-Tulloh-Shapiro** — The Structure of Authority.
- **2005 Miller-Tribble-Shapiro** — Concurrency Among Strangers.
- **2009 Close** — ACLs Don't.
- **2011 Taly-Erlingsson-Mitchell-Miller-Nagra** — Automated Analysis of Security-Critical JavaScript APIs.
- **2013 Miller-Van Cutsem-Tulloh** — Distributed Electronic Rights in JavaScript.
- **2015 Drossopoulou-Noble-Miller-Murray** — Reasoning about Risk and Trust in an Open World.
- **2026 Maloyan-Namiot** — Sleeper Channels and Provenance Gates.
- Plus the endo source code: track-turns.js (Mark Miller) and pass-style/error.js (Turadg).

The library now has the *complete arc* from informal-position-paper (Close 2009) through theoretical-elaboration (Miller cluster 2003-2005) through formal-foundations (Taly 2011 + Drossopoulou 2015) through contemporary-realization (track-turns.js, pass-style/error.js) and contemporary-threats (Maloyan-Namiot 2026 sleeper-channels). Maintainer's *Mark-mentor* note (cycle 65) on the user's intent to *build tools that explicitly defend against the harms Mark has been working 30 years to forestall* is realized in the library's coverage of the full theory-and-practice arc.
