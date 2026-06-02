---
ts: 2026-06-02T06:05:29Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/designer--159247
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
refs:
  - entries/2026/06/02/055200Z-dispatch-steward-159247.md
---

# result: designer -- #358 round-2 (incorporate maintainer answers + caching scope)

Addressed kriskowal CHANGES_REQUESTED round-2 on #358 by updating
the four layered design docs plus the README to incorporate the
body ask (registry caching behavior + retention link) and all
eight inline directives.

## Push

- Branch: `design/daemon-worker-import-from-mount`
- Push: regular append (no force), four-then-one commits over the
  prior `0257affa7` head.
- New head SHA: **`affa19d32`** (origin tracks).
- Push warnings: GitHub's standard 50-Dependabot-vulnerability
  banner on the default branch. No push-side errors.

## Commits

1. `aa9a9a5d4` design(registry-capability): conflate @registry
   slots; drop credentials; add caching+retention scope (round-2)
   - Modified: `designs/registry-capability.md`
2. `4e875c5d6` design(mvs-resolver): drop conditions from
   dep-graph scope; add workspace resolution; expand test scope
   (round-2)
   - Modified: `designs/mvs-resolver.md`,
     `designs/registry-capability.md` (small symmetric drop of
     `condition?:` from the resolve signature, plus addition of
     `workspaceRoot?:`)
3. `108e17f01` design(snapshot-mapper): adopt archive precedent
   for layout; drop endo-mount: URL scheme; link to registry
   caching (round-2)
   - Modified: `designs/snapshot-mapper.md`
4. `e78e052ba` design(daemon-worker-import-integration): reflect
   snapshot-mapper layout change (round-2)
   - Modified: `designs/daemon-worker-import-from-mount.md`
5. `affa19d32` design(README): sync snapshot-mapper prose with
   round-2 layout change
   - Modified: `designs/README.md` (three stale `endo-mount:` /
     `node_modules` prose references synced to the
     archive-precedent layout; no dependency-graph nodes or edges
     changed). Folded as a follow-up commit because the inline
     directives only touched the four layered docs, but the
     snapshot-mapper rewrite made the README's prose summary
     stale.

## Inline-comment-to-commit mapping

For the steward to resolve threads cleanly:

| Comment | File / line | Body summary | Commit |
|---------|-------------|--------------|--------|
| 1 | `designs/snapshot-mapper.md:362` | Drop endo-mount: scheme; drop node_modules convention; adopt archive precedent (top-level `compartment-map.json` + peer dirs named by package, with version for registry-resolved, without version for workspace members) | `108e17f01` |
| 2 | `designs/snapshot-mapper.md:371` | "Sure" affirming readPowers caching question; folded into registry-capability caching section | `108e17f01` (registry caching cross-link); `aa9a9a5d4` (the caching section itself) |
| 3 | `designs/registry-capability.md:422` | Run without credentials; npm packages must be public | `aa9a9a5d4` |
| 4 | `designs/registry-capability.md:408` | Keep `@registry` since it will exceed its current mission as scope changes | `aa9a9a5d4` |
| 5 | `designs/registry-capability.md:397` | Conflate the resolver/store slots into `@registry` | `aa9a9a5d4` |
| 6 | `designs/mvs-resolver.md:323` | Include peerDependencies and optionalDependencies in scope; test accordingly | `4e875c5d6` |
| 7 | `designs/mvs-resolver.md:314` | Workspace resolution: search parent package.json with workspaces enabled where the workspace is mentioned | `4e875c5d6` |
| 8 | `designs/mvs-resolver.md:300` | Conditions don't come to bear on the dependency graph; they apply at compartment-map link time, out of this doc's scope | `4e875c5d6` |

Body ask (caching behavior + hard retention link from snapshot
mapper to CAS): `aa9a9a5d4` lands the §*Caching and retention*
section in `registry-capability.md`; `108e17f01` adds the
snapshot-mapper's complement (the §*Mount snapshot before the
mapper runs* paragraph that describes the
`thisDiesIfThatDies` retention link from the captured trio
formula into the CAS trees the resolution names).

## Substantive changes per file

