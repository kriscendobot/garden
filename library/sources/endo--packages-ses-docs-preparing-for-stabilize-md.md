---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/ses/docs/preparing-for-stabilize.md
source_line_range: 1-30
file_commit: 07ff084c87af4e567f6bf4f5e331742be94b6587
file_commit_date: 2025-01-19
file_commit_author: Mark S. Miller
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 349 designs-lane ingest. 30-line forward-looking
  design document in SES's docs/. Documentation-side closure
  for cycles 146 (E.js) + 154 (trap.js) + 322 (exo-makers
  complementary-lens) which all explicitly cited this
  document (§stabilize-discipline + §preparing-for-
  stabilize.md references). Fortieth consecutive non-garden
  source after the pivot (310-349).

  Single most structurally interesting move: §the-named-
  three-language-anti-features-mitigated-by-SES — lines 3-6
  name THREE distinct JavaScript language anti-features and
  the THREE Stabilize-proposal integrity traits mitigating
  each: (1) **fixed** mitigates return-override mistake
  (private-field stamping); (2) **overridable** mitigates
  assignment-override mistake (this is cycle 345's "override
  mistake"); (3) **non-trapping** mitigates proxy-based
  reentrancy hazards. Cycle 345 named ONE anti-feature;
  cycle 349 reveals SES mitigates THREE. §the-named-language-
  anti-features-as-orthogonal-traits as tier-3 meta-pattern;
  §three-shapes-of-language-anti-feature-mitigation (spec
  TC39 + library SES + user defineProperties-workaround).

  §the-named-forward-looking-design-document-discipline as
  tier-3 meta-pattern — the document is prospective (describes
  what's coming and how to prepare) rather than retrospective
  (describing what exists). Describes Stabilize at TC39 stage
  1 + draft PRs #2673 and #2675 + preparation guidance for
  proxy code and passable objects.

  §the-named-placeholder-names-are-not-final + §the-named-
  bikeshedding-process-acknowledged + §the-named-stabilize-
  renaming-suppressTrapping-with-named-alternatives (TWO
  candidate names listed: "stabilize" or "suppressTrapping");
  §the-named-name-not-yet-finalized-honesty-discipline as
  tier-3 meta-pattern.

  §the-named-by-default-discipline-with-named-opt-in — safety
  by default; opt-in for less safety; §the-named-safety-by-
  default-opt-in-for-less-safety; §four-cycles-with-named-
  safety-by-default-discipline (337 + 343 + 345 + 349).

  §the-named-E-returns-proxy-with-frozen-trivial-target —
  closes citation arcs with cycle 146 (E.js) and cycle 154
  (trap.js); §the-named-trivial-frozen-target-as-proxy-
  pattern as tier-3 meta-pattern; §the-named-shared-trivial-
  target-via-module-scope.

  §the-named-draft-PR-named-with-issue-number — PRs #2673 and
  #2675 named with titles; §the-named-implementation-PRs-
  named-explicitly as tier-3 meta-pattern; §four-shapes-of-
  stable-pointer-discipline (326 deprecation-pointer + 336
  issue-link + 338 error-code-Markdown + 349 PR-link-for-WIP).

  §the-named-harden-discipline-changing-meaning — the
  semantics of harden vs Object.freeze is changing; §the-
  named-discipline-semantics-evolution-with-named-migration
  as tier-3 meta-pattern.

  Closes eight citation arcs: cycle 348 = 1 cycle + cycle 346
  = 3 cycles + cycle 345 = 4 cycles + cycle 146 = 203 cycles
  (E.js §stabilize-discipline reference) + cycle 154 = 195
  cycles (trap.js §preparing-for-stabilize comment) + cycle
  322 = 27 cycles (exo-makers §state-sealed-not-frozen) +
  cycle 187 = 162 cycles + cycle 343 = 6 cycles (§four-cycles-
  with-named-safety-by-default-discipline). Pushes citation-
  arc-closures-in-pivot to ONE-HUNDRED-THIRTY-FIVE (130 + 5
  net new).
---

> Abstract: 30-line forward-looking design document in SES's
> docs/. **Fortieth consecutive non-garden source** after
> the pivot.
>
> **Single most structurally interesting move**: §the-named-
> three-language-anti-features-mitigated-by-SES — return-
> override + assignment-override + proxy-reentrancy each
> mitigated by a named Stabilize integrity trait (fixed +
> overridable + non-trapping). Cycle 345 named ONE; cycle
> 349 reveals THREE. §the-named-language-anti-features-as-
> orthogonal-traits as tier-3 meta-pattern.
>
> §the-named-forward-looking-design-document-discipline —
> prospective vs retrospective; describes what's coming.
>
> §the-named-name-not-yet-finalized-honesty-discipline —
> TWO candidate names listed (stabilize OR suppressTrapping).
>
> §the-named-safety-by-default-opt-in-for-less-safety;
> §four-cycles-with-named-safety-by-default-discipline (337
> + 343 + 345 + 349).
>
> §the-named-E-returns-proxy-with-frozen-trivial-target —
> closes 203-cycle arc to cycle 146 (E.js cited this
> document) and 195-cycle arc to cycle 154 (trap.js cited
> this document). §the-named-trivial-frozen-target-as-proxy-
> pattern.
>
> §the-named-implementation-PRs-named-explicitly (#2673 and
> #2675 named with titles); §four-shapes-of-stable-pointer-
> discipline (326 + 336 + 338 + 349).
>
> §the-named-discipline-semantics-evolution-with-named-
> migration — harden semantics changing; how to prepare.
>
> Closes eight citation arcs; §one-hundred-thirty-five-
> citation-arc-closures-in-pivot-now.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [three-language-anti-features-mitigated-by-SES-and-forward-looking-design-document-discipline](../sections/endo--packages-ses-docs-preparing-for-stabilize-md--three-language-anti-features-mitigated-by-SES-and-forward-looking-design-document-discipline.md) | hardened-javascript, TC39-Stabilize-proposal, integrity-traits, forward-looking-design, proxy-reentrancy, harden-semantics-evolution | current (cycle 349, designs-lane) |

30-line forward-looking design doc. One dense section covering three language anti-features + integrity traits + forward-looking discipline + placeholder-names + by-default-discipline + trivial-frozen-target + implementation-PRs + harden-semantics-evolution.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `07ff084c87af4e567f6bf4f5e331742be94b6587`) via the local clone.
- Last substantive touch 2025-01-19 by Mark S. Miller.
- Apache-2.0 license per package LICENSE file.
- **Fortieth consecutive non-garden source after the pivot** (cycles 310-349).
- **Documentation-side closure** of cycles 146 (E.js §stabilize-discipline) + 154 (trap.js §preparing-for-stabilize comment) + 322 (exo-makers §state-sealed-not-frozen). Cycle 146 → 349 = 203 cycles; cycle 154 → 349 = 195 cycles.
- §four-cycles-with-named-safety-by-default-discipline (337 + 343 + 345 + 349).
- §four-shapes-of-stable-pointer-discipline (326 + 336 + 338 + 349).
- Cycle 349 closes **eight citation arcs**; §one-hundred-thirty-five-citation-arc-closures-in-pivot-now (130 + 5 net new).
