---
source: designs/break-dev-dependency-cycles.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/break-dev-dependency-cycles.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - repository-governance
  - tooling
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sink-only-package-pattern
cycle: 186
lane: designs
status: current
---

# Sink-only synthetic test packages with five cuts, alphabetical-adjacency naming, package-namespaced `test` conditions, and illusion-of-an-option rejected

> §Designs-lane after cycle 185's chat-lane. §The-twentieth-
> consecutive designs/chat alternation cycle (166-186). §Status:
> **In Progress** — design merged 2026-05-10 via PR #206; Cuts
> 2-5 shipped 2026-05-11 → 2026-05-14; Cut 1 open as PR #261.
> §The-parent-design that cycle 180 hex-package's §"@endo/hex-
> test (Cut 2)" sentence ratified.

`break-dev-dependency-cycles.md` (736 lines, Created 2026-05-11,
Updated 2026-05-18) audits the workspace dependency graph and
proposes a §sink-only-synthetic-test-package factoring that
breaks the 13-package SCC currently formed by 18 dev-
dependency back-edges.

§The-single-most-structurally-interesting-move is §sink-only-
synthetic-test-packages-where-`sink-only-is-the-load-bearing-
constraint`. §A-package-downstream-of-the-SCC-cannot-extend-
the-SCC: that is what makes it a cycle break. §Each-cut moves
test scaffolding into a `@endo/<subsystem>-test` package whose
dependencies declare the upstream subsystems, and on which no
other workspace package depends (neither as dependencies nor
devDependencies).

## §The-survey (Tarjan SCC produces exactly one 13-package SCC)

```
@endo/compartment-mapper
@endo/evasive-transform
@endo/eventual-send
@endo/harden
@endo/hex
@endo/init
@endo/lockdown
@endo/module-source
@endo/promise-kit
@endo/ses-ava
@endo/test262-runner
@endo/zip
ses
```

§The-dependencies-only-subgraph-has-zero-non-trivial-SCCs.
§Every-cycle-is-created-by-devDependencies-back-edges. §This-
observation-is-load-bearing: the runtime layering is clean; the
test-time layering creates the cycle.

§The-18-cycle-forming-devDep-edges collapse to §four-families:

| Family | Edges | Cut |
|--------|-------|-----|
| `ses`-as-test-installer | 11 | Cut 1 → `@endo/ses-test` |
| `@endo/hex`'s test scaffold | 4 | Cut 2 → `@endo/hex-test` |
| Vestigial `@endo/zip` devDeps | 2 | Cut 3 → delete |
| `@endo/harden`'s `ses` import | 1 | Cut 4 → `@endo/harden-test` |
| Mop-up: `@endo/eventual-send` → `@endo/lockdown` + `ses` | — | Cut 5 → `@endo/eventual-send-test` |

§Each-cut-is-independent — they can land in any order. §The-
recommended-order-is-smallest-to-largest: Cut 3 (5 lines) →
Cut 4 (50 lines) → Cut 2 (30 lines) → Cut 5 (150 lines) → Cut 1
(600 lines) → final turbo.json flip.

## §The-`sink-only` constraint (the load-bearing property)

```
The proposal is a one-shot factoring that moves the test
scaffolding that creates each cycle edge into a sink-only
package: a package that declares the upstream subsystems it
tests via regular `dependencies` and on which **no other
workspace package depends** (neither as `dependencies` nor as
`devDependencies`).  Sink-only is the load-bearing constraint.
A package downstream of the SCC cannot extend the SCC; that
is what makes it a cycle break.
```

§The-prose-names-the-constraint-explicitly. §Sink-only =
§no-incoming-workspace-edges. §If-any-other-workspace-package-
ever-adds-`@endo/foo-test`-as-a-dep, the cycle break collapses.

§Compare-to-cycle-180-hex-package's §sibling-package-cloned-
file-for-file — both are §package-shape-disciplines, but
focused on different invariants. §Hex-package-discipline: clone
the skeleton. §Sink-only-discipline: don't get depended on.

