---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/ses-ava/README.md
source_line_range: 1-113
ingested: 2026-06-15
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 361 designs-lane ingest. 113-line README for
  @endo/ses-ava, an AVA test-runner wrapper that initializes
  SES with debugging-friendly options. **TWENTY-THIRD package**
  added to pivot cluster. Ninth AUTHORED conformant single-body
  section doc in post-refactor era. Fifty-one consecutive non-
  garden sources after the pivot (310-361). §fifty-one-cycles-
  with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  explicit-unredaction-only-where-trusted — SES purposefully
  redacts error messages and stack traces for safety (to deny
  attackers visibility into internal state); ses-ava provides
  a CONTROLLED, EXPLICITLY-OPT-IN HOLE for that redaction
  specifically scoped to the test environment, which is inside
  the trust boundary. The package's REASON-FOR-EXISTENCE is
  that unredaction must NOT be the default and must NOT
  accidentally ship with production code. §the-named-trust-
  boundary-aware-unredaction-package as tier-3 meta-pattern;
  §the-named-default-safety-with-named-exception-package.

  §The-named-testing-substrate-bridge-as-package — NEW SHAPE.
  ses-ava bridges AVA (test runner) and SES (substrate). The
  twenty-third cluster member's shape is neither runtime-
  substrate, data-format, control-flow, bundling-transport,
  nor discipline-as-package; it is testing-substrate-bridge-
  as-package. Tier-3 meta-pattern §the-named-three-bridge-
  shapes-of-package: developer-discipline-bridge (cycle 359
  eslint-plugin) + testing-substrate-bridge (cycle 361 ses-ava)
  + runtime-test-262-runner (test262-runner, not yet ingested).

  §The-named-three-debugging-affordances — deep stacks of
  prior turns + unredacted stack traces + unredacted error
  messages. The first connects to @endo/eventual-send's
  turn machinery (deep async causality); the second and
  third connect to @endo/errors' redaction story.

  §The-named-devDependencies-not-dependencies-warning — README
  explicitly notes that putting ses-ava in regular
  dependencies causes bundlers to bundle all of AVA into
  production. §the-named-bundler-implication-of-dependency-
  placement as tier-3 meta-pattern.

  §The-named-multi-config-test-runner — ses-ava CLI consumes
  package.json's `avaConfigs` to run the same test source
  under multiple environments. Useful specifically for
  §the-named-Hardened-Modules: modules using `harden` to
  defend interface integrity with VARYING DEGREES of defense
  depending on lockdown composition. §the-named-Hardened-
  Modules-with-varying-defense-degrees names the formal
  concept first explicit here.

  §The-named-node-condition-as-config-flag — Node.js
  conditional exports (`ses-ava:endo` node condition) switch
  the export of `@endo/ses-ava/test.js` between raw AVA and
  wrapped AVA. The runtime environment IS the configuration.

  §The-named-honoring-old-patterns-without-deprecating —
  Compatibility section preserves the `wrapTest(rawTest)`
  pattern as still-working but explicitly recommends the new
  pattern. No deprecation warning, no removal threat; just an
  upgrade path stated.

  §The-named-rhymes-with-Nineveh-mnemonic (line 31, "SES-AVA
  rhymes with Nineveh") — playful pronunciation aid embedded
  mid-document. §the-named-pronunciation-mnemonic-aside as
  tier-3 meta-pattern; the cluster's first instance.

  Closes seven citation arcs: cycle 360 (1, adjacent forward
  pair to a peer new-shape-cluster-member) + cycle 359 (1,
  the prior NEW-SHAPE introduction of discipline-as-package)
  + cycle 343 (16, ses README provides the substrate this
  wraps) + cycle 339 (47, lockdown README first introduced
  Hardened Modules) + cycle 337 (47, harden README defended-
  interface notion) + cycle 326 (35) + cycle 322 (40, errors
  README redaction story this opens a hole in). Pushes
  citation-arc-closures-in-pivot to ONE-HUNDRED-NINETY-EIGHT
  (191 + 7 net new).
---

113-line README for @endo/ses-ava (twenty-third package in pivot cluster). Wraps AVA with SES initialization providing deep stacks + unredacted stack traces + unredacted error messages. §the-named-explicit-unredaction-only-where-trusted (single most structurally interesting move). §the-named-testing-substrate-bridge-as-package as NEW SHAPE. §the-named-three-debugging-affordances. §the-named-devDependencies-not-dependencies-warning. §the-named-multi-config-test-runner (uses `avaConfigs` to run same tests under multiple environments). §the-named-Hardened-Modules-with-varying-defense-degrees. §the-named-node-condition-as-config-flag. §the-named-honoring-old-patterns-without-deprecating. §the-named-rhymes-with-Nineveh-mnemonic. Seven citation arcs closed.
