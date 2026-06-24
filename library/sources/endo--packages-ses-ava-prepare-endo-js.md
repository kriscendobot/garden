---
source_kind: source
source_repo: endojs/endo
source_path: packages/ses-ava/prepare-endo.js
source_line_range: 1-27
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 362 chat-lane ingest paired to cycle 361 designs-lane
  @endo/ses-ava README. 27-line canonical user-facing entry
  point that initializes SES + sets debug env vars + wraps AVA
  test. Tenth AUTHORED conformant single-body section doc in
  post-refactor era. Fifty-two consecutive non-garden sources
  after the pivot (310-362). §fifty-two-cycles-with-named-pivot-
  domain-stay.

  Single most structurally interesting move: §the-named-env-
  vars-as-cross-package-config-channel — the implementation
  reveals that the THREE README-named debugging affordances
  (deep stacks + unredacted stacks + unredacted messages) are
  delivered NOT by patching SES or AVA, but by MUTATING process
  env vars at module load time so that other modules
  (@endo/init/debug.js, @endo/env-options, the SES Assert
  machinery) consult those env vars at their own initialization.
  The env IS the cross-package configuration bus, even when all
  participants are JavaScript modules in the same process.

  §The-named-additive-env-modification — lines 15-21 don't
  clobber existing DEBUG; if `DEBUG` is set they append
  `track-turns` to it. §the-named-augment-not-clobber as
  tier-3 meta-pattern; respects existing user configuration
  while adding the package's own needs.

  §The-named-three-shapes-of-design-vs-implementation-arc-from-
  README-to-source as tier-3 framing — THIRD instance after
  cycles 357→358 (ABSTRACTING: README abstract → source
  concrete bytes) and 359→360 (UNDERCOUNTING: README enumeration
  < source enumeration). The third shape: §the-named-what-vs-
  how-arc — README states the WHAT (three debugging
  affordances); source reveals the HOW (env-var mutation as
  the delivery mechanism). Three instances establish the
  framing: §the-named-three-shapes-of-design-vs-implementation-
  arc.

  §The-named-two-init-imports-in-order — line 3 imports
  `@endo/init/pre-remoting.js` and line 4 imports
  `@endo/init/debug.js`. The pre-remoting init must precede
  debug init; the source establishes the ORDER as explicit
  imports. §the-named-imports-as-ordered-side-effect-sequence
  as tier-3 meta-pattern (sibling to cycle 344's @endo/init
  rung-as-entry-point shape).

  §The-named-eslint-disable-as-deliberate-rule-carveout —
  line 26 carries `// eslint-disable-next-line no-restricted-
  exports`. The file uses `export { test as default }` which
  the project's base ESLint config disallows; the disable
  comment EXPLICITLY opts out for this single line. The
  carve-out is NECESSARY because the README's canonical import
  pattern is `import test from '@endo/ses-ava/prepare-endo.js'`
  which requires a default export. The discipline package's
  rules (cycle 359-360 @endo/eslint-plugin) interact with this
  file: the file is a deliberate, named, single-line carve-out
  in a known location. §the-named-carveout-located-at-readme-
  canonical-entry-point as tier-3 meta-pattern.

  §The-named-TODO-in-source-as-known-gap — line 10 carries
  `// TODO consider adding env option setting APIs to @endo/
  env-options`; line 11 carries `// TODO should set up
  globalThis.process.env if absent`. The file ships with TWO
  acknowledged gaps. Pairs with cycle 359's §the-named-
  unfilled-supported-rules-section as a sibling shape of
  in-source-honest-incompleteness. §the-named-honest-gap-
  named-as-TODO as tier-3 meta-pattern.

  §The-named-TRACK_TURNS-env-var — line 13 sets
  `env.TRACK_TURNS = 'enabled'`. This is the env-var name
  that turns on the eventual-send turn-tracking machinery —
  the substrate behind the README's "deep stacks of prior
  turns" affordance. §the-named-deep-stacks-via-track-turns-
  env-var ties the README's named affordance to its
  underlying mechanism.

  Closes seven citation arcs: cycle 361 (1, adjacent forward
  pair README → source, third instance of design-vs-
  implementation-arc) + cycle 360 (1, the cycle that
  established the meta-pattern with two instances; this
  cycle's third instance establishes the three-shapes
  framing) + cycle 358 (1, the cycle 358 zip instance now
  has a third sibling) + cycle 344 (17, @endo/init rung-as-
  entry-point) + cycle 207 (33, @endo/env-options is the
  module that reads the env vars this file mutates) + cycle
  322 (41, errors README redaction story this opens a
  named-channel through) + cycle 359 (1, eslint-plugin
  rules from cycle 359 explicitly carved out in this file
  at line 26). Pushes citation-arc-closures-in-pivot to
  TWO-HUNDRED-FIVE (198 + 7 net new).
---

27-line `prepare-endo.js` for @endo/ses-ava, the canonical user-facing entry point named in cycle 361's README. Chat-lane after cycle 361 designs-lane README. §the-named-env-vars-as-cross-package-config-channel (single most structurally interesting move — env IS the bus). §the-named-additive-env-modification (don't clobber, augment). §the-named-three-shapes-of-design-vs-implementation-arc-from-README-to-source as tier-3 framing (ABSTRACTING + UNDERCOUNTING + WHAT-VS-HOW). §the-named-two-init-imports-in-order (pre-remoting then debug). §the-named-eslint-disable-as-deliberate-rule-carveout (line 26 `no-restricted-exports` carve-out at README-canonical-entry-point). §the-named-TODO-in-source-as-known-gap (TWO TODOs in 27 lines). §the-named-TRACK_TURNS-env-var (mechanism behind README's "deep stacks"). Seven citation arcs closed.
