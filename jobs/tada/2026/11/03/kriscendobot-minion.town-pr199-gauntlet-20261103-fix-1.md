Fix round 1 for PR #199 is finished: the one blocking pre-pass finding is fixed and pushed, and CI is green.

**What changed**
- **Blocking finding:** I renamed the abbreviated `err` to `error` throughout the `catch` block of `runRootCtl` in `src/endo/root-ctl.ts`. This is commit `69be650d` on `feat/guest-coupons`, pushed with `safe-push-pr-head.sh` as a fast-forward from `ff114545`.
- **Left alone:** the `err` in the `main().catch` handler at line 244 of the same file. The PR doesn't add it and the probe didn't flag it.
- **Advisory comment:** I kept the comment at `deploy/aws/scripts/deploy-coupon-store.sh:5`. It records something the adjacent code doesn't show: creating the table doesn't change admission until `COUPON_STORE=dynamodb` is set. It also notes that the script is idempotent and host-side only.

**Verification**
- **Probe:** `spell-out-identifiers` passes when run with `--scan-stdin` on the lines this PR adds to `root-ctl.ts`, and a control line containing `err` still fails. A first run passed only because the working-tree diff was empty after the commit, so I don't count it.
- **Scope of the re-check:** I re-scanned only `root-ctl.ts`, the one file the pre-pass flagged, and did not re-run the full pre-pass stage.
- **Local checks:** `tsc --noEmit` is clean, and `test/endo-root.test.ts` and `test/web/guest-coupons-http.test.ts` pass (44 tests). ESLint could not check the file because it stopped with a config migration error, so the rename is unlinted locally.
- **CI:** `ci-wait-merge.sh` returned 0, with 2 of 2 runs and none failed on `69be650d`. The PAT can't read `statusCheckRollup`, so this comes from the Actions runs API and doesn't cover commit statuses or non-Actions checks.

**Follow-ups:** none from this stage; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (402968 cached reads)
- Output: 3688 tokens
- Cost: $0.5590656
- Wall-clock: 484s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
