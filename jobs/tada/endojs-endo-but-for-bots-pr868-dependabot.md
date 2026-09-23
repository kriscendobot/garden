# Botany review: endojs/endo-but-for-bots PR #868 — EMBARGO-2026-08-02

**PR:** https://github.com/endojs/endo-but-for-bots/pull/868 (`chore: bump eslint-plugin-unicorn from 56.0.1 to 72.0.0`, base `llm`, head `f8cf6acf688cff25033412355d2047609d2e9cc2`)

## Verdict

**EMBARGO-2026-08-02**, maturity floor `2026-08-02T16:39:39Z`. Two independent legs bar MERGE-NOW; neither is a flake.

**Leg 1 — maturity.** The headline package is mature (`eslint-plugin-unicorn@72.0.0` published 2026-07-14, floor passed 2026-07-21). But the lockfile moves **27 versions**, two of which were under 6 hours old when dependabot opened the PR: `globals@17.8.0` (2026-07-26T16:39:39Z, 3h26m) and `baseline-browser-mapping@2.11.4` (4h55m). Three more sit inside the window. I took the floor from the freshest *moved* version, not the headline.

**Leg 2 — `lint` is red for a real reason.** 7 errors, all `unicorn/numeric-separators-style`, in `packages/ocapn/test/codecs/passable.test.js` (2), `packages/random/src/random.js` (1), `packages/random/test/random.test.js` (4). 21 of 22 checks pass. Mechanism confirmed by reading both rule sources: v56 grouped a float's fractional part left-to-right at `groupLength: 3`; v72 added a separate `fractionGroupLength` defaulting to `Infinity` (no fractional grouping), so every pre-existing fractional separator is now an invalid group. The repo configures the rule at `packages/eslint-plugin/src/configs/shared.js:568` without setting it.

## What cleared

- **Advisories:** all 27 moved versions queried individually against OSV (unions GHSA). **Zero advisories**, none withdrawn or deprecated.
- **Install:** `YARN_ENABLE_SCRIPTS=false yarn install --immutable --mode=skip-build` completed clean, lockfile self-consistent. No `preinstall`/`install`/`postinstall` hook anywhere in the moved set; the two `prepare` hooks (`web-worker`, `globals`) don't run for registry tarballs.
- **Source read** of the headline package and all **13 newly-introduced** packages: no `child_process`, no `node:http`/`node:https`, no `fetch` call site, no filesystem write, no `eval`/`new Function`, no credential-shaped env read. The only `fetch`/`XMLHttpRequest` strings in unicorn are rule names and descriptions.
- **Called out by name:** `quote-js-string@0.1.0` is a first-ever release; `identifier-regex@1.1.0` and `is-identifier@1.1.0` are three weeks old. All 13 new packages are `sindresorhus`-owned or ESLint-org-owned and consumed by unicorn itself, so their appearance is explained by the upgrade.
- **Licenses** permissive throughout (MIT, Apache-2.0, ISC, BSD-2-Clause, CC0-1.0, CC-BY-4.0). No regression.

**Extra finding:** `eslint-plugin-unicorn` is a runtime `dependencies` entry of the *published* `@endo/eslint-plugin@2.6.0`, not a devDependency, so the range bump is downstream-visible. The PR carries no changeset.

## Disposition executed (bot-owned repo, standing comment authorization)

| Artifact | Where |
|---|---|
| Verdict comment | https://github.com/endojs/endo-but-for-bots/pull/868#issuecomment-5098723542 |
| Ledger row | `journal2:entries/2026/07/28/011419Z-message-gardener-3e5edb.md` |
| Precise one-shot recheck | `schedules/dependabotany-recheck-endo-but-for-bots-pr868.md`, `once: 2026-08-02T17:15:00Z` (floor ceiled to hour + 15m, self-deleting) |
| Daily backstop | `schedules/dependabotany-recheck-endo-but-for-bots.md` re-created (the embargoed set had been empty since 2026-07-01) |
| Fixer escalation | job `endojs-endo-but-for-bots-pr868-lint-fix`, already claimed into `doin/` |
| Result entry | `journal2:entries/2026/07/28/011545Z-result-gardener-ed86a3.md` |

All verified present on `origin/journal2`. **No merge and no close performed.**

The fixer job carries the preferred fix (add `fractionGroupLength: 3` to the `number` options, restoring v56 behaviour and leaving all 7 literals as written — the v72 schema accepts it) in preference to `eslint --fix`, which would strip fractional separators from 7 literals across 3 packages and change a deliberate convention without a decision. It also requires the missing changeset.

## Follow-ups

- If dependabot force-pushes a regenerated head before 2026-08-02, the maturity floor resets; the recheck job body already instructs re-derivation from the live lockfile.
- Nothing was committed to `main2` by this job; the garden worktree is clean.

Self-improvement: message to `liaison` (`inbox/liaison/20260728T011523Z-add2c0`) proposing that `roles/botanist/AGENT.md` define the maturity floor on the freshest version that moved anywhere in the lockfile rather than the headline's publish date — this PR is the case where the two readings diverge by 12 days, and § Autonomous disposition's one-shot recipe currently points at the headline explicitly. Not landed myself, per the skill's rule that a gardener does not land role changes outside a garden-infra job.
