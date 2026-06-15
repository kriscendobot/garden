---
source_kind: source-cluster
source_repo: endojs/endo
source_path: packages/ses/{index.js,lockdown.js,lockdown-shim.js,compartment-shim.js,console-shim.js,assert-shim.js}
source_line_range: 1-23 (across 6 files; 1-18 lines each)
file_commit: 0a5c55585613298358d9fb78d1765347756e15b1
file_commit_date: 2024-03-08
file_commit_author: Mark S. Miller
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 346 chat-lane ingest. Six tiny @endo/ses top-level
  entry-point files totaling **23 lines** (five 1-line
  forwarders + one 18-line aggregator with Apache header).
  Adjacent forward pair with cycle 345 designs-lane @endo/ses
  README. **THIRTEENTH INSTANCE of one-cycle README↔source
  pattern** (cycle 345 → 346 same-package); §the-named-
  streak-resumes-with-thirteenth-instance.

  Single most structurally interesting move: §the-named-
  single-line-forwarder-as-stability-barrier — each top-level
  file (except index.js) is one line: `import './src/X.js';`.
  The file system structure creates a stable API surface;
  the src/ implementation can move without breaking
  importers. This is HOW cycle 342 @endo/lockdown's `import
  'ses';` works.

  §the-named-rung-as-entry-point-vs-stability-via-thin-
  forwarder as tier-3 meta-pattern — TWO shapes of tiny-file
  orchestration: cycle 344 @endo/init's tiny files are
  RUNG-AS-ENTRY-POINT (each = config variant); cycle 346
  @endo/ses's tiny files are STABILITY-VIA-THIN-FORWARDER
  (each = stable URL for internal module); §two-shapes-of-
  tiny-files-orchestration. Both are orchestration-via-
  import-graph (cycle 344's tier-3 meta-pattern) but with
  different orchestration purposes.

  §the-named-two-modes-of-package-installation as tier-3
  meta-pattern: all-or-nothing (`import 'ses';` →
  lockdown.js → index.js → all four shims) + à-la-carte
  (`import 'ses/compartment-shim.js';` → only one component);
  §the-named-all-or-nothing-vs-a-la-carte-install; §the-
  named-index-js-aggregates-all-shims; §the-named-
  individual-shim-files-allow-partial-installation.

  §the-named-license-header-as-most-of-the-file — index.js
  has 14 lines of license header to 4 lines of code (ratio
  ~3.5:1); §the-named-six-tiny-files-with-license-header-
  dominating; §the-named-license-header-only-on-aggregator
  as tier-3 meta-pattern — discipline-marker for tiny-file
  clusters.

  §the-named-foundational-package-has-thinnest-entry-cluster
  as tier-3 meta-pattern — cycle 344 @endo/init (8 files ~66
  lines) for variant-selection; cycle 346 @endo/ses (6 files
  23 lines) for API-stability; the MORE foundational package
  has the SMALLER entry-point cluster; §the-named-stability-
  correlates-inversely-with-cluster-size — the thin entry
  cluster signals interface stability.

  Closes eight citation arcs: cycle 345 = 1 cycle (adjacent
  forward pair) + cycle 344 = 2 cycles (§two-shapes-of-
  tiny-files-orchestration) + cycle 342 = 4 cycles (`import
  'ses';` resolves to this cluster) + cycle 341 = 5 cycles
  + cycle 339 = 7 cycles (errors coordinates with ses) +
  cycle 337 = 9 cycles + cycle 183 = 163 cycles (init+
  lockdown bootstrap cluster) + cycle 187 = 159 cycles
  (promise-kit/shim and base64/shim install AFTER ses).
  Pushes citation-arc-closures-in-pivot to ONE-HUNDRED-
  TWENTY (116 + 4 net new).
---

> Abstract: Six tiny @endo/ses top-level entry-point files
> totaling **23 lines** — five one-line forwarders + one
> 18-line aggregator. Adjacent forward pair with cycle 345
> README. **THIRTEENTH INSTANCE** of one-cycle README↔source
> pattern.
>
> **Single most structurally interesting move**: §the-named-
> single-line-forwarder-as-stability-barrier — top-level
> files are one-line `import './src/X.js';` wrappers
> creating a stable API surface; the src/ implementation
> can move without breaking importers.
>
> §the-named-rung-as-entry-point-vs-stability-via-thin-
> forwarder as tier-3 meta-pattern — TWO shapes of tiny-
> file orchestration (cycle 344 init = config variants +
> cycle 346 ses = stable URLs); §two-shapes-of-tiny-files-
> orchestration.
>
> §the-named-two-modes-of-package-installation (all-or-
> nothing + à-la-carte); §the-named-index-js-aggregates-
> all-shims; §the-named-individual-shim-files-allow-partial-
> installation.
>
> §the-named-license-header-as-most-of-the-file (14:4 ratio
> in index.js); §the-named-license-header-only-on-aggregator
> as tier-3 meta-pattern.
>
> §the-named-foundational-package-has-thinnest-entry-cluster
> — depth in architecture inversely correlates with cluster
> size; §the-named-stability-correlates-inversely-with-
> cluster-size.
>
> Closes eight citation arcs. §one-hundred-twenty-citation-
> arc-closures-in-pivot-now.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [thirteenth-one-cycle-pair-single-line-forwarder-as-stability-barrier-and-two-modes-of-package-installation](../sections/endo--packages-ses-entry-cluster--thirteenth-one-cycle-pair-single-line-forwarder-as-stability-barrier-and-two-modes-of-package-installation.md) | hardened-javascript, substrate-package, entry-point-cluster, stability-via-thin-forwarder, two-modes-of-installation, foundational-package-thinness | current (cycle 346, chat-lane) |

23-line cluster. One section covering single-line-forwarder + two-modes-of-installation + license-header-only-on-aggregator + foundational-package-has-thinnest-entry-cluster.

## Provenance

- Fetched 2026-06-15 from `endojs/endo@HEAD` via the local clone.
- index.js last touched 2024-03-08 by Mark S. Miller in commit `0a5c5558`.
- Apache-2.0 license per package LICENSE file and inline in index.js.
- **Thirty-seventh consecutive non-garden source after the pivot** (cycles 310-346).
- **Thirteenth INSTANCE of one-cycle README↔source pattern** (cycle 345 → 346 same-package).
- Cycle 346 closes **eight citation arcs**; §one-hundred-twenty-citation-arc-closures-in-pivot-now (116 + 4 net new).
