---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/ses/README.md
source_line_range: 1-964
file_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
file_commit_date: 2025-09-25
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 345 designs-lane ingest. **EIGHTEENTH package added
  to the pivot cluster** — SES is THE foundational package
  that all other @endo packages coordinate with (cycles 337
  + 339 + 341 + 342 + 343 + 344 named SES as their
  coordination target). **964-line README** — the largest in
  the pivot by far; substrate-policy-VAST shape; §seven-
  shapes-of-README refines cycle 343's six-shape with
  substrate-policy-vast as SEVENTH shape (collection 17 +
  substrate-policy-minimal 13-15 + substrate-policy-mid 52 +
  utility 60-140 + substrate-policy-prose 158 + substrate-
  deep 188-415 + substrate-policy-vast 964); §the-named-
  foundational-package-gets-vast-README as tier-3 meta-
  pattern.

  Single most structurally interesting move: §the-named-
  precise-claims-with-precise-caveats-discipline — the
  Security claims and caveats section (~166 lines) pairs
  each GUARANTEE with its LIMITATION explicitly; the
  discipline is to **never claim more than is true** and to
  **explicitly enumerate what is NOT guaranteed**; §three-
  cycles-with-named-precise-security-claim-discipline (337
  partial-safety-with-tradeoff + 342 named-hole-with-named-
  mitigation + 345 full-claims-with-caveats).

  Other key tier-3 meta-patterns named first-explicitly:
  §the-named-pre-written-PR-language-for-ecosystem-
  cooperation — lines 932-948 provide verbatim text for
  downstream maintainers to paste into upstream issues
  (§the-named-README-as-cultural-artifact-not-just-
  documentation; READMEs can script community-action);
  §the-named-volunteer-PR-language-with-named-fallback-
  comment.

  §the-named-acronym-with-named-philosophical-expansion —
  *"SES stands for *fearless cooperation*"*; lead with
  values not technical expansion. §the-named-SES-stands-
  for-fearless-cooperation. §three-cycles-with-named-
  architectural-philosophy (87 V8-stack-accessor metaphor +
  337 place-to-stand metaphor + 345 fearless-cooperation).

  §the-named-four-pillars-of-HardenedJS — Compartments +
  Frozen-realm + Strict-mode + POLA; each as bolded keyword
  + one-line description; §the-named-bolded-keyword-as-
  pillar-marker; §two-shapes-of-architectural-summary
  (cycle 337 three-tier-meta-defense + cycle 345 four-
  pillars-component-architecture).

  §the-named-host-program-vs-guest-program-vocabulary —
  formal in-section definition; §the-named-vocabulary-
  definition-in-section as tier-3 meta-pattern. §the-named-
  three-tiers-of-isolation-claims (Single-guest + Multi-
  guest + Endowment-Protection); §the-named-layered-
  isolation-claims-with-named-conditions; §the-named-list-
  of-things-guest-cannot-do + §the-named-list-of-things-
  guest-can-still-do (paired guarantees + residual
  capabilities).

  §the-named-Trusted-Compute-Base-enumerated — SEVEN TCB
  components (hardware + OS + virtual OS + memory manager +
  ECMAScript 2021 impl + debugger + pre-lockdown JavaScript);
  §the-named-domain-property-on-promises-as-named-Node-
  host-behavior.

  §the-named-override-mistake-as-named-JavaScript-anti-
  feature — language wart named with cite to ECMAScript wiki
  strawman; §the-named-defineProperties-workaround-for-
  override-mistake; §the-named-language-anti-feature-with-
  workaround-code as tier-3 meta-pattern.

  §the-named-audit-history-as-trust-signal — FOUR trust-
  building activities documented (formal third-party audit
  June 2021 + collaborative bug hunt July 2021 + formal
  verification + bug bounty); §the-named-purple-teaming-as-
  collaborative-audit-style.

  §the-named-canonical-deployers-named-with-logos (Agoric +
  MetaMask); §the-named-video-introductions-embedded
  (TWO YouTube videos); §the-named-community-channels-trio
  (Mailing List + Matrix + weekly call); §the-named-Caja-
  as-named-predecessor-with-named-extensions ("introduces
  compartments and modernizes").

  §the-named-three-attack-categories-lockdown-defends-
  against (prototype pollution + man-in-the-middle + covert
  communication channels); §the-named-undeniable-objects-
  discipline; §the-named-taming-as-named-verb-of-art
  (RegExp + locale + errors); §the-named-locale-methods-
  as-fingerprinting-vector; §the-named-realm-vs-
  compartment-distinction; §the-named-Math-random-and-
  Date-now-disabled-by-default; §the-named-SharedArrayBuffer-
  as-named-attack-vector; §the-named-reentrancy-attack-
  named-explicitly; §the-named-defending-via-clean-stack-
  promise; §the-named-supply-chain-attack-via-bundler-named.

  Closes ELEVEN citation arcs (substrate-cluster culmination):
  cycle 344 = 1 + cycle 343 = 2 + cycle 342 = 3 + cycle 341 =
  4 + cycle 340 = 5 + cycle 339 = 6 + cycle 338 = 7 + cycle
  337 = 8 + cycle 87 = 258 cycles (V8-stack-accessor; new
  second-longest pivot arc, just under 261-cycle record) +
  cycle 211 = 134 cycles + cycle 183 = 162 cycles + cycle 322
  = 23 cycles. Pushes citation-arc-closures-in-pivot to
  ONE-HUNDRED-SIXTEEN (105 + 11 net new).

  §eight-cycles-with-named-substrate-package-introduction
  (337-345); §the-named-substrate-package-cluster-
  introduction-trend-extends-to-nine-cycles; §the-named-
  substrate-introduction-phase-culminates-at-foundational-
  package — librarian-discipline observation. The phase
  moved from outer layers (harden + errors + lockdown +
  init) inward to the foundation (ses).
---

> Abstract: 964-line README for @endo/ses — THE
> foundational substrate that all other @endo packages
> coordinate with. **Eighteenth package** added to the
> pivot cluster; **substrate-introduction culmination**.
> **Substrate-policy-VAST shape** (964 lines) — §seven-
> shapes-of-README refines cycle 343's six-shape with
> substrate-policy-vast as SEVENTH shape.
>
> **Single most structurally interesting move**: §the-named-
> precise-claims-with-precise-caveats-discipline — the
> Security claims and caveats section pairs each guarantee
> with its limitation; never claim more than is true;
> §three-cycles-with-named-precise-security-claim-discipline
> (337 + 342 + 345).
>
> §the-named-pre-written-PR-language-for-ecosystem-
> cooperation — verbatim PR text for downstream maintainers;
> §the-named-README-as-cultural-artifact-not-just-
> documentation as tier-3 meta-pattern.
>
> §the-named-acronym-with-named-philosophical-expansion —
> *"SES stands for fearless cooperation"*; lead with values.
>
> §the-named-four-pillars-of-HardenedJS — Compartments +
> Frozen-realm + Strict-mode + POLA; §two-shapes-of-
> architectural-summary (337 three-tier-meta + 345 four-
> pillars-component).
>
> §the-named-host-program-vs-guest-program-vocabulary;
> §the-named-vocabulary-definition-in-section.
>
> §the-named-three-tiers-of-isolation-claims (Single-guest +
> Multi-guest + Endowment-Protection); §the-named-layered-
> isolation-claims-with-named-conditions.
>
> §the-named-Trusted-Compute-Base-enumerated (7 components);
> §the-named-override-mistake-as-named-JavaScript-anti-
> feature with §the-named-defineProperties-workaround-for-
> override-mistake.
>
> §the-named-audit-history-as-trust-signal (four trust-
> building activities documented); §the-named-purple-
> teaming-as-collaborative-audit-style.
>
> §the-named-foundational-package-gets-vast-README — complexity
> tracks position in layered architecture.
>
> Closes ELEVEN citation arcs (substrate-cluster culmination)
> including 258-cycle arc to cycle 87 (V8-stack-accessor;
> new second-longest pivot arc). §eight-cycles-with-named-
> substrate-package-introduction (337-345); §the-named-
> substrate-introduction-phase-culminates-at-foundational-
> package.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [eighteenth-package-precise-claims-with-precise-caveats-and-pre-written-PR-language-for-ecosystem-cooperation](../sections/endo--packages-ses-README-md--eighteenth-package-precise-claims-with-precise-caveats-and-pre-written-PR-language-for-ecosystem-cooperation.md) | hardened-javascript, ses-foundation, security-claims-with-caveats, ecosystem-cooperation, README-shape-vast, substrate-introduction-culmination | current (cycle 345, designs-lane) |

964-line README. One dense section spanning the README's full thematic surface: acronym + four pillars + lockdown + harden + Compartment + Security Claims and Caveats + Trusted Compute Base + Audits + Bug Disclosure + Ecosystem Compatibility.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `fe81477bf88b00775bf135ce6cb3a7123a296e3e`) via the local clone.
- Last substantive touch 2025-09-25 by Kris Kowal in commit `fe81477b`.
- Apache-2.0 license per package LICENSE file; additional licenses present (LICENSE-aura + LICENSE-caja + LICENSE-corejs + LICENSE-v8) acknowledging the package's multi-source heritage.
- **EIGHTEENTH package** added to the pivot cluster (cycles 310-345).
- **SUBSTRATE-INTRODUCTION CULMINATION** — SES is the foundational package that the other introduced substrate-packages (harden + errors + lockdown + init) all coordinate with.
- §eight-cycles-with-named-substrate-package-introduction (337-345); §the-named-substrate-introduction-phase-culminates-at-foundational-package.
- §seven-shapes-of-README — refines cycle 343's six-shape categorization with substrate-policy-vast as the SEVENTH shape.
- Cycle 345 closes **ELEVEN citation arcs** including the 258-cycle arc to cycle 87 (V8-stack-accessor; new second-longest pivot arc).
