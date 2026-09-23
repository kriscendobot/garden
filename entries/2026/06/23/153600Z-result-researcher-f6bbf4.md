---
ts: 2026-06-23T15:36:00Z
kind: result
role: researcher
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

The proposed builder task is a systematic sweep to eliminate TypeScript and ESLint warnings in the `endojs/endo-but-for-bots` monorepo by toggling one strictness constraint per commit. This refinement locates the current configuration baselines, identifies the exact warn-level rules that are first-order targets, maps the CI invocations, and names the garden skills and project rules the builder must respect to keep each commit mergeable.

```markdown
## Library and project references

### TypeScript configuration — baseline

- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig.eslint-base.json` — the shared root for all ESLint type-checking tsconfigs; sets `allowJs: true`, `checkJs: true`, `noEmit: true`, `noImplicitAny: **false**`, `erasableSyntaxOnly: true`, `verbatimModuleSyntax: true`, `module/moduleResolution: NodeNext`. This is the single most important file for the builder: `noImplicitAny: false` is the root strictness floor the sweep will lift.
- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig.json` — extends `tsconfig.eslint-base.json`; adds `allowSyntheticDefaultImports: true` and excludes several packages from the ESLint type-check scope. The builder needs to know which packages are excluded before designing the sweep sequence.
- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig.eslint-src.json` — narrower include set (root files + `packages/*/src/**`; excludes test dirs).
- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig.eslint-full.json` — widest include (`**/*.js`, `**/*.ts`). Used for full-repo ESLint type-checking pass.
- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig-build-options.json` — sets `emitDeclarationOnly: true`; governs `.d.ts`-only emission for the composite build. Not a type-check file but the builder must not break this invariant.
- `/home/kris/dispatches/researcher--ac9ad6/project/tsconfig.composite.json` — auto-generated; references all packages with `tsconfig.composite.json`. Running `yarn build:types` exercises the full graph.
- Per-package `tsconfig.json` pattern: every package extends `../../tsconfig.eslint-base.json`. Nearly all inherit the root's `noImplicitAny: false`. **Only exception found**: `packages/stream-types-test/tsconfig.json` already sets `noImplicitAny: true` — proof the per-package escalation pattern works.
- `packages/goblin-chat/tsconfig.json` overrides `checkJs: false` — this package opts out of JS type-checking entirely. The sweep must treat it as a special case.

### ESLint configuration — baseline

- `/home/kris/dispatches/researcher--ac9ad6/project/packages/eslint-plugin/lib/configs/internal.js` — the primary config used by most packages (`plugin:@endo/internal`); extends `plugin:@endo/strict`, adds `@typescript-eslint/parser`, `unicorn`, and `@typescript-eslint/restrict-plus-operands: 'error'` for non-test files; **downgrades** `@typescript-eslint/restrict-plus-operands` to `'warn'` for `**/test/**/*.{js,ts}` (comment: "until we have time to clean them up") — a first-order target.
- `/home/kris/dispatches/researcher--ac9ad6/project/packages/eslint-plugin/lib/configs/recommended.js` — sets `@endo/no-harden-pattern-maker: 'warn'` — a warn-level rule to promote.
- `/home/kris/dispatches/researcher--ac9ad6/project/packages/eslint-plugin/lib/configs/style.js` — sets `consistent-return: 'warn'` (comment: "some bugs. TS covers."), `no-fallthrough: 'warn'` (comment: "doesn't detect throws"), `jsdoc/no-multi-asterisks: ['warn', ...]`. All three are first-order targets.
- `/home/kris/dispatches/researcher--ac9ad6/project/packages/eslint-plugin/lib/configs/strict.js`, `imports.js`, `ses.js`, `daemon.js` — no warn rules.
- `/home/kris/dispatches/researcher--ac9ad6/project/.eslintignore` — ignores `coverage/`, `build/`, `dist/`, `api-docs/`, `browser-test/`, `*.json`, `*.d.ts`, `*.d.cts`, `*.d.mts`, `*.types.js`. The builder must not widen this without understanding the "tseslint confused" note on `*.types.js`.
- Root `package.json` `"eslintConfig"`: `{"root": true}` only. All rules live in the plugin configs.
- Per-package ESLint config lives in each package's `package.json` under `"eslintConfig"`. Most extend `plugin:@endo/internal`. Exceptions: `cache-map`, `env-options`, `immutable-arraybuffer`, `ses` extend `plugin:@endo/ses`; `cli`, `daemon` extend `plugin:@endo/daemon`.

### Summary of current warn-level ESLint rules (the sweep's first-order ESLint targets)

| Rule | Config file | Comment |
|------|-------------|---------|
| `@endo/no-harden-pattern-maker` | `recommended.js` | none |
| `consistent-return` | `style.js` | "some bugs. TS covers." |
| `no-fallthrough` | `style.js` | "doesn't detect throws" |
| `jsdoc/no-multi-asterisks` | `style.js` | allows whitespace |
| `@typescript-eslint/restrict-plus-operands` | `internal.js` test override | "until we have time to clean them up" |