### `designs/registry-capability.md`
- Goals/Non-Goals: replaced the obsolete "confinement story
  (resolver-vs-store split)" goal with a "bounded-growth CAS
  retention" goal.
- §*Mount snapshot vs live read* and §*Host special name*:
  rewrote the daemon-startup configuration prose to drop
  credentials and assert public-only.
- New §*Caching and retention*: transparent refetch, bounded
  growth via CAS eviction plus LRU-bounded table, hard retention
  link from snapshot-mapper-captured formulas into the CAS.
  Includes a §*Failure surface refinements* subsection
  clarifying that eviction-driven re-fetch reuses the existing
  error classes (no new class needed).
- Phase 1 tests: added two new tests (transparent-refetch,
  hard-retention-link).
- §*Open Questions* collapsed (per editorial-pass norm) into
  §*Anti-design steers* with two one-liners (resolver/store
  split, per-host credentials).
- `resolve()` signature: dropped `condition?: string[]`, added
  `workspaceRoot?: string | EndoMount`.
- Dependencies table: added rows for
  `daemon-content-store-gc` and `retention-path-notation`;
  enriched the existing `daemon-cas-management` and
  `inventory-cancel-and-liveness` rows to call out the
  caching/retention role.
- Prompt: appended a round-2 note enumerating the body ask and
  the three inline directives.
- Metadata: added `Updated: 2026-06-02`.

### `designs/mvs-resolver.md`
- Goals: added goal #6 ("Cover workspace, peerDependencies, and
  optionalDependencies in scope, with explicit tests for each;
  conditional exports are out of scope as a linking-time
  concern").
- §*JS reference implementation shape*: rewrote the
  pseudocode. Dropped `condition` option; added a `workspaceRoot`
  option; folded peer / optional dependency walking into the
  frontier; explicit handling for workspace: specifiers; explicit
  peer cross-check after the walk; explicit unmet-optionals
  diagnostic side-channel. Updated the explanatory bullets.
- New §*Workspace resolution* section: parent-directory walk to
  find the workspace root by matching globs in the parent
  package.json's `workspaces` field. Names the workspace-wins
  semantic (workspace member's version overrides predicates) and
  the diagnostic surface when the workspace member's on-disk
  version does not satisfy an importer's range.
- §*Phased implementation* tests: added five new fixtures
  (workspace resolution, workspace member version mismatch
  diagnostic, peer satisfied, peer unmet, optional missing).
- §*Open Questions* collapsed into §*Anti-design steers* with
  two one-liners (thread condition through MVS walk; defer
  peerDeps/optionalDeps as gaps).
- Prompt: appended a round-2 note.
- Metadata: added `Updated: 2026-06-02`.

### `designs/snapshot-mapper.md`
- Summary + Goals: rewrote to name the archive-precedent layout
  instead of the `endo-mount:` URL scheme. Added an explicit
  workspace-member layout goal.
- §*Where This Sits* table: updated the mapper row description.
- §*mapSnapshot in context*: dropped the URL-scheme mention;
  named the archive precedent. Dropped `conditions?:` from the
  mapSnapshot signature sketch since conditions are not a
  graph-walk concern.
- Replaced §*ReadPowers synthesis: makeMountReadPowers* with
  §*Synthesized layout*. Defined the peer-directory naming rule
  (`<name>@<version>/` for registry-resolved entries;
  `<name>/` for workspace members; never collide). Rewrote the
  `makeMountReadPowers` JS sketch to parse compartment locations
  as `(compartmentKey, modulePath)` rather than URLs with an
  `endo-mount:` scheme.
- §*npm-shape and compartment-map-shape translation* table:
  added a row for workspace members; updated the "Package
  contents" row to drop the URL form; named both workspace and
  registry rows.
- §*Mount snapshot before the mapper runs*: appended a
  paragraph naming the hard retention link from
  registry-capability and explaining the safety mechanism.
- §*Phased implementation* tests: added two new fixtures
  (workspace member layout; workspace member coexistence with
  registry-resolved entry).
- §*Design Decisions*: rewrote decision #2 (was "one synthesized
  scheme"; now "Reuse the compartment-mapper archive precedent
  for layout"). Added decision #3 (workspace members carry no
  version segment).
