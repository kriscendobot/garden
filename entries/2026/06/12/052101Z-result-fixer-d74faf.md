---
ts: 2026-06-12T05:21:01Z
kind: result
role: fixer
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/fixer--d74faf
short_id: d74faf
to: liaison
refs:
  - entries/2026/06/12/041400Z-dispatch-fixer-d74faf.md
  - entries/2026/06/12/035100Z-result-shepherd-076ec8.md
  - entries/2026/06/11/201726Z-result-weaver-0207d5.md
  - https://github.com/kriscendobot/agoric-sdk/pull/5
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: liaison
---

# result: fixer PR kriscendobot/agoric-sdk#5 (d74faf)

## TL;DR

Phase 1 (Option B) applied via interactive rebase: `218350dda7` was edited to fold in restoration of `ava ^7.0.0` across 29 workspace `package.json` files (the only ava-affecting deltas in the cherry-pick), preserving the rest of the commit's substance. A separate `chore: Update yarn.lock` commit at the tip reconciles the lockfile (drops `ava@npm:^6.4.1`, leaves only `ava@npm:^7.0.0`). CI converged: **68 SUCCESS, 11 SKIPPED, 1 FAILURE (`test-dapp (node-new)` — documented expected-fail per `MAINTAINERS.md`)**. The 11-job mixed-ava cascade and its 2 downstream cancellations are fully resolved.

Phase 2 (yarn `resolutions` override) was investigated and found unnecessary post-Phase-1: with all workspaces at ava `^7.0.0` and the lockfile holding only `ava@npm:^7.0.0`, there is no non-overlapping range to override. The `@endo/ses-ava@1.4.0` peer-dep YN0060 warnings remain but match upstream master's warning state; `yarn install --immutable` succeeds.

Force-with-lease push: `c81b03e62216edcbfc12809aefb91d029f7a20a5` (lease) -> `bd397628bca25d84cb8a9dcbb97dd1ddbb6d4c7b`.

## Phase 1 - Interactive rebase of 218350dda7

### Procedure

1. `GIT_SEQUENCE_EDITOR='sed -i -e "s/^pick 218350dda7/edit 218350dda7/"' git rebase -i 218350dda7~1` to stop at the target commit.
2. Restored `"ava": "^7.0.0"` (from `"ava": "^6.4.1"`) in 29 workspace `package.json` files via a one-line `str.replace` per file (preserves JSON formatting and key order).
3. `git add -u && git commit --amend --no-edit` (no `--reset-author`, so the original `Turadg Aleahmad <turadg@agoric.com>` author identity is preserved on the amended commit).
4. `git rebase --continue` replayed the 9 downstream commits with zero conflicts. None of the subsequent commits touch the 29 affected workspace `package.json` files; the root-level `package.json` touches by `9fd0304fc3` and `ea1e76300e` are disjoint.
5. After rebase, `corepack yarn install --mode update-lockfile` regenerated `yarn.lock` to reflect the workspace-level ava ^7 restoration (37 inserts, 265 deletes; ava 6.4.1 entries and their transitive package set drop out).
6. Staged the lockfile delta as a separate `chore: Update yarn.lock` commit at the tip (per `skills/yarn-lock-separate-commit/SKILL.md`).

### The 29 workspaces edited

`packages/{ERTP, base-zone, builders, casting, deploy-script-support, fast-usdc-deploy, governance, inter-protocol, internal, kmarshal, network, notifier, orchestration, portfolio-contract, smart-wallet, solo, spawner, store, swingset-xsnap-supervisor, telemetry, time, vat-data, vats, vow, wallet/api, xsnap-lockdown, xsnap, zoe, zone}/package.json`.

Note: the dispatch brief named 28 files; the actual count is 29. The brief's count was off by one; the operation is identical and the verification check below confirms zero ava drift vs upstream.

### Net-diff invariant check (vs upstream master)

```
$ git diff upstream/master..HEAD -- 'packages/*/package.json' | grep -E '^[+-].*"ava":'
(no output)
```

Zero ava-version delta between this branch and `upstream/master` for any workspace `package.json`. The branch is now in the same ava-state as upstream master.

### Final commit chain (post-rebase, post-lockfile-commit)

