---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/init/README.md
source_line_range: 1-52
file_commit: dd24b13d838f045d8d54354a8d704af83718e0a8
file_commit_date: 2025-12-04
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 343 designs-lane ingest. **SEVENTEENTH package added
  to the pivot cluster** (nat + memoize + hex + lp32 + stream
  + eventual-send + exo + captp + pass-style + patterns +
  marshal + common + promise-kit + harden + errors +
  lockdown + **init**). Substrate-policy-mid shape at 52
  lines — fills the gap between substrate-policy-minimal
  (13-15 lines from cycles 339/341) and substrate-policy-
  prose (158 lines from cycle 337); §the-named-fifty-two-
  line-policy-deep-README; §the-named-substrate-policy-shape-
  spans-three-length-ranges. §six-shapes-of-README — refines
  cycle 339's five-shape categorization with a sixth shape.

  Single most structurally interesting move: §the-named-
  enumeration-of-side-effects-as-package-purpose — lines
  3-7 enumerate FIVE specific actions the package performs
  on import: (1) sets up HardenedJS including locking it
  down; (2) sets the realm up for Eventual Send; (3) ensures
  atob is present; (4) ensures btoa is present; (5) ensures
  promises can be hardened regardless of platform. §the-
  named-five-named-actions-performed-on-import; §the-named-
  side-effect-only-package-with-enumerated-side-effects as
  tier-3 meta-pattern — side-effect-only packages SHOULD
  enumerate their side effects in the README; the enumeration
  is the *contract* for what the import accomplishes. §three-
  cycles-with-named-side-effect-only-package (187 shim
  cluster + 341 lockdown + 343 init).

  §the-named-default-is-fully-locked-down (line 9 — *"By
  default, the environment is fully locked down and as safe
  as we can make it for cotenant host and guest programs"*);
  §the-named-cotenant-host-and-guest-programs; §two-cycles-
  with-named-cotenant-threat-model (339 errors + 343 init).

  §the-named-three-entry-point-tolerance-ladder-named-in-
  README — three named entry points (@endo/init default +
  @endo/init/debug.js + @endo/init/unsafe-fast.js); §the-
  named-hr-separator-as-section-divider (Markdown `---`
  between sections); §the-named-three-rung-ladder-default-
  debug-unsafe-fast; §three-shapes-of-safety-vs-performance-
  tradeoff-exposure (cycle 183 entry-point-files + cycle
  337 build-conditions + cycle 343 entry-point-ladder-with-
  named-rationale).

  §the-named-debug-as-less-safe-but-conducive-to-debugging
  (non-pejorative phrasing); §the-named-detailed-rationale-
  for-each-debug-option — per-option documentation (error
  Taming + stackFiltering + overrideTaming); §two-shapes-
  of-per-option-discipline (cycle 342 NOTE-TO-REVIEWERS in
  source + cycle 343 per-option rationale in README).

  §the-named-cross-package-compensation-named — *"The
  @endo/ses-ava package compensates for the case of Ava
  specifically"*; §the-named-ses-ava-compensates-for-Ava-
  specifically; §the-named-cross-package-compensation-
  mechanism as tier-3 meta-pattern — when defaults conflict
  with a tool's expectations, the architectural solution is
  a compensation package rather than weakening the defaults;
  §three-shapes-of-compatibility-strategy (cycle 187
  conditional-install + cycle 187 unconditional-replacement
  + cycle 343 cross-package-compensation).

  §the-named-unsafe-fast-with-named-regret-and-named-
  aspiration — *"Avoid using `@endo/init/unsafe-fast.js`.
  It is an extreme measure we hope to obviate"*; §the-named-
  extreme-measure-we-hope-to-obviate; §the-named-existing-
  entry-point-with-named-aspiration-to-remove as tier-3
  meta-pattern; §two-cycles-with-named-honest-regret-with-
  named-aspiration (cycle 337 isFake-deprecated-with-named-
  regret + cycle 343 unsafe-fast-named-aspiration).

  Closes nine citation arcs: cycle 342 = 1 cycle + cycle 341
  = 2 cycles + cycle 340 = 3 cycles + cycle 339 = 4 cycles +
  cycle 337 = 6 cycles + cycle 183 = 160 cycles (init+
  lockdown 12-file cluster comment-fragment first observation
  of init's tolerance-ladder) + cycle 187 = 156 cycles (shim
  cluster — @endo/init/pre-remoting + @endo/init/debug) +
  cycle 87 = 256 cycles (errorTaming-safe-redacts-stack
  observation; NEW second-longest pivot arc after 261-cycle
  record) + cycle 211 = 132 cycles (@endo/common dependency-
  ceiling names the substrates @endo/init coordinates).
  Pushes citation-arc-closures-in-pivot to NINETY-EIGHT
  (89 + 9 net new); approaching 100-arc milestone.

  §six-cycles-with-named-substrate-package-introduction
  (337 + 339 + 340 + 341 + 342 + 343); §the-named-substrate-
  package-cluster-introduction-trend-extends-to-seven-cycles
  (337-343).
---

> Abstract: 52-line README for @endo/init — the canonical
> entry point for setting up an Endo JavaScript realm.
> **Seventeenth package** added to the pivot cluster.
> **Substrate-policy-mid shape** (52 lines; fills the gap
> between substrate-policy-minimal 13-15 lines and
> substrate-policy-prose 158 lines).
>
> **Single most structurally interesting move**: §the-named-
> enumeration-of-side-effects-as-package-purpose — the
> README enumerates FIVE specific actions performed on
> import (HardenedJS setup + Eventual Send setup + atob/btoa
> + promise hardening). §the-named-side-effect-only-package-
> with-enumerated-side-effects as tier-3 meta-pattern.
>
> §the-named-default-is-fully-locked-down + §the-named-
> cotenant-host-and-guest-programs; §two-cycles-with-named-
> cotenant-threat-model (339 + 343).
>
> §the-named-three-entry-point-tolerance-ladder-named-in-
> README — three named entry points each with own section;
> §the-named-hr-separator-as-section-divider; §three-shapes-
> of-safety-vs-performance-tradeoff-exposure (183 entry-
> point-files + 337 build-conditions + 343 entry-point-
> ladder-with-rationale).
>
> §the-named-debug-as-less-safe-but-conducive-to-debugging;
> §the-named-detailed-rationale-for-each-debug-option;
> §two-shapes-of-per-option-discipline (342 NOTE-TO-REVIEWERS
> + 343 per-option rationale).
>
> §the-named-cross-package-compensation-named — @endo/ses-
> ava compensates for Ava specifically; §the-named-cross-
> package-compensation-mechanism as tier-3 meta-pattern;
> §three-shapes-of-compatibility-strategy (conditional-
> install + unconditional-replacement + cross-package-
> compensation).
>
> §the-named-unsafe-fast-with-named-regret-and-named-
> aspiration — *"avoid using... extreme measure we hope to
> obviate"*; §the-named-existing-entry-point-with-named-
> aspiration-to-remove; §two-cycles-with-named-honest-regret-
> with-named-aspiration (337 + 343).
>
> §six-shapes-of-README — refines cycle 339's five-shape
> categorization with substrate-policy-mid as sixth shape.
>
> Closes nine citation arcs including 256-cycle arc to cycle
> 87 (NEW second-longest pivot arc). §six-cycles-with-named-
> substrate-package-introduction (337-343); §the-named-
> substrate-package-cluster-introduction-trend-extends-to-
> seven-cycles.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [seventeenth-package-enumeration-of-side-effects-as-package-purpose-and-three-rung-tolerance-ladder-named-in-README](../sections/endo--packages-init-README-md--seventeenth-package-enumeration-of-side-effects-as-package-purpose-and-three-rung-tolerance-ladder-named-in-README.md) | hardened-javascript, side-effect-only-package, tolerance-ladder, cross-package-compensation, README-shape, substrate-policy-mid | current (cycle 343, designs-lane) |

52-line README. One dense section with first-explicit-observations across enumeration-of-side-effects + cotenant-threat-model + three-entry-point-ladder + per-option rationale + cross-package compensation + honest-regret-with-aspiration + six-shapes-of-README.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `dd24b13d838f045d8d54354a8d704af83718e0a8`) via the local clone.
- Last substantive touch 2025-12-04 by Kris Kowal in commit `dd24b13d`.
- Apache-2.0 license per package LICENSE file.
- **SEVENTEENTH package** added to the pivot cluster (cycles 310-343).
- **Substrate-policy-mid shape** at 52 lines — fills the gap between substrate-policy-minimal (13-15 lines from cycles 339 errors + 341 lockdown) and substrate-policy-prose (158 lines from cycle 337 harden).
- §six-shapes-of-README — refines cycle 339's five-shape categorization with substrate-policy-mid as the sixth shape.
- §the-named-substrate-policy-shape-spans-three-length-ranges — minimal (13-15) + mid (52) + prose (158).
- §six-cycles-with-named-substrate-package-introduction (337 + 339 + 340 + 341 + 342 + 343); §the-named-substrate-package-cluster-introduction-trend-extends-to-seven-cycles.
- Cycle 343 closes **nine citation arcs**; the cycle 87 arc at **256 cycles** is the new second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).
