---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/errors/README.md
source_line_range: 1-13
file_commit: dd24b13d838f045d8d54354a8d704af83718e0a8
file_commit_date: 2025-12-04
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 339 designs-lane ingest. **FIFTEENTH package added to
  the pivot cluster** (nat + memoize + hex + lp32 + stream +
  eventual-send + exo + captp + pass-style + patterns +
  marshal + common + promise-kit + harden + **errors**).
  **NEW SHORTEST README in the pivot** at 13 lines (previous
  record: cycle 333 @endo/common at 17 lines).

  Single most structurally interesting move: §the-named-
  information-disclosure-via-thrown-exception-threat-model —
  lines 3-7 open with a threat model that is structurally
  DIFFERENT from cycle 337 @endo/harden's supply-chain-attack
  threat model. The two threats are at different layers:
  cycle 337 defends the module boundary; cycle 339 defends
  the exception channel. §two-threat-models-named-in-pivot-
  READMEs (337 supply-chain + 339 information-disclosure-via-
  exception); §the-named-two-threat-models-name-different-
  attack-surfaces as a tier-3 meta-pattern.

  §the-named-symmetric-disclosure-risk-named-twice — README
  names BOTH host→guest AND guest→guest disclosure;
  §the-named-host-AND-guest-guest-disclosure-symmetry.

  §the-named-package-coordinates-with-named-other-package —
  lines 11-13 name the coordination with `ses` in the host
  realm; the README points to `../ses/` (relative path within
  the monorepo); §the-named-coordination-with-ses-for-
  console-reveal. §the-named-redacted-vs-revealed-asymmetry —
  two audiences with different privileges (code that catches
  sees redacted; realm's console sees full); §the-named-two-
  audiences-different-privileges. §three-cycles-with-named-
  capability-channel-by-audience (87 V8-stack-accessor + 337
  intrinsic-over-endowment + 339 redacted-vs-revealed).

  §the-named-one-sentence-purpose-statement (lines 9-10:
  *"For this reason, the @endo/errors package provides
  utilities for constructing errors with redacted messages"*).
  §the-named-three-piece-minimal-README (threat-model +
  purpose + coordination = 13 lines total). §the-named-
  thirteen-line-README-as-floor.

  §the-named-five-shapes-of-README refines cycle 337's
  four-shape categorization with a fifth: collection (333
  17 lines) + utility (335 71 lines) + substrate-policy-
  prose (337 158 lines) + substrate-policy-minimal (339 13
  lines) + substrate-deep (325 216 lines). §the-named-
  substrate-policy-vs-collection-package-shape-distinct —
  cycle 333 @endo/common is a collection-package; cycle 339
  @endo/errors is a NEW shape: substrate-policy-minimal.

  Closes nine citation arcs (substrate-cluster documentation-
  side closure for the SECOND TIME after cycle 337):
  cycle 87 = 252 cycles (pass-style/error.js V8-stack-accessor;
  equals cycle 338's 251-cycle second-longest pivot arc) +
  cycle 102 = 237 cycles (Rejector trio pattern; rejector.js
  exists in this package) + cycle 134 = 205 cycles + cycle
  138 = 201 cycles + cycle 211 = 128 cycles + cycle 322 = 17
  cycles + cycle 332 = 7 cycles + cycle 337 = 2 cycles
  (two-threat-models-named-in-pivot-READMEs) + cycle 338 =
  1 cycle (cross-package designs-lane after chat-lane).
  Pushes citation-arc-closures-in-pivot to SIXTY-EIGHT (62 + 6
  net new). §two-cycles-with-named-substrate-package-
  introduction (337 + 339).
---

> Abstract: 13-line README for `@endo/errors` — **NEW SHORTEST
> README in the pivot** (previous record: cycle 333 @endo/
> common at 17 lines). **Fifteenth package** added to the
> pivot cluster.
>
> **Single most structurally interesting move**: §the-named-
> information-disclosure-via-thrown-exception-threat-model —
> the README opens with a threat model structurally
> DIFFERENT from cycle 337 @endo/harden's supply-chain-attack
> threat model. §two-threat-models-named-in-pivot-READMEs
> (337 supply-chain + 339 information-disclosure-via-
> exception); the two threats are at different defense layers.
>
> §the-named-symmetric-disclosure-risk-named-twice — README
> names BOTH host→guest AND guest→guest disclosure.
>
> §the-named-package-coordinates-with-named-other-package —
> @endo/errors coordinates with `ses` in the host realm;
> §the-named-redacted-vs-revealed-asymmetry (catchers see
> redacted; console sees full); §three-cycles-with-named-
> capability-channel-by-audience (87 + 337 + 339).
>
> §the-named-five-shapes-of-README refines cycle 337's
> four-shape categorization: collection (333) + utility (335)
> + substrate-policy-prose (337) + **substrate-policy-minimal
> (339)** + substrate-deep (325).
>
> §the-named-three-piece-minimal-README — threat-model +
> purpose + coordination = 13 lines is sufficient.
>
> Closes nine citation arcs across the errors-cluster; the
> cycle 87 arc at 252 cycles equals cycle 338's 251-cycle
> second-longest pivot arc. §two-cycles-with-named-substrate-
> package-introduction (337 + 339).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [fifteenth-package-information-disclosure-threat-model-with-package-coordinates-with-ses](../sections/endo--packages-errors-README-md--fifteenth-package-information-disclosure-threat-model-with-package-coordinates-with-ses.md) | hardened-javascript, information-disclosure-defense, capability-channel-by-audience, package-coordination, README-shape, substrate-policy-minimal | current (cycle 339, designs-lane) |

13-line README. One section with dense first-explicit-observations across threat-model + symmetric-disclosure + package-coordination + redacted-vs-revealed asymmetry + five-shapes-of-README + three-piece-minimal-README.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `dd24b13d838f045d8d54354a8d704af83718e0a8`) via the local clone.
- Last substantive touch 2025-12-04 by Kris Kowal in commit `dd24b13d`.
- Apache-2.0 license per package LICENSE file.
- **Fifteenth package** added to the pivot cluster (cycles 310-339).
- **NEW SHORTEST README in the pivot** at 13 lines (previous: cycle 333 @endo/common at 17 lines).
- **§two-threat-models-named-in-pivot-READMEs** — substrate-packages name DIFFERENT threats at DIFFERENT layers; cycle 337 @endo/harden defends the module boundary; cycle 339 @endo/errors defends the exception channel.
- **§the-named-substrate-package-introduction-closes-many-arcs** discipline applies for the SECOND TIME (cycle 337 + 339). §two-cycles-with-named-substrate-package-introduction.
- Cycle 339 closes **nine citation arcs**; the cycle 87 arc at 252 cycles equals cycle 338's 251-cycle arc as the second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).
