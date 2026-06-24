---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/where/README.md
source_line_range: 1-15
file_commit: 59e6a3cbad40b1e9fe70c5bfbf43cddab4236716
file_commit_date: 2023-01-03
file_commit_author: Kris Kowal
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 347 designs-lane ingest. **NINETEENTH package added
  to the pivot cluster** (after the eighteen named in cycle
  345). Substrate-policy-minimal shape at 15 lines —
  matches cycle 341 @endo/lockdown (15 lines) and cycle 339
  @endo/errors (13 lines); §three-substrate-policy-minimal-
  READMEs-confirms-the-shape.

  Single most structurally interesting move: §the-named-
  question-as-package-title — line 1 *"# Where is Endo?"*;
  the TITLE is a QUESTION; the package's purpose is to
  ANSWER the question; §the-named-package-title-as-question-
  form as tier-3 meta-pattern; §the-named-package-name-as-
  implicit-question — when package name is a question word
  (where + when + how + what), README can make question form
  explicit in title.

  §the-named-platform-specific-acknowledgment-of-incomplete-
  support — lines 8-13 document FOUR states of platform
  support: what we DO (use XDG conventions) + where the SPEC
  BREAKS (Windows named pipes don't fit) + the FALLBACK
  (native conventions) + what's NOT YET DONE (no separate
  state/cache dirs + no sync between Windows home
  directories); §the-named-XDG-with-named-where-the-spec-
  breaks; §the-named-named-external-spec-with-named-
  limitations as tier-3 meta-pattern — name spec AND where
  it fails to apply; §the-named-fall-back-to-native-
  conventions-when-spec-doesnt-fit; §the-named-not-yet-
  named-aspiration (softer than cycle 343 "we hope to
  obviate"); §four-cycles-with-named-explicit-acknowledgment-
  of-limits (337 isFake-regret + 343 unsafe-fast-aspiration
  + 345 precise-claims-with-caveats + 347 platform-specific-
  incomplete-support); §the-named-honest-documentation-of-
  incomplete-features-discipline as tier-3 meta-pattern.

  §the-named-where-as-user-files-and-socket-locator (two-
  part purpose: locate user files + locate daemon IPC
  endpoint); §the-named-per-user-runtime-data (named scope).

  Cycle 167 already ingested where/index.js as comment-
  fragment (named-TODO observation); cycle 347 is the
  documentation-side closure for the where-package
  observations; cycle 167 → 347 = 180 cycles.

  Closes nine citation arcs: cycle 346 = 1 cycle (cross-
  package) + cycle 345 = 2 cycles + cycle 167 = 180 cycles
  (documentation-side closure of comment-fragment ingest) +
  cycle 187 = 160 cycles + cycle 211 = 136 cycles + cycle
  339 = 8 cycles (§three-substrate-policy-minimal-READMEs)
  + cycle 341 = 6 cycles + cycle 343 = 4 cycles + cycle 345
  = 2 cycles (§four-cycles-with-named-explicit-acknowledgment-
  of-limits). Pushes citation-arc-closures-in-pivot to
  ONE-HUNDRED-TWENTY-FIVE (120 + 5 net new).
---

> Abstract: 15-line README for @endo/where — utility for
> locating user files and the Endo daemon's IPC endpoint.
> **Nineteenth package** added to the pivot cluster.
> Substrate-policy-minimal shape (15 lines) joins cycles
> 339 + 341 as third application; §three-substrate-policy-
> minimal-READMEs-confirms-the-shape.
>
> **Single most structurally interesting move**: §the-named-
> question-as-package-title — *"# Where is Endo?"*; the
> TITLE is a QUESTION the package ANSWERS; §the-named-
> package-name-as-implicit-question as tier-3 meta-pattern.
>
> §the-named-platform-specific-acknowledgment-of-incomplete-
> support — README documents FOUR states (what we do + where
> spec breaks + fallback + what's not yet done). §the-named-
> XDG-with-named-where-the-spec-breaks; §the-named-named-
> external-spec-with-named-limitations as tier-3 meta-
> pattern. §four-cycles-with-named-explicit-acknowledgment-
> of-limits (337 + 343 + 345 + 347). §the-named-honest-
> documentation-of-incomplete-features-discipline.
>
> §the-named-substrate-policy-minimal-anchor-varies-but-
> shape-is-stable — three substrate-policy-minimal READMEs
> have different anchors (threat-model + side-effect-import
> + question) but consistent structural shape.
>
> Closes nine citation arcs including 180-cycle arc to
> cycle 167's where/index.js comment-fragment ingest
> (documentation-side closure).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [nineteenth-package-question-as-package-title-and-platform-specific-acknowledgment-of-incomplete-support](../sections/endo--packages-where-README-md--nineteenth-package-question-as-package-title-and-platform-specific-acknowledgment-of-incomplete-support.md) | hardened-javascript-tooling, daemon-locator, XDG-conventions, README-shape-minimal, question-as-title, platform-specific-support | current (cycle 347, designs-lane) |

15-line README. One section covering question-as-package-title + platform-specific-acknowledgment-of-incomplete-support + named-external-spec-with-named-limitations + three-substrate-policy-minimal-READMEs-confirms-shape.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` (commit `59e6a3cbad40b1e9fe70c5bfbf43cddab4236716`) via the local clone.
- Last substantive touch 2023-01-03 by Kris Kowal.
- Apache-2.0 license per package LICENSE file.
- **NINETEENTH package** added to the pivot cluster (cycles 310-347).
- **Documentation-side closure** of cycle 167's where/index.js comment-fragment ingest (180-cycle arc).
- §three-substrate-policy-minimal-READMEs-confirms-the-shape (339 + 341 + 347).
- §four-cycles-with-named-explicit-acknowledgment-of-limits (337 + 343 + 345 + 347).
- Cycle 347 closes **nine citation arcs**; §one-hundred-twenty-five-citation-arc-closures-in-pivot-now (120 + 5 net new).
