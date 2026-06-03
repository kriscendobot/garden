---
ts: 2026-06-03T01:29:06Z
kind: result
role: weaver
worktree: dispatches/weaver--496105/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/03/011729Z-dispatch-liaison-496105.md
  - https://github.com/endojs/endo/pull/3294
---

# weaver 496105 — sync bot-master to actual/master, weave bots/llm onto bot-master

Propagated upstream endojs/endo#3294 (benchmark direct-download fix) into the bot fork. Force-with-leased `endojs/endo-but-for-bots:master` to mirror `endojs/endo:master`, then merged the new master into `endojs/endo-but-for-bots:llm`. Both pushes succeeded. PR-impact table below.

## Pre-sync SHAs

- `endo-upstream/master`: `ba26f4cdb` (`fix(benchmark): install xs/v8 via direct download instead of esvu (#3294)`).
- `origin/master` (bot-master): `3c5753b67` (`chore: dependency maintenance, #3292`). 4 commits behind upstream, 0 ahead. Strict ancestor.
- `origin/llm` (bots/llm): `c85d618df` (`design(daemon): importLocation from EndoMount, #358`). 1270 commits ahead of old bot-master; 65 commits behind upstream master at merge base `bf951df34`.

## bot-master sync

Strict fast-forward of upstream master onto bot-master.

```
git push --force-with-lease=master:3c5753b67f9ec16fccded31f3023814de52f042f \
    origin endo-upstream/master:master
```

Exit code: 0. Remote update: `3c5753b67..ba26f4cdb  endo-upstream/master -> master`. Post-push `git ls-remote origin master` = `ba26f4cdb`.

## bots/llm weave onto bot-master

Strategy choice. The dispatch said "rebase," but `origin/llm` is 1270 commits ahead of the merge base and yarn.lock churn alone would force re-resolution of many of those commits. The prior weaver on this same axis (`entries/2026/05/21/054802Z-result-weaver-7d7d5e.md`, "merged endo-upstream/master into endo-but-for-bots/llm") adopted a merge-commit shape exactly for this reason, and the maintainer's framing on PR #109 (the predecessor case) preserves the same shape. Started with `git rebase origin/master`, hit yarn.lock and benchmark-area conflicts within the first 12 of 1072 replayed commits, aborted, switched to merge. Per `garden/roles/weaver/AGENT.md` § Procedure step 2 ("Prefer a merge commit only when the branch has many commits the dispatch wants preserved as discrete units"), this branch absolutely qualifies.

Merge command: `git merge --no-ff origin/master -m "merge: actual/master into llm"`.

- Pre-merge HEAD: `c85d618df` (`origin/llm`).
- Merge commit: `720a39600` ("merge: actual/master into llm").
- Push: `git push --force-with-lease=llm:c85d618df0d50b08b2dd82cb8eebd6d327e7bb05 origin HEAD:llm`. Exit code: 0. Remote update: `c85d618df..720a39600  HEAD -> llm` (fast-forward of the merge commit; the lease anchor was held to preserve the safety net against concurrent pushes).

## Conflict resolutions (by file)

Twelve files entered conflict.

