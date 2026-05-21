---
ts: 2026-05-21T05:35:00Z
kind: result
role: weaver
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/weaver--674658/
---

# Result: weaver 674658 — rebase feat/cbors-package onto endo-upstream/master (step 1 of #288)

Per kriskowal review on endojs/endo-but-for-bots#288 (2026-05-21T05:25:58Z): rebase `feat/cbors-package` onto upstream master so the branch becomes restagable into the syrup-frame-analogous shape. This dispatch handled **step 1 only**; a fixer-retcon will restage per-package and add the ocapn-default-cbor commit next.

## Heads

- Pre-rebase: `7b96f6247d74fb3b0322e66d081f098a0baf69e3` (`chore: Update yarn.lock`, based on `llm` tip `68246ad92`).
- Post-rebase: `f7239bb9abfd194513ae73de8fc344421ddb394a` (`chore: Update yarn.lock`, based on `endo-upstream/master` tip `bf951df346cfcf605a6709e6a5479f2fdd526113`).

## Base ref used

`endo-upstream/master` at `bf951df346cfcf605a6709e6a5479f2fdd526113`. There is no `actual/master` ref in this fork; the dispatch's phrasing ("actual/master / origin/actual/master / etc.") deferred to whichever ref tracks the canonical upstream master. `git ls-remote endo-upstream refs/heads/master` returned the same `bf951df346...` SHA as the local cache, so the lease anchor for the upstream base was confirmed before the rebase. `endo-upstream/master` carries the just-merged syrup-frame PR #3256 — the exact reference state kriskowal pointed at as the analogous landed work.

Note: `origin/master` (the fork's own master mirror on `endojs/endo-but-for-bots`) is at `9213d2c56`, which predates the syrup-frame merge by several commits. Rebasing on `origin/master` would have missed the analogous reference and the natural neighborhood for the upcoming ocapn-default-cbor commit. The right target was `endo-upstream/master`.

## Commits replayed

Four commits on `llm..feat/cbors-package` were considered:

1. `68186ded9 design(cbor-frame): rename cbors to cbor-frame, mandatory tag 24, lp32 sibling` — **dropped** (rationale below).
2. `0af0114ad feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing` → `8910d7004` (clean apply, all new files).
3. `227a8c557 docs(netstring,lp32): cross-reference framing-package siblings` → `d403b7fea` (clean apply).
4. `7b96f6247 chore: Update yarn.lock` — **skipped** during rebase due to content conflict on the new base; lockfile regenerated against the new base via `npx corepack yarn install` and recommitted as `f7239bb9a` per `skills/yarn-lock-separate-commit/SKILL.md` § Notes from the field (2026-05-17 entry: skip-then-regenerate is the canonical resolution).

Net commit count: 3 on top of `endo-upstream/master`.

## Conflicts resolved

- **`designs/README.md` and `designs/cbors.md → designs/cbor-frame.md` (modify/delete + rename/delete) on commit 1.** Cause: the `designs/` directory does not exist on `endo-upstream/master`; it lives only on the bot's `llm` development branch. The analogous, just-merged syrup-frame PR (#3256) carries **no design commit upstream** — its full set is `feat(syrup-frame): add @endo/syrup-frame package`, `feat(ocapn): add opt-in syrup framing to TCP-testing netlayer`, `chore: Update yarn.lock`, `chore: regenerate composite tsconfig files`. The `feat/syrups-package` source branch (the predecessor on `endo-but-for-bots` that the boatman ferried) followed the same shape: no design commit. Skipping the design commit during this rebase mirrors that pattern. The design's content (`designs/cbor-frame.md`, 235 lines) is not lost: it remains on `llm` and on the prior `7b96f6247` tip held by the `weaver-lease-anchor-pre` tag inside the project worktree for the duration of this dispatch. The upcoming fixer-retcon does not need the design file; the design content has already informed the package code being rebased.

- **`yarn.lock` (content) on commit 4.** Cause: upstream master gained dependencies (notably from the syrup-frame merge) since the original `chore: Update yarn.lock` was authored. Resolved per the skill: skip the conflicting commit, run `npx corepack yarn install` against the new base, recommit. The regenerated diff is the same 17-line addition the original commit had (the cbor-frame package's workspace registration), so the package contract was preserved across regeneration.

No `--ours` / `--theirs` was used; the lockfile resolution falls under the skill's enumerated regenerated-files exception and is functionally a recompute, not a side selection.

## Tests

Ran in the project worktree after the rebase and before the force-push:

- `packages/cbor-frame`: 32 tests passed.
- `packages/netstring`: 25 tests passed.
- `packages/lp32`: 6 tests passed.

`yarn install` produced peer-dependency `YN0060` warnings (eslint-plugin-import / typescript / `@typescript-eslint/utils` mismatches) that pre-exist on `endo-upstream/master`, unrelated to this branch's changes.

## Push

`git push --force-with-lease=feat/cbors-package:7b96f6247d74fb3b0322e66d081f098a0baf69e3 origin HEAD:feat/cbors-package`. Result:

```
+ 7b96f6247...f7239bb9a HEAD -> feat/cbors-package (forced update)
```

Remote `feat/cbors-package` is now `f7239bb9a`.

## What the fixer-retcon takes from here

The branch tip `f7239bb9a` is now three commits on `endo-upstream/master`:

1. `8910d7004 feat(cbor-frame): add @endo/cbor-frame package for CBOR byte-string framing`
2. `d403b7fea docs(netstring,lp32): cross-reference framing-package siblings`
3. `f7239bb9a chore: Update yarn.lock`

To mirror the syrup-frame PR shape, the retcon will:

- Combine the `docs(netstring,lp32)` cross-reference into the `feat(cbor-frame)` commit (a single feat commit per the upstream syrup-frame pattern, which did not split docs).
- Add the maintainer-requested `feat(ocapn): default codec 'cbor', 'syrup' and 'none' remain alternatives` commit — the existing ocapn package's `framing` option currently accepts `'none'` (default) and `'syrup'`; the retcon will add `'cbor'`, swap the default to `'cbor'`, and keep `'syrup'` and `'none'` as alternatives. Source code for the syrup framing precedent is in commit `bdb9ddc50` (`feat(ocapn): add opt-in syrup framing to TCP-testing netlayer`).
- Re-regenerate `yarn.lock` if the ocapn-default-cbor commit pulls cbor-frame into ocapn's `package.json` dependencies (it should; the analogous syrup commit added syrup-frame to ocapn's deps).
- Optionally add `chore: regenerate composite tsconfig files` if the cbor-frame package's tsconfig requires composite-graph regeneration on upstream master (the syrup-frame PR included this commit).

The fixer's [`retcon`](../../../../skills/retcon/SKILL.md) procedure handles the reset + restage; this entry leaves the branch in a state where the rebased diff is a strict subset of the eventual retcon's net diff.

## Self-improvement

Nothing this time. The skip-then-regenerate yarn.lock pattern (`skills/yarn-lock-separate-commit/SKILL.md` § 2026-05-17 note) handled the lockfile conflict exactly as documented, and the design-commit drop is justified by the upstream syrup-frame analog rather than a new general principle that needs encoding (designs/ vs. upstream is a project-specific shape, already captured in the boatman's ferry-time-stripping).
