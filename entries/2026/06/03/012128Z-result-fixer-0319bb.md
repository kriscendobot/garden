---
ts: 2026-06-03T01:21:28Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--37e82a
short_id: 0319bb
prs:
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebase-cascade, new_head: 5ee4b571a34ec10ba019b819913a1420abc9b4ca }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebase-cascade, new_head: 0d105dce6d7d08b294d4d19c5641adbaed567803 }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebase-cascade, new_head: 54e97628c80a0f6b4284037d775b88a26ac75fe3 }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebase-cascade, new_head: bdfbe87a4e0a938c7861bf129c4db69d0be86d72 }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/394
  - https://github.com/endojs/endo-but-for-bots/pull/395
  - https://github.com/endojs/endo-but-for-bots/pull/396
  - https://github.com/endojs/endo-but-for-bots/pull/397
---

# result: fixer — cascade rebase resume #394 → #397 onto post-#389 base

Resumed the cascade the prior fixer (`2deace`) stalled mid-#394.
Enabled `rerere.enabled true` at start so resolutions on the
phase-7 README and phase-8 `index.js` were recorded for future
cascades. All four pushes were force-with-lease against the
pre-cascade SHAs the dispatch named, and a refetch immediately
before each push showed no concurrent sibling work.

## Per-PR

### #394 (Phase 6: Git smart-HTTP handler)

- Base: `fc2b7adc3` (new phase-5 head with #389 admin-sock split).
- Old head: `72d425f71`. New head: `5ee4b571a`.
- Rebase: 4 commits replayed cleanly.
- Post-rebase test: `admin › Gateway getAdmin works when sockBootstrap is disabled` failed because the test (added in #389) instantiates `makeGateway` with bare `powers` and the default-on `gitHttp` feature throws `gitHttp requires powers.resolveRepo`.
- Resolution: added `gitHttp: false` to the test's `enableFeatures` override with a comment naming Feature 3's independent powers axis. Folded the change into the phase-6 feat commit via `git commit --fixup` + `git rebase --autosquash` (the feat commit owns "test must cope with new feature gate"); kept the stack at 4 commits, no separate fixup commit.
- Tests: 280 / 280 (brief expected 273; +7 from #389's new tests now in base).

### #395 (Phase 7: formula-backed AppsNameHub)

- Base: `5ee4b571a` (new phase-6). Old head: `96708da1b`. New head: `0d105dce6`.
- Rebase: 1 commit. Conflict in `packages/gateway/README.md` § Status: HEAD carried the new "phase-5 slice" wording (#389-aware), incoming carried the "phase-7 slice" wording (pre-#389). Merged: kept the phase-7 slice description but inserted the admin-sock-split clause into the dependency lineage (`phase 3's admin daemon (Feature 7) with its bootstrap-vs-admin sock split`).
- Tests: 322 / 322 (brief expected 315).

### #396 (Phase 8: ResourceLedger exo)

- Base: `0d105dce6` (new phase-7). Old head: `ac68f0811`. New head: `54e97628c`.
- Rebase: 1 commit. Two conflicts in `packages/gateway/index.js`:
  - Typedef block: HEAD's `getAdmin` JSDoc (the new #389 wording mentioning `admin.sock`) wins; phase-8's new `getLedger` typedef stays. Resolved by taking HEAD and appending the `getLedger` block.
  - `makeGateway` body: HEAD moved admin construction outside the `if(sockBootstrap)` block (per #389: admin no longer depends on bootstrap). Phase-8's diff added it inside that block, wired to `adminLedger`. Resolution: deleted the inside-block construction (HEAD's structure wins) and updated the moved-out construction at line 420 to use `adminLedger` instead of `powers.resourceLedger`, preserving phase-8's ledger-selection logic.
- Tests: 364 / 364 (brief expected 357).

### #397 (Phase 9: Familiar-bundled fallback publisher)

- Base: `54e97628c` (new phase-8). Old head: `3cc7e5051`. New head: `bdfbe87a4`.
- Rebase: 1 commit, clean (rerere's recorded resolutions did not need to fire).
- Tests: 398 / 398 (brief expected 391).

## Anomalies

None. All four `git fetch` checks immediately before each push showed the expected pre-cascade SHA on the remote; no sibling orchestrator committed to these branches during the dispatch. The phase-8 admin-construction relocation was the only multi-step conflict and it followed the brief's pattern ("the rename's wording wins; new content in each successor PR stays") exactly: the rename was the #389-admin-relocation, and the new content was the `adminLedger` selection logic.

The test counts ran +7 above the brief's pre-cascade table on every phase, matching the count of new `admin.test.js` tests #389 added on top of the old phase-5 base. This is expected: the cascade brings #389's new tests into every successor's working tree.

## Yarn-install drift

`yarn install` (run once early in the dispatch to make ava resolvable) re-formatted `packages/hex-test/package.json` indentation. Discarded with `git checkout --` before any phase-rebase commit; no drift entered any pushed commit.

## Self-improvement

Self-improvement: when a cascade rebase carries a test added by a new dependency commit into a successor branch whose later commit added a default-on feature gate that the test does not honor, the correct resolution is `git commit --fixup` + `git rebase --autosquash` to fold the gate-honoring test patch into the feature-introducing commit (rather than a separate "fix tests for cascade" commit). The feature-introducing commit owns the "tests must cope with this gate" responsibility; folding keeps the per-PR commit history clean and matches what a fresh-on-new-base PR would have looked like.
