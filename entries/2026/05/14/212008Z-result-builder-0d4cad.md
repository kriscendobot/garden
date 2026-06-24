---
ts: 2026-05-14T21:20:08Z
kind: result
role: builder
project: agoric-sdk
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 1
    role: head
  - repo: Agoric/agoric-sdk
    pr: 12659
    role: source
refs:
  - entries/2026/05/14/204849Z-dispatch-liaison-0d4cad.md
---

# Result: agoric-sdk fork PR #1 force-pushed with the aliasing approach (mirror of Agoric/agoric-sdk#12659 + turadg feedback)

Fork PR: <https://github.com/kriscendobot/agoric-sdk/pull/1>. Branch head SHA: `638a578f5`. Base: `master`. State: draft.

The branch as fetched (`c2200be70`) carried kriskowal's rename-style migration (commit `33e176251` renames every `import/*` rule to `import-x/*` across 161 files). Reset to `master` and rebuilt with the aliasing approach per turadg's review:

1. `chore(eslint-config): alias eslint-plugin-import to import-x@4` (`0ab4e7bbb`). Aliases `eslint-plugin-import` to `npm:eslint-plugin-import-x@4.16.2` in the root `package.json`, adds `eslint-import-resolver-node@^0.3.9` so import-x's optional peer dep is satisfied and the airbnb-base `import/resolver: { node: ... }` legacy fallback resolves cleanly, widens `@agoric/eslint-config`'s peer range to `^2.25.3 || ^4.16.0`. No changes to `eslint-config.cjs`; no changes to the ~150 source-file disable comments.
2. `chore(lint): clean import-x@4 lint findings` (`ede0da6d5`). Five stricter-resolver findings get per-line `eslint-disable-next-line` comments: four `import/no-extraneous-dependencies` (matching kriskowal's original silences for `ava` and three `nano-spawn` imports) plus one new `import/no-named-as-default` on `packages/portfolio-contract/test/contract-setup.ts` (file added after kriskowal's branch).
3. `chore: Update yarn.lock` (`638a578f5`).

`yarn lint:eslint` reports 0 errors, 1224 warnings (matches the pre-migration baseline within drift). `yarn install` succeeded with the alias; `node_modules/eslint-plugin-import/package.json` shows `name: eslint-plugin-import-x, version: 4.16.2`.

CI: not observable from the dispatch (CI on the fork is not gated by upstream's labels).

Per dispatch authorization: pushed to `kriscendobot/agoric-sdk`; updated the existing fork PR #1 (force-push + title/body rewrite + redrafted). No comment on `Agoric/agoric-sdk#12659`. No cross-fork PR opened.

The fork PR is now ready for the orchestrator's next dispatches: assayer (if jurisdiction calls) and judge (12-seat code panel), per `skills/pr-creation-flow/SKILL.md`. Affected packages: `@agoric/eslint-config`, `@agoric/internal`, `@agoric/portfolio-contract`, and the repo-root packing scripts.

Self-improvement: nothing this time. The aliasing-approach precedent from `endojs/endo-but-for-bots#226` (commits `1e4f819a` + `f38d828b`) was structurally identical and transferred cleanly; the agoric-specific complications (no yarn catalog so the alias goes straight into `package.json`; `viem/node` directory colliding with the legacy `node` resolver, requiring the extra `eslint-import-resolver-node` devDep) are captured in the commit-1 body so the same fix lands cleanly on upstream when the boatman ferries this back to Agoric/agoric-sdk#12659.
