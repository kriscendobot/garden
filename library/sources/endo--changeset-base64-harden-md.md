---
source_kind: changeset
source_repo: endojs/endo
source_path: .changeset/base64-harden.md
source_line_range: 1-13
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 380 chat-lane ingest paired to cycle 379 designs-lane
  @endo/captp changelogs README. 13-line `.changeset` entry
  announcing a base64 hardening change; concrete instance of
  the modern changeset system that cycle 379's meta-
  observation contrasted against the legacy per-package
  system. Twenty-eighth AUTHORED conformant single-body
  section doc in post-refactor era. Seventy consecutive non-
  garden sources after the pivot (310-380). §seventy-cycles-
  with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-
  changeset-as-cross-package-version-bump-declaration —
  the YAML frontmatter (lines 1-4) declares TWO packages
  bumping simultaneously: `'@endo/base64': minor` and
  `'@endo/bundle-source': patch`. A single changeset can
  span MULTIPLE packages in the monorepo, each with its
  own semver-level bump declared in one place. §the-named-
  single-changeset-multiple-packages-different-bumps as
  tier-3 meta-pattern. The author declares the impact
  shape (which packages, what level); the changesets tool
  later aggregates these declarations across PRs to
  determine the next release versions.

  §The-named-frontmatter-as-version-bump-declaration — the
  YAML frontmatter is the structured metadata; the body is
  the human-readable description. §the-named-yaml-
  frontmatter-as-tool-input-prose-as-human-output as tier-
  3 meta-pattern. Tools read the frontmatter; humans read
  the body; the two halves serve different audiences.

  §The-named-named-exports-now-frozen-as-breaking-shape —
  lines 6-7: "`@endo/base64`'s named exports (`encodeBase64`,
  `decodeBase64`, `atob`, `btoa`) are now frozen." Four
  named exports listed explicitly; the change is naming-
  level. §the-named-exhaustive-enumeration-in-breaking-
  change-note as tier-3 meta-pattern; the reader can scan
  for their own usage rather than parsing prose.

  §The-named-error-mode-named-in-changeset — lines 8-9:
  "Consumers that previously assigned to or extended these
  exports will see a `TypeError` under SES; read-only
  consumers are unaffected." The break manifests as a
  named runtime error (TypeError) and is bounded to
  consumers who were mutating the exports. §the-named-
  break-bounded-to-mutating-consumers as tier-3 meta-
  pattern; the author tells the reader exactly which
  consumers are affected and how.

  §The-named-read-only-consumers-unaffected — the contrast
  with the mutating consumers makes the impact precise:
  read = safe; mutate = breaks. The discipline of telling
  the reader which side they're on. §the-named-precise-
  impact-bounded-by-consumer-shape as tier-3 meta-pattern.

  §The-named-pre-lockdown-shim-entry-point-unchanged —
  lines 11-13: "The shim entry point `@endo/base64/shim.js`
  (which `@endo/init/pre.js` uses to install
  `globalThis.atob` / `globalThis.btoa` before `lockdown()`)
  is unchanged and continues to be safe to load pre-
  lockdown." The shim layer is EXPLICITLY exempt from the
  break, with the load-ordering invariant named (pre-
  lockdown). The change-author calls out the specific entry
  point that consumers of the shim subpath shouldn't worry
  about. §the-named-shim-subpath-exempt-from-breaking-
  change as tier-3 meta-pattern.

  §The-named-globalThis-installation-before-lockdown — the
  parenthetical on lines 11-12 names the @endo/init/pre.js
  pattern: install globalThis.atob and globalThis.btoa
  BEFORE lockdown freezes the realm. After lockdown the
  globals can't be added. §the-named-pre-lockdown-global-
  installation-as-bootstrap-discipline as tier-3 meta-
  pattern; this is the order-of-operations discipline that
  makes pre-lockdown a structural concept, not just a
  point in time.

  §The-named-thirteen-line-changeset-with-rich-structure —
  the entire change communication fits in 13 lines: 3-line
  frontmatter, 1-line blank, 4-line prose paragraph
  describing breaks, 1-line blank, 3-line prose paragraph
  describing exemption. The compactness IS the discipline.
  Sibling shape to cycle 369's @endo/daemon (14-line README
  for substantial system) and cycle 363's @endo/benchmark
  (8-line README). §the-named-changeset-as-minimal-but-
  rich as tier-3 meta-pattern; the system rewards terse
  authors but still allows enumeration where precision
  matters.

  §The-named-bundle-source-patched-because-it-depends — the
  bundle-source bump is `patch` because base64 is its
  dependency. Bundle-source's behavior doesn't change but
  it pulls in a new minor version of base64; the patch bump
  signals "no API change, just dependency refresh." §the-
  named-cascading-bump-via-dependency-update as tier-3
  meta-pattern; the changesets tool encodes the dependency
  graph implicitly via the bump declarations.

  Closes seven citation arcs: cycle 379 (1, adjacent forward
  pair changelog-system-meta-doc → concrete changeset
  instance; the cycle 379 META observation gets a CONCRETE
  example here) + cycle 359 (1, eslint-plugin discipline
  composes with breaking-change-via-freeze; the lint
  config probably catches mutation-of-exports before this
  TypeError fires) + cycle 339 (58, lockdown is named as
  the moment after which globals can't be added) + cycle
  344 (18, @endo/init's pre.js bootstrap discipline named
  explicitly) + cycle 364 (2, base64 was the cluster's
  first data-format-package; cycle 380 shows the package
  being further hardened years later) + cycle 326 (54,
  pure-naming-as-discipline; named-exports-now-frozen is
  pure naming applied to the export surface) + cycle 322
  (54, @endo/errors TypeError is the specific error type
  named). Pushes citation-arc-closures-in-pivot to THREE-
  HUNDRED-THIRTY-NINE (332 + 7 net new).
---

13-line .changeset entry for the base64 hardening change. Chat-lane after cycle 379 designs-lane changelog-system-meta-doc. §the-named-changeset-as-cross-package-version-bump-declaration (single most structurally interesting move — YAML frontmatter declares TWO packages bumping with different semver levels in one file). §the-named-yaml-frontmatter-as-tool-input-prose-as-human-output (tools read frontmatter; humans read body). §the-named-named-exports-now-frozen-as-breaking-shape (exhaustive enumeration in breaking change note). §the-named-error-mode-named-in-changeset (TypeError; break bounded to mutating consumers). §the-named-read-only-consumers-unaffected (precise impact bounded by consumer shape). §the-named-pre-lockdown-shim-entry-point-unchanged (shim subpath exempt from breaking change). §the-named-globalThis-installation-before-lockdown (pre-lockdown global installation as bootstrap discipline). §the-named-thirteen-line-changeset-with-rich-structure (sibling minimal-but-rich shape from cycles 363/369). §the-named-bundle-source-patched-because-it-depends (cascading bump via dependency update). Seven citation arcs closed.
