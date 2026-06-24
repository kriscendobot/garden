---
ts: 2026-06-08T02:24:00Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 96
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/96
---

# Result: researcher refinement for builder dispatch on PR #96

## Summary

The proposed builder dispatch is the off-pattern shape on `endo-but-for-bots`: a design-only PR (currently `designs/compartment-mapper-auxiliary-package-json.md` only, base `llm`) is being asked by the maintainer to rebase onto `master` and grow an implementation in place, overriding the standing "designs on `llm`, implementations on `master`" split. The implementation has to extract a package-descriptor cache out of `node-modules.js`, add a two-question API (`findEnclosingCompartmentRoot`, `collectLanguageOverrides`), thread the cache through `mapNodeModules` and its relatives (`archive`, `bundle`, `import`), and export a sibling constructor that wires the cache by default. Test plan in the design names four named cases and reuses the existing `fixtures-nested-pkg` and `fixtures-no-name` fixtures. This refinement points the builder at the upstream `compartment-mapper` README sections in the library that describe the existing architecture being modified, the project README rules that codify the split the maintainer is now overriding, the precursor PR #70 whose diagnostic this design replaces, and the source-tree landmarks the builder will edit.

## Refinement section to inline

```markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sources/endo--pkg-compartment-mapper-readme.md`](../../library/sources/endo--pkg-compartment-mapper-readme.md): the `@endo/compartment-mapper` README ingested as a five-section source (overview, evaluating-from-filesystem, writing-archive, evaluating-from-archive, language-extensions). Whole-package context for the package being modified.
- [`journal/library/sections/endo--pkg-compartment-mapper-readme--language-extensions.md`](../../library/sections/endo--pkg-compartment-mapper-readme--language-extensions.md): the existing `languageForExtension`, `moduleLanguageForExtension`, `commonjsLanguageForExtension`, and `parsers` (package.json) machinery the design extends with a per-prefix layered shape (`languageForExtensionByPrefix`). Read first; the design's new field name must compose with this surface.
- [`journal/library/sections/endo--pkg-compartment-mapper-readme--evaluating-from-filesystem.md`](../../library/sections/endo--pkg-compartment-mapper-readme--evaluating-from-filesystem.md): describes the `importLocation` / `loadLocation` entry points that ultimately consume `mapNodeModules`'s output. Useful to understand which call sites get the new `packageDescriptorCache` option and the new sibling constructor.
- [`journal/library/sections/endo--pkg-compartment-mapper-readme--writing-archive.md`](../../library/sections/endo--pkg-compartment-mapper-readme--writing-archive.md): `writeArchive` / `makeArchive` flow. Phased Implementation §6 names `archive`, `bundle`, and `import` as needing the same `packageDescriptorCache` option; this section anchors the `archive` side. `importArchive` is the noted exception (fully described compartment map already pins per-module language).
- [`journal/library/sections/endo--pkg-compartment-mapper-readme--overview.md`](../../library/sections/endo--pkg-compartment-mapper-readme--overview.md): one-paragraph framing for compartments + per-package authority; orients a reader who is new to the package on what a "compartment mapper" actually does.

(No keyword entries for `auxiliary descriptor`, `package-descriptor-cache`, `findEnclosingCompartmentRoot`, `collectLanguageOverrides`, `readDescriptorUpwards`, `searchDescriptor`, `inferParsers`, or `languageForExtensionByPrefix` exist in the library yet; the design itself is the canonical source for these terms until implementation lands and a scholar pass ingests them.)

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Rules of engagement: codifies the *bot-fork roadmap branch: `llm` (designs); implementation base: `master` (implementations)* split that the maintainer's directive on PR #96 ("Please rebase on master and proceed to implement in place, in this PR") is explicitly overriding for this PR. The builder should rebase onto `master`, retarget the PR's base to a frozen-base snapshot of `master`, and grow the implementation on the same head branch (`design/compartment-mapper-auxiliary-package-json`) without opening a sibling PR.
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md) § Standing authorizations: the broad-comment authorization for `endojs/endo-but-for-bots` applies. The builder may post the in-place transition summary, reply on any open inline threads after the rebase, and request re-review without per-action authorization in the dispatch prompt.
- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md): the rebase-and-retarget mechanic. Mint `master-<short-sha>` at `origin/master`'s current tip, push, rebase the head onto it, retarget the PR's base via `gh pr edit --base master-<short-sha>`, then force-with-lease the head. The existing base `llm` is left as the design-only floor; the new base is the implementation floor.
- [`garden/roles/builder/AGENT.md`](../../../garden/roles/builder/AGENT.md) § Operating norms, *A design that lives on the roadmap branch is read, not branched-from*: the standing reference shape (Node-18-drop `#232` design on `llm` plus `#246` implementation on `master`) is precisely the shape the maintainer is overriding here; the builder should note in the PR's transition summary that this PR is the off-pattern dual-purpose case (design + implementation on one PR, base moved to `master`) and that the design's body stays in `designs/compartment-mapper-auxiliary-package-json.md` as the in-tree spec.
- [`journal/entries/2026/05/21/064124Z-result-designer-9c1d4d.md`](../9c1d4d): the most recent designer dispatch on this same PR, which locked the field name (`languageForExtensionByPrefix`), the sibling-constructor pattern (`mapNodeModulesWithAuxiliary`), the `importArchive` exception, and the policy-out-of-scope decision. Head SHA on `design/compartment-mapper-auxiliary-package-json` is `725b3d3d3` from that dispatch; the builder's rebase target is `origin/master` and the design file should fast-forward through unchanged when the head is replayed onto `master`.

