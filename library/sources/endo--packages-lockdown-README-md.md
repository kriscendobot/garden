---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/lockdown/README.md
source_line_range: 1-15
file_commit: dd24b13d838f045d8d54354a8d704af83718e0a8
file_commit_date: 2025-12-04
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 341 designs-lane ingest. **SIXTEENTH package added to
  the pivot cluster** (nat + memoize + hex + lp32 + stream +
  eventual-send + exo + captp + pass-style + patterns +
  marshal + common + promise-kit + harden + errors +
  **lockdown**). Substrate-policy-minimal shape at 15 lines
  (slightly above cycle 339 @endo/errors 13-line floor).
  §two-substrate-policy-minimal-READMEs (339 + 341).

  Single most structurally interesting move: §the-named-
  subset-relationship-named-with-named-alternative — lines
  14-15 *"The HardenedJS environment is a subset of the Endo
  environment. Use [`@endo/init`](../init) for a more
  comprehensive upgrade"*; the README names the scope-
  relationship (HardenedJS ⊂ Endo) AND points to the larger
  alternative AND explains when to use it. §the-named-
  pointer-to-related-package-with-named-relationship; §the-
  named-scope-awareness-discipline as tier-3 meta-pattern.

  Other key first-explicit-observations: §the-named-side-
  effect-import-as-environment-upgrade — lines 3-7 open with
  *"We often need to upgrade a JavaScript environment as a
  side effect of importing a module"*; the package's purpose
  is the import-side-effect. §the-named-side-effect-only-
  package (no exports; the import IS the contract); §two-
  shapes-of-export-less-package (types-only cycle 340 +
  side-effect-only cycle 341); both shapes have zero runtime
  exports but contribute different things (typedefs vs
  runtime side-effects). §the-named-import-order-as-
  temporal-discipline (lockdown must be imported FIRST);
  §the-named-import-statement-as-temporal-anchor as tier-3
  meta-pattern. §the-named-quoted-import-ellipsis-as-
  placeholder (string-literal-ellipsis as documentation
  idiom). §the-named-coordinate-with-SES-via-import; §three-
  cycles-with-named-coordination-target-IS-SES (337 + 339 +
  341) — SES is the convergent coordination target for all
  three minimal-substrate-policy READMEs; §the-named-SES-as-
  convergent-coordination-target as tier-3 meta-pattern.
  §the-named-simply-ensures-language — *"simply ensures"* is
  the minimalism discipline-marker. §two-cycles-with-named-
  temporal-ordering-discipline (337 vulnerability + 341
  prevention).

  §three-cycles-with-named-package-coordinates-with-named-
  other-package (337 harden's prepare-* convention + 339
  errors with ses + 341 lockdown with init).

  Closes eight citation arcs: cycle 340 = 1 cycle (cross-
  package) + cycle 339 = 2 cycles (substrate-policy-minimal
  pair) + cycle 338 = 3 cycles (lockdown senses harden via
  Object[Symbol.for('harden')]) + cycle 337 = 4 cycles
  (lockdown installs harden; prepare-* convention) + cycle
  183 = 158 cycles (init/lockdown 12-file comment-fragment
  cluster; first observation of tolerance-ladder) + cycle 187
  = 154 cycles (shim cluster coordinates with lockdown) +
  cycle 87 = 254 cycles (lockdown's underlying SES handles
  stack-accessor concerns; ties cycle 340's 253-cycle arc) +
  cycle 211 = 130 cycles (@endo/common dependency-ceiling
  names ses). Pushes citation-arc-closures-in-pivot to
  EIGHTY-TWO (75 + 7 net new). §four-cycles-with-named-
  substrate-package-introduction (337 + 339 + 340 + 341);
  §the-named-substrate-package-cluster-introduction-trend
  (five consecutive cycles in substrate-introduction phase).
---

> Abstract: 15-line **substrate-policy-minimal README** for
> @endo/lockdown — the side-effect-only package that ensures
> SES has initialized and locked down the environment.
> **Sixteenth package** added to the pivot cluster.
>
> **Single most structurally interesting move**: §the-named-
> subset-relationship-named-with-named-alternative — names
> the package's scope (HardenedJS) + the structural
> relationship (HardenedJS ⊂ Endo) + the alternative
> (@endo/init for more comprehensive) + relative-path link.
> §the-named-pointer-to-related-package-with-named-
> relationship; §the-named-scope-awareness-discipline as
> tier-3 meta-pattern.
>
> §the-named-side-effect-import-as-environment-upgrade —
> import statement as the contract for an environment-setup
> package. §the-named-side-effect-only-package; §two-shapes-
> of-export-less-package (types-only cycle 340 + side-effect-
> only cycle 341).
>
> §the-named-import-order-as-temporal-discipline + §the-
> named-import-statement-as-temporal-anchor — lockdown must
> be imported FIRST; the source-order import IS the temporal
> contract. §two-cycles-with-named-temporal-ordering-
> discipline (337 vulnerability + 341 prevention).
>
> §the-named-coordinate-with-SES-via-import + §three-cycles-
> with-named-coordination-target-IS-SES (337 + 339 + 341);
> §the-named-SES-as-convergent-coordination-target — SES is
> the convergent target for all three minimal-substrate-
> policy READMEs.
>
> §the-named-simply-ensures-language — *"simply ensures"* is
> the minimalism discipline-marker.
>
> §two-substrate-policy-minimal-READMEs (339 errors at 13
> lines + 341 lockdown at 15 lines); §the-named-substrate-
> policy-minimal-shape-confirmed-across-two-applications.
>
> Closes eight citation arcs including the 254-cycle arc to
> cycle 87 (ties cycle 340's 253-cycle arc as second-longest
> pivot arc). §four-cycles-with-named-substrate-package-
> introduction (337 + 339 + 340 + 341); §the-named-substrate-
> package-cluster-introduction-trend (five-consecutive-cycle
> substrate-introduction phase 337-341).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [sixteenth-package-side-effect-import-as-environment-upgrade-and-subset-relationship-with-named-alternative](../sections/endo--packages-lockdown-README-md--sixteenth-package-side-effect-import-as-environment-upgrade-and-subset-relationship-with-named-alternative.md) | hardened-javascript, lockdown, environment-setup, side-effect-only-package, scope-awareness, README-shape, substrate-policy-minimal | current (cycle 341, designs-lane) |

15-line README. One section with first-explicit-observations across subset-relationship-with-named-alternative + side-effect-import-as-environment-upgrade + import-statement-as-temporal-anchor + coordinate-with-SES + simply-ensures-language + two-shapes-of-export-less-package + substrate-policy-minimal-shape-confirmation.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `dd24b13d838f045d8d54354a8d704af83718e0a8`) via the local clone.
- Last substantive touch 2025-12-04 by Kris Kowal in commit `dd24b13d`.
- Apache-2.0 license per package LICENSE file.
- **SIXTEENTH package** added to the pivot cluster (cycles 310-341).
- **Substrate-policy-minimal shape** at 15 lines (above cycle 339 @endo/errors 13-line floor); §two-substrate-policy-minimal-READMEs (339 + 341).
- **§four-cycles-with-named-substrate-package-introduction** (337 + 339 + 340 + 341).
- Cycle 341 closes **eight citation arcs**; the cycle 87 arc at 254 cycles ties cycle 340's 253-cycle and cycle 339's 252-cycle as second-longest pivot arcs (current record: 261 cycles from cycle 69 → 330).
