---
ts: 2026-05-29T21:00:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/papers--swasey-garg-dreyer-ocpl-2017.md
---

# liaison cycle 94 result — OCPL (Swasey-Garg-Dreyer 2017) ingest

Papers-lane ingest (cycle 94, **third formal-foundation paper in the capability-theory cluster after cycle 85 Drossopoulou and cycle 91 Taly**, per the three-lane rotation after cycle 93's comments-lane).

Ingested **Swasey, Garg, Dreyer, *Robust and Compositional Verification of Object Capability Patterns (Long Version)*** (OOPSLA 2017, MPI-SWS). PDF SHA-256 `e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef`, 34 pages.

Three argument-cluster sections:

1. `hla-language-program-logic-and-robust-safety` (§1 + §2) — readonly motivating example; low-integrity-value concept from Abadi 1999; HLA language with assert + goodness bit; OCPL program logic with high/low locations + `lift Ψ` logical relation; progressive vs non-progressive Hoare triples; AdequacySafety + **RobustSafety** meta-theorems.

2. `three-ocps-verified-dynamic-sealing-caretaker-membrane` (§3 + §4 + §5) — dynamic sealing (Morris 1973 sealer-unsealer + intervals worked client + six-rule spec including SealedInv + SealedAgree); caretaker (API + location with temporary-invariant-break pattern); membrane (recursive value-transformation lift + public membrane = Caja language-invariants pattern with shadow locations for backward-compatible library invariants).

3. `related-work-iris-foundation-and-future-firefox-membrane` (§6 + §7) — related work survey citing cycles 82, 85, 91; Iris/RustBelt linkage; Firefox same-origin-policy membrane + Coq automation future work.

## The cycle-94 ingest establishes a *trilogy* of formal foundations

The capability-theory cluster now has three complementary formal foundations:

| Cycle | Paper | Framework | Granularity |
| ----- | ----- | --------- | ----------- |
| 85 | Drossopoulou-Noble-Miller-Murray 2015 | Hoare four-tuples + obeys/MayAccess/MayAffect | One worked example (escrow exchange) |
| 91 | Taly-Erlingsson-Mitchell-Miller-Nagra 2011 | Datalog points-to + soundness | Three JavaScript APIs (ADSafe, Sealer-Unsealer, Mint) |
| **94** | **Swasey-Garg-Dreyer 2017 (this cycle)** | **Iris separation logic + RobustSafety** | **Three compositional patterns (sealing, caretaker, membrane)** |

The three are complementary — each handles a dimension the others don't:
- **Drossopoulou** handles *dynamic-trust nuances* in a single contract.
- **Taly** handles *flow-insensitive API confinement* with decidable Datalog soundness.
- **OCPL** handles *compositional pattern verification* with Coq mechanization.

A design that wants to argue capability-safety should pick the appropriate framework for the question being asked.

## Stiegler-2006 paper identified

The OCPL paper's reference [Stiegler-Miller 2006] confirms that the actual Stiegler 2006 paper is **How Emily tamed the Caml** (HPL-2006-116, HP Laboratories). The cycle-85 ingest correctly identified the *Reasoning about Risk and Trust in an Open World* paper as Drossopoulou-Noble-Miller-Murray 2015b (technical report ECSTR-15-08).

*How Emily tamed the Caml* would be a future paper-lane candidate; its title suggests it formalizes a capability-safe subset of OCaml — a possible companion to Mettler-Wagner-Close's 2010 *Joe-E* (Java capability subset).

## Pick rationale

Per cycle 93 notes-for-next-cycle, papers-lane candidates were:
- *Incentive Engineering for Computational Resource Management* (Miller/Drexler; 608 KB)
- *Comparative Ecology: A Computational Perspective* (Huberman/Hogg; 455 KB)
- *Robust and Compositional Verification of Object Capability Patterns* (715 KB; Drossopoulou-adjacent)
- *Robust Composition* (Miller PhD 2006; multi-cycle)

**OCPL (Swasey-Garg-Dreyer 2017) was the cohesion-density winner** because:
1. It directly pairs with cycle 85 (Drossopoulou) and cycle 91 (Taly) to form the *complete formal-foundations trilogy* — a major library-architecture milestone.
2. It cites three prior library ingests (cycle 82, 85, 91), making it the most cross-linked paper to date.
3. It introduces *new tooling* (Iris-Coq-mechanization) that the library hasn't covered.
4. It identifies the actual Stiegler 2006 paper, resolving the cycle-85 ambiguity.
5. 34 pages including appendices; 24 pages of main text — single-cycle-appropriate.

Other candidates saved for future cycles.

## Three drafting-lessons confirmed

1. **URL probing + cohesion-density survey** — all three reachable candidates (Comparative Ecology, OCPL, Incentive Engineering) probed; OCPL chosen on multiple criteria.
2. **Source-slug duplicate-check (cycle 89's standing discipline)** — `ls library/sources/ | grep -i "swasey\|ocpl"` confirmed no prior ingest.
3. **Per-section commit discipline upheld** — each section committed as written.
4. **Cohesion-over-density discipline upheld** — three sections cleanly decompose the 24-page main text into argument clusters.

## Library state after cycle 94

- Sources: 140 (was 139) — adds the OCPL paper.
- Sections: 590 (was 587) — adds 3 sections.
- Topics: 27 (unchanged) — threading into hardened-javascript (101 → 104), capability-security (158 → 161), capability-theory (35 → 38).
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~2200 (was ~2060) — added ~140 aliases tied to this paper's vocabulary.

## Capability-theory cluster milestone

After cycle 94, the capability-theory topic page contains **38 sections** spanning:
- **1988 Miller-Drexler** — Markets and Computation; agoric vision.
- **2000 Miller-Morningstar-Frantz** — Capability-Based Financial Instruments.
- **2003 Miller-Yee-Shapiro** — Capability Myths Demolished.
- **2003 Miller-Shapiro** — Paradigm Regained.
- **2004 Miller-Tulloh-Shapiro** — The Structure of Authority.
- **2005 Miller-Tribble-Shapiro** — Concurrency Among Strangers.
- **2009 Close** — ACLs Don't.
- **2011 Taly-Erlingsson-Mitchell-Miller-Nagra** — Automated Analysis (formal static-analysis foundation).
- **2013 Miller-Van Cutsem-Tulloh** — Distributed Electronic Rights in JavaScript.
- **2015 Drossopoulou-Noble-Miller-Murray** — Reasoning about Risk and Trust (formal Hoare-logic foundation).
- **2017 Swasey-Garg-Dreyer** — OCPL (formal program-logic foundation).
- **2026 Maloyan-Namiot** — Sleeper Channels.
- Plus the endo source code: track-turns.js (Mark Miller) and pass-style/error.js (Turadg) and ses tame-v8-error-constructor.js (Richard Gibson).

The library now has the *complete formal-foundations trilogy* covering Hoare-logic (Drossopoulou), Datalog-static-analysis (Taly), and Iris-separation-logic (OCPL). Together they describe the full landscape of capability-program verification.

## Notes for next cycle (95)

Three-lane rotation pointer advances to **chat-lane**.

Future chat-lane candidates per cycle 92 chat-branch discovery:
- `chat-rename-dismiss-to-clear` (75 lines, Status: Complete; single-section candidate as PR-merge decision record).
- `chat-reply-chain-visualization` (502 lines, Status: Deprecated — superseded by chat-focus-message; design-rationale-history candidate).
- Watch `origin/design/chat-*` and `origin/llm/designs/chat-*` for new merges.

Future comments-lane candidates after cycle 96:
- `packages/ses/src/error/console.js` (541 lines / 212 comments / 39% — strong candidate).
- `packages/ses/src/error/assert.js` (604 lines / 199 comments / 32%).
- `packages/ses/src/error/unhandled-rejection.js` (122 lines / 50 comments / 40%).
- `packages/exo/src/exo-makers.js` / `packages/patterns/src/keys/checkKey.js` / `packages/marshal/src/marshal-justin.js` (verified present; lower density).

Future paper-lane candidates after cycle 97:
- *Incentive Engineering for Computational Resource Management* (Miller/Drexler; 608 KB) — agoric-systems companion.
- *Comparative Ecology: A Computational Perspective* (Huberman/Hogg; 455 KB).
- *How Emily tamed the Caml* (Stiegler-Miller 2006; HPL-2006-116) — newly identified per OCPL reference [Stiegler-Miller 2006].
- *Robust Composition* (Miller PhD 2006) — multi-cycle plan still pending.
