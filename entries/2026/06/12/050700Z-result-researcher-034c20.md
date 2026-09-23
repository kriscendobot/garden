---
ts: 2026-06-12T05:07:00Z
kind: result
role: researcher
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - https://github.com/Agoric/agoric-sdk/pull/12721
---

The proposed builder dispatch will create an analogous tsgo migration on `endojs/endo-but-for-bots`, modeling Agoric/agoric-sdk#12721: switch every `lint:types` from `tsc` to `tsgo` (TypeScript 7 native preview), add root-level `typecheck-all` (unified `tsconfig.json` scope under tsgo) and `typecheck-packages` (`yarn workspaces foreach --all run lint:types`), and document the division of labor in `AGENTS.md`. This refinement grounds that prompt in the library's existing `agoric-sdk--docs-typescript` and `endo--agents--typescript-usage` material, surfaces the project's asymmetries vs. agoric-sdk (`tsconfig` layout differs; `build:types` is a `tsc --build` composite emit that must stay on `tsc`; no `tsconfig.quickcheck.json` to drop), and proposes a four-commit ladder.

```markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sources/agoric-sdk--docs-typescript.md`](../../../library/sources/agoric-sdk--docs-typescript.md): the canonical source page for `agoric-sdk/docs/typescript.md`, which the agoric PR extends with a new "TypeScript Preview (tsgo)" section. Frame your edit to `docs/typescript.md` (if any) in the same vocabulary.
- [`journal/library/sections/agoric-sdk--docs-typescript--build.md`](../../../library/sections/agoric-sdk--docs-typescript--build.md): the `emitDeclarationOnly` story and the "why not two `tsc` passes" rationale. Relevant because tsgo's declaration-emit parity is not complete; emit stays on `tsc`. Endo's analogue is `tsconfig-build-options.json` + `tsconfig.composite.json` (per-workspace declaration emit via `tsc --build`).
- [`journal/library/sections/agoric-sdk--docs-typescript--dts-modules.md`](../../../library/sections/agoric-sdk--docs-typescript--dts-modules.md): `skipLibCheck: true` means `.d.ts` files are not checked. Tsgo inherits that constraint; the migration neither tightens nor relaxes it.
- [`journal/library/sources/endo--agents.md`](../../../library/sources/endo--agents.md) and [`journal/library/sections/endo--agents--typescript-usage.md`](../../../library/sections/endo--agents--typescript-usage.md): Endo's TypeScript conventions. Note: this snapshot is endojs/endo @ `6ea51ece` (2026-03-21), which **predates** the "composite TypeScript build" section now present in `endo-but-for-bots`'s current `AGENTS.md`. Read the live `AGENTS.md` in the project worktree, not the library snapshot, for the current command surface.
- [`journal/library/sections/endo--agents--testing.md`](../../../library/sections/endo--agents--testing.md): documents `yarn lint:types` as the type-test (`tsd`) entry point alongside runtime tests. Cross-check: most endo packages run `lint:types` as plain `tsc` (49 of 50 surveyed), not `tsd`; `tsd` is the test-side type-check that lives in `test/types.test-d.ts`. Either way `lint:types` is the script the migration retargets to tsgo.
- [`journal/library/sections/agoric-sdk--agents--build-test-and-development-commands.md`](../../../library/sections/agoric-sdk--agents--build-test-and-development-commands.md): the *pre-PR-12721* command inventory (still names `typecheck-quick`, `typecheck-tsgo`). Read as the baseline the agoric PR replaces; the library section will be ingested again after #12721 lands. Useful for the AGENTS.md edit's vocabulary.

### Project context

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § *Rules of engagement*: the implementation base for builder PRs is **`master`** (not `llm`, which is design-only). The migration is implementation, so the PR opens against `master`. Standing authorizations apply (the builder may post on its own PR without per-action authorization).
- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md) § *Authority structure*: any commenter on this repo routes as maintainer-equivalent. Build the PR description with that audience in mind.
- No related design exists in `designs/` on the `llm` branch (verified by `git ls-tree -r llm` over `designs/`; no `tsgo`, `typecheck`, `typescript`, `composite`, or `lint:types` matches). The migration is a builder-only flow, not a design-then-build.

### Project asymmetries vs. agoric-sdk (load-bearing for the builder)

