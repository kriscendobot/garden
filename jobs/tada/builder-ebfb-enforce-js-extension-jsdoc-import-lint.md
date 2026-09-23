Job complete. Everything verified: DRAFT PR #581 open against the frozen base, worktree clean, inbox empty.

---

## Completion report

**Job:** builder-ebfb-enforce-js-extension-jsdoc-import-lint — enforce `.js` extension on JSDoc `@import` specifiers via lint (endojs/endo-but-for-bots), discharging the PR #442 review directive.

**Outcome:** Opened DRAFT PR **endojs/endo-but-for-bots#581** — `feat(eslint-plugin): enforce .js extension on JSDoc @import specifiers`, base `llm-f98d663` (frozen snapshot of `llm`), head `feat/eslint-plugin-jsdoc-import-extensions`.

**Mechanism chosen:** A small **custom rule** in `@endo/eslint-plugin`, not an existing plugin rule. I confirmed `eslint-plugin-jsdoc` v62.9 (already a dep) ships no rule that validates `@import` extensions (`imports-as-dependencies`, `check-syntax`, `no-restricted-syntax`, `prefer-import-tag` — none enforce extensions), and a bespoke rule matches Endo's convention of shipping its own rules (`harden-exports.js`, etc.) while giving precise control over the `ignorePackages` exemption.

**What changed (4 files, +182):**
- `packages/eslint-plugin/lib/rules/jsdoc-import-extensions.js` — new rule. Reads block comments, matches `@import … from '<spec>'`, flags **relative** specifiers (`./`, `../`) lacking a file extension; reports at the specifier's exact location. Mirrors the repo's `import/extensions: ['error','always',{ignorePackages:true}]`: relative-requires-extension, bare-package-exempt.
- `packages/eslint-plugin/lib/configs/imports.js` — enabled `'@endo/jsdoc-import-extensions': 'error'` next to `import/extensions`; declared `plugins: ['@endo']` so the config resolves the rule self-containedly.
- `packages/eslint-plugin/test/jsdoc-import-extensions.test.js` — new RuleTester suite, 17 cases.
- `.changeset/eslint-plugin-jsdoc-import-extensions.md` — `minor` bump (published lint-behavior change).

**Verification:** Red/green demonstrated with the real repo config chain (eslint flags an extensionless relative `@import`, silent once `.js` present) in both the eslint-plugin package and an unrelated package (`eventual-send`), confirming the rule travels the `internal → strict → imports` cascade repo-wide. New test 17/17; full `@endo/eslint-plugin` mocha suite 154 passing; `eslint .` and `tsc` clean on the package; prettier clean. Repo-wide scan on `llm` found no extensionless relative JSDoc `@import` outside `node_modules` fixtures (ESLint-ignored), so no existing violations needed fixing on this base.

**Follow-ups / flags:**
1. **#442 one-line fix folded back, not touched here.** `packages/daemon-cas` does not exist on `llm` yet (it is introduced by #442), so `content-store.js` line 6 lives only on #442's branch. The orchestrator/liaison should relay to #442 that the maintainer's requested `.js` addition is #442-local. I did **not** comment on #442 (external-repo etiquette — no per-action authorization carried).
2. **Residual scope nuance the maintainer should know:** the exact line 6 specifier, `@endo/platform/fs/lite/types`, is a **bare-package** specifier that `ignorePackages: true` exempts — so this lint rule will **not** flag it (matching how `import/extensions` treats real bare-package imports; blanket-requiring `.js` on package subpaths would break valid `exports`-map subpaths). The rule enforces the **relative** `@import` surface, which is the job's explicit floor. Whether that specific subpath should carry `.js` depends on `@endo/platform`'s exports and is a #442 judgement call. This is stated plainly in the PR body.
3. Next gamut stages (cleaner → judge → fixer-loop → un-draft) follow on the open draft; not my stage.

Self-improvement: nothing this time.
