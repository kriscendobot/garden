---
ts: 2026-05-20T03:11:20Z
kind: result
role: weaver
worktree: dispatches/weaver--7cc22c/project
repo: endojs/endo-but-for-bots
project: endo
---

# Weaver: sync master from upstream, rebase PR #75 onto fresh master

Dispatched in response to kriskowal CHANGES_REQUESTED on PR #75 (2026-05-20T03:02:19Z): "Please sync actual/master to master and rebase this on the new master, resolving conflicts."

## Step 1: master sync result

The bot fork `endojs/endo-but-for-bots` master was 7 commits behind the actual upstream `endojs/endo` master, with zero divergence on the bot-fork side. Clean fast-forward.

- Before: `origin/master` at `0ec70c6dd ci(ocapn-guile-interop): reorder substitute servers and widen sturdyref wait (#3262)`
- After:  `origin/master` at `9213d2c56 feat(compartment-mapper): new option additionalLocations for mapNodeModules (#3150)`
- Push: `git push origin endo-upstream/master:refs/heads/master` (fast-forward, no `--force` required)
- 7 incoming commits include the composite TypeScript build configuration (adds `tsconfig.composite.json` to ~50 packages, `scripts/generate-composite-tsconfigs.{mjs,test.mjs}`, root `tsconfig.composite.json`, AGENTS.md section), the `compartment-mapper` `additionalLocations` feature, and the `marshal` `compareRankRemotablesTied` refactor.

## Step 2: rebase result

Note: the PR branch's remote tip had advanced beyond the dispatch's snapshot (`9e3a77276`) by 11 additional commits (round-3+ fixer work landing while the dispatch was queued). I used the live remote tip `7130f1178` as the rebase source rather than the snapshot, so all fixer work survives in the rebased branch.

- Pre-rebase head (live remote tip): `7130f1178 docs(random): prettier-format tables, drop scratch-buffer section (#75)`
- Post-rebase head: `e8fa0ec7a docs(random): prettier-format tables, drop scratch-buffer section (#75)`
- Commits rebased: 35 (all preserved; none dropped as empty)
- Conflicts resolved: **0**. The rebase ran clean. Only one file overlapped between the 7 incoming master commits and the 35 branch commits (`AGENTS.md`), and the two append at different positions of the file (incoming inserts a "Composite TypeScript build" section before "Commit conventions"; branch appends a "Thunk modules" section after "Commit conventions"); git's three-way merge handled both without prompting.
- Authors preserved: `Kris Kowal <kris@agoric.com>`, `Kris Kowal <kris@cixar.com>`, `endolinbot <main.barn5084@fastmail.com>` (all three present on rebased branch).

## Post-rebase verification

- 58 files changed vs new master (focused on chacha12 + random + hex/ocapn refactor + root tsconfig.eslint-base.json / typedoc.json / yarn.lock / AGENTS.md).
- `yarn install` clean (warnings only, no errors; working tree clean after install).
- `yarn lint:prettier`: "All matched files use Prettier code style!"
- `yarn lint` in `packages/random/`: exit 0.
- Conflict-marker grep across `.js/.json/.md/.ts`: clean.

## Force-push result

```
git push --force-with-lease=kriskowal-random-chacha12:7130f1178 origin HEAD:kriskowal-random-chacha12
+ 7130f1178...e8fa0ec7a HEAD -> kriskowal-random-chacha12 (forced update)
```

(First push attempt with lease against the dispatch-snapshot SHA `9e3a77276` was rejected as stale; the second attempt with the lease pinned at the live remote tip `7130f1178` succeeded.)

## File count summary

- Pre-sync, pre-rebase: 24 commits, ~similar file count
- Post-rebase: 35 commits, 58 files changed vs new master

Self-improvement: noted in final report.