§The-repo-already-has-one-such-package: `@endo/stream-types-
test`. §The-design-generalizes-that-shape, citing it as the
§existing-precedent.

## §Cut-1-eats-11-edges (the largest cut)

```
A new package packages/ses-test/.  Hosts the SES test files
currently in packages/ses/test/ that need @endo/module-source
and the test262 prelude harness driving @endo/test262-runner.
```

§The-package.json-of-`@endo/ses-test`:

```
name: @endo/ses-test
private: true
dependencies:
  ses:                        workspace:^
  @endo/module-source:        workspace:^
  @endo/test262-runner:       workspace:^
  @endo/compartment-mapper:   workspace:^
  @endo/evasive-transform:    workspace:^
  @endo/init:                 workspace:^
  @endo/ses-ava:              workspace:^
  @endo/eventual-send:        workspace:^
  @endo/lockdown:             workspace:^
  ava: catalog:dev
```

§Nine-workspace-dependencies + `ava`. §`private: true` so
`lerna publish` skips it. §No-other-workspace-package-depends-
on-`@endo/ses-test`.

§The-files-moving: 13 import-hook test files + 5 test262
preludes + 2 build scripts. §This-single-move-retires-11-
edges including the `ses` ↔ `@endo/compartment-mapper` mutual
pair.

§Compare-to-cycle-178/180/184-§phased-implementation: this
design's §recommended-order is by §estimated-diff-size, not by
§dependency-order. §The-cuts-are-independent so size-order is
the §least-friction-rollout.

## §Cut-3-is-pure-deletion (the simplest cut)

```
@endo/zip declares @endo/eventual-send and @endo/ses-ava as
devDeps but its test imports neither; it uses plain ava and
node:assert.

Decision: delete the two devDep entries.  No new package is
needed.
```

§Five-lines-of-diff. §The-§spot-audit-of-test-files (grep for
`import` from each declared devDep) §turned-up-vestigial-
entries. §A-design-that-finds-existing-mistakes is §audit-as-
cycle-break-precondition.

§Compare-to-cycle-180-hex-package's §32-row-audit-table — both
are §exhaustive-audit-drives-scope patterns. §The-§unused-
devDep-detection-via-grep is §mechanical-precision.

## §The-"illusion of an option" (Cut 4 rejected sub-option)

§Cut-4-(`@endo/harden`):

```
Considered and rejected: an in-place rewrite that replaces
each `import 'ses'` with `import './_lockdown.js'` (the file
already exists alongside the other tests in
packages/harden/test/).  `_lockdown.js` itself imports
`'ses'`, so this only renames the edge rather than cutting it.
Per kriskowal review (PR #206 [#discussion_r3216062975](...))
this is "an illusion of an option" and is dropped from the
proposal.
```

§"An illusion of an option" — kriskowal's review phrase
preserved verbatim. §The-proposed-shim-renames-the-edge-rather-
than-cutting-it because `_lockdown.js` itself imports `'ses'`.
§The-edge-from-`@endo/harden`-to-`ses` survives the rename.

§This-is-§see-through-the-form-to-the-substance discipline.
§The-rewrite looks like a cycle-break but isn't, because the
import target is still in the SCC.

§Tier-1-borrowing: §illusion-of-an-option pattern — §a-fix-
that-looks-like-a-cycle-break-but-only-renames-the-edge. §The-
substantive-test: does the cycle-break candidate live outside
the SCC?

§Compare-to-cycle-182-debugger's §three-option-architectural-
decision (A chosen; B rejected because xsDebug.c internals not
public API; C rejected because massive fork divergence). §Both-
are-§rejected-options-named-with-reasoning. §Cycle-186's
§illusion-of-an-option-rejection-language is the §sharpest in
the corpus.