```
bd397628bc  chore: Update yarn.lock                                               # NEW (lockfile reconciliation)
b46dc4cc40  chore(a3p-integration): refresh yarn.lock and pin @endo/promise-kit / ses
3bb633f59d  chore: Update yarn.lock
9625b667ce  fix(deps): patch @endo/compartment-mapper to strip __createdBy from bundles
5cc0059c9d  chore(deps): refresh lockfiles
5f76256b61  chore(swingset-vat): update xsnap store test snapshots
a8040fe924  chore(swingset-vat): increase meter allocation for Endo update
35c18254e4  fix(types): adapt to @endo/bundle-source load() returning unknown
84735c184a  chore(deps): deduplicate yarn.lock after Endo sync
f32af8dc41  build(deps): ensure @endo/pass-style is patched
ed29496b2f  chore(deps): update Endo packages and fix type regressions             # AMENDED (ava ^7 restored)
d3a90fa16e  chore: sync Endo versions and patches
57c65644e1  (upstream/master) remove PSM from provisionPool (#11866)
```

11 commits remain (vs weaver `0207d5`'s 11 + my +1 `chore: Update yarn.lock` = 12). Authorship preserved: `218350dda7 -> ed29496b2f` still Turadg Aleahmad; the new tip lockfile commit is endolinbot per the per-host bot-identity pin.

## Phase 2 - Yarn resolutions investigation

### Findings

The maintainer's directive comment `4687234318` asked whether yarn `resolutions` could override the non-overlapping ava range. Post-Phase-1, this override is structurally unnecessary:

1. **Lockfile state**: post-Phase-1 yarn.lock contains exactly one ava entry, `ava@npm:^7.0.0`. There is no `ava@npm:^6.4.1` resolution to coerce; the multi-major state that `resolutions` would address no longer exists.
2. **Orphan resolution entry**: the root `package.json` `resolutions` block carries `"ava@npm:^6.4.1": "patch:ava@npm%3A6.4.1#~/.yarn/patches/ava-npm-6.4.1-be769b2551.patch"`. This is a dead lookup post-Phase-1 (no transitive consumer requests ava 6.4.1), but `upstream/master` carries the same orphan entry, so this is behavior parity rather than divergence. The patch file (`.yarn/patches/ava-npm-6.4.1-be769b2551.patch`, an Agoric-specific TAP-output env tweak) is also retained on upstream master.
3. **`@endo/ses-ava@1.4.0` peer-dep**: the published manifest declares `peerDependencies: { "ava": "^5.3.0 || ^6.1.2" }`. Against the workspace-declared `ava ^7.0.0`, this produces YN0060 warnings during `yarn install`. The warnings are non-blocking (yarn install --immutable succeeds), and they are the same warnings flagged by the maintainer's prior comment 4677822843 as "yarn tolerates it as a warning in normal installs". Runtime use of ava in `ses-ava` is limited to `import test from 'ava'` (pass-through re-export) and JSDoc type imports of `ExecutionContext` / `LogFn`; ava 7's surface for these is API-compatible.

### Decision

Held off on adding a yarn `resolutions` entry. Rationale:

- Adding `"ava@npm:^5.3.0 || ^6.1.2": "npm:^7.0.0"` would silence the YN0060 warnings, but the warnings already match upstream master's state, so the silencing would be a *new* divergence from upstream behavior (the opposite of the directive's intent of "this PR should not affect ava state").
- The cascade that motivated the override question (mixed-major ava installs producing the runnerChain assertion) is fully resolved by Phase 1 alone. CI evidence below.

If the maintainer prefers to silence the YN0060 explicitly anyway (a defensive lockdown against future transitive consumers pulling in ava 6), a one-line `resolutions` add plus a follow-up `chore: Update yarn.lock` commit is a separate small dispatch. Routed through the recommended-next-stage.

## Phase 3 - CI convergence

### Pre-rebase baseline (from shepherd `076ec8` on `c81b03e62`)

| Conclusion | Count |
|------------|-------|
| SUCCESS    |    28 |
| FAILURE    |    14 |
| CANCELLED  |    27 |
| SKIPPED    |    14 |

The 14 FAILUREs decomposed as 11 mixed-ava cascade + 2 downstream + 1 documented `test-dapp`.

### Post-rebase final (head `bd397628bc`, run id at link below)

| Conclusion | Count |
|------------|-------|
| SUCCESS    |    68 |
| SKIPPED    |    11 |
| FAILURE    |     1 |

The sole FAILURE is `test-dapp (node-new)`, documented expected-fail per `MAINTAINERS.md` § Syncing Endo dependency versions (unrelated to ava).

All previously-failing checks are now SUCCESS:

