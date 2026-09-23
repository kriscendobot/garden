---
ts: 2026-06-08T02:28:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--813762
prs:
  - repo: endojs/endo-but-for-bots
    pr: 96
    role: target
refs:
  - entries/2026/06/08/021800Z-dispatch-researcher-0918be.md
  - entries/2026/06/08/022400Z-result-researcher-0918be.md
  - https://github.com/endojs/endo-but-for-bots/pull/96
  - https://github.com/endojs/endo-but-for-bots/pull/96#pullrequestreview-4446211295
---

# dispatch: builder — PR #96 design-to-implementation transition (rebase on master + implement in place)

Maintainer directive on `endojs/endo-but-for-bots#96`
(`design(compartment-mapper): auxiliary package.json overrides`)
at 2026-06-08T01:40:58Z (kriskowal CHANGES_REQUESTED):

> Please rebase on master and proceed to implement in place, in
> this PR.

This is a **design-to-implementation transition**: the PR's
current base is `llm`, files are `designs/README.md` +
`designs/compartment-mapper-auxiliary-package-json.md`. The
maintainer wants the PR rebased onto `master`, and the design
implemented as source/test code in the same PR.

## State at dispatch time

- **PR #96**, OPEN, base `llm`, head
  `design/compartment-mapper-auxiliary-package-json` at full
  SHA `725b3d3d3...` (fetch the full SHA before pushing for the
  lease anchor).
- **Bot master**: `4a04d078bd208b852a7bebadccd703f53ceea8cc`
  (synced to upstream master).
- **Researcher's library + project references** landed at
  `journal/entries/2026/06/08/022400Z-result-researcher-0918be.md`
  in a fenced markdown block. **Read that file's section first**
  before composing your implementation; it covers the
  compartment-mapper architecture, the design spec, the
  test-fixture precedents, the dual design+implementation PR
  shape.

## Researcher refinement summary

Key references from the researcher (full section in the result
entry above):

- The five `endo--pkg-compartment-mapper-readme--*` library
  sections + source page: cover `mapNodeModules`,
  `languageForExtension` / `moduleLanguageForExtension`, the
  `parsers` field, and the workflow the design extends with
  `languageForExtensionByPrefix`.
- Source-tree landmarks on bot master:
  `packages/compartment-mapper/src/{node-modules,search,import,
  archive,bundle,extension}.js`. Test fixtures in `test/{nested-
  pkg,no-name,language-for-extension,extension}.test.js` +
  `fixtures-nested-pkg` / `fixtures-no-name`.
- Precursor: PR #70 (the diagnostic this design relaxes).
- Upstream issue: `endojs/endo#1845`.
- The 2026-05-21 designer result `9c1d4d` pinned the design's
  terminology.
- The "designs on llm, implementations on master" project README
  convention is being **overridden** by the maintainer for this
  PR; dual design+implementation in one PR is the first instance
  in the journal (gardener may want to encode a norm if it
  recurs).

## Task

In your `project/` worktree (currently at PR #96 head `725b3d3`):

1. **Read the design spec** in
   `designs/compartment-mapper-auxiliary-package-json.md` (on
   the current head). Understand the proposed
   `languageForExtensionByPrefix` mechanism and what it overrides
   in `mapNodeModules`.
2. **Read the researcher's full inlined section** at
   `journal/entries/2026/06/08/022400Z-result-researcher-0918be.md`
   for the architecture references.
3. **Mint the frozen base** `master-4a04d07`:
   - `git push origin 4a04d078bd208b852a7bebadccd703f53ceea8cc:refs/heads/master-4a04d07`
     (if it doesn't already exist).
4. **Rebase** the head branch onto the frozen base:
   - `git fetch origin && git rebase master-4a04d07`. The PR's
     current commits are design-only (designs/* files); the
     rebase should be clean.
5. **Implement the design** in
   `packages/compartment-mapper/src/` + tests. Per the
   researcher's references:
   - The implementation surface is likely
     `packages/compartment-mapper/src/node-modules.js` (or
     `search.js`) where the per-extension language map is
     resolved.
   - Add `languageForExtensionByPrefix` (or whatever the design
     names it) as a per-package override layer.
   - Add tests in
     `packages/compartment-mapper/test/language-for-extension.test.js`
     or a new test file. Cover the per-prefix override path.
   - Use the existing test fixtures (`fixtures-nested-pkg`,
     `fixtures-no-name`) or add a new fixture as needed.
6. **Commit** the implementation with conventional-commit
   messages (separate `feat(compartment-mapper):` for src,
   `test(compartment-mapper):` for tests; lockfile chore
   separate if needed).
7. **Push** the rebased + implementation head:
   `git push --force-with-lease=design/compartment-mapper-auxiliary-package-json:725b3d3d3... origin HEAD:design/compartment-mapper-auxiliary-package-json`.
8. **Retarget the PR base** to the frozen master:
   `gh pr edit 96 -R endojs/endo-but-for-bots --base master-4a04d07`.
9. **Post a top-level summary comment** on PR #96 citing:
   - The rebase target (`master-4a04d07`).
   - The implementation's commit SHAs and file paths.
   - Acknowledgment of the design-to-implementation transition
     shape.
   - Note that the PR body now describes both the design and
     the implementation.

## Authorizations (per-action, forwarded by steward)

- **Push** frozen-base + rebased+implemented head.
- **Retarget PR base** via `gh pr edit`.
- **Post top-level summary comment** (`endo-but-for-bots`
  standing broad-comment authorization).
- **NOT re-request review**: maintainer sets the pace.

## Out of scope

- Do NOT touch packages outside `packages/compartment-mapper/`
  except for `yarn.lock` if a dep change is needed.
- Do NOT trigger panel/judge/fixer chain.
- Do NOT shepherd CI to green; if CI fails, surface to liaison
  in your result.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming:

- Pre/post head SHAs and the new frozen base.
- Per-commit SHA + one-line description of implementation
  commits.
- Files touched in `packages/compartment-mapper/src/` + tests.
- Top-level summary comment URL.
- Any out-of-scope drift surfaced (e.g., if the design's spec
  exceeds the builder's surgical-implementation scope).
- A `Self-improvement: ...` line.

If the implementation grows beyond the fixer's surgical scope
(e.g., requires a substantial test rewrite, an interface
redesign, or a new dependency), surface to liaison via a
`message: builder → liaison` and stop at a partial implementation
rather than overrun.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
