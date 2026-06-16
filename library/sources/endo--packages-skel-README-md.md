---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/skel/README.md
source_line_range: 1-3
ingested: 2026-06-16
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 365 designs-lane ingest. 3-line README for @endo/skel,
  the skeleton-package-template used as the starting point for
  new @endo/* packages. **TWENTY-FIFTH package** added to pivot
  cluster. Thirteenth AUTHORED conformant single-body section
  doc in post-refactor era. Fifty-five consecutive non-garden
  sources after the pivot (310-365). §fifty-five-cycles-with-
  named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  template-package-where-package-json-is-blueprint-and-README-
  is-placeholder — the package has DUAL NATURE. The 3-line
  README reads literally `# [name]\n\nThis `[package]` package
  is a skeleton package.` with explicit `[name]` and
  `[package]` markup-placeholders for human substitution. The
  package.json is the BLUEPRINT: full real values that the
  derivative inherits unchanged (lint config, test scripts,
  prepack/postpack hooks, devDependencies on @endo/lockdown and
  @endo/ses-ava, publishConfig, files allowlist). When you
  copy skel/ to create a new package, you replace [name] and
  [package] in the README and you keep the package.json
  almost as-is. §the-named-readme-has-placeholders-package-
  json-has-blueprint as tier-3 meta-pattern.

  §The-named-meta-template-package-as-skeleton — NEW SHAPE.
  Twenty-fifth cluster member opens a tier-3 meta-pattern peer
  to runtime-substrate-package + data-format-package + control-
  flow-package + bundling-transport-package + discipline-as-
  package + testing-substrate-bridge-as-package + private-
  package-as-internal-tooling. The shape is: a package that
  exists to be COPIED rather than IMPORTED. §the-named-package-
  meant-to-be-copied-not-imported as the tier-3 meta-pattern.

  §The-named-the-eslint-plugin-ses-ava-benchmark-skel-quartet
  — cycles 359 + 361 + 363 + 365 introduce four peer
  development-affordance packages: discipline (eslint-plugin)
  + testing-substrate-bridge (ses-ava) + private-cross-engine-
  benchmarking (benchmark) + meta-template (skel). The
  trilogy from cycle 363 is now a quartet. §the-named-four-
  development-affordance-package-shapes.

  §The-named-private-with-publish-config-for-derivatives —
  package.json carries BOTH `"private": true` AND
  `"publishConfig": { "access": "public" }`. The contradiction
  resolves only when you understand: skel itself is private
  (never published), but the publishConfig is BLUEPRINT for
  derivatives — copies of skel that REMOVE the `private: true`
  flag will publish to npm using the publishConfig that
  travels unchanged from the skeleton.

  §The-named-skel-extends-internal-config — eslintConfig says
  `extends: ["plugin:@endo/internal"]`. Skel is internal-to-
  Endo by definition (every @endo/* package starts as a copy
  of skel); the internal config (cycle 359 §the-named-internal-
  rules-only-for-source-repo) is the right baseline for the
  template. The lint discipline package (cycle 359) and the
  template package (cycle 365) interact at the eslintConfig
  level: the template hard-codes the internal config so every
  derivative starts with it.

  §The-named-skel-uses-ses-ava-CLI — package.json `test:c8`
  script is `c8 ${C8_OPTIONS:-} ses-ava`, invoking the
  cycle 361 ses-ava CLI (its multi-config test runner). The
  template hard-codes this so every derivative starts with
  the SES-AVA + c8 coverage scaffold.

  §The-named-skel-devDependencies-on-lockdown-and-ses-ava —
  package.json devDependencies hard-code @endo/lockdown
  (cycle 339) and @endo/ses-ava (cycle 361). The template
  expects every derivative to depend on these for testing
  under Hardened JS.

  §The-named-test-xs-yields-trivially-in-skeleton — `test:xs`
  script is `exit 0`. The XS test for the skeleton itself is
  a no-op; the derivative provides the real test.

  §The-named-explicit-null-description-as-placeholder —
  package.json `"description": null` (explicit null, not
  empty string). The derivative replaces null with prose.
  §the-named-typed-null-as-placeholder-not-empty-string as
  tier-3 meta-pattern; the JSON shape declares "this field
  exists but has no value yet" via the null literal.

  §The-named-readme-with-explicit-placeholder-markup — the
  README uses brackets `[name]` and `[package]` as a
  human-readable placeholder convention. Not a templating
  language (no `{{ name }}`); just markup that humans
  recognize as "fill in here". §the-named-placeholder-as-
  bracketed-name as tier-3 meta-pattern.

  §The-named-living-template — because skel is a workspace
  package, it gets dependency updates, lint runs, and
  CHANGELOG entries (version 1.1.13 as of ingest). The
  template stays current with the rest of the monorepo's
  conventions; copying skel today gives you a derivative
  that starts in the present, not in the past.

  Closes eight citation arcs: cycle 364 (1, adjacent forward
  pair benchmark source → skel README, both private-package
  shape but distinct sub-shapes) + cycle 363 (1, private-
  package-as-internal-tooling extends to meta-template-
  package; quartet established) + cycle 362 (1, ses-ava
  CLI consumed by skel's test:c8 script) + cycle 361 (1,
  ses-ava devDependency hard-coded in skel) + cycle 360 (1,
  eslint-plugin's `internal` config is the skel's
  eslintConfig.extends) + cycle 359 (1, eslint-plugin
  package itself ships the internal config skel uses) +
  cycle 339 (50, lockdown devDependency hard-coded) + cycle
  326 (38, pure-naming-as-discipline sibling). Pushes
  citation-arc-closures-in-pivot to TWO-HUNDRED-TWENTY-SEVEN
  (219 + 8 net new).
---

3-line README for @endo/skel (twenty-fifth package in pivot cluster). The README is a placeholder with `[name]` and `[package]` markup; the package.json is the blueprint that derivatives inherit. §the-named-template-package-where-package-json-is-blueprint-and-README-is-placeholder (single most structurally interesting move). §the-named-meta-template-package-as-skeleton as NEW SHAPE. §the-named-the-eslint-plugin-ses-ava-benchmark-skel-quartet (four development-affordance package shapes). §the-named-private-with-publish-config-for-derivatives (the contradiction resolves: private itself, publishConfig for copies). §the-named-skel-extends-internal-config (cycle 359-360 lint discipline hard-coded). §the-named-skel-uses-ses-ava-CLI. §the-named-skel-devDependencies-on-lockdown-and-ses-ava. §the-named-test-xs-yields-trivially-in-skeleton. §the-named-explicit-null-description-as-placeholder. §the-named-readme-with-explicit-placeholder-markup. §the-named-living-template. Eight citation arcs closed.
