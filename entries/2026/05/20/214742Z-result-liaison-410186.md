---
ts: 2026-05-20T21:47:42Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/20/214118Z-dispatch-liaison-410186.md
  - entries/2026/05/20/214619Z-result-boatman-1045a5.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Eighth ferry of #109 closed. Source SHA unchanged; upstream PR rebased onto fresher master.

- Upstream PR head: `f5182df17` → `da5a9b48edbc6a0609a3fd4086676e797008dacb` via force-push-with-lease (lease satisfied at push time; pre-flight ancestor check passed).
- **New master tip used**: `ec3dcbc0cbf65b0b65725d041d4ee8f2ccf1610f` (11 commits ahead of the prior recompute's `c063631fed`).
- **Four new commits** in order, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero bot trailers:
  - `38fe6787d` feat(syrup-frame): add @endo/syrup-frame package
  - `bdb9ddc50` feat(ocapn): add opt-in syrup framing to TCP-testing netlayer
  - `7ea0a9eb0` chore: Update yarn.lock
  - `da5a9b48e` chore: regenerate composite tsconfig files
- **Cherry-pick conflicts**: none. All four applied cleanly atop the fresher master. The expected conflicts on commits 3 and 4 did not materialize because the new master commits did not collide with the source's files:
  - **Commit 3 validation** (yarn.lock): `yarn install --mode=update-lockfile` produced zero diff — the source's yarn.lock is already current against the moved master.
  - **Commit 4 validation** (composite tsconfig): `node scripts/generate-composite-tsconfigs.mjs --check` reported all composite tsconfigs up to date. `ec3dcbc0` (the new master commit) only touches `packages/skel/tsconfig.json`, not the generated composites.
- **kumavis's APPROVED persists** (anchored on an old commit OID from the original ferry; the review record stays in the reviews array).
- Source-side cross-link on #109: [issuecomment-4502904461](https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4502904461).
- Title and body untouched.

Worktree-index marked collected; dispatch root torn down.

Self-improvement: the boatman flagged a generalizable lesson — **when a cherry-pick of a generator-output commit (composite tsconfig, yarn.lock, etc.) applies cleanly atop a moved master, the clean text apply is necessary but not sufficient**; running the generator's `--check` mode before pushing catches the case where the generator's *inputs* changed even though the *outputs* still text-merge. This validates the no-drift state on the new master and is cheap. Worth a row in the eventual `skills/pr-handoff/SKILL.md` (joining the existing notes about pre-flight ancestor check and yarn.lock regeneration patterns).

Also worth flagging for future reference: the **Node 18/20 drop (`endojs/endo#3084`) landed on master** in this advance window (commit `f22f4b5d`). The stacked PR I opened/squashed earlier this session (`endojs/endo#3268`) had `ta/node-matrix` as its base — that base may now be merged or its branch may need attention. Surface as a follow-up if you want me to check #3268's disposition.
