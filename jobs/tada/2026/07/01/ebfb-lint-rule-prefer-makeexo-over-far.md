The work is complete and deconflicted. Final report:

---

## Completion report: `ebfb-lint-rule-prefer-makeexo-over-far`

**What I did** — Added a custom ESLint rule to `@endo/eslint-plugin` on endojs/endo-but-for-bots that flags `Far(...)` and steers authors to `makeExo(...)`, per kriskowal's #58 review 4611555757. Opened **DRAFT PR [#587](https://github.com/endojs/endo-but-for-bots/pull/587)** (base `llm`, frozen-base discipline; branch `lint-prefer-makeexo-over-far`).

**What changed** (4 files, commit `3423b097b`):
- **`packages/eslint-plugin/lib/rules/prefer-make-exo.js`** (new) — reports any `CallExpression` whose callee is the bare identifier `Far` (the `import { Far } from '@endo/far'` shape). Member calls (`x.Far(...)`), `Far`-as-a-value, and unrelated identifiers are left alone. No autofix (the `Far`→`makeExo` migration needs an interface guard the tool can't synthesize).
- **`packages/eslint-plugin/lib/configs/recommended.js`** — wired the rule at **`warn`**, inherited by all ~90 packages via `strict` → `internal`. Chose `warn` over `error` deliberately: there are **~540 `Far(...)` call sites in-tree today**, so erroring would break `eslint .` wholesale. Matches the existing `@endo/no-harden-pattern-maker` `warn` precedent, and the root lint script (`eslint .`) has no `--max-warnings`, so CI stays green.
- **`packages/eslint-plugin/test/prefer-make-exo.test.js`** (new) — RuleTester cases: `Far→report` (declaration, statement, nested), `makeExo→ok`, value/member/unrelated→ok, and the documented **eslint-disable escape hatch→ok**.
- **`.changeset/eslint-plugin-prefer-make-exo.md`** — `@endo/eslint-plugin` minor.

**Escape hatch** — `Far` is discouraged, not forbidden: suppress with `// eslint-disable-next-line @endo/prefer-make-exo -- <reason>`, documented in the rule's docblock, the config comment, the changeset, and the PR body.

**Verification** — Installed the monorepo (`corepack yarn install`; only the unrelated `better-sqlite3` native build failed). `yarn mocha` in the plugin: **146 passing** (10 new cases). `eslint` on the plugin package: **green, 0 errors**. Confirmed on real source (`packages/chat/floot-component.js`) that the rule fires as a **warning** on live `Far(...)` sites — not an error. (Did not run full-tree `eslint .`: it's warn-only by construction and the whole-monorepo typescript-projectService run is very heavy; targeted verification covers the mechanism.)

**Deconfliction** — Found a genuine **duplicate job** in flight: `endojs-endo-but-for-bots-lint-prefer-makeexo-over-far` (gardener 33, claimed 17:36 — 2.5 min *after* mine at 17:33), which a peer on #58 had flagged in my inbox. Since I claimed first and had already opened #587, I messaged that live peer to stand down and fold any extras into #587 as review comments rather than land a second competing rule.

**Follow-ups**
- Migrate existing `Far(...)` sites to `makeExo(...)` (or annotate with the escape hatch), then promote the rule to `error`.
- The duplicate job's spec suggested *also* flagging the `import { Far }` binding (mine flags call sites only, per my job spec — crisper, avoids false positives on type-only/`ERef` imports). A possible enhancement if the maintainer wants import-level enforcement too.
