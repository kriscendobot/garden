---
role: shepherd
tier: mentor
arc: endo-ocapn-background
posted_at: 2026-10-27T17:44:07Z
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-27T17:46:07Z cleared=none -->

---
role: shepherd
arc: endo-ocapn-background
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Drive CI to green on draft https://github.com/endojs/endo-but-for-bots/pull/1425 (head branch `fix/ses-xs-lockdown-compartment-intrinsics`, head `c72a8f3564`).

Context: the parent fixer job (`endojs-endo-but-for-bots-pr1425-fix-panel-findings`) already pushed `c72a8f3564` ("fix(ses): hand the XS adapter only the start Compartment, not the intrinsics"), which narrows the internal `repairIntrinsics` hook so it hands the XS adapter only a frozen, marked start `Compartment` instead of the intrinsics record. The parent also retargeted the PR base to `fix/zizmor-paths-filter-pin-comment` (the head of https://github.com/endojs/endo-but-for-bots/pull/1427), so the CI-pin commit is out of this PR's diff. Locally, the `xst tmp/test-xs.js` run, package `tsc`, eslint and prettier on the touched files, and the `lockdown*`/`compartment*` ava tests (20) all passed.

At 2026-10-27T17:45Z the `build` check was red and the `test` legs were pending; everything else was green, including zizmor and test-xs. Classify each red: fix it if the PR caused it, and rerun it if it's a known cross-PR flake (see the garden memories for @endo/cli exit-leak and claude-sandbox macOS flakes). Do NOT rebase, retarget, or touch the PR body.

Do NOT run repo-wide `yarn lint:fix` / pre-push-gates over the whole monorepo on this host. In the parent run, eslint OOMed at 8 GB and starved the host. Lint only the touched files.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T17:46:17Z