- **packages/benchmark/install-engines.sh**: both sides made the same fix (direct xs/v8 download instead of esvu), but with different forms. Master carries the upstream-accepted final form (`~/.engines/` cache, relative-traversal launcher, `jq` parser, execution-verification probe, refined error wording). llm carried the in-flight mirror form (`~/.bench-engines/`, absolute `$HOME` baked into launcher, python3 parser). Took master's full file verbatim. Justified by the canonical-form rule in `feedback_bot_master_reset_to_actual.md`: bot-fork master mirrors upstream, and the upstream-merged shape supersedes the bot mirror's in-flight shape. Diff against master post-merge: empty.
- **packages/benchmark/README.md**: identical structure, the one differing line is the engine-cache directory (`.bench-engines` vs `.engines`). Took master's `.engines` to match install-engines.sh.
- **packages/benchmark/run-tests.sh**: same `.bench-engines` vs `.engines` divergence. Took master's `.engines`.
- **packages/hex/test/run-benches.sh**: same `.bench-engines` vs `.engines` divergence (master commit 84a3f2a16 "chore(hex): point run-benches.sh at the ~/.engines binary cache"). Took master's `.engines`.
- **.github/workflows/ci.yml**: HEAD added two jobs (`sandbox-drivers`, `test-async-hooks`); master added nothing here. Conflict was the surrounding boundary. Kept both new jobs; the `=======` / marker block became a clean append. YAML round-trips through `python3 yaml.safe_load`.
- **package.json (root)**: three conflict regions.
  1. `@changesets/changelog-github` and `@changesets/cli`: took the newer of each side (`^0.7.0` from llm, `^2.31.0` from master).
  2. Large devDependencies block: kept llm's curated bot-side form (preserves `@octokit/core`, `lerna`, `turbo`, `@types/node ^25.2.3`, pinned `typescript-eslint 8.59.2`, `eslint-plugin-jsdoc ^62.5.5`, `eslint-config-prettier ^10.1.8`, `eslint-import-resolver-exports`, `eslint-plugin-import ^2.31.0`, etc.). Folded in master's net-new `ts-node-pack: ^0.3.2` because the auto-merged scripts block kept master's `release:npm`, `pack:all`, and `smoketest:publish` (which depend on `ts-node-pack`). Did not adopt master's `eslint-plugin-import: catalog:dev` route or its `@typescript-eslint/* ^8.60.0` un-pin; matches the prior weaver's `b381e6ada` precedent.
  3. `lavamoat.allowScripts`: kept llm's superset (`lerna>nx`, `@ipshipyard/node-datachannel`, `better-sqlite3` plus the shared `@lavamoat/preinstall-always-fail`).