- **Package count**: 50 packages under `packages/`. **49** declare `"lint:types": "tsc"`; only `packages/lockdown` has no `lint:types` script. Plan: update the 49 to `tsgo --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo`; leave `lockdown` alone (or add a stub if the per-package sweep would otherwise skip it silently, mirroring the `swingset-runner` exception in the agoric PR which is excluded in `tsconfig.check.json` with a TODO).
- **TypeScript installation**: catalog-resolved. `.yarnrc.yml` carries `catalogs.dev.typescript: ~6.0.3`; the analogous tsgo entry needs to be added there (`@typescript/native-preview` is the package name). Agoric used `"@typescript/native-preview": "^7.0.0-dev.20260610.1"` per their root `package.json`; Endo's catalog should follow the agoric guidance: deliberately **unpinned** for nightly advancement (`^7.0.0-dev.*` or equivalent), with `resolutions` reserved for upstream regressions.
- **Yarn's `run -T` is not used pervasively**: agoric's per-package `lint:types` is `yarn run -T tsc` (top-level); Endo's per-package `lint:types` is bare `tsc` (relies on each workspace's resolved binary). Either invocation form works for tsgo; following the existing style (bare `tsgo --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo`) keeps the diff smaller.
- **No `tsconfig.quickcheck.json` exists** in endo-but-for-bots. The agoric PR's "drop quickcheck" commit has no analogue here. Skip that commit from the ladder.
- **Unified-check tsconfig layout differs.** Agoric has a dedicated `tsconfig.check.json` (the unified noEmit-tsbuildinfo target). Endo's analogue is `tsconfig.json` itself (it already sets the eslint-base + the workspace-graph exclusions: `eslint-plugin`, `ses-integration-test`, `module-source`, `test262-runner`, `ses/test262`, `ses/types.test-d.ts`, `**/build`, `**/demo`, `**/dist`, `**/docs`). Decision points for the builder: either (a) use `tsconfig.json` directly as the `typecheck-all` target, or (b) add a dedicated `tsconfig.check.json` modeled on agoric. Recommend (a) for minimum diff; the existing `tsconfig.json` already provides repo-wide JSDoc check coverage. Verify in the PR whether `noEmit` / `incremental` need to be added (the eslint-base already sets both).
- **`build:types` is composite emit, not check.** `package.json:69` defines `"build:types": "tsc --build tsconfig.composite.json"` (emits `.d.ts` for the entire workspace graph; AGENTS.md § *Composite TypeScript build*). This is the declaration-emit path that agoric's docs say must stay on `tsc` (tsgo declaration-emit parity not complete). **Do not migrate `build:types*` scripts to tsgo.** Likewise leave `tsconfig.composite.json` and `tsconfig-build-options.json` alone; the per-package `tsconfig.composite.json` references inside each package are the emit-build state machine.
- **CI workflow surface**: `.github/workflows/ci.yml` has a single `lint` job that runs `yarn lint` (which already runs `lint:eslint` + per-package `lint:types` indirectly via the root `lint` script). Agoric's PR edited two specific jobs (`test-all-packages.yml` lint-primary and lint-rest) because their CI is segmented; endo's is not. Adding `typecheck-all` and `typecheck-packages` as new steps in the `lint` job (between `yarn lint` and `yarn build:types:check`) is the minimal change. The job already uses `actions/setup-node@v6` with `node-version-file: .node-version` (lts/*).
- **CI matrix**: tests run on `[ubuntu-latest, macos-15] × [22.x, 24.x]`. The new lint steps run only on ubuntu-latest (the `lint` job is single-platform). No matrix expansion needed.
- **AGENTS.md surface**: the live `AGENTS.md` at the project root carries: (i) `# Testing` block (`yarn lint:types` is `tsd`), (ii) `# Composite TypeScript build` block (the `build:types*` scripts). The migration needs to:
  - Either replace or augment `lint:types` description to call out tsgo (preserving the `tsd` vs `tsc-as-check` distinction; in endo `tsd` runs only in packages whose `lint:types` is `tsd test/types.test-d.ts` — verify whether that's still the case after this survey, or if `tsd` is invoked through a separate script).
  - Add a "TypeScript Preview (tsgo)" section mirroring agoric's, naming the division of labor: `lint:types` and the new `typecheck-all`/`typecheck-packages` on `tsgo`; `build:types`, per-package `prepack` emit, and ESLint type-aware rules on `tsc`.
- **`.gitignore` covers `*.tsbuildinfo`** (verified). The new `tsconfig.tsgo.tsbuildinfo` files will be ignored without further changes; no `.gitignore` edit needed.

### Recommended commit ladder

Modeled on agoric/agoric-sdk#12721's five-commit ladder, adapted for endo's lack of `tsconfig.quickcheck.json` and presence of the composite emit build:

1. **`chore(types): add @typescript/native-preview to the catalog`** — `.yarnrc.yml` `catalogs.dev.@typescript/native-preview: <unpinned 7.0.0-dev>`. `yarn install` and verify `yarn lock` updates cleanly. Add the lockfile changes as a separate `chore: Update yarn.lock` commit per [`skills/yarn-lock-separate-commit/SKILL.md`](../../../../garden/skills/yarn-lock-separate-commit/SKILL.md).
2. **`chore(types): switch lint:types to tsgo for the dev loop`** — sweep the 49 packages with `lint:types: tsc` to `tsgo --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo`. Update `packages/skel/package.json` (the uniformity template) to match. Verify `yarn workspaces foreach --all run lint:types` is green on a built tree.
3. **`chore(types): add typecheck-all (tsgo over the unified config)`** — add root `"typecheck-all": "tsgo -p tsconfig.json --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo"` (or `-p tsconfig.check.json` if a dedicated config is introduced; recommend reusing `tsconfig.json` for minimum diff). Wire it into `.github/workflows/ci.yml`'s `lint` job after `yarn lint`. Verify timing (agoric saw ~3s cold; expect endo to be faster, ~50 packages vs ~150).
4. **`chore(types): add typecheck-packages (per-workspace consumer view)`** — add root `"typecheck-packages": "yarn workspaces foreach --all --parallel --verbose run lint:types"`. Wire it into the CI `lint` job after `typecheck-all`. This provides the consumer-view-through-node_modules coverage that `typecheck-all` (which maps everything to source) does not.
5. **`docs: tsgo transition (AGENTS.md + docs/typescript.md if present)`** — extend `AGENTS.md` with a "TypeScript Preview (tsgo)" section mirroring agoric's vocabulary (division of labor table, nightly-advance policy, endgame at 7.0 stable). Cite the agoric source so future readers can cross-reference. Verify `AGENTS.md`'s existing "Testing" and "Composite TypeScript build" blocks remain accurate.

(Add a separate `chore: Update yarn.lock` commit between #1 and #2 per the project's yarn-lock-separate-commit discipline.)

### Why each reference is relevant

- The agoric `docs/typescript.md` source + the `build` section + the `dts-modules` section give the builder the same vocabulary the maintainer reviewed in #12721. Mirroring vocabulary speeds review.
- The endo `agents` source + `typescript-usage` and `testing` sections name the existing conventions the migration must not disturb (`emitDeclarationOnly`, `types-index`, `skipLibCheck`).
- The pre-#12721 agoric-sdk command inventory section frames what to remove from documentation (`typecheck-quick`, `typecheck-tsgo`); endo has none of those, so the "remove" half collapses but the "add" half (`typecheck-all`, `typecheck-packages`) maps directly.
- The endo-but-for-bots project README anchors the dispatch policy (master base, standing authorization to comment, who counts as a maintainer-equivalent reviewer).
```

## Library writeback

- **Keyword shortcuts added (deferred to a follow-up `librarian` engagement)**: the term *tsgo* / *typecheck-all* / *typecheck-packages* / *@typescript/native-preview* / *lint:types as a workspace script* are not in `journal/library/keywords.md`. They are load-bearing for any future TS-tooling research. Surfaced under *Open questions* below rather than added here so the librarian can decide whether to draft a concept page first and link the shortcut to it.
- **Concept-page draft (also deferred)**: a `journal/library/concepts/tsgo-transition.md` page would consolidate the agoric PR's framing into a project-agnostic concept the next caller can lookup once and reuse across endo, endo-but-for-bots, and (eventually) agoric. Recommend the librarian draft this page after #12721 is fully ingested.
- **Section re-ingest pending**: `library/sections/agoric-sdk--agents--build-test-and-development-commands.md` will need a re-ingest after #12721 merges (it still names `typecheck-quick` and `typecheck-tsgo` which the PR removes). Surfacing here so the scholar's next agoric-sdk pass picks it up; not in scope for this researcher dispatch.

## Open questions

- **Should endo introduce a dedicated `tsconfig.check.json` or reuse `tsconfig.json`?** Agoric has the former; endo currently has the latter playing the role. Either works; minimum-diff bias favors reuse, separation-of-concerns bias favors the new file. Defer to the builder.
- **What does `tsd` do under tsgo?** The `agents--testing` library section claims `lint:types` runs `tsd` against `test/types.test-d.ts`, but the file-level survey (`grep -r '"lint:types"'` in the project worktree) shows uniform bare `tsc`. The `tsd` integration likely lives in a separate script (the root `tsd` devDep + a per-package convention not visible from `lint:types` alone). The builder should verify whether tsgo's declaration-only check captures the same surface; if not, `tsd` may need to stay on `tsc` or a co-script may need to be added.
- **`packages/lockdown` lacks `lint:types`.** Either (a) accept the gap (mirror agoric's swingset-runner TODO-with-exclusion model in the unified-check config) or (b) add a `lint:types` stub. The builder should make this decision in the migration, not leave it implicit.
- **Composite build interaction.** The `tsconfig.composite.json` graph and the new `typecheck-all` over `tsconfig.json` both touch the same files. Verify their tsbuildinfo files do not collide (the agoric PR's `--tsBuildInfoFile tsconfig.tsgo.tsbuildinfo` convention handles this; endo's composite build already uses `*.tsbuildinfo` per-package, so the `tsconfig.tsgo.tsbuildinfo` discipline keeps the two separate).
- **Renovate / Dependabot policy** for `@typescript/native-preview`. Agoric leaves it unpinned with a docs-level fix-forward policy. Endo's renovate config (if any) should follow suit. Not strictly load-bearing for the first PR, but worth a follow-up.

Self-improvement: nothing this time.
