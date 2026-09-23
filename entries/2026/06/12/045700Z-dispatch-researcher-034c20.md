---
ts: 2026-06-12T04:57:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--034c20
refs:
  - https://github.com/Agoric/agoric-sdk/pull/12721
---

# dispatch: researcher — references for an analogous tsgo migration on endo-but-for-bots

User directive (2026-06-12T~04:55Z): "Please dispatch a builder
to create an analogous migration in the endo-but-for-bots
repository for tsgo https://github.com/Agoric/agoric-sdk/pull/12721"

Precedence dispatch per the researcher-precedence rule. The
downstream builder will perform the migration; this researcher
surfaces the references the builder needs.

## Upstream PR shape (#12721 on Agoric/agoric-sdk)

Title: "chore(types): switch lint:types to tsgo for the dev loop"
Merged: 2026-06-12T00:57:39Z. Head: `ta/lint-types-tsgo` at
`34bdfaf4ca86889ec2810fead469d289f612f1cc`.

Per the PR description:
1. **`lint:types` → tsgo** in root and all 50 packages. tsgo
   is the TS 7 native preview. Type-check-only (no artifacts),
   so it's the risk-free half of the TS7 transition. tsgo is
   stricter on JSDoc.
2. **`typecheck-all` covers all TypeScript via tsgo** against
   a unified `tsconfig.check.json`. tsgo cold-start ~3s.
   Excludes one package (`swingset-runner`, never type-gated,
   ~64 errors) via a TODO.
3. **`typecheck-packages` runs each workspace's `lint:types`
   (tsgo) against its own tsconfig**, resolving deps through
   `node_modules` entrypoints. Replaces the prior per-package
   `tsc` sweep. TS 6 compat still enforced via CI build +
   prepack `tsc` runs.
4. **`tsconfig.quickcheck.json` dropped**. `typecheck-quick`
   and `typecheck-tsgo` removed. AGENTS.md points at
   `typecheck-all` and `lint:types`.

## Scope of the research

The downstream builder needs to know:
- The endo-but-for-bots repo's current TypeScript setup
  (root tsconfig, per-package tsconfig pattern, lint:types
  scripts, any existing typecheck-* scripts).
- The package count and which ones have `lint:types` defined.
- The differences between agoric-sdk's and endo-but-for-bots's
  shape (different conventions, different per-package style,
  any quirks).
- Existing `tsgo` installation status in the repo (is it
  already a devDependency? at what version?).
- The relevant AGENTS.md (or equivalent — endo's
  `AGENTS.md` lives in the repo root and per-package).
- How CI currently invokes lint:types and typecheck (which
  workflow file).

In your `project/` worktree at endo-but-for-bots master
(`4a04d078b`):

1. **Read upstream PR #12721 in detail**:
   `gh pr view 12721 --repo Agoric/agoric-sdk --json
   commits,files`. List each commit's title; identify the
   minimum viable patch shape.
2. **Map endo-but-for-bots's TypeScript setup**:
   - Root `tsconfig.json`, `tsconfig.eslint-base.json`,
     `tsconfig.base.json`, etc. Identify which exist.
   - Per-package tsconfig: `find packages -name 'tsconfig*.json'`.
   - `package.json:scripts`: which packages have `lint:types`?
     `find packages -name package.json -exec sh -c 'jq
     -r ".scripts | to_entries[] | select(.key | startswith(\"lint:types\")) | \"\(input_filename): \(.key) → \(.value)\"" {}' \;`.
   - Root `package.json:scripts`: enumerate the typecheck-*
     scripts already present.
3. **Map tsgo status**:
   - `grep -r 'tsgo' --include='package.json'` to find
     existing tsgo references.
   - Identify if tsgo is already a devDep, and at what version.
4. **Compare upstream → downstream**:
   - Which of the upstream PR's changes apply directly to
     endo-but-for-bots?
   - Which need adaptation (different file names, paths,
     conventions)?
   - Which are inapplicable (agoric-sdk-specific concerns
     like the swingset-runner exclusion)?
5. **Identify the CI surface**: which workflow file(s) run
   `lint:types` and `typecheck-*` on endo-but-for-bots?
   Inspect `.github/workflows/`.
6. **Identify the AGENTS.md surface**: which AGENTS.md (root,
   per-package, or both) needs to be updated to point at
   the new scripts? `find . -name 'AGENTS.md'`.

## Output shape

Produce a `result` entry under `journal/entries/2026/06/12/`
with the standard `## Library and project references` section.
In particular surface:

- The shape of endo-but-for-bots's current `lint:types` +
  typecheck infrastructure (root + per-package).
- The package count + which packages need `lint:types` →
  `tsgo` conversion.
- tsgo installation state.
- The unified-tsconfig analog (what should
  `tsconfig.check.json` look like for endo-but-for-bots?).
- The CI workflow file(s) that need updating.
- The AGENTS.md file(s) that need updating.
- Blockers / asymmetries (e.g., does endo-but-for-bots have
  packages that would fail tsgo's stricter JSDoc that need
  explicit exclusion?).
- A recommended commit ladder for the builder (e.g., one
  commit per phase: install tsgo, root scripts, per-package
  scripts, AGENTS.md, drop deprecated configs).

## Out of scope

- Do NOT propose the implementation itself; that's the
  builder.
- Do NOT touch the tree or push anything.
- Do NOT speculate beyond what the code shows; flag unknowns
  as open questions for the builder.

## Authorizations

Read-only.

## Deliverable

A `result` entry under `journal/entries/2026/06/12/` with the
`## Library and project references` section ready for inlining
into the builder dispatch, plus the standard self-improvement
footer.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section into the builder dispatch and
tears down your dispatch root on return.
