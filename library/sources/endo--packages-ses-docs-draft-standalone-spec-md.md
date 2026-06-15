---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/ses/docs/draft-standalone-spec.md
source_line_range: 1-201
file_commit: c1f40befca0f6e0f863e2ec81b2e595530f21875
file_commit_date: 2024-10-28
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 351 designs-lane ingest. 201-line forward-looking
  architectural blueprint for a STANDALONE SES engine (vs
  the current shim-based implementation).

  Single most structurally interesting move: §the-named-
  omissions-organized-by-removed-property — the document
  enumerates omissions from standard EcmaScript each tied
  to a NAMED PROPERTY being eliminated (non-determinism +
  ambient authority + global communications channel +
  evaluators). The taxonomy is organized by the security
  property being preserved. §three-named-anti-properties-
  being-eliminated; §the-named-three-anti-properties-equal-
  the-three-attack-categories (parallel to cycle 345's
  attack categories); §two-shapes-of-defense-taxonomy.

  §the-named-shim-vs-standalone-engine-distinction as tier-3
  meta-pattern — SES has two implementation strategies: shim
  (current) + standalone (this spec). §the-named-throws-
  rather-than-returns-discipline; §three-shapes-of-
  discipline-violation-visibility (337 helpful-stack + 342
  console-warn + 351 throw-on-denied-capability).

  §the-named-rom-able-immutable-discipline (frozen intrinsics
  + no hidden state + no ambient authority → ROM-able for
  IoT). §the-named-deterministic-replication-as-canonical-
  use-case (blockchain as shorthand). §the-named-shared-
  globals-vs-shared-intrinsics-distinction (formal
  definitions). §the-named-IoT-and-blockchain-may-omit-
  evaluators; §the-named-function-constructors-not-evaluators;
  §the-named-makeRootRealm-feature-test-discipline.

  Closes eight citation arcs: cycle 350 (1) + cycle 349 (2)
  + cycle 345 (6) + cycle 87 (264 V8 stack accessor / non-
  determinism theme) + cycle 152 (199 memo-race / Promise.race
  non-determinism) + cycle 156 (195 finalize.js gc-as-side-
  channel) + cycle 342 (9) + cycle 337 (14). Pushes citation-
  arc-closures-in-pivot to ONE-HUNDRED-FORTY-EIGHT (142 + 6
  net new).
---

> Abstract: 201-line forward-looking architectural blueprint
> for a STANDALONE SES engine. **Forty-second consecutive
> non-garden source** after the pivot.
>
> **Single most structurally interesting move**: §the-named-
> omissions-organized-by-removed-property — enumerated by
> named anti-property (non-determinism + ambient authority +
> global communications channel + evaluators). §three-named-
> anti-properties-equal-the-three-attack-categories; §two-
> shapes-of-defense-taxonomy.
>
> §the-named-shim-vs-standalone-engine-distinction as tier-3
> meta-pattern — two implementation strategies for SES.
>
> §the-named-throws-rather-than-returns-discipline; §three-
> shapes-of-discipline-violation-visibility (337 + 342 + 351).
>
> §the-named-rom-able-immutable-discipline (IoT-friendly
> end-state); §the-named-deterministic-replication-as-
> canonical-use-case.
>
> Closes eight citation arcs.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [omissions-organized-by-removed-property-and-shim-vs-standalone-engine-distinction](../sections/endo--packages-ses-docs-draft-standalone-spec-md--omissions-organized-by-removed-property-and-shim-vs-standalone-engine-distinction.md) | hardened-javascript, SES-architecture, standalone-engine, omissions-by-removed-property, IoT-blockchain, deterministic-replication | current (cycle 351, designs-lane) |

201-line forward-looking design doc. One section.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `c1f40befca0f6e0f863e2ec81b2e595530f21875`) via local clone.
- Last substantive touch 2024-10-28 by Kris Kowal.
- Apache-2.0 license per package LICENSE file.
- **Forty-second consecutive non-garden source after the pivot** (cycles 310-351).
- Cycle 351 closes **eight citation arcs**; §one-hundred-forty-eight-citation-arc-closures-in-pivot-now (142 + 6 net new).
