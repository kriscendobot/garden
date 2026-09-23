---
ts: 2026-06-11T20:17:26Z
kind: result
role: weaver
host: endolinbot
project: agoric-sdk
repo: kriscendobot/agoric-sdk
dispatch_root: /home/kris/dispatches/weaver--0207d5
short_id: 0207d5
to: liaison
refs:
  - entries/2026/06/10/181800Z-result-fixer-d6af77.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 5
    role: mirror
    state: DRAFT
next: ferry-from-credentialed-host
---

# result: weaver PR kriscendobot/agoric-sdk#5 (0207d5)

## Directive

`kriskowal` on PR #5 comment `4684506028` (2026-06-11T20:07Z): "@kriscendobot Let's try that. Please rebase on master and remove the ava ^7 commit."

Reverses the prior fixer 18:18Z (d6af77) decision to restore `ava ^7.0.0` to match upstream master. The maintainer + upstream review prefer keeping the mirror branch on `ava ^6.4.1` (the state the cherry-pick of `Agoric/agoric-sdk#12527` landed in) and addressing the `runnerChain` cascade upstream rather than papering it over in this mirror.

## Pre / post SHAs

- Pre (lease anchor): `02782246bb5abb4af012fae35b3072b9d82b7998` (the `chore(a3p-integration): refresh yarn.lock and pin @endo/promise-kit / ses` head from the prior fixer).
- Post: `c81b03e62216edcbfc12809aefb91d029f7a20a5` (new head after dropping the ava restore + paired yarn.lock commits).

Note on commit-SHA terminology: the dispatch brief named `cf798d660e` as the ava restore commit; the actual SHA on the branch by the time this weaver ran was `181a10e25d` (the commit title matched verbatim — `chore(deps): restore ava ^7.0.0 across workspaces`). The brief's SHA was the prior fixer's pre-rebase SHA; an intervening rebase had moved it. Net effect identical.

## Commits dropped

| Old SHA | Title | Why dropped |
|---|---|---|
| `181a10e25d` | `chore(deps): restore ava ^7.0.0 across workspaces` | Directive: the maintainer reversed the prior fixer's restoration decision after upstream review. |
| `b917c62349` | `chore: Update yarn.lock` (the lockfile reconciliation paired with the restore above) | Its lockfile delta was the exact inverse of the regenerated lockfile state once the ava restore was gone; keeping it then regenerating would have produced an empty additional commit. The cleanest history drops both. Confirmed by post-drop `git stash pop` producing zero working-tree delta. |

## Commits preserved

Eleven commits remain (was 13):

```
c81b03e622  chore(a3p-integration): refresh yarn.lock and pin @endo/promise-kit / ses
54de66c9e6  chore: Update yarn.lock
ea1e76300e  fix(deps): patch @endo/compartment-mapper to strip __createdBy from bundles
01e2e7d7c7  chore(deps): refresh lockfiles
3648438224  chore(swingset-vat): update xsnap store test snapshots
103a197441  chore(swingset-vat): increase meter allocation for Endo update
28f48a84bd  fix(types): adapt to @endo/bundle-source load() returning unknown
43e88c10a5  chore(deps): deduplicate yarn.lock after Endo sync
9fd0304fc3  build(deps): ensure `@endo/pass-style` is patched
218350dda7  chore(deps): update Endo packages and fix type regressions
d3a90fa16e  chore: sync Endo versions and patches
```

All commits above `54de66c9e6` retain their original SHAs (the rebase only touched commits above the drop points and there were no commits above `b917c62349` after the ava drop, so only the a3p commit reflowed onto the new parent: `40da00fd6a -> c81b03e622`).

## Frozen base

`master-57c6564` is already at upstream/master tip (`57c65644e1`). No new frozen-base branch was needed; the existing base is current. The `gh pr edit --base` step in `skills/frozen-base-branch/SKILL.md` § Rebase was skipped because the SHA-7 short SHA did not move (`origin/master-57c6564` and `upstream/master` agree on `57c65644e1`).

## Verification

- Local: `corepack yarn install --immutable` at root → PASS (no YN0028, no YN0071).
- Local: `corepack yarn build` at root → PASS (31s, clean compile, single-file ESM bundle at services/ymax-planner/dist/entrypoint.js built).
- Net-diff vs `upstream/master`: 96 files changed, 4,723 insertions, 5,146 deletions (the package.json files re-acquire ava ^6.4.1 entries on the workspaces where the cherry-pick landed them; yarn.lock reflects ava 6 resolutions; the rest is the Endo sync content unchanged).

## Force-push

```
git push --force-with-lease=mirror/12527-endo-sync-refresh:02782246bb5abb4af012fae35b3072b9d82b7998 \
        origin HEAD:mirror/12527-endo-sync-refresh
# → + 02782246bb...c81b03e622 HEAD -> mirror/12527-endo-sync-refresh (forced update)
```

Lease anchor matched HEAD before push, no concurrent writer raced.

## CI first look

PR head `c81b03e622`. ~30 seconds post-push the static set was 4 SUCCESS + 11 SKIPPED + 8 IN_PROGRESS (Test Golang, golangci-lint, Test Documentation, Nix Flake Check, plus four other jobs that hadn't reported a conclusion yet). Substantive `test-*` jobs hadn't reported yet at result-write time; expected failure shape is the same `runnerChain` cascade the shepherd diagnosed (entries/2026/06/10/043918Z-result-shepherd-39f4a0.md) plus the `test-dapp (node-new)` documented expected-fail per `MAINTAINERS.md`. The directive's framing implies the maintainer is OK accepting the red mirror PR as evidence of the cherry-pick state, with the real fix landing upstream rather than here.

## PR comment posted

Per the dispatch brief's explicit instruction "Reply on directive comment 4684506028 noting drop + first-look CI state + that upstream re-ferry is a separate boatman engagement from credentialed host", which is the per-action authorization for this weaver comment (the weaver does not otherwise post on PRs without per-action authorization per roles/COMMON.md § External-repo etiquette).

- <https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4684602126>

## Recommended next stage

**ferry from credentialed host**. The dispatch brief named the next-stage handoff explicitly: re-ferry the refreshed `mirror/12527-endo-sync-refresh` onto upstream `Agoric/agoric-sdk#12527`. This requires a boatman dispatch from the kriskowal-credentialed host (kmkmbp2021 as of 2026-05-14 per `journal/projects/endo/README.md` § Identity and credentials); the bot identity on endolinbot cannot ferry upstream. The liaison receiving this report on endolinbot should NOT originate a boatman dispatch from here; the maintainer (or a liaison on the credentialed host) issues the ferry.

If the maintainer prefers to wait on CI before ferrying, the shepherd's CI watch on this PR is the appropriate gate — but per the directive's framing, the ava ^6 state is intentional and the upstream is the right place to triage the `runnerChain` cascade. The mirror PR's CI red on `runnerChain` jobs is then expected and acceptable.

Self-improvement: the brief's pre-rebase SHA (`cf798d660e`) was stale by the time the weaver dispatched (the branch had been pushed-amended in between to `02782246bb`, with the ava restore commit moved to `181a10e25d`). The weaver found the right commit by matching subject line ("chore(deps): restore ava ^7.0.0 across workspaces") and confirming the diff matched the brief's description. Lesson: a dispatch brief's SHA for "drop commit X" is best-effort — verify by subject + diff before the interactive rebase, and trust the lease anchor over the brief's pre-SHA for the push. Below threshold for a new skill; noting here as a one-line nudge for future weavers reading recent results.
