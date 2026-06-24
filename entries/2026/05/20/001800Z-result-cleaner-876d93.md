---
ts: 2026-05-20T00:18:00Z
kind: result
role: cleaner
dispatch_id: 876d93
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 303
    role: target
refs:
  - entries/2026/05/20/000105Z-dispatch-steward-876d93.md
  - entries/2026/05/19/232613Z-result-builder-867b8a.md
---

# Result cleaner 876d93 — PR #303 lint fix; CI green; judge-ready

## Findings

PR #303 (devDep-cycle Cuts 1-5 mirrored onto `master`) arrived with one
red CI check (`lint`) against a fully-green test matrix and full
coverage matrix. Eight `import/no-unresolved` errors clustered in the
four synthetic `*-test` packages this PR introduces
(`@endo/eventual-send-test`, `@endo/harden-test`, `@endo/hex-test`,
`@endo/ses-test`) on imports that reach the source package's internal
`./src/*` subpath under a per-package exports condition
(`test-endo-eventual-send`, `test-endo-harden`, `test-endo-hex`,
`test-endo-ses`).

The root cause is that `master` carries upstream PR #3255
(`@endojs/endo` commit `638306eac`) which aliases the `dev` catalog's
`eslint-plugin-import` to `eslint-plugin-import-x@4.16.2`. The import-x
plugin reads its settings under the `import-x/` namespace (not
`import/`); the per-package `eslintConfig.settings` block on each
synthetic test package targeted the legacy `import/resolver` key, so
import-x silently fell back to its default resolver (with default
`conditionNames: ['import', 'require', 'default']`) and the
per-package test condition never reached `unrs-resolver`. The `llm`
branch did not exhibit this because the import-x migration has not
landed there yet; the same source files lint cleanly on `llm` and
fail on the `master` mirror only because of the resolver-settings key
namespace.

The fix rewrites each block from

```json
"import/resolver": {
  "exports": { "conditions": ["test-endo-<pkg>"] },
  "node": {}
}
```

to

```json
"import-x/resolver": {
  "node": {
    "conditionNames": ["import", "require", "default", "test-endo-<pkg>"]
  }
}
```

so the import-x bundled `unrs-resolver` picks up the per-package
condition. Default conditions are preserved alongside the custom one
so production imports still resolve.

## Coverage delta

None: this PR is a structural refactor that moves tests out of source
packages into sibling `*-test` packages to break the devDep cycle. The
same tests still run under the same coverage rules. Coverage CI jobs
(`cover (18.x | 20.x | 24.x, ubuntu-latest)`) all pass on both the
pre- and post-fix heads. No coverage commits are warranted; no
dead-code removal is warranted.

## Commits added

- `593c518e3` (after amend to bot-pinned identity): `chore(*-test):
  migrate import resolver settings to import-x namespace`. Touches
  four `package.json` files; +28/-20 lines.

No `chore: Update yarn.lock` follow-on commit needed (no dependency
churn). No dead-code-deletion commit warranted.

## Push and CI

Pushed `e64274246..593c518e3` to `feat/break-devdep-cycles-master`.
CI run `26133028006` converged green on all 27 checks (lint included,
prior failure cleared). Two pre-existing JSDoc warnings remain
(`packages/evasive-transform/src/index.js:25`,
`packages/ses/src/compartment.js:340`) which are unrelated to this PR
and pre-date the master mirror.

## Judge-ready

Yes. PR #303 is in draft state, fully green on CI, with no in-scope
must-fix issues from the cleaner pass. The judge can dispatch the
code panel (seventeen seats) plus the fire-and-forget
`gh pr edit 303 --add-reviewer @copilot` next.

Self-improvement: nothing this time. The lint-fix shape (lint-failure
caused by a master-branch upstream merge that changed the
`eslint-plugin-import` namespace) was novel for this dispatch, but
the fix itself is local to four package.json files and the discovery
path (yarn install + per-package yarn lint + read the resolver
plumbing in node_modules) is what the cleaner role's standing
"verify CI on cleaner's own HEAD" norm already prescribes. No skill
or role tweak warranted.
