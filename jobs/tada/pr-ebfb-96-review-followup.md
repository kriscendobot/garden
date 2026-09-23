Both review asks on PR #96 are complete, verified, pushed, and acknowledged on the threads. Completion report below.

---

# Completion report — `pr-ebfb-96-review-followup`

**PR:** endojs/endo-but-for-bots#96 · **Branch:** `design/compartment-mapper-auxiliary-package-json` · **Commit:** `aa78d8329` (bot identity, no identity switch)

## What I did

Closed the two open `CHANGES_REQUESTED` review asks (the third, type-consolidation, had already landed in `63266ca`).

**Item 1 — relocate + rewrite the design doc.** Moved `designs/compartment-mapper-auxiliary-package-json.md` → `packages/compartment-mapper/designs/compartment-mapper-auxiliary-package-json.md` (alongside the sibling `subpath-pattern-replacement.md`) and rewrote it to describe **only the implemented design**: two-kinds-of-descriptor, the on-demand `package-descriptor-cache.js`, and the lazy per-module `languageForExtensionByPrefix` import-hook walk. Dropped the ~470 lines of phasing / alternatives / test-plan / original-prompt history (613 lines → 145). Repo-root `designs/` is now empty (untracked). Source-comment references (`designs/…`) now resolve package-relative to the new location.

**Item 2 — ts/mts/cts parity.** Extended `languageForExtensionOverride` (`language-for-extension-by-prefix.js`) to flip `.ts` alongside `.js`, mirroring Node.js: `type:"module"`→`.js`=mjs/`.ts`=mts, `type:"commonjs"`→`.js`=cjs/`.ts`=cts; the unambiguous `.mjs`/`.cjs`/`.mts`/`.cts` are left type-independent. Added `test/auxiliary-typescript.test.js` + a `test/fixtures-auxiliary-typescript/` tree that drives the full `mapNodeModules`→`loadFromMap` pipeline and confirms the classification against Node.js at every dependency depth (incl. `.mts` staying ESM inside a `{"type":"commonjs"}` subtree, inheritance into deeper dirs, and a deeper `{"type":"module"}` auxiliary flipping `.ts` back to ESM). Extended the `language-for-extension-by-prefix.test.js` unit test for the `ts` flip.

## Verification
- `@endo/compartment-mapper` full suite: **927 passed, 12 known failures** — invariant unchanged.
- **Regression is load-bearing** (verified by experiment): removing the `ts` flip makes `cjs-sub/leaf.ts`'s `module.exports` throw as ESM → 3 tests fail; restored → green.
- `tsc` (lint:types): clean (run via `node …/typescript/lib/tsc.js` — bin shims are sandbox-blocked).
- `eslint` on changed files: clean. Design doc + changeset prettier-formatted.
- Updated the existing feature changeset to note ts/mts/cts parity and the new doc path.

## Communication
- Inline reply on the design-doc thread (`#discussion_r3485255853`).
- Inline reply on the ts/mts/cts thread (`#discussion_r3485256066`).
- Top-level summary comment (`#issuecomment-4815285650`) with SHA + what changed + verification.

Worktree created for the job has been torn down; the branch head on `origin` is `aa78d8329`.

## Follow-ups
- PR remains `CHANGES_REQUESTED` until kriskowal re-reviews; all three of that review's inline asks are now addressed, so it's ready for a re-review pass (and, if approved, conductor merge per the standing APPROVED→conductor norm).
- Note: I did **not** add ts/mts/cts to the production *default* language maps in `node-modules.js` (no TS parser ships by default, and doing so risked the 12-known-failures invariant). The override mechanism handles them when a caller supplies TS language options + parsers, which the test exercises. Flag for kriskowal if he intended default TS classification rather than override-only.