## §Naming-convention-Option-B-`@endo/<subsystem>-test` (alphabetical adjacency)

```
Adopted per kriskowal review (PR #206 [...]):
"I prefer this option on the grounds that the package and its
test package will be adjacent in the list."

The suffix `-test` says "test harness" and matches the existing
`@endo/stream-types-test` precedent exactly, so no rename of
that package is needed.
```

§Two-design-axes-considered:

- **Option A**: `@endo/test-<subsystem>` — groups synthetic
  packages alphabetically under `packages/test-*/`. §Rejected-
  because-it-loses-§alphabetical-adjacency between subject and
  test.
- **Option B**: `@endo/<subsystem>-test` — sorts test
  immediately after subject. §Chosen.

§The-rationale-named: "Each synthetic package sorts immediately
after the package it tests (both in `packages/` directory
listings and in alphabetical `package.json` lookups), which
makes it easy to find the test package next to its subject."

§Compare-to-cycle-180-hex-package's §sibling-package-cloned-
file-for-file naming. §Both-are-§adjacent-naming-as-
discoverability disciplines. §Hex-package: clone the source's
filename pattern. §This-design: sort the test next to its
subject.

## §The-`test`-condition mechanism (resolved with package-namespacing)

§For-internal-only-test-surfaces, the design proposes §test-
conditioned-subpath-exports:

```json
{
  "name": "@endo/foo",
  "exports": {
    ".": "./src/index.js",
    "./src/*": {
      "test-endo-foo": "./src/*"
    }
  }
}
```

§The-`test-endo-foo` condition is §package-namespaced, not bare
`test`. §The-rationale: "A package-specific condition preserves
visibility into which internals the test surface relies on; a
bare `test` shared across every package would degenerate into
'internal access from any test-mode caller', erasing the
public-interface unreachability the pattern is meant to
enforce."

§Compare-to-cycle-175-make-selector.js' §Symbol.for-as-
coordination-slot — both use §named-slots-instead-of-bare-
generics to preserve §which-realm-owns-this-channel. §Cycle-
175: Symbol.for('harden') vs other Symbol.for slots. §Cycle-
186: `test-endo-foo` vs bare `test`.

§The-§best-practice-named: "Name the test-conditioned subpaths
after their filesystem location and expose them through a
single subpath-pattern entry rather than one entry per file."

§Two-named-benefits:

- §The-literal-path-form works in environments that ignore the
  `exports` directive at all (bundlers reading files directly).
- §One-subpath-pattern-entry-replaces-N-per-file-entries (§add-
  another-test-surface-is-a-no-op-in-package.json).

## §Five-Resolved-Decisions (all settled in PR #206 review)

| Topic | Resolution |
|-------|------------|
| Helper utilities | No `@endo/test-utils` package; duplicate fixtures across `<subsystem>-test` packages |
| Internal-only test surfaces | Use the `test-endo-<package>` condition (package-namespaced) |
| `@endo/zip` cleanup | Delete unused devDeps (no synthetic package) |
| Cut 4 (`@endo/harden`) | Move to `@endo/harden-test` (in-place rewrite was "an illusion") |
| Naming convention | Option B `@endo/<subsystem>-test` |
| Cut 5 test262 scripts | Move with the test files |
| `dependsOn: ["build"]` workaround | Retires once cycle is broken; flip to `^build` |

§Each-resolution-cites-the-PR-review-discussion that fixed it.
§The-§Resolved-Decisions-section is §the-archive-of-validated-
choices made during review iteration.

§Compare-to-cycle-180-hex-package's §five-known-gaps + cycle
178's §revised-scope-discussion + cycle 184's §design-
evolution-record-in-prompt-section. §All-four-record-design-
evolution; §this-design-records-review-iteration explicitly via
§PR-discussion-link-per-resolution.

## §The-§"I'm fine with duplication where necessary to avoid a utils package"

```
"I'm fine with duplication where necessary to avoid a utils
package."
```