- **packages/eslint-plugin/lib/configs/internal.js**: llm added a 5-line comment explaining why `parserOptions.project` was dropped (typescript-eslint 8.59 deprecation); master had no comment. Kept llm's comment. `node --check` passes.
- **packages/eslint-plugin/package.json**: llm pinned `typescript-eslint 8.59.2` family; master used `^8.39.1` plus added `eslint-plugin-import: catalog:dev`. Kept llm's pins; omitted master's `eslint-plugin-import` addition because (a) the package does not import eslint-plugin-import in any source file under `lib/` or `src/`, (b) the root already declares `eslint-plugin-import ^2.31.0` directly (not via the catalog alias), and (c) adding the `catalog:dev` route here would silently route through llm's `eslint-plugin-import-x` soft-fork.
- **packages/harden/package.json**: llm added `postpack` and `prepack` scripts; master had no diff in that region. Kept llm's additions.
- **packages/hex/package.json**: llm added `prepack`/`postpack`; master added `cover: c8 ses-ava`. Both kept (orthogonal additions).
- **packages/ocapn-noise/package.json**: llm switched test runner from `ava` to `ses-ava` and added prepack/postpack; master kept `ava`. Took llm's ses-ava + prepack/postpack form. Same direction the bot fork has been moving in for hardened-JS-aware testing.
- **yarn.lock**: regenerated via `git checkout HEAD -- yarn.lock` then `yarn install --mode=update-lockfile`. Resolution step completed in <1s with the expected `eslint-plugin-import vs eslint-config-airbnb-base` peer-dep warning (pre-existing; carries over from the prior weaver's note on `b381e6ada`). Net lockfile change: added `@fast-check/ava 3.0.1`, `ava 8.0.1`, `c8 11.0.0`, `ts-node-pack 0.3.3` and 32 more; removed `@bcoe/v8-coverage 0.2.3`, the older `c8 7.14.0`, etc.

Rerere captured all twelve resolutions.

## Post-sync SHAs

- `origin/master`: `ba26f4cdb` (same as `endo-upstream/master`).
- `origin/llm`: `720a39600` ("merge: actual/master into llm"; parents `c85d618df` and `ba26f4cdb`).

## Validation

- All staged files syntax-check (bash `-n` on the three shell scripts, `python3 yaml.safe_load` on ci.yml, `python3 -c "import json; json.load(open(...))"` on each package.json, `node --check` on internal.js).
- install-engines.sh post-merge diff against `ba26f4cdb` is empty (the canonical upstream form survived intact).
- Full workspace test suite was not run (the dispatch's scope is bot-master + bots/llm only; per-package tests are appropriate for per-PR rebases, not the trunk weave).

## PR-impact list

153 PRs open against `endojs/endo-but-for-bots`. The base move ripples differently depending on which branch shape the PR uses.

### Steward-queue-named PRs

The dispatch named: #387 (just-merged ferry; N/A), #388, #389, #392, #393, #394, #401, #403.

- **#387** | base=master-814dfa1 | needs-rebase=no (superseded) | upstream endojs/endo#3294 merged at `ba26f4cdb`; the mirror PR's diff is now reflected in `origin/master`. Conductor or steward closes the bot-side mirror as merged-via-upstream rather than rebasing. The frozen-base branch `master-814dfa1` can be swept after close.
- **#388** | base=design/gateway-package | needs-rebase=cascade | head of the gateway-package phase stack rooted on `llm-b1c3f4d` via #343. Direct rebase impact lands when the foundation (#343 on `llm-b1c3f4d`) is rebased onto new `llm`. Cascade rebase, not a direct one.
- **#389** | base=design/gateway-package-phase-2 | needs-rebase=cascade | stacked on #388. Rebases when #388 rebases.
- **#392** | base=design/gateway-package-phase-3 | needs-rebase=cascade | stacked on #389.
- **#393** | base=design/gateway-package-phase-4 | needs-rebase=cascade | stacked on #392.
- **#394** | base=design/gateway-package-phase-5 | needs-rebase=cascade | stacked on #393.
- **#401** | base=master-814dfa1 | needs-rebase=yes | needs a fresh frozen base at the new master tip (`master-ba26f4c`), rebase onto it, and `gh pr edit 401 --base master-ba26f4c`. The benchmark-area touch points are unlikely to overlap with a shellcheck-CI PR, so conflicts should be light. Per `skills/frozen-base-branch/SKILL.md`.
- **#403** | base=llm-c85d618 | needs-rebase=yes | needs a fresh frozen base at the new llm tip (`llm-720a396`), rebase onto it, and `gh pr edit 403 --base llm-720a396`. The PR is layer-1 of #358; the new merge commit between c85d618df and 720a39600 covers the upstream sync but does not touch registry-capability code, so conflicts should be light.

### Other PRs needing fresh frozen base + rebase

Frozen-base PRs against an older `llm-<sha>` or `master-<sha>` branch need a new frozen base at the post-sync tip plus a rebase. Per `skills/frozen-base-branch/SKILL.md`, the weaver creates `<base>-<new-sha>` at the new tip, rebases the head, and updates the PR's `base` field.

| PR | current base | needs |
| -- | -- | -- |
| #79 | master-c49fb04 | new frozen base on `ba26f4cdb`; rebase |
| #242 | llm-b1c3f4d | new frozen base on `720a39600`; rebase |
| #311 | master-455ce47 | new frozen base on `ba26f4cdb`; rebase |
| #320 | llm-b1c3f4d | new frozen base on `720a39600`; rebase |
| #343 | llm-b1c3f4d | new frozen base on `720a39600`; rebase (foundation of the gateway-package stack #388/389/392/393/394/395/396/397) |
| #356 | llm-b1c3f4d | new frozen base on `720a39600`; rebase |
| #357 | llm-5b1361d | new frozen base on `720a39600`; rebase |
| #359 | llm-b1c3f4d | new frozen base on `720a39600`; rebase |
| #360 | llm-b1c3f4d | new frozen base on `720a39600`; rebase |
| #377 | master-c49fb04 | new frozen base on `ba26f4cdb`; rebase (also a benchmark-area PR; likely conflicts with the merged #3294 fix; may be superseded similarly to #387) |
| #405 | llm-c85d618 | new frozen base on `720a39600`; rebase |

### PRs on bare `llm` (91 PRs, no frozen base)

These PRs use the literal `llm` branch as base. With `llm` now at `720a39600` (was `c85d618df`), GitHub will re-render each PR's diff against the new base on its next fetch. Most do not need a per-PR rebase action; the base moved forward and GitHub recomputes. Action depends on:

- **CI status**: PRs that were red because of the test-xs esvu flake (the #3294 fix's motivation) should now go green on a fresh CI run. Re-trigger CI on each.
- **Merge conflicts surfaced by the new merge commit**: rare, because the merge commit only adds master-side content the llm branch did not already touch. Any PR that touches `packages/benchmark/install-engines.sh`, `packages/hex/test/run-benches.sh`, `packages/benchmark/run-tests.sh`, root `package.json`, root `yarn.lock`, `.github/workflows/ci.yml`, `packages/eslint-plugin/lib/configs/internal.js`, or the four `packages/<pkg>/package.json` files listed above will need a per-PR rebase.

The 91 PRs on `llm`: #58, #89, #96, #101, #106, #123, #125, #127, #129, #131, #132, #133, #134, #135, #138, #147, #149, #151, #152, #160, #165, #166, #169, #170, #174, #178, #179, #197, #216, #224, #231, #234, #237, #238, #241, #248, #249, #254, #256, #257, #264, #266, #267, #268, #269, #270, #271, #273, #274, #275, #276, #277, #278, #279, #281, #282, #283, #284, #286, #288, #289, #290, #297, #298, #300, #301, #305, #306, #313, #316, #317, #318, #319, #321, #322, #323, #324, #328, #329, #330, #331, #335, #340, #367, #369, #370, #398, #399, #400, #402, #404.

Of note in this set:

- **#257** is *itself* the "chore: merge actual/master into llm" PR from 2026-05-15 (now stale). The new merge commit `720a39600` is the live form; the steward may close #257 as superseded.
- **#275** bumps eslint to 10.4.0 against llm's pinned 8.57.1 stack; a fresh CI run will tell whether the new yarn.lock invalidates it.
- **#402** (Dependabot all-minor-patch group, 22 updates) likely conflicts with the regenerated yarn.lock; botanist verdict applies after Dependabot re-opens.

### PRs on bare `master` (34 PRs, no frozen base)

Same shape as the llm-base set, but smaller blast radius (master moved forward by only 4 commits). Action: re-trigger CI on each; per-PR rebase only if the PR touches the benchmark area, root package.json, yarn.lock, or `.github/workflows/ci.yml`.

The 34 PRs on `master`: #57, #60, #64, #68, #69, #71, #75, #76, #111, #155, #182, #186, #235, #239, #244, #250, #251, #253, #258, #259, #263, #280, #303, #334, #337, #344, #346, #347, #348, #350, #351, #353, #355, #379.

Of note: most are mirrors of pre-existing endojs/endo PRs; if any was hitting the test-xs esvu flake in CI, it will now go green.

### Other PR stacks (cascade-affected only)

PRs whose base is another PR's branch (not `llm`, `master`, or a frozen `<base>-<sha>` branch). These do not need direct action from this weaver; they rebase when their foundation rebases.

- #107 (base=kriskowal-random-chacha12, on #75)
- #112 (base=stack-ocapn-noise/layer-1-ocapn-codec)
- #113 (base=stack-ocapn-noise/layer-2-noise-netlayer)
- #124 (base=endor)
- #262 (base=design/ocapn-daemon-integration)
- #308 (base=feat/lal-pi-harness)
- #395 #396 #397 (base=design/gateway-package-phase-6/7/8; cascade from #343 via #388)

## Judgment calls

- **Rebase vs merge for bots/llm onto bot-master.** Switched to merge after a partial rebase attempt; justification in *Strategy choice* above. Follows the prior weaver's `b381e6ada` precedent. Surfacing here because the dispatch literal said "rebase"; the maintainer can override on next sync if they prefer the unconditional rebase shape (at the cost of replaying 1072 commits for every future sync of this kind).
- **install-engines.sh resolution: took master verbatim.** The two sides represent the same fix in different forms (in-flight mirror vs upstream-merged); the upstream-merged form is the canonical truth per `feedback_bot_master_reset_to_actual.md`. Calling this out because the `--ours/--theirs` discipline is the weaver's hard rule, and "take master verbatim" looks superficially like `--theirs`. The justification is that both sides were the same intent (and the upstream form supersedes the in-flight form), not "we picked a side." If a reviewer prefers, they can verify by reading the per-side diffs in this entry's conflict-resolution section.
- **eslint-plugin-import scope on the sub-package.** Master's addition was omitted from `packages/eslint-plugin/package.json` because of the soft-fork-aliasing concern noted by the prior weaver, even though the addition is in a per-package file rather than root. If the upstream intent was to declare a peer dep here (rather than rely on the root declaration), a follow-up may need to surface it as a `eslint-plugin-import: ^2.31.0` direct add rather than the `catalog:dev` route. Flagged for steward awareness.
- **#387 and #377 as benchmark-area mirrors.** Both PRs are bot-side mirrors of the same upstream fix (#387 ferried, #377 an earlier attempt). With #3294 now in upstream and merged into bot-master, both are superseded. The steward / conductor handles the close, not this weaver.

Self-improvement: nothing this time. The merge-vs-rebase strategy choice is already captured in `journal/projects/endo-but-for-bots/README.md` precedent (the b381e6ada entry) and in the weaver role's "many commits the dispatch wants preserved as discrete units" clause; no new garden-level lesson surfaces from this sync.
