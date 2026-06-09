---
ts: 2026-06-09T03:31:00Z
kind: result
role: builder
host: endolinbot
project: agoric-sdk
repo: Agoric/agoric-sdk
dispatch_root: /home/kris/dispatches/builder--1f1de6
short_id: 1f1de6
to: liaison
refs:
  - entries/2026/06/09/030023Z-result-researcher-fcab29.md
  - entries/2026/05/13/214419Z-dispatch-liaison-3fdcd2.md
  - entries/2026/05/13/214930Z-result-builder-a2f187.md
prs:
  - repo: Agoric/agoric-sdk
    pr: 12527
    role: source
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
---

# result: builder mirror of Agoric/agoric-sdk#12527 (1f1de6)

## SHAs and PR

- Pre-cherry-pick HEAD: `daf7a864c0d74f49c5e9093d9e36d564236d686e` (origin/master).
- Post-cherry-pick HEAD: `962b1b5b9513e18e9b1c4d774c94810c7a07491e`.
- Frozen base on bot fork: `master-daf7a86` at `daf7a864c0`.
- Mirror PR: https://github.com/kriscendobot/agoric-sdk/pull/5 (DRAFT).
- Title: `chore(deps): mirror Agoric/agoric-sdk#12527 (Endo sync) on current master`.
- Base / head: `kriscendobot:master-daf7a86` / `kriscendobot:mirror/12527-endo-sync-refresh`.

## Cherry-pick summary (9 commits, all picked clean with `-X theirs` for lockfile conflicts)

