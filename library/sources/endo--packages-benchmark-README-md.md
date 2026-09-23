---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/benchmark/README.md
source_line_range: 1-8
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 363 designs-lane ingest. 8-line README for
  @endo/benchmark, a private (never-published, `"private":
  true`) internal-tooling package providing "a minimalistic
  ava-like interface to run benchmark tests" across V8 and XS
  engines via eshost+esvu. **TWENTY-FOURTH package** added to
  pivot cluster. Eleventh AUTHORED conformant single-body
  section doc in post-refactor era. Fifty-three consecutive
  non-garden sources after the pivot (310-363). §fifty-three-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-cross-
  engine-substrate-benchmarking-explains-the-package — the
  package exists because Endo's substrate must perform
  acceptably on BOTH V8 (mainstream JS engine) AND XS
  (Moddable's embedded JS engine), and verifying that requires
  running JS code on both engines uniformly via eshost. The
  README's mention of "V8 and XS engines in $HOME/.esvu" is
  the reveal: this is not a generic benchmark tool, it is
  specifically for §the-named-cross-engine-substrate-
  benchmarking. §the-named-V8-and-XS-as-the-two-target-engines
  names the engine pair Endo cares about most.

  §The-named-private-package-as-internal-tooling — NEW SHAPE.
  Twenty-fourth cluster member opens a tier-3 meta-pattern
  peer to runtime-substrate-package + data-format-package +
  control-flow-package + bundling-transport-package +
  discipline-as-package + testing-substrate-bridge-as-package.
  The shape is: `"private": true` in package.json, version
  pre-1.0 (0.1.4), empty index.js (0 lines), 8-line README,
  39-line implementation in src/benchmark.js. Internal-only.
  Never published. §the-named-private-true-not-for-npm-
  publication.

  §The-named-readme-defines-by-analogy-to-external-package —
  README says "ava-like interface" rather than defining the
  interface. The design specification is DELEGATED to an
  external reference (AVA). The 8-line minimalism IS the
  design choice: the consumer is presumed to know AVA, and
  the package's surface area is "AVA but for benchmarks".
  §the-named-readme-as-pointer-to-external-conventions as
  tier-3 meta-pattern.

  §The-named-eshost-as-cross-engine-runner — the eshost tool
  is the mechanism that lets the benchmark code execute on
  multiple JS engines uniformly. §the-named-install-engines-
  script (`yarn install-engines`) ensures V8 and XS are
  installed via esvu (the JS engine version manager). §the-
  named-V8-and-XS-engines-via-esvu names the install path.

  §The-named-empty-index-js-private-package-pattern — the
  package's `"main"` and `"exports"` point at an empty
  index.js. The package exposes literally nothing via the
  package boundary. Its only interface is `yarn test`. This
  is consistent with `"private": true`: a package that is
  never consumed externally needs no exported surface area.
  §the-named-script-as-interface-not-imports as tier-3
  meta-pattern.

  §The-named-the-eslint-plugin-ses-ava-benchmark-trilogy —
  cycles 359 + 361 + 363 introduce three peer development-
  affordance packages: discipline (eslint-plugin), testing-
  substrate-bridge (ses-ava), private-cross-engine-
  benchmarking (benchmark). The three shapes of development-
  affordance-package crystallize as a trilogy.

  §The-named-eight-line-minimal-readme — sibling shape to
  cycle 357's @endo/zip 57-line README and cycle 361's @endo/
  ses-ava 113-line README. The minimal README is consistent
  with the private-package shape: no need for documentation
  polish when there is no external audience. §the-named-
  documentation-effort-proportional-to-public-audience as
  tier-3 meta-pattern.

  This cycle's relationship to the three-shapes-of-design-vs-
  implementation-arc framing (established in cycle 362):
  benchmark does NOT fit any of the three shapes cleanly.
  It is not ABSTRACTING (no concrete-vs-abstract pairing); it
  is not UNDERCOUNTING (the README does not attempt enumeration
  at all); it is not WHAT-VS-HOW (the README does not state
  the WHAT clearly enough to compare to source HOW). The
  three-shapes framing applies to packages where the README
  ATTEMPTS to describe the implementation; benchmark's README
  DELEGATES the description to AVA-conventions. §the-named-
  three-shapes-framing-presumes-readme-attempts-description —
  the framing is bounded; the benchmark cycle reveals the
  boundary without breaking the framing.

  Closes seven citation arcs: cycle 362 (1, adjacent forward
  pair ses-ava prepare-endo.js → benchmark README) + cycle
  361 (1, both ava-related: ses-ava IS AVA-wrapping, benchmark
  is "ava-like"; sibling shapes) + cycle 360 (1, three-shapes
  framing presumes-description; benchmark is the bounding
  case) + cycle 359 (1, completes the development-affordance-
  trilogy: discipline + testing-bridge + benchmark) + cycle
  339 (48, lockdown's cross-engine concerns) + cycle 337 (48,
  harden's cross-engine performance is what this measures) +
  cycle 326 (36). Pushes citation-arc-closures-in-pivot to
  TWO-HUNDRED-TWELVE (205 + 7 net new).
---

8-line README for @endo/benchmark (twenty-fourth package in pivot cluster). Private (`"private": true`) internal-tooling for cross-engine substrate benchmarking. §the-named-cross-engine-substrate-benchmarking-explains-the-package (single most structurally interesting move — V8 + XS via eshost). §the-named-private-package-as-internal-tooling as NEW SHAPE. §the-named-readme-defines-by-analogy-to-external-package ("ava-like interface" delegates spec to AVA). §the-named-empty-index-js-private-package-pattern. §the-named-the-eslint-plugin-ses-ava-benchmark-trilogy (cycles 359+361+363 form the development-affordance-package trilogy). §the-named-three-shapes-framing-presumes-readme-attempts-description (benchmark is the bounding case). Seven citation arcs closed.