§Kris's-design-philosophy-named: §duplication-preferred-over-
indirection-that-creates-cycles. §A-`@endo/test-utils`-package
would itself need to depend on `@endo/init` and reintroduce
the cycle.

§The-design-explains-why: "They are not pure test helpers;
they are full SES installers and AVA wrappers that are also
legitimately consumed at runtime by downstream packages. The
synthetic-package approach moves the *consumers* (the tests
themselves), not the helpers, which preserves the helpers'
public surface."

§Compare-to-cycle-167-where/index.js' §when-in-Rome (per-
platform naming conventions duplicated rather than abstracted)
+ cycle 170's §map-to-existing-substrate-not-parallel-
abstractions. §All-three-are-§prefer-duplication-over-
indirection patterns at different scales.

## §The-§cycle-is-cosmetic-noise-not-fatal (the motivation)

```
The cycle is not strictly fatal for affected-set selection
(`...[origin/llm]` walks the same workspace graph turbo would
walk for `^build`, so downstream packages are still selected
when an upstream changes), but the cosmetic noise on every CI
log conflicts with the project's silent-by-default diagnostic
discipline, and the per-task cache hash is weaker than it
could be.
```

§Three-cited-costs:

1. **§Cosmetic-noise** — turbo prints a multi-line cycle
   warning at the start of every invocation; clutters CI logs.
2. **§Silent-by-default-discipline-conflict** — Endo's
   project-wide diagnostic discipline (cycle 183-init's
   `console.warn` is the §exception-not-the-rule) is violated
   by per-invocation noise.
3. **§Weaker-per-task-cache-hash** — without `^build`, the
   `test`/`lint` task hashes don't include upstream package
   build hashes, so the cache is more permissive than
   correctness allows.

§None-of-these-is-fatal-alone, but together they §motivate-the-
factoring. §Compare-to-cycle-180-hex-package's §three-concrete-
costs of duplication (inconsistent semantics + native fast-
paths only wired up in one package + no canonical home). §Both-
designs-name-the-motivating-costs-as-a-three-bullet-list.

## §Roadmap-calibration (per `git blame`)

```
Active development: 2026-05-10 → present (ongoing; Cut 1 open).
  Cuts 2-5 landed within a 4-day burst.
Design phase: 2026-05-10 → 2026-05-11 (2 days).
Implementation phase: 2026-05-11 → 2026-05-14 so far (4 days
  for Cuts 2-5; Cut 1 remains open).
```

§Two-day-design-phase + §four-day-burst-for-Cuts-2-5 + §Cut-1-
still-open. §The-§roadmap-calibration-via-git-blame discipline
(cycle 168 + cycle 180).

§Compare-to-cycle-178-snapshot's §revised-scope-discussion
+ cycle 184-metering's all-seven-phases-Complete. §This-
design's-status: §four-of-five-cuts-shipped-within-a-week +
§the-largest-remaining-as-open-PR.

§The-§cuts-can-land-independently property explains the rapid
shipping rhythm: each PR is small and self-contained. §Cycle-
174-gateway-package's §strategic-vs-tactical-phase-numbering
(4 strategic + 11+ tactical PRs) is a similar §multi-PR-rhythm
but at a larger scale.

## §Future-Work (the §next-cycle-of-cleanups)

```
Once the cycles are broken and turbo is configured for ^build,
several follow-ups become attractive:
- Remove the multi-paragraph "Why not ^build?" section from
  turbo.json.md and replace it with a one-paragraph note...
- Pick the --conditions=test threading form...
- Audit the rest of the workspace (the 52 packages outside the
  SCC) for less-impactful devDep edges...
- Land the upstream dependencyTypes flag in turborepo as a
  defense-in-depth...
```

§Four-named-follow-ups. §The-§audit-the-rest-of-the-workspace
item points to §the-cycle-detection-discipline applying beyond
the SCC. §The-§upstream-dependencyTypes-flag item points to §a
§defense-in-depth-against-future-cycle-regression.

