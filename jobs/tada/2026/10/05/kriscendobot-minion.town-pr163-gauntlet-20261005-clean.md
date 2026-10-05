Clean stage for kriscendobot/minion.town PR #163 ("fix(deploy): restart caddy when its gate-token env changes", draft): nothing needed changing, and CI is green at head `92ae00d3`.

- **Check:** all 3 CI checks pass at the current head (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`). The bounded `ci-wait-merge.sh --no-merge` run returned rc=0 (GREEN).
- **Coverage:** the PR's own tests already cover the new helper `deploy/aws/scripts/lib/caddy-env-sync.sh`. `test/caddy-account-routes.test.ts` runs `caddy_env_in_sync` against fixture env files for four cases:
  - the token matches;
  - the token is empty in the running process (the 2026-10-05 incident);
  - the token was rotated but the process still has the old one;
  - the env file is not deployed.

  Each case also checks that the secret never appears in the output. Separate assertions check that both secret scripts restart caddy instead of reloading it, and validate the config first.
- **Dead code:** none was left behind. The old `systemctl reload caddy || true` steps were replaced in place, and every new helper has a caller.
- **Result:** no commits pushed and no project worktree created, so this stage was a no-op.
- **Follow-up (optional):** two branches of the helper have no test: an env file that exists but sets no value, and the restart-then-recheck failure path in `caddy_env_ensure`. Neither is enough to justify another CI cycle here; the later panel stage can raise them if it wants.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (175281 cached reads)
- Output: 1601 tokens
- Cost: $0.4559802
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
