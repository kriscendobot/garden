---
ts: 2026-06-10T22:29:51Z
kind: result
role: weaver
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/221842Z-result-liaison-20c0e8.md
  - entries/2026/06/10/220923Z-dispatch-liaison-f5b22f.md
---

**Rebased kriscendobot/agoric-sdk#5 onto Agoric upstream master tip `57c65644e1` (71 commits ahead of prior `daf7a864c`).** Single-conflict rebase, force-with-lease push, PR base retargeted, mergeable. CI is firing.

**Frozen-base lifecycle (per `skills/frozen-base-branch/SKILL.md` § Rebase).**
- Old frozen base: `master-daf7a86` (left in place; conductor sweeps at PR close).
- New frozen base: `master-57c6564` (pushed from `upstream/master` tip).
- PR #5 `--base` moved to `master-57c6564` via `gh pr edit`.

**Head movement.**
- Before: `b69f426410f1849fa41e03f8fec7ba48449c10b9` (the lease anchor).
- After: `02782246bb` (force-with-lease push verified by remote ack `b69f426410...02782246bb`).
- 13 commits preserved; per-commit attribution intact (the 9 originals + 4 normalized to Kris Kowal stay as the boatman ferry's `f5b22f` left them).

**Conflict surface.** One commit, `chore(deps): update Endo packages and fix type regressions` (Turadg, originally `95b650ce92`, now `218350dda7`):

1. **`packages/inter-protocol/test/provisionPool.test.js`** (content conflict). Upstream `#11866 BREAKING CHANGE: remove PSM from provisionPool` eliminated `psmBundle`, `psmInstall`, `startPSM`, `initPSM` references. The Endo-sync commit added `SourceBundle` type casts on all four bundles (psm, policy, committee, centralSupply). Resolution: preserve upstream's PSM-free structure but keep the `SourceBundle` type-cast pattern on the three bundles that survive (`policyBundle`, `committeeBundle`, `centralSupplyBundle`). The `@import {SourceBundle}` survives. Per `skills/conflict-resolution/SKILL.md`: read both sides, write the third state honoring both intents — no `--ours`/`--theirs`.
2. **`packages/inter-protocol/test/smartWallet/boot-test-utils.js` and `contexts.js`** (modify/delete). Upstream deleted them in `5f5e5ffc45 test: rm outdated tests` (sibling to the PSM removal). The Endo-sync commit had type-refresh edits. Resolution: accept the deletion — these PSM-era test fixtures are obsolete with PSM gone, and the type-refresh edits have no consumer in the post-PSM tree. Confirmed no remaining references via `git grep -l 'boot-test-utils\|smartWallet/contexts' -- packages/inter-protocol/`.

The other twelve commits rebased cleanly — no conflicts in yarn.lock, package.json workspace deps, xsnap `METER_TYPE`, SwingSet snapshots, or `patches/`. The expected hot spots quietly cooperated; only the PSM-removal cross-cut bit.

**Post-rebase verification.**
- `yarn install --immutable`: clean (only the project's usual peer-dep warnings about `@agoric/xsnap` and `eslint-plugin-import` that exist on upstream master too; no lockfile mutation owed).
- `yarn build`: success. Build stamp written.

**Push and PR state.**
- Force-with-lease push: `b69f426410...02782246bb` (lease anchor matched).
- `gh pr view 5 -R kriscendobot/agoric-sdk --json baseRefName,mergeable`: base `master-57c6564`, mergeable `MERGEABLE`, state `OPEN`, isDraft `true`.
- CI: `flake-check`, `lint`, `breakage`, `up-to-date`, `gotest`, `test-dapp`, `build (node-new/old)`, `run-scripts-tests`, `golangci-lint`, `wait-integration-pre-checks` (already SUCCESS) firing.

**Comment reply posted.** Replied on the directive comment `4675167395` ("Please rebase on upstream master and resolve conflicts.") with new head SHA, new frozen base name, conflict-resolution summary, and verification results. Comment URL: `https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4675265878`. (Per `roles/COMMON.md` § External-repo etiquette weaver bullet, a follow-up comment on the PR requires a per-action authorization; the dispatch brief explicitly authorized this reply on the directive comment.)

**Follow-up shape.** PR #5's purpose was the bot-side mirror of Agoric/agoric-sdk#12527 for ferry; the boatman already ferried `b69f426410` upstream as `8d2ccb2b9a`. The maintainer's directive ("Please rebase on upstream master and resolve conflicts.") was for the bot-side mirror; upstream #12527 is still anchored on `a6212a802`/then `8d2ccb2b9a` (also on a stale-vs-current-master base). The shape the prior result entry anticipated — *weave the mirror, then re-ferry* — now has its first half complete; whether to re-ferry to #12527 is the maintainer's call (and the boatman dispatch is host-gated to the credentialed host).

**Recommended next stage**: `next: shepherd`. CI has 13 in-progress checks at push time; the larger integration-tests batch and breakage check on a 71-commit-shifted base want a shepherd watching for the first real failure rather than relying on the steward's per-cycle scan to notice. If maintainer prefers a lighter touch, `next: none` with the steward's PR-creation-flow scan will pick this up at the next cycle.

Self-improvement: nothing this time. The `frozen-base-branch` § Rebase procedure cleanly applied; the `conflict-resolution` discipline (read both sides, write the third state) is the right framing for the PSM-removal cross-cut; no skill or role edit owed.