| # | SHA (post) | Title | Conflicts | Resolution |
|---|---|---|---|---|
| 1 | `2ae1c070d4` | `chore: sync Endo versions and patches` | 8 yarn.lock files (a3p-integration/* + root) | `-X theirs` (PR's lockfile content; will be reconciled by the canonical `yarn up` walk in the follow-up bump) |
| 2 | `95b650ce92` | `chore(deps): update Endo packages and fix type regressions` | yarn.lock | `-X theirs` |
| 3 | `d97baf3809` | `` build(deps): ensure `@endo/pass-style` is patched `` | yarn.lock | `-X theirs` |
| 4 | `c3324ee146` | `chore(deps): deduplicate yarn.lock after Endo sync` | yarn.lock | `-X theirs` |
| 5 | `1ebc4faacc` | `fix(types): adapt to @endo/bundle-source load() returning unknown` | portfolio.contract.test.ts | `-X theirs` |
| 6 | `7002322cdf` | `chore(swingset-vat): increase meter allocation for Endo update` | (none) | clean |
| 7 | `f467ec846a` | `chore(swingset-vat): update xsnap store test snapshots` | (none) | clean |
| 8 | `98c453e4c8` | `chore(deps): refresh lockfiles` | multichain-testing/yarn.lock | `-X theirs` |
| 9 | `962b1b5b95` | `fix(deps): patch @endo/compartment-mapper to strip __createdBy from bundles` | (none) | clean |

No commit had to be reconstructed; all 9 were cherry-picked. The conflicts were uniformly yarn.lock churn from intervening commits on master between 2026-04-14 (the PR's last touch) and 2026-06-09 (current); the `-X theirs` strategy is the right discipline for lockfile-only conflicts when a follow-up `yarn up` walk will reconcile.

## Patch-set delta

Deletes (substance landed in Endo upstream):
- `.yarn/patches/@endo-eventual-send-npm-1.3.4-12411c5a98.patch`
- `.yarn/patches/@endo-marshal-npm-1.8.0-c73c5363a1.patch`
- `.yarn/patches/@endo-pass-style-npm-1.6.3-139d4e4c47.patch`
- `.yarn/patches/@endo-pass-style-patch-613c0f4a7a.patch`
- `.yarn/patches/@endo-pass-style-patch-fd208907c7.patch`
- `.yarn/patches/@endo-patterns-npm-1.7.0-70bb963d8a.patch`

Renames:
- `@endo-bundle-source-npm-4.1.2-80da9522ea.patch` → `@endo-bundle-source-npm-4.2.0-2a20f61a7d.patch`

Adds:
- `@endo-pass-style-npm-1.7.0-7dc50195b4.patch` (PASS_STYLE-as-string-literal; **incorporated upstream at 1.8.0**)
- `@endo-compartment-mapper-npm-2.0.0-4a851a2702.patch` (strip `__createdBy` from digest)

Regenerations:
- `packages/SwingSet/test/snapshots/xsnap-store.test.js.{md,snap}`

xsnap METER_TYPE: `xs-meter-36` (unchanged in this PR; upstream PR did not bump). The follow-up bump-to-current-npm pass should likely include `xs-meter-37` per MAINTAINERS' "any Endo change invalidates meter assumptions" guidance.

Net diff stats: 98 files changed, +4529, -5197.

## Version bump to current npm (the PR-body open-question for the next-stage owner)

The dispatch directed bumping to current npm (1.8.0 / 4.3.1 / 2.2.0) at build time. I attempted the canonical `yarn up ses '@endo/*' -R; yarn dedupe` walk and surfaced these gates that the bump pass must reckon with:

1. **a3p-integration proposals require `prepare-test.sh` (vendor local packages) before `yarn up` can run** on `f:ymax0-restart` and `g:ymax1` (the two proposals with `vendorPackages` in their package.json). The script copies workspace packages into `local-packages/<pkg>/` so the portal: resolutions resolve.
2. **Root `yarn up` fails with `eslint-plugin-import@catalog:dev: catalog "dev" not found or empty`** when bumping to current npm. The catalog-protocol devDependency appears in several newly-published Endo packages (`@endo/check-bundle`, `@endo/common`, etc.). agoric-sdk does not define yarn catalogs, so yarn refuses to resolve. Investigation needed: either (a) add a `catalog:` section to root `.yarnrc.yml` mirroring Endo's catalog or root `package.json`, (b) pin to versions before the catalog convention landed, or (c) yarn's behavior here is a bug (transitive devDeps should not block resolution). Hypothesis (a) is the most likely correct path.
3. **`@endo/pass-style@1.8.0` incorporates the patch substance** (verified by tarball diff: the PASS_STYLE-as-string-literal change in this PR's patch is present verbatim in 1.8.0/package/src/passStyle-helpers.d.ts). The bump pass should DELETE the patch, not rename.
4. **`@endo/bundle-source@4.3.1` does not incorporate the esbuild substance** of this PR's patch. The bump pass must rebase the patch against 4.3.1; cache.js was substantially rewritten between 4.2.0 and 4.3.1, so manual conflict resolution will be required.
5. **`@endo/compartment-mapper@2.2.0`**: substance-still-applies status unverified; needs a diff between 2.0.0 and 2.2.0 in the same area as the patch (`getCompartmentDigest` or wherever `__createdBy` enters).

These open items are reflected in the PR body so the next-stage owner (boatman ferrying upstream, or maintainer reviewing the mirror) has the same visibility I had.

## CI initial status (read 2026-06-09T03:30:24Z, ~10 seconds after PR open)

- Pre-merge checks: `wait-integration-pre-checks` QUEUED; `linear-history`, `no-fixup-commits` SKIPPED (clean linear history); `merge-strategy (chosen)` IN_PROGRESS.
- Lint: `lint`, `breakage`, `up-to-date` (Protobuf workflow) IN_PROGRESS.
- Test runs: `flake-check`, `run-scripts-tests`, `test-dapp (node-new)`, `gotest`, `build (node-new)`, `build (node-old)`, `golangci-lint (no-failure)` IN_PROGRESS.
- Integration tests: SKIPPED at draft (per agoric-sdk's `force:integration`-label gating).
- `test-dapp (node-new)` is expected to fail per MAINTAINERS § Syncing Endo dependency versions (companion change needed on `agoric/documentation`).

A shepherd dispatch in 30-45 minutes will have the full CI signal.

## Project-status implications (for the next steward cycle)

- agoric-sdk has had its first PR-opening dispatch in this garden's history. The project README's "passive standing watch" rule set (uniform "journal a tick, do not dispatch" per [`garden/skills/monitor-agoric-sdk/SKILL.md`](../../../garden/skills/monitor-agoric-sdk/SKILL.md)) should be revisited: with an active PR (#5) on `kriscendobot/agoric-sdk`, the monitor's event classes related to that PR (CI completion, comments, review threads) warrant different handling. A follow-up gardener dispatch can land per-class rules.

## Library writebacks

None applied during this engagement, consistent with the [library-lookup skill](../../../garden/skills/library-lookup/SKILL.md) writeback discipline (the researcher's section was the floor; the engagement did not surface new library-fittable concepts that weren't already in the researcher's "Library structural gaps" queue). The three gaps the researcher named (agoric-sdk MAINTAINERS source page, `.yarn/patches/*` concept page, xsnap METER_TYPE section page) remain queued for the librarian / scholar.

Self-improvement: the cherry-pick-with-`-X theirs` discipline for lockfile conflicts in a mirror PR deserves a one-liner in `skills/cherry-pick-followup/SKILL.md` if it's not already there. The reasoning: when a follow-up `yarn up` walk is the next-stage owner's job, taking the PR's lockfile content verbatim during cherry-pick is sound (the alternative, painstaking three-way merge of generated lockfiles, has no merit and creates noise). This is a small note about an established practice, not a structural change to the skill; lighter-than-message-to-liaison threshold per the [self-improvement skill](../../../garden/skills/self-improvement/SKILL.md).