§Compare-to-cycle-180's §five-known-gaps + cycle 184's §six-
known-gaps. §All-three-are-§named-follow-ups-as-honest-design-
disclosure.

## §Cohesion notes

- §Sink-only-synthetic-test-packages is the §load-bearing-
  constraint. §A-package-downstream-of-the-SCC-cannot-extend-
  the-SCC.
- §Five-cuts collapse 18 cycle-forming devDep edges into four
  families. §Cuts-are-independent and §can-land-in-any-order.
- §Tarjan-SCC-survey identifies exactly one 13-package SCC;
  §dependencies-only-subgraph has zero non-trivial SCCs.
- §"An illusion of an option" — §a-fix-that-looks-like-a-
  cycle-break-but-only-renames-the-edge. §Reject-via-substance-
  test: does the candidate live outside the SCC?
- §Naming-convention-Option-B `@endo/<subsystem>-test` for
  §alphabetical-adjacency (sort test immediately after subject).
- §Test-condition-package-namespacing (`test-endo-foo` not
  bare `test`) to preserve §which-realm-owns-this-channel.
- §"I'm fine with duplication where necessary to avoid a utils
  package" — §duplication-preferred-over-indirection-that-
  creates-cycles. §The-utils-package-would-itself-need-cycle-
  forming-deps.
- §Five-Resolved-Decisions cited with PR review discussion
  links. §Review-iteration-archived-in-design.
- §Three-cited-costs-of-the-cycle: cosmetic noise +
  silent-by-default conflict + weaker cache hash.
- §Four-day-burst-for-Cuts-2-5 + §Cut-1-still-open. §Cuts-can-
  land-independently rhythm.
- §Audit-as-cycle-break-precondition: vestigial devDep
  detection via grep retires Cut 3 with zero new packages.
- §Parent-design-of-cycle-180-hex-package's-§"@endo/hex-test
  (Cut 2)" sentence. §Cycle-180-ratified-this-design's-Cut-2.

## §Tier-1 borrowing

- §sink-only-synthetic-test-packages (no incoming workspace
  edges = can't extend an SCC)
- §the-cycle-is-all-in-devDependencies discipline (audit by
  removing dev edges first; see if cycles persist)
- §"an illusion of an option" rejection-language for §a-fix-
  that-looks-like-a-cycle-break-but-only-renames-the-edge
- §package-namespaced-conditions (`test-endo-foo` not bare
  `test`) to preserve realm ownership
- §duplication-preferred-over-indirection-that-creates-cycles
  ("I'm fine with duplication")
- §alphabetical-adjacency-naming (test sorts immediately after
  subject)
- §cuts-can-land-independently rhythm (each PR small + self-
  contained; ordered by diff size)
- §audit-as-cycle-break-precondition (grep for unused devDeps
  before adding new packages)
- §review-iteration-archived-in-design (PR discussion links
  per Resolved Decision)
- §exhaustive-Tarjan-SCC-survey as §motivation-evidence
- §three-cited-costs-of-the-cycle (cosmetic-noise + silent-by-
  default-conflict + weaker-cache-hash)

## §Synthesis-target

The §slot-machine-library's workspace (when it has one) can
§borrow-the-sink-only-test-package-pattern from day one rather
than retrofitting after cycles form. §The-§Option-B-naming-
convention (`@endo/<subsystem>-test`) is the canonical
adjacency-preserving form.

§The-§"illusion of an option" diagnostic is borrowable for any
§cycle-break-candidate: ask "does this candidate live outside
the SCC?" If the answer is "no, it just renames the edge,"
the candidate is an illusion.

§The-§package-namespaced-condition pattern (`test-endo-foo`)
is borrowable for any §internal-surface-exposed-only-to-a-
specific-consumer scenario; it preserves the §minimal-
visibility-radius that a bare `test` condition erodes.
