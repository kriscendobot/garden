---
ts: 2026-06-10T03:57:00Z
kind: result
role: shepherd
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/shepherd--528eb6
short_id: 528eb6
to: liaison
refs:
  - entries/2026/06/09/033100Z-result-builder-1f1de6.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: fixer
---

# result: shepherd PR #5 kriscendobot/agoric-sdk (528eb6)

## Head SHA and verdict

- Head: `962b1b5b9513e18e9b1c4d774c94810c7a07491e` (unchanged; no shepherd push).
- Mergeable: `MERGEABLE` (no merge-ref blockage; CI dispatches on push).
- Draft: yes.
- CI: 4 failures, 7 passes, ~30 skipped (integration tests gated on `force:integration` label).

## Failure inventory

All four red checks share **one** root cause: `YN0028: The lockfile would have been modified by this install, which is explicitly forbidden`. The yarn-immutable-install gate trips at `yarn install` before any test or build logic runs.

| Check | Job | Classification | Step where it failed |
|---|---|---|---|
| `build (node-new)` | [80242960464](https://github.com/kriscendobot/agoric-sdk/actions/runs/27182002112/job/80242960464) | fix-in-scope (fixer) | `yarn install` post-resolution validation |
| `build (node-old)` | [80242960481](https://github.com/kriscendobot/agoric-sdk/actions/runs/27182002112/job/80242960481) | fix-in-scope (fixer) | `yarn install` post-resolution validation (job cancelled after YN0028) |
| `test-dapp (node-new)` | [80242960406](https://github.com/kriscendobot/agoric-sdk/actions/runs/27182002096/job/80242960406) | fix-in-scope (fixer) | `yarn install` post-resolution validation |
| `flake-check` | [80242960400](https://github.com/kriscendobot/agoric-sdk/actions/runs/27182002100/job/80242960400) | fix-in-scope (fixer) | wait-build-image setup; YN0028 repeats at 03:31:22 and 03:37:22 |

## Classification justification

### Why not `flake re-run`

YN0028 is deterministic. A re-run will produce the same lockfile mismatch because the cherry-picked yarn.lock has the wrong content for the current `master`'s workspace package.json files. No re-run warranted.

### Why not `environment-acknowledge` (despite the PR body's framing)

The PR body says `test-dapp (node-new)` is "expected to fail per MAINTAINERS § Syncing Endo dependency versions until a companion change on `agoric/documentation` lands." That framing was correct for the **dapp-test substance**, but is not applicable here because:

- The job never reaches the dapp-test logic. It fails at `yarn install` (pre-resolution / post-resolution), the same step that gates `build (node-new)`, `build (node-old)`, and `flake-check`.
- The companion-documentation PR resolves a documentation-side test fixture; it does not unstick the install gate.

Acknowledging this failure as expected would mask the real, in-scope regression.

### Why `fix-in-scope` and `next: fixer` (not shepherd's own push)

The fix is the canonical Endo-sync walk per `MAINTAINERS.md` § Syncing Endo dependency versions:

```
git ls-tree -r HEAD | cut -f2 | grep '.yarn.lock$' |
while read lock; do (cd $(dirname $lock); yarn up ses '@endo/*' -R; yarn dedupe); done
```

The builder's result entry (`entries/2026/06/09/033100Z-result-builder-1f1de6.md` § Version bump to current npm) explicitly deferred this walk to the next-stage owner, naming two gates the bump pass must reckon with:

1. **a3p-integration proposals require `prepare-test.sh`** (vendor local packages) before `yarn up` can run on `f:ymax0-restart` and `g:ymax1`.
2. **Root `yarn up` fails with `eslint-plugin-import@catalog:dev: catalog "dev" not found or empty`** when bumping to current npm; agoric-sdk does not define yarn catalogs, so yarn refuses transitively.

Plus the substance refresh the builder named (delete `@endo/pass-style@1.7.0` patch absorbed into 1.8.0; rebase `@endo/bundle-source` patch against 4.3.1; verify `@endo/compartment-mapper@2.2.0` substance).

That work spans:

- 9+ yarn.lock files (`a3p-integration/proposals/{a,b,c,d,e,f,g}*/yarn.lock` + `multichain-testing/yarn.lock` + root `yarn.lock`).
- Patch-set edits under `.yarn/patches/*` (delete one, rebase one, verify one).
- Per-workspace `package.json` resolutions (root resolutions, possibly catalog definition).
- Resolution of the two gates the builder named (interactive `prepare-test.sh`, root catalog).

This exceeds shepherd's surgical-fix scope (≤5 files; no public-API or topology changes; no `--no-verify` or skip-the-failure shortcuts). The `next: fixer` verdict authorizes the steward's auto-pickup chain to dispatch the fixer without re-asking the maintainer.

## No shepherd push

The dispatch prompt permitted append-push (no amend/force/rebase). I did not push: the only defensible fix is the deferred Endo-sync walk, which is fixer-shaped and exceeds shepherd scope. An attempted small fix here would either (a) touch >>5 files at the lockfile-walk step, or (b) hit the catalog-"dev" gate at the root step and fail without progress.

## Posted to PR

Per the dispatch prompt's per-action authorization ("Post convergence summary on PR #5 + reply on kriskowal's directive comment 4662462430"):

- Convergence summary: <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666316507>
- Reply quote to "Pray shepherd.": <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4666318718>

## Hand-off

`next: fixer`. The fixer dispatch should reference this result entry and the builder's `entries/2026/06/09/033100Z-result-builder-1f1de6.md` § Version bump to current npm. The deliverable is a green-CI head SHA on `mirror/12527-endo-sync-refresh` for kriscendobot/agoric-sdk PR #5, reached via:

1. Run `prepare-test.sh` in `a3p-integration/proposals/f:ymax0-restart` and `g:ymax1` to vendor workspace packages.
2. Investigate the root `eslint-plugin-import@catalog:dev` gate (likely path: add a yarn catalog to `.yarnrc.yml` mirroring Endo's, or downgrade affected transitive dependencies). Document the resolution in the commit message.
3. Run the canonical `yarn up ses '@endo/*' -R; yarn dedupe` walk per `MAINTAINERS.md`.
4. Refresh the patch set: delete `@endo/pass-style@1.7.0` patch (absorbed into 1.8.0); rebase `@endo/bundle-source` patch against 4.3.1 (cache.js rewrite warned in builder result); verify `@endo/compartment-mapper@2.2.0` substance.
5. Commit per `MAINTAINERS.md`'s canonical commits (`chore: Sync Endo versions`, `chore: Update yarn.lock`) and push.
6. The `test-dapp (node-new)` expected-fail framing then becomes applicable for whatever subset of test-dapp logic the CI reaches; that's a separate companion `agoric/documentation` PR per MAINTAINERS.

Self-improvement: when a PR body documents an "expected CI failure" for a specific check, the shepherd should verify the failing job actually reaches the documented-substance step before honoring the framing. In this case the PR body's `test-dapp (node-new)` expected-fail note was substantively correct but operationally moot because the install gate hits first. This is a small clarification worth a line in `skills/ci-status-summary/SKILL.md` if it's not already there: "verify the failure mode matches the framing's failure mode, not just the check name." Below threshold for a message-to-liaison; noting here for the next shepherd that encounters a documented-expected-fail framing.