### CI — how type-check and lint are invoked

- `/home/kris/dispatches/researcher--ac9ad6/project/.github/workflows/ci.yml` — `lint` job runs `yarn build`, `yarn lint` (which is `lint:prettier && lint:eslint && lint:sh`), `yarn build:types:check`. There is **no `--max-warnings 0`** anywhere; `lint:eslint` is `"eslint ."` with no ceiling. Warnings are currently silent in CI. The sweep's final step should add `--max-warnings 0` to the `lint:eslint` script in root `package.json`.
- The `test` job runs `yarn build` then `yarn test`; the `cover` job runs `yarn test:c8`. Neither invokes lint or tsc directly — test failures can still come from compile errors surfaced by `checkJs`.

### Per-package TypeScript type-check scripts

`"lint:types": "tsc"` is present in many packages (skel template, `promise-kit`, `init`, `exo`, `cache-map`, `common`, `stream-node`, `bundle-source`, `chacha12-fast-check-test`, and more). All call bare `tsc` with no extra flags; narrowing happens only in the tsconfig files. No package uses `--strict` or any invocation-time narrowing flag.

### Prior art in this repo

- Branch `origin/claude/lint-rules-mismatch-61tws5` (`fix(eslint): make ignore set independent of working directory`) — recent ESLint ignore-path fix; the builder should check this branch's diff before modifying ignore config to avoid re-introducing the same issue.
- Commit `a2b70c49f` (`fix(lint): fix import/order, no-unused-vars, no-shadow, no-empty-function, no-await-in-loop`) — prior bulk lint-fix style commit; reference for the commit style this sweep produces.
- No prior PR titled "strict", "no-warn", "tighten lint", or "tighten typescript" was found in the repo's git log. This appears to be the first systematic sweep.

### Open designs on the llm branch

`git ls-tree origin/llm:designs` contains no file matching lint, eslint, typescript, or strictness. This PR has no open design dependency to declare.

### Project-specific rules the builder must respect

- `/home/kris/dispatches/researcher--ac9ad6/journal/projects/endo-but-for-bots/README.md` § Rules of engagement: the sweep touches only `master`-present packages, so `master` is the correct base. Use a frozen `master-<sha>` snapshot per `skills/frozen-base-branch/SKILL.md`.
- `project/AGENTS.md` (at the repo root in the project worktree): canonical agent conventions; key constraints: no `.ts` in runtime bundles, `emitDeclarationOnly: true` is invariant, use `/** @import */` JSDoc for type-only imports in `.js` files.
- Library topic `/home/kris/dispatches/researcher--ac9ad6/journal/library/topics/typescript-conventions.md` — distilled TS-in-JS conventions for `endo` and `endo-but-for-bots`; sections `endo--agents--typescript-usage` and `endo--agents--exo-this-context` explain where type definitions belong and what `emitDeclarationOnly` means.
- Library topic `/home/kris/dispatches/researcher--ac9ad6/journal/library/topics/tooling.md` §§ `endo--pkg-eslint-plugin-readme--supported-rules` and `endo--pkg-eslint-plugin-readme--usage` — distilled overview of the ESLint plugin rules and config inheritance hierarchy.

### Garden skills the builder must consult

- `garden/skills/pre-pr-checklist/SKILL.md` — pre-PR gate; every commit in the sweep must pass the checklist.
- `garden/skills/frozen-base-branch/SKILL.md` — pin a `master-<sha>` snapshot as the PR base; the conductor unfreezes at merge time.
- `garden/skills/yarn-lock-separate-commit/SKILL.md` — the sweep should produce no lockfile changes; if any dependency changes arise, the lock update belongs in its own commit.
- `garden/skills/changeset-discipline/SKILL.md` — each commit that touches a published package's source files needs a changeset entry (patch bump, type-fix category).
- `garden/skills/stacked-pr-build/SKILL.md` — if the sweep grows too large for a single PR, this skill covers splitting into a stacked chain.
- `garden/skills/regression-evidence/SKILL.md` — the PR description should cite before/after warning counts as regression evidence.
```

Library writeback: no new keyword shortcuts added; "ESLint", "TypeScript", "strictness", "tsconfig", and "lint" are general-purpose tooling terms not indexed as domain concepts in `journal/library/keywords.md`. The existing `tooling.md` and `typescript-conventions.md` topic pages are the correct routing surface.

Open questions: (1) the builder should run `yarn lint 2>&1 | grep " warning " | wc -l` and `yarn build:types 2>&1 | grep "TS" | wc -l` at start to establish the actual warning baseline before committing the first toggle — this researcher did not execute the linter. (2) `goblin-chat`'s `checkJs: false` override may mean it either produces zero TS warnings (opted out) or many suppressed ones; the builder should audit the package's intent before the sweep. (3) The `@typescript-eslint/restrict-plus-operands` test-file downgrade may involve many occurrences across the test suite; the builder should count before committing to promoting it as a single commit.

Self-improvement: nothing this time.
