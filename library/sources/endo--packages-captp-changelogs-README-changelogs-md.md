---
source_kind: repo-doc
source_repo: endojs/endo
source_path: packages/captp/changelogs/README-changelogs.md
source_line_range: 1-13
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 379 designs-lane ingest. 13-line README describing
  the per-PR per-package changelog file convention used in
  selected @endo packages (captp + marshal both have
  identical copies). Twenty-seventh AUTHORED conformant
  single-body section doc in post-refactor era. Sixty-nine
  consecutive non-garden sources after the pivot (310-379).
  §sixty-nine-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-two-
  changelog-systems-coexist — the @endo monorepo runs BOTH
  the newer `.changeset/*.md` system (at repo root, consumed
  by @changesets/cli) AND this older per-package
  `changelogs/$ISSUENUMBER.txt` system (in select packages
  like captp + marshal, consumed by a NEWS.md generator).
  In-progress-migration evidence; the older system survives
  in packages that haven't fully moved over. §the-named-
  evidence-of-in-progress-migration-via-coexistence as
  tier-3 meta-pattern.

  §The-named-per-PR-changelog-file-named-by-issue-number —
  the convention is `$ISSUENUMBER.txt` per file (one file
  per PR). The FILENAME carries the cross-reference; the
  contents describe the downstream-visible changes. §the-
  named-filename-as-issue-number-as-cross-reference as
  tier-3 meta-pattern.

  §The-named-downstream-visible-changes-as-recording-scope —
  line 2-5: "describe any downstream-visible changes in it
  (one per line). For libraries, this should include
  anything a developer using this library needs to know when
  they upgrade to the new version (API changes, new
  features, significant bugs fixed)." Scope is explicitly
  *consumer-facing*: a downstream developer is the imagined
  reader. §the-named-consumer-facing-changelog-scope as
  tier-3 meta-pattern.

  §The-named-empty-file-as-acknowledged-no-downstream-change
  — lines 5-7: "If the PR only makes internal changes
  (refactorings, documentation updates), you should still
  add a file, but leave it empty." Honest discipline: every
  PR must have a changelog entry; empty file is the answer
  when no downstream effect. The system requires the
  AUTHOR to make an explicit no-downstream-change
  declaration; you cannot silently skip the changelog step.
  §the-named-empty-file-as-explicit-no-change-declaration
  as tier-3 meta-pattern; sibling to cycle 359's §the-
  named-honest-placeholder-not-hidden-gap and cycle 378's
  §the-named-honesty-via-shared-lie — another shape of
  enforced-explicit-acknowledgment-in-source.

  §The-named-concatenation-into-NEWS-md-during-release —
  lines 8-10: "These files will be concatenated together
  and added to the NEWS.md file during the release process.
  Their filenames will be used to indicate which issues
  were closed in the release." The aggregation is
  mechanical: concatenate text bodies, render filenames as
  issue links. The release process consumes the per-PR
  files; the developer doesn't write the aggregate. §the-
  named-mechanical-aggregation-from-per-PR-files as tier-3
  meta-pattern.

  §The-named-top-level-developer-docs-pointer — line 12:
  "See the top-level developer docs for more details." The
  per-package README defers to the repo-level docs for the
  authoritative description; the package's README is a
  pointer + summary. §the-named-package-README-as-pointer-
  to-repo-docs as tier-3 meta-pattern.

  §The-named-identical-README-in-multiple-packages — captp
  and marshal carry IDENTICAL 13-line copies of this README.
  The system isn't centralized in repo-level docs (despite
  the pointer in line 12); each package gets its own copy.
  §the-named-duplicated-convention-doc-across-packages as
  tier-3 meta-pattern; the project has consciously chosen
  to copy the convention into each package's
  changelogs/ directory rather than centralize. (Possible
  motivation: the changelogs/ directory is intentional per-
  package documentation that ships with the package via
  npm; centralized docs in /docs would not.)

  §The-named-system-restricted-to-some-packages-not-all —
  not every @endo package has a changelogs/ directory. The
  ones that do (captp, marshal, others) appear to be the
  ones that participated in the older changelog system
  before .changeset/ adoption. New packages (eslint-plugin,
  ses-ava, benchmark, skel — the post-pivot quartet) do
  NOT use the per-package changelogs system. §the-named-
  legacy-discipline-not-applied-to-new-packages as tier-3
  meta-pattern; in-progress migrations often look like this
  — old packages keep both systems, new packages start
  fresh with only the new one.

  Closes seven citation arcs: cycle 378 (1, adjacent forward
  pair tame-harden source → changelog convention doc; both
  surface honest-discipline shapes in different domains) +
  cycle 359 (1, honest-placeholder-not-hidden-gap sibling;
  empty-file-as-explicit-no-change is another shape of
  enforced-explicit-acknowledgment) + cycle 378 (1, honesty-
  via-shared-lie sibling shape) + cycle 365 (1, skel as
  template; this doc is implicitly part of the
  template/blueprint discipline — packages copy from skel
  but skel itself has no changelogs/ directory, evidencing
  the legacy-not-applied-to-new-packages observation) +
  cycle 363 (1, benchmark also has no changelogs/) + cycle
  326 (53, pure-naming-as-discipline; FILENAME-as-issue-
  number-as-cross-reference is pure naming) + cycle 322
  (53, @endo/errors; the changelog system documents what
  the consumer needs to know when upgrading, including
  changed error behavior). Pushes citation-arc-closures-in-
  pivot to THREE-HUNDRED-THIRTY-TWO (325 + 7 net new).
---

13-line README describing the per-PR per-package changelog file convention used in selected @endo packages (captp + marshal both have identical copies). §the-named-two-changelog-systems-coexist (single most structurally interesting move — newer `.changeset/*.md` + older `changelogs/$ISSUENUMBER.txt`; in-progress migration evidence). §the-named-evidence-of-in-progress-migration-via-coexistence. §the-named-per-PR-changelog-file-named-by-issue-number (FILENAME carries cross-reference). §the-named-downstream-visible-changes-as-recording-scope (consumer-facing). §the-named-empty-file-as-acknowledged-no-downstream-change (every PR must have an entry; empty file is the no-change declaration; sibling honest-discipline shape from cycles 359/378). §the-named-concatenation-into-NEWS-md-during-release. §the-named-top-level-developer-docs-pointer. §the-named-identical-README-in-multiple-packages (duplicated convention doc). §the-named-system-restricted-to-some-packages-not-all (legacy-discipline-not-applied-to-new-packages; cycle 359/361/363/365 post-pivot quartet has no changelogs/). Seven citation arcs closed.
