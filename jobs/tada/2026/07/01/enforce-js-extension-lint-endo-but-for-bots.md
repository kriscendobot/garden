Done. Here is my completion report.

---

## Completion report: `enforce-js-extension-lint-endo-but-for-bots`

**Outcome: deduped in favor of PR #581.** My work is complete and correct, but it collided with a sibling job that shipped the same fix first. Net result: no duplicate PR left open; the surviving PR is stronger for a suggestion I contributed.

### What I did
- Investigated the repo's ESLint config chain (`@endo/internal` → `@endo/strict` → `@endo/imports`). Confirmed the gap: `import/extensions` (`['error','always',{ignorePackages:true}]`) and `import/no-unresolved` walk the syntax tree, so **JSDoc `@import` tags — which live in comments — are invisible to both**. That is exactly why the extensionless `@endo/platform/fs/lite/types` on `daemon-cas/content-store.js:6` slipped through.
- Authored a `@endo/jsdoc-import-extensions` custom rule (the repo's own plugin — no new dependency), wired it into the shared `imports` config as `error`, added `checkTypeImports: true` to `import/extensions`, and a 21-case RuleTester test. Verified: **158 plugin tests passing**; **`eslint .` green on the whole `llm` tree (0 errors)**; rule proven to fire end-to-end through the real config.
- **Key correctness finding:** requiring `.js` on *all* `@endo/*` subpaths is **not** uniformly correct. `@endo/daemon`/`exo`/`marshal` use `.js`-suffixed export keys, but `@endo/platform`/`agentry`/`preact-container` use **extensionless** keys, so their extensionless specifiers are the only resolvable form — the reported `@endo/platform/fs/lite/types` is actually a *correct* explicit-key export. I scoped the rule to **relative** specifiers and surfaced the exports-map nuance rather than making a breaking change.
- Opened DRAFT PR #582, then **drained my inbox and found a STAND-DOWN**: a sibling job (`builder-ebfb-enforce-js-extension-jsdoc-import-lint`) had opened **#581 two minutes earlier** for the same ask. #581 independently reached the identical design (same rule name, same relative-only scope, same `@endo/*` reasoning) and is more convention-complete (frozen `llm-f98d663` base + a changeset — both of which mine lacked).

### What changed (outward)
- **Closed #582** and deleted its branch, with a dedup note pointing at #581.
- **Commented on #581** offering my one incremental delta losslessly: add `checkTypeImports: true` to also cover TS `import type` runtime specifiers (verified green on `llm`).
- Corrected my earlier maintainer ping (the `@endo/*` scope question needs no decision — both PRs concluded the same).
- Removed the scratch project worktree and temp PR ref.

### Follow-ups
- **Review target is #581**, not mine. It optionally may fold in `checkTypeImports: true`.
- **Process gap (self-improvement):** I opened #582 *after* the stand-down had already landed in my inbox, because I didn't re-drain immediately before the PR-open. This is the exact case the existing "re-check thread + drain inbox before the final push" guidance covers — it should extend explicitly to the **PR-open** step in the builder/gardener flow, and the root cause is producer-side: two builder jobs were posted for one #442 review line (fixer + design-queue both posted). Worth a dedup check at job-post time.