- §*Open Questions* collapsed into §*Anti-design steers* with
  three one-liners (synthesized URL scheme; node_modules
  segment; separate readPowers caching layer).
- Prompt: appended a round-2 note.
- Metadata: added `Updated: 2026-06-02`.

### `designs/daemon-worker-import-from-mount.md`
- §*Where This Sits* table: updated the mapper row description.
- §*Where This Sits Among Existing Designs* convergence prose:
  points at the archive-precedent layout (the shape
  makeFromPackage and makeFromTree share) rather than the
  removed URL scheme.
- §*Worker dispatch* pseudocode: dropped the synthesized
  `entryLocation = endo-mount:/...` line; pass the bare entry
  specifier to `importLocation`. Threaded
  `conditions: options.conditions` through `importLocation`
  rather than through `mapSnapshot` or `resolve()` per the
  linking-time-not-graph-time rule.
- §*Architecture diagram*: relabeled the read-loop alt branches
  from "entry tree / dependency package (pre-resolved) /
  dependency package (late bind)" to
  "entry compartment / peer directory (pre-resolved registry
  entry or workspace member) / peer directory (late bind from
  registry)". Renamed `read(location)` to
  `read(compartmentKey, modulePath)` and `treeHash` to
  `treeRef`.
- Trailing decomposition note: appended a round-2 update
  paragraph naming the layout change and the linking-time
  conditions shift.

### `designs/README.md`
- Three prose references to `endo-mount:` / `node_modules` syned
  to the archive-precedent layout: the four-layer overview
  paragraph; the snapshot-mapper row in the summary table; the
  snapshot-mapper row in the size-estimate table.
- No dependency-graph node or edge changes (the dispatch's
  expectation).

## New open questions surfaced by round-2

The round-2 updates resolved (and removed) several open questions
on each of the four layered docs without surfacing new ones at
the same scope. Two implementation-detail open questions are
worth flagging for the implementing builder, but they are
small-enough that the builder can land them at the JS-fixture
phase rather than escalate:

1. **Workspace root discovery cost** (`mvs-resolver.md`
   §*Workspace resolution*). The "walk up the mount tree until
   the first `workspaces`-bearing package.json names the
   importer's directory" is O(depth * workspace-root size) per
   workspace-specifier edge. For deep workspaces (a typical Endo
   monorepo at depth 2: root / `packages/<name>`) this is cheap;
   for unusual nestings the resolver can memoize the
   discovered workspace root by importer-package directory. Not
   surfaced as a design open question because the memoization is
   an obvious implementation move.

2. **Workspace member with version that the registry also
   publishes** (`snapshot-mapper.md` §*Synthesized layout*
   workspace test). The layout admits a workspace `lib-b` (peer
   directory `lib-b/`) coexisting with a registry-resolved
   `lib-b@1.0.0` (peer directory `lib-b@1.0.0/`) without
   collision, but the design defers to the resolver to decide
   which one the importer's specifier binds to. The resolver
   says "workspace wins regardless of predicate"; the layout
   admits both directories to exist; the binding is on the
   resolver's side. This is consistent across the two layers,
   but a future builder may want a single integration test that
   confirms the resolver-side and layout-side stories agree
   end-to-end. Captured as a Phase-2 test in
   `snapshot-mapper.md` ("Workspace member coexistence with
   registry-resolved entry").

## Operational notes for the steward

- Five threads to resolve once the PR is rebased to head
  `affa19d32`: comments 1 through 8 above. Comment 2 ("Sure" on
  the readPowers caching question) is the one whose resolution
  lives in two commits (the registry caching section in
  `aa9a9a5d4` and the snapshot-mapper cross-link in
  `108e17f01`); the steward can resolve the thread once either
  commit is the basis for the body.
- The PR stays draft (not authorized to un-draft).
- The PR stays open (not authorized to close).
- No review threads were resolved by the designer
  (not authorized).
- No `packages/` modifications (not authorized).

Self-improvement: nothing this time.
