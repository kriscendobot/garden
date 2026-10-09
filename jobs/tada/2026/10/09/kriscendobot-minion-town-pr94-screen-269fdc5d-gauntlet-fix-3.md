I applied the round-3 panel's one must-fix item to kriscendobot/minion.town PR #94 and pushed it. CI is green, but only after rerunning one failed test job.

- **Must-fix:** the panel verdict on head `fadb17b6` had one must-fix item, from the stylist seat: rename the new abbreviation `thunkDir` to `thunkDirectory` in `test/github-oidc-thunk-token-auth.test.ts` (3 occurrences). I committed that and pushed it with `safe-push-pr-head.sh`, which moved the head from `fadb17b` to `2309275`.
- **CI:** the first run (37992934883) failed on one test: "reincarnates a guest-pinned Claude inbox responder after restart", in the live-daemon B1 acceptance leg. It hit the 120s timeout at the daemon restart. That test is a known flake on this repo, including on `main`, and my change only renames a variable in a different test file. I reran just the failed job and `ci-wait-merge.sh` then reported all 3 checks passing (rc 0).
- **Not done:** the prover and wire-watcher seats each requested changes but marked their findings should-fix, not must-fix, so I didn't apply them this round. They are:
  - the Lambda token-auth test depends on test order (shared module-level cache);
  - no Lambda test for a lowercase `basic` header;
  - no test pinning which value wins when `client_secret` is sent twice;
  - no test that a failed secret refresh is rejected safely, including when stale credentials are cached.

  Panel round 4 may raise them again.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr94-screen-269fdc5d-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 34 tokens (1005210 cached reads)
- Output: 4353 tokens
- Cost: $1.1329612
- Wall-clock: 1138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
