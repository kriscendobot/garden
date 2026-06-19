---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/check-bundle/README.md
source_line_range: 1-13
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 397 designs-lane ingest. 13-line README for @endo/
  check-bundle, the package that verifies bundle integrity.
  Forty-fifth AUTHORED conformant single-body section doc
  in post-refactor era. Eighty-seventh consecutive non-
  garden source after the pivot (310-397). §eighty-seven-
  cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  four-Cs-of-bundle-validation — line 4 names four
  alliterative criteria for bundle integrity: "consistency,
  completeness, coherence, and conciseness (no extra
  files)". The alliteration is mnemonic; the parenthetical
  on conciseness reveals its sharp meaning ("no extra
  files"). §the-named-alliterative-criteria-as-mnemonic-
  set as tier-3 meta-pattern; the four C-words are
  intentionally a SET, not a list — the alliteration
  signals that the four are co-equal aspects of the same
  concept.

  §The-named-conciseness-as-no-extra-files — line 4: the
  parenthetical defines conciseness as "no extra files."
  Bundle validation REJECTS bundles that include files
  beyond what the bundle declares. §the-named-strict-set-
  not-superset as tier-3 meta-pattern; the bundle is the
  EXACT set declared, not a superset.

  §The-named-internal-hashes-plus-one-external-hash —
  line 3: "inspects all of its internal hashes and its
  one external hash." The bundle has MANY internal hashes
  (one per included file or per content-addressed slot)
  and ONE external hash (presumably the bundle's own hash
  as known by the caller). §the-named-many-internal-one-
  external-hash-structure as tier-3 meta-pattern; the
  bundle is content-addressed at two levels — its
  contents and itself.

  §The-named-checkBundle-as-bundle-integrity-verifier —
  the function's name names its purpose. §the-named-self-
  documenting-function-name-purpose as tier-3 meta-
  pattern.

  §The-named-rejected-promise-as-failure-signal — line 5:
  "returns a rejected promise if the bundle fails the
  check." Asymmetric return: success resolves (with
  nothing meaningful); failure rejects. The contract is
  binary at the promise level. §the-named-binary-promise-
  contract as tier-3 meta-pattern; cycle 392's setup-ws-
  relay.js returned a result string on success; cycle 397
  checkBundle returns nothing on success, just resolves.
  Different conventions for different package shapes.

  §The-named-bundle-is-JSON-serializable — line 9 comment
  "'bundle' is JSON-serializable". The bundle is a plain
  data structure (no live capabilities) and can be passed
  through any JSON-compatible boundary. §the-named-bundle-
  as-plain-data-not-capability as tier-3 meta-pattern.

  §The-named-must-run-in-Endo-environment — line 13:
  "This must run in an Endo environment. To run on Node.
  js, import `@endo/init` before importing `@endo/import-
  bundle`." The package depends on the Endo runtime
  (SES + lockdown). §the-named-Endo-environment-as-
  runtime-precondition as tier-3 meta-pattern.

  §The-named-init-import-as-environment-precondition —
  the README references `@endo/init` as the way to
  prepare the Endo environment on Node.js. Cycle 344
  ingested @endo/init; cycle 397 reveals one of its
  consumer-facing roles. §the-named-init-as-import-side-
  effect-environment-setup as tier-3 meta-pattern.

  §The-named-thirteen-line-README-for-validation-package
  — sibling shape to cycle 363 (8-line @endo/benchmark
  README), cycle 365 (3-line @endo/skel README), cycle
  369 (14-line @endo/daemon README), cycle 380 (13-line
  changeset). The §the-named-minimal-README-for-
  substantial-system shape recurs.

  §The-named-import-bundle-named-as-runtime-companion —
  line 13 mentions @endo/import-bundle alongside @endo/
  init. The check-bundle README POINTS to import-bundle
  as the package consumer would use. §the-named-validation-
  paired-with-runtime-consumer as tier-3 meta-pattern;
  the validator and the loader are explicitly companion
  packages.

  Closes seven citation arcs: cycle 396 (1, adjacent
  forward; daemon types.d.ts API surface → check-bundle's
  validation API surface; both 21-line and 13-line
  package public APIs) + cycle 371 (3, @endo/compartment-
  mapper builds bundles; @endo/check-bundle validates
  them; complementary packages) + cycle 369 (7, daemon
  README named application runner; bundles are what the
  application runner runs) + cycle 344 (19, @endo/init
  named as the runtime precondition import) + cycle 363
  (3, minimal-README-for-substantial-system sibling) +
  cycle 326 (71, pure-naming-as-discipline; four-Cs is
  pure naming applied to the criteria set) + cycle 322
  (71). Pushes citation-arc-closures-in-pivot to FOUR-
  HUNDRED-FIFTY-EIGHT (451 + 7 net new).
---

13-line README for @endo/check-bundle. §the-named-four-Cs-of-bundle-validation (single most structurally interesting move; consistency + completeness + coherence + conciseness; alliterative mnemonic set); §the-named-alliterative-criteria-as-mnemonic-set. §the-named-conciseness-as-no-extra-files; §the-named-strict-set-not-superset (bundle is EXACT set declared not superset). §the-named-internal-hashes-plus-one-external-hash (bundle content-addressed at two levels); §the-named-many-internal-one-external-hash-structure. §the-named-checkBundle-as-bundle-integrity-verifier; §the-named-self-documenting-function-name-purpose. §the-named-rejected-promise-as-failure-signal; §the-named-binary-promise-contract (success resolves with nothing meaningful; failure rejects). §the-named-bundle-is-JSON-serializable; §the-named-bundle-as-plain-data-not-capability. §the-named-must-run-in-Endo-environment; §the-named-Endo-environment-as-runtime-precondition. §the-named-init-import-as-environment-precondition (cycle 344 init as consumer-facing role); §the-named-init-as-import-side-effect-environment-setup. §the-named-thirteen-line-README-for-validation-package (sibling minimal-but-rich shape). §the-named-import-bundle-named-as-runtime-companion; §the-named-validation-paired-with-runtime-consumer. Seven citation arcs closed.
