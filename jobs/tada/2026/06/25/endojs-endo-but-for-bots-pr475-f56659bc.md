## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 (kriskowal: *"Please eject this into a fixture so that it's subject to lint and other validation."*)

**What "this" was:** the `nodePreludeHeader` — the eshost-VM TextEncoder/TextDecoder cross-realm adapter that lived as an inline template literal in `packages/test262-runner/scripts/generate-preludes.js`, so its body escaped eslint, prettier, and tsc.

**What I did** (commit `a2656e816`, pushed to `feat/narrow-bytearray-to-uint8`):
- **Added** `packages/test262-runner/scripts/node-prelude-header.js` — the glue ejected to a real source file (prettier-formatted, single-quoted), carrying its own rationale comment and `@ts-nocheck`.
- **Edited** `scripts/generate-preludes.js` to read the fixture at generate time (`fs.readFile` of the sibling file) instead of holding the string; removed the now-duplicated comment block.
- **Edited** `packages/test262-runner/package.json` — a file-scoped `eslintConfig` override (`env: node`; relaxes `no-var`, `vars-on-top`, `prefer-const`, `no-plusplus`, `no-empty-function`, `no-underscore-dangle`) that documents the glue is deliberately ES5/CommonJS because it runs in a bare `vm.createContext`, not as a module. All other validation (prettier, syntax, unused-vars, comparison operands) now applies.

The generated `prelude/node.js` is functionally unchanged — only quote style and a leading comment banner differ (`prelude/` is gitignored and lint/tsc-ignored, so the banner is inert).

**Verification:** `node --check` on both scripts and `prettier --check` (repo `.prettierrc.json`) on all three files pass. A concurrent peer commit (`fe0c785b5`, src/ refactor) landed mid-job; I rebased cleanly (disjoint files) before pushing.

**Communication:** replied in the review thread (discussion_r3477739884) and posted a top-level summary comment (issuecomment-4804241788). Worktree torn down.

**Follow-up / caveat:** I could not run the full monorepo `yarn lint`/`lint:types` locally (no installed workspace in the worktree), so the exact eslint rule-relaxation set is reasoned from `@endo/internal`'s config, not empirically confirmed — CI on the PR is the backstop. If CI surfaces another rule the VM-glue style trips, it's a one-line addition to the override block.
