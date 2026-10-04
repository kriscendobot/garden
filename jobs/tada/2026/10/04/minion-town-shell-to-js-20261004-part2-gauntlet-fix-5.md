Fix round 5 for kriscendobot/minion.town PR #152 is done. The fix is pushed and CI is green: all 3 checks passed on head `1968736`.

**The must-fix item:** the panel-5 review had one, from the integrator seat. The shared `isMain` helper in `deploy/aws/scripts/lib/common.js` compared the module URL against `process.argv[1]` as typed. Node loads the main script by its real path, so running any of the 14 provisioning scripts that use the helper through a symlink skipped `main()` and exited 0 without doing anything. #151 already fixed this in `3e73f007a2`, but #152 branched from an earlier snapshot of #151 that doesn't have the fix.

**What changed (commit `1968736`, pushed with `safe-push-pr-head.sh` as a fast-forward from `b308a11`):**
- `isMain` now compares against `realpathSync(process.argv[1])`, the same fix #151 used, which covers all 14 scripts.
- `test/deploy-provisioning-scripts.test.mjs` has a new test that runs `set-account-role.js` through a symlink and checks that the usage text is printed. That text only appears if `main()` actually ran.

**Checks:**
- **Local:** typecheck, the JavaScript-only scripts check and the changed test file (30/30) passed.
- **Full suite locally:** one test failed, in `test/git-remote/capability.test.ts`. My change doesn't touch it and it passed in CI, so it's a quirk of this machine's git setup.
- **CI:** `ci-wait-merge.sh` returned 0 (green).

**Follow-up:** #152 is still stacked on #151's round-1 snapshot (`dcc2d64`), which is several fix rounds behind #151's current head. This is the third panel round where that stale base has brought back a bug #151 already fixed. #152 should be woven onto #151's current head before #151 merges.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-shell-to-js-20261004-part2-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1842015 cached reads)
- Output: 7606 tokens
- Cost: $2.2131432000000006
- Wall-clock: 1009s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
