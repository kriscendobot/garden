Landed on `origin/journal2`. Job complete.

## Completion report

**Task:** Fill two gaps in `library/keywords.md` (journal2) — the concept pages `dual-package-hazard` and `package-type-field` existed under `library/concepts/` but had no keyword-index entries, so library-lookup greps for their terms dead-ended.

**What I did:**
- Verified both concept pages exist and that both concept-ids were absent from `keywords.md` (grep count 0 before).
- Read each page's `aliases:` frontmatter — they matched the aliases named in the job spec exactly.
- Appended keyword→concept-id lines in the file's `<keyword> | <concept-id>` format, one line per alias plus the concept-id itself:
  - **dual-package-hazard** (8 lines): the id + `dual package hazard`, `dual-package hazard`, `dual CommonJS/ES module`, `dual ESM/CJS`, `ESM CJS dual publishing`, `two module instances`, `singleton duplication`.
  - **package-type-field** (10 lines): the id + `type field`, `` `"type": "module"` ``, `type module`, `type commonjs`, `module system determination`, `nearest parent package.json`, `` `.mjs` ``, `` `.cjs` ``, `syntax detection`.
- Applied backticks to the three clearly code-symbol keywords (`` `"type": "module"` ``, `` `.mjs` ``, `` `.cjs` ``), matching the file's format note (code symbols in backticks, prose plain) and the existing `` `"type": "module"` `` precedent.
- Landed via `scripts/jobs/land-journal-edit.sh library/keywords.md` (no hand-git of the live journal worktree).

**Acceptance verified:** grep for `dual-package-hazard` and `package-type-field` each now hit `keywords.md`; a lookup on `"type": "module"` resolves to `package-type-field`. Edit landed on `origin/journal2`.

**Follow-ups:** none.