- `lint-rest`, `lint-primary` (the two-distinct-ava-resolution tsc TS2345/TS2322 failures).
- `test-zoe-unit (node-new)`, `test-zoe-swingset (node-new)`, `test-inter-protocol (node-new)`, `test-governance (node-new)`, `test-solo (node-new)` (the supertap YAMLException chain).
- `test-quick (xs)`, `test-quick2 (node-old)`, `test-fast-usdc-deploy (node-old)`, `test-portfolio-contract (node-old)` (the `assert(refs.runnerChain)` falsy cascade).
- `dependency-graph` (downstream of the lint-primary tsc misshape).
- `test-swingset (node-new, 0, 5)` (no longer cancelled).

Run URL: https://github.com/kriscendobot/agoric-sdk/actions?query=branch%3Amirror%2F12527-endo-sync-refresh

### Pre-push gates

Ran `garden/skills/pre-push-gates/pre-push-gates.sh` after `corepack yarn build` (required to generate `@agoric/cosmic-proto` codegen artifacts so lint:types could resolve transitive imports). Final result: `gate passed`. All probes (filename-no-stutter, no-ascii-banners, no-inline-import-jsdoc, no-non-ascii-in-source, no-pull-citations, security-md-hash-uniform, sentence-per-line-md, test-package-no-main) pass; yarn format pass (no changes); yarn lint pass.

## Push

```
git push --force-with-lease=mirror/12527-endo-sync-refresh:c81b03e62216edcbfc12809aefb91d029f7a20a5 \
        origin HEAD:mirror/12527-endo-sync-refresh
# -> + c81b03e622...bd397628bc HEAD -> mirror/12527-endo-sync-refresh (forced update)
```

Lease anchor matched remote tip at push time; no concurrent writer raced.

## Comments posted on PR #5

- Top-level summary: https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687710148
- Reply on directive `4687224493` (Option B sgtm): https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687710812
- Reply on directive `4687234318` (override path): https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4687711299

The summary at-mentions `@kriskowal` per the dispatch's per-action authorization, names the pre/post SHAs, includes the before/after CI table, and explains the held-off Phase 2 decision. The two reply comments cite the summary for detail and offer the explicit resolution-add as a follow-up if the maintainer wants the YN0060 silenced.

## Out of scope (did not do)

- No re-add of the prior `chore(deps): restore ava ^7.0.0 across workspaces` standalone commit (explicit dispatch prohibition; restoration is folded into `218350dda7` instead).
- No base rebase; PR remains on `master-57c6564`.
- No PR un-draft, no ready-for-review flip; PR remains DRAFT.
- No upstream cross-link or re-ferry; that is the maintainer's call from the credentialed host and is the recommended next stage if approved.

## Recommended next stage

**`next: liaison`**. The maintainer's directive comment `4687224493` named "Option B sgtm. I'll ask for a rebase and retcon regardless, then shepherd again" - meaning the maintainer planned to follow up with an explicit retcon request (which would also drive a re-ferry) once Option B converged. CI is now green up to the documented expected-fail; the branch is structurally ready for either:

1. **Retcon + ferry** (the maintainer's stated next step) - the liaison routes a retcon (likely a fixer or weaver per `skills/retcon/SKILL.md`) and then a boatman dispatch from the credentialed host.
2. **Direct ferry** (skip retcon if the maintainer is satisfied with the current commit shape) - boatman from the credentialed host updates `Agoric/agoric-sdk#12527` with the new branch head.
3. **Add yarn resolutions defensively** (if the maintainer wants the YN0060 silenced) - a one-line add per the Phase 2 investigation; small fixer or weaver dispatch.

The branch is in a clean, mergeable-shape state from a CI perspective. The liaison receiving this report on `endolinbot` should *not* originate a boatman dispatch from here; the boatman runs from the kriskowal-credentialed host per `journal/projects/endo/README.md` § Identity and credentials.

Self-improvement: the dispatch brief's "Option B" framing (drop just the ava version downgrades from the cherry-pick) was unusually precise about WHAT to do, but slightly under-specified WHERE to put the lockfile delta. I chose a separate `chore: Update yarn.lock` commit at the tip per `skills/yarn-lock-separate-commit/SKILL.md`, but the alternative of folding the lockfile delta into the amended `218350dda7` would have produced an even tighter net-diff history. Future dispatches that combine "interactive-rebase-edit a commit's package.json changes" with "regenerate lockfile" should consider folding the lockfile into the amended commit when the changed lockfile scope is narrowly the same as the amend's package.json scope; below threshold for a new skill (the existing yarn-lock-separate-commit skill already has the right guidance for the general case), noting here as a one-line nudge for future readers.