### Project source-tree landmarks (read on `master`, not `llm`)

- `packages/compartment-mapper/src/node-modules.js`: holds today's private `memo` keyed by `packageLocation` and the `readDescriptor` closure built around it. Phased Implementation §1 extracts both into the new `package-descriptor-cache.js` sibling. The `MapNodeModulesOptions` type extension (§3) lives in this file.
- `packages/compartment-mapper/src/search.js`: the `searchDescriptor`/`findPackage` upward walk the design replaces. The new walk transparently skips past auxiliary (no-`name`) descriptors and falls through to the PR #70 diagnostic only when no named ancestor exists.
- `packages/compartment-mapper/src/{import,archive,bundle}.js`: the relatives that funnel through `mapNodeModules` (Phased Implementation §6). Each accepts the same `packageDescriptorCache` option and gets a sibling constructor that injects a default cache. `packages/compartment-mapper/src/import-archive.js` is the noted exception (fully described compartment map already pins per-module language; auxiliary lookup has no work to do).
- `packages/compartment-mapper/src/extension.js` and the `parse-*.js` family: the parser dispatch the layered `languageForExtensionByPrefix` field feeds. At parse time, the deepest matching prefix's map is used.
- `packages/compartment-mapper/test/fixtures-nested-pkg/`: the existing canonical reproducer fixture (`node_modules/apackage/afolder/package.json` contains `{"type": "module"}`). The auxiliary type-scoping test case reuses this fixture; the existing `nested-pkg.test.js` is the regression check for the cache-omitted path.
- `packages/compartment-mapper/test/fixtures-no-name/`: PR #70's fixture. The PR #70 diagnostic regression test reuses this; the entry sits inside a fully anonymous package with no named ancestor, so the diagnostic must still fire.
- `packages/compartment-mapper/test/{nested-pkg,no-name,language-for-extension,extension}.test.js`: existing test files in the same idiom the new tests should match. New fixtures for nested-auxiliary and named-vs-unnamed disambiguation cases land alongside; the new test file (working name `auxiliary-package-json.test.js` or similar) follows the same `ava`-style structure.

### Precursor PR

- `endojs/endo-but-for-bots#70` (`feat(compartment-mapper): diagnose package.json without a name (#1845)`, base `master`, not yet merged): adds the "must have a `name` field" diagnostic this design's auxiliary case relaxes for *intermediate* unnamed descriptors. The diagnostic remains as the floor; only the named-ancestor-found path changes. The builder must verify the new behavior does not break PR #70's test (`no-name.test.js`) and should consider rebase ordering: if PR #70 lands first, the builder rebases onto its merge commit; if PR #96's implementation lands first, the diagnostic source moves with it. Stop at impasse and surface the discrepancy if PR #70's `node-modules.js` edits conflict materially with the cache extraction.

### Upstream tracking issue

- `endojs/endo#1845`: the upstream tracking issue for the original "no name" diagnostic the precursor PR addresses; the design is the deeper fix promised in PR #70's review thread. The builder need not interact with this issue (no per-action authorization required); cite it in the PR body if the body is rewritten for the implementation transition.
```

## Library writeback

Added the following shortcuts to [`keywords.md`](../../library/keywords.md) (writeback per `skills/library-lookup/SKILL.md` § 4a, reached the relevant sections via flat-grep on `compartment-mapper` not via the keyword index):

- `` `@endo/compartment-mapper` `` → `(see source: endo--pkg-compartment-mapper-readme)`
- `compartment mapper` → `(see source: endo--pkg-compartment-mapper-readme)`
- `compartment-mapper architecture` → `(see section: endo--pkg-compartment-mapper-readme--language-extensions)`
- `` `mapNodeModules` `` → `(see section: endo--pkg-compartment-mapper-readme--language-extensions)`
- `` `languageForExtension` ``, `` `moduleLanguageForExtension` ``, `` `parsers` (package.json) `` → same section
- `auxiliary package.json`, `language-for-extension overrides` → same section

No concept page was drafted: the concepts axis for compartment-mapper internals is largely empty, and the design itself (still in flight) is the load-bearing source for terms like `package-descriptor-cache`, `findEnclosingCompartmentRoot`, `auxiliary descriptor`, and `languageForExtensionByPrefix`. A scholar pass after the implementation lands is the right time to draft `concepts/compartment-mapper-architecture.md` or similar.

## Open questions

- The library has no ingested section covering `mapNodeModules`'s internals (the README's *Design* sub-section describes the workflow diagram but not the cache or `searchDescriptor` walk). A future scholar pass against the `endojs/endo` source tree under `packages/compartment-mapper/src/` would let the next researcher pre-stage cache, walk, and per-prefix-language-map terminology without sending the builder to the source unaided.
- The design's "in-place transition" shape (a design-only PR carrying its own implementation on the same branch with a base move from `llm` to `master`) is the first instance the journal records. If the maintainer makes this a recurring pattern, the gardener may want to encode an *in-place design+implementation* norm in `roles/builder/AGENT.md` § Operating norms or in a project-level topic file at `journal/projects/endo-but-for-bots/in-place-design-implementation.md`. Surfacing here rather than acting; the researcher does not author role files.

Self-improvement: the keyword index did not surface `compartment-mapper`-package terms (`mapNodeModules`, `languageForExtension`, `parsers` (package.json), `auxiliary package.json`) despite the README being ingested in five sections; flat-grep against `sections/` was required to reach them. Added the shortcuts above so the next researcher (or any designer / builder on a compartment-mapper-adjacent PR) reaches the README from the keyword index directly.
