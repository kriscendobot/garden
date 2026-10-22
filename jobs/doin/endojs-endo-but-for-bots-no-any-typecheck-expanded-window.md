---
tier: mentor
handler-timeout: 3600
split-indivisible-reason: 'pr-open-needs-endojs-pr-write-pat-on-endolin-host-implementation-already-pushed'
split-lineage-root: endojs-endo-but-for-bots-no-any-typecheck
split-lineage-parent: endojs-endo-but-for-bots-no-any-typecheck-split
split-lineage-depth: 1
split-lineage-max-depth: 1
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-22T11:20:07Z cleared=none -->

---
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# endojs/endo-but-for-bots: open the draft no-explicit-any PR (pushed branch, PR-open only)

Continuation of `endojs-endo-but-for-bots-no-any-typecheck` (maintainer directive, kriskowal on #1393:
https://github.com/endojs/endo-but-for-bots/pull/1393#discussion_r4345304671). The implementation is
DONE and PUSHED; the only remaining step failed on host oros-studio-garden-ce242c49 because its bot PAT
gets `Resource not accessible by personal access token (createPullRequest)` on endojs. This job is pinned
to endolin-garden-ece02cb4, whose PAT can open PRs.

State: branch `no-explicit-any-ratchet` on endojs/endo-but-for-bots at `6b4326a119a1b18ad4e35bf0860e6790fc4ed35d`
(two commits on `llm-54d3d2a` = 54d3d2a682e7, which already exists as a frozen base):
- `3c17fb151` feat(eslint-plugin): reject explicit any in the internal config (+ changeset + config tests)
- `6b4326a11` chore(lint): ratchet the explicit any baseline (eslint-no-explicit-any-baseline.json,
  eslint.config.js baseline block, scripts/check-no-explicit-any.mjs, `yarn lint:no-any` in `yarn lint`)
Verified on oros: full `yarn lint:eslint` exit 0; `node scripts/check-no-explicit-any.mjs` holds
(4976 any / 990 files); eslint-plugin tests 154 pass; growth probe rejected.

Do:
1. `ensure-project-worktree.sh <your-base> endojs/endo-but-for-bots no-explicit-any-ratchet`; confirm HEAD is
   6b4326a11 (if the branch moved, read why before proceeding).
2. Open the DRAFT PR, base `llm-54d3d2a`, through ensure-pr.sh ONLY, keeping the original job's marker so it is
   rediscoverable: write the PR body below to a file and run
   `scripts/jobs/gardening/ensure-pr.sh endojs-endo-but-for-bots-no-any-typecheck endojs/endo-but-for-bots no-explicit-any-ratchet llm-54d3d2a --title "chore(lint): reject explicit any, with a shrink-only baseline" --body-file <file>`
   (first argument is the ORIGINAL job base on purpose — it matches the body's garden-job marker). The body is
   already conformed to the repo PR template.
3. Report the PR URL. The body asks the maintainer an open question (implicit `any` / noImplicitAny /
   type-coverage in CI); do not act on it.

----- PR BODY (verbatim, between the markers) -----
Refs: https://github.com/endojs/endo-but-for-bots/pull/1393#discussion_r4345304671

## Description

Following kriskowal's review on #1393: "Unacceptable to fall back to `any`. This is a rule in general." This PR makes explicit `any` a lint error everywhere in the monorepo. Code that already has `any` is held to a baseline that can only shrink.

- **`@endo/eslint-plugin` `internal` / `flat/internal`** (the monorepo-only configs) now set two rules to `error`:
  - `jsdoc/reject-any-type` for JSDoc types. It catches `{any}`, `{*}`, and `any` nested inside other types, such as the `/** @type {Map<number, any>} */` cast from #1393. It checks every JSDoc block, casts and typedefs included. Before this PR, `style` turned it off and nothing turned it back on.
  - `@typescript-eslint/no-explicit-any` for `.ts` syntax.
- **Ratchet:** `eslint-no-explicit-any-baseline.json` lists every existing violator with its count. The root `eslint.config.js` reads it and turns both rules off for exactly those files.
- **`scripts/check-no-explicit-any.mjs`** (new `yarn lint:no-any`, added to `yarn lint`, so CI's lint job runs it) re-counts violations in every linted file. It fails if a baselined file's count goes up, if a file outside the baseline has one, or if a file's count goes down without the baseline being lowered. `--update` only writes a baseline that does not raise any file's allowance, so it cannot loosen the ratchet. The script honors `eslint-disable-next-line` directives, so a genuinely irreducible `any` can still be kept with a comment naming the rule and saying why.

**Inventory and why there is a ratchet.** The baseline has **4,976 explicit `any`s in 990 files**: 2,944 in source and 2,032 in tests, across 94 package directories. The largest are hosted-agent 680, daemon 602, thixotrope 518, floot 380, sandbox 205, ocapn 175, workflow 172, codex-sandbox 139, patterns 130, fae 128, and chat 123. Rewriting all of them in one PR is not reviewable, so the rule lands now and new `any` is blocked from today. Burn-down can then go package by package. Each burn-down PR lowers the baseline with `--update`, and the check requires that.

**Why a config-read baseline, not ESLint's bulk suppressions.** ESLint 10's `eslint-suppressions.json` is applied only by the CLI, and only relative to its cwd. The 128 per-package `lint:eslint` scripts run from their own package directory, and editor integrations never apply suppressions. With suppressions, every legacy `any` would be an error in those places. A baseline that the flat config reads behaves the same in every ESLint invocation: the bucketed root lint, a package's own lint, and an editor. The cost is that the exemption covers whole files, which is why the separate count check exists.

**Open question for the maintainer: implicit `any`.** This PR covers **explicit** `any`. TypeScript's **implicit** `any` is a separate gate. `tsconfig.eslint-base.json` sets `"noImplicitAny": false`, five packages set it `false` explicitly, and only about 20 set `strict`/`noImplicitAny`. The existing `type-coverage` floors (50 packages) are not run in CI. Closing that gap means turning on `noImplicitAny` per package as each one comes clean, with the same ratchet idea, or running `type-coverage --at-least` in CI. That is a larger and separate change. Should it be a follow-up job, and which mechanism do you prefer?

Files to review most closely: `packages/eslint-plugin/src/configs/shared.js`, `eslint.config.js` (the baseline block comes after every block that re-extends the internal config), and `scripts/check-no-explicit-any.mjs`.

### Security Considerations

None. This is a lint-only change with no runtime code.

### Scaling Considerations

`yarn lint` gains one syntactic, untyped pass over the repository, about 1 to 1.5 minutes locally. The bucketed ESLint run is unchanged.

### Documentation Considerations

The script's header documents the burn-down workflow (`node scripts/check-no-explicit-any.mjs --update`). The changeset describes the config change for `@endo/eslint-plugin` consumers.

### Testing Considerations

- `yarn lint:eslint` over the whole repo: exit 0 (no errors).
- `node scripts/check-no-explicit-any.mjs`: baseline holds. Adding one `any` to a baselined file fails both the check and `--update`.
- Linting a new file containing `/** @type {Map<number, any>} */` from inside `packages/marshal` reports `jsdoc/reject-any-type`.
- `packages/eslint-plugin` tests: 154 pass. New tests cover the internal configs (`.js`, `.ts`, and test files), leave `strict` unchanged, and detect the nested-cast case.

### Compatibility Considerations

Only the monorepo-only `internal` configs change. `recommended`, `strict`, and `style`, which other projects extend, are unchanged, so the changeset is `minor`. A PR that adds an `any` now fails lint. A PR that removes one must also lower the baseline.

### Upgrade Considerations

None. No runtime or persisted-data impact.

<!-- garden-job: endojs-endo-but-for-bots-no-any-typecheck -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T13:42:23Z
