---
ts: 2026-05-29T14:55:00Z
kind: result
role: liaison
host: endolin
project: garden
refs:
  - inboxes/endolin/scholar.md
  - library/sources/papers--close-acls-dont-2009.md
---

# liaison cycle 88 result — ACLs Don't (Tyler Close ~2009) ingest

Papers-lane ingest (cycle 88, **first non-Miller paper in the capability-theory cluster; first Tyler Close paper**, per the three-lane rotation after cycle 87's comments-lane).

Ingested **Tyler Close, *ACLs don't*** (~2009 position paper, HP Labs Palo Alto). PDF SHA-256 `d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75`, 12 pages, fetched from `papers.agoric.com/assets/pdf/papers/acls-dont.pdf`.

Three argument-cluster sections:

1. `compilation-scenario-and-the-confused-deputy-attack` (§1 + §2.1-§2.3) — the canonical Vendor-User-Compiler-log.txt worked example; ACL-checking (column lookup) vs capability-transfer (row-keyed permission packaging); the Confused Deputy attack that exploits ACL's loss of context across message sends; the 1971 Protection paper's equivalence presumption overturned.
2. `three-failures-of-acls-and-capability-application-caveat` (§2.4-§2.7) — three structural failures of ACLs: authorize (RBAC/ABAC/IBAC/setuid/stack-introspection all share the *delaying-the-access-check-until-a-late-stage* property and fail); authenticate (*who said this* is not *who intended this*); accountability (the deputy is blamed instead of the principal-of-intent — Horton capability protocol [13] fixes via capability-identity equality). §2.7 caveat: capability applications can recreate ACL vulnerabilities by re-implementing ACL design on top of capabilities (string-name-to-capability mappings); fix is *capabilities-by-reference everywhere*.
3. `web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix` (§3-§5) — CSRF + clickjacking + click-fraud as Confused Deputy attacks on the Web (Table 3 element-for-element mapping); §3.2.1 web-key as unguessable URL = capability-by-reference for the Web; §5 *no-infrastructure-change* migration claim — capability adoption is application-local, not infrastructure-wide.

## Pick rationale

Per cycle 87 notes-for-next-cycle, papers-lane candidates were Robust Composition (250-page Miller thesis, needs multi-cycle plan), The Digital Path (Stiegler + Miller 2002), and Stiegler's original *Reasoning About Risk and Trust* 2006.

URL probing for the cycle-87-listed candidates yielded mixed results:
- Robust Composition: PDF exists at `papers.agoric.com/assets/pdf/papers/robust-composition.pdf` (250 pages — too large for single cycle).
- The Digital Path: 404 at the obvious URL slug (paper title is `the-digital-path-smart-contracts-and-the-third-world` per Agoric index; not probed for PDF).
- Stiegler 2006: still elusive via direct URL probing (the Agoric mirror's URL slug `reasoning-about-risk-and-trust-in-an-open-world` serves the Drossopoulou-Noble-Miller-Murray 2015 paper, not Stiegler 2006).

While probing, **discovered the Agoric index lists ten additional unexplored papers**, of which "ACLs Don't" (Tyler Close) is a bounded, canonical, and high-value pick:
- 12 pages (single-cycle-appropriate).
- Canonical: the access-matrix-terminology formalization of the Confused Deputy attack; pairs with Hardy 1988 and Miller-Yee-Shapiro 2003 as the foundational ACL critique.
- First non-Miller paper in the cluster — diversifies the library's authorship beyond the Miller corpus.
- Directly extends prior cycle's content: §2.5 *who said this is not who intended this* is the precise wisdom that cycle 87's pass-style/error.js §3 enacts at the package level (with the *security-vs-diagnostic-preservation* tension).
- Strong CSRF / clickjacking / click-fraud worked examples that pair with cycle 76's Sleeper Channels paper and the garden's standing monitoring-safety-constraint discipline.

## Three drafting-lessons confirmed

1. **URL-probing-before-drafting upheld.** Cycle 73 / 74 verify-bare-clone discipline extended to paper PDFs. The cycle-87 candidate list was partially obsolete; URL probing surfaced the actual reachable papers.
2. **Per-section commit discipline upheld** — each section committed as written, not batched. Cycle-67 mitigation continues to apply.
3. **Cohesion-over-density discipline upheld** — three sections rather than five thinner cuts; each section is a self-contained argument cluster.

## Library state after cycle 88

- Sources: 134 (was 133) — adds the new Close paper.
- Sections: 573 (was 570) — adds 3 sections.
- Topics: 27 (unchanged) — threading into capability-theory (28 → 31) and capability-security (150 → 153).
- Concepts: 44 (unchanged) — cohesion-over-density continues to defer concept-page creation.
- Keywords: ~1640 (was ~1560) — added ~80 aliases tied to this paper's vocabulary.

## Cross-source linkage

This ingest connects multiple prior threads:

- **Hardy 1988 *Confused Deputy*** [8] is the originating source; this paper is the access-matrix-terminology elaboration.
- **Miller-Yee-Shapiro 2003 *Capability Myths Demolished*** (cycle 64) is the long-form theoretical elaboration; this paper is the condensed-position-paper version. Together they form the canonical ACL-critique pair.
- **Miller-Shapiro 2003 *Paradigm Regained*** (cycle 70) provides the formal *permission-vs-authority* language for this paper's informal arguments.
- **Miller-Tulloh-Shapiro 2004 *Structure of Authority*** (cycle 71) makes the *cp-vs-cat* argument and the multiplicative-attack-surface case; this paper's compilation scenario is the canonical cp-vs-cat worked example.
- **Drossopoulou-Noble-Miller-Murray 2015** (cycle 85) provides the formal Hoare-logic specification of capability programs; this paper is the informal-pedagogy companion.
- **Maloyan-Namiot 2026 *Sleeper Channels*** (cycle 76) has *A4 cron-via-confused-deputy* — the same Confused Deputy attack class transposed to the LLM-agent runtime.
- **Miller-Van Cutsem-Tulloh 2013 *Distributed Electronic Rights in JavaScript*** (cycle 82) — web-keys as pass-by-reference encoding in Dr. SES is the JavaScript-native realization of §3.2.1's web-key fix.
- **endo packages/pass-style/src/error.js** (cycle 87) — the package-level enactment of *who-said-this-is-not-who-intended-this*.

## Notes for next cycle (89)

Three-lane rotation pointer advances to **chat-lane**.

Future chat-lane candidates per cycle 86 / 87 notes:
- `chat-edit-message-ui` (present on remote, not yet ingested).
- `chat-voice-command-parser` (present on remote, not yet ingested).

Future paper-lane candidates after cycle 89:
- **Other unexplored Agoric mirror papers** discovered during cycle 88 URL probing:
  - *Comparative Ecology: A Computational Perspective* (Huberman / Hogg) — companion to Markets and Computation 1988.
  - *Incentive Engineering for Computational Resource Management* — agoric-systems companion.
  - *Robust and Compositional Verification of Object Capability Patterns* — Drossopoulou-adjacent, may overlap with cycle 85 ingest.
  - *Automated Analysis of Security-Critical JavaScript APIs* (Taly et al 2011) — early SES verification.
  - *Tahoe-LAFS* — Wilcox-O'Hearn et al distributed-file-storage capability paper.
  - *The Digital Path: Smart Contracts and the Third World* (Stiegler + Miller 2002) — needs URL re-probe; if findable, a Stiegler-perspective complement to the Miller cluster.
- **Robust Composition** (Miller PhD 2006) — still on the multi-cycle plan list. A 250-page thesis would take ~5-7 cycles per chapter. Maintainer call when to begin.

Future comments-lane candidates:
- `packages/patterns/src/keys/checkKey.js` (verified present cycle 87; lower comment density).
- `packages/marshal/src/marshal-justin.js` (verified present cycle 87; utility-code).
- `packages/exo/src/exo-makers.js` (new candidate per cycle 87 notes).
- `packages/captp/src/captp.js` body (new candidate per cycle 87 notes).
- `packages/eventual-send/src/track-turns.js` (new candidate per cycle 87 notes).
