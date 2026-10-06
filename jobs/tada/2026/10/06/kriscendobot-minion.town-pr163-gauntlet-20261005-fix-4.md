Fix round 4 for kriscendobot/minion.town#163 is pushed and CI is green: all 3 checks passed (`ci-wait-merge` returned 0). The head moved from `4d5fd6f` to `4230a28`. Locally, vitest passes 44 of 44. The change has not been run against the live server.

**Round-4 findings addressed:**
- **spec-keeper / engine-realist (should-fix: the check read the wrong process).** I took the reviewers' option (a). The five `header_up` lines in `deploy/aws/caddy/conf.d/minion-town.caddy` now use runtime placeholders, `{env.ACCOUNT_GATE_TOKEN}` and `{env.BILLING_GATE_TOKEN}`.
  - Caddy fills these in on every request from its main process's environment, which is exactly what the helper hashes from `/proc/<MainPID>/environ`.
  - The old `{$…}` form was filled in by whichever process read the Caddyfile. A `caddy reload` run by hand without the token could serve an empty header while the check still passed; that gap is now closed.
  - I corrected the root-cause wording in `DEPLOYMENT.md`, the helper's header comment, and the comments in both secret scripts.
  - A new test checks that the Caddyfile uses `{env.*}` for the gate tokens and never `{$…GATE_TOKEN}`.
- **corner-prober (must-fix-loop: untested unit states).** New tests cover a `reloading` caddy (checked, and restarted when its token is stale) and a `deactivating` one (skipped as not running). The test's `systemctl` stub now reports `active` after a restart, so those states can be tested.
- **integrator / packager / spec-keeper (formatting churn).** A new commit, `5853185`, drops the Prettier reformat of `test/caddy-account-routes.test.ts`. That file now differs from base only in its two placeholder lines.
- **integrator (description out of date).** I rewrote the PR description to match the current code: the lock, the bounded wait after a restart, how a failed unit is handled, restarting the app before reporting a caddy failure, and the full test list. The PR title is now "fix(deploy): restart caddy when its gate-token environment is stale".
- **scribe (must-fix: missing summary).** I posted a fix-round summary comment (`issuecomment-6007171998`). It lists the changes in `0a181cc`, which no earlier summary covered, as well as this round's changes.

**Not done:**
- I did not regroup the earlier commits as integrator suggested, so older commit messages still use names that were later renamed. Squashing or regrouping can happen at merge time.
- Comment-only suggestions are left for later: `grep -F` hardening, putting the reload in `deploy-caddy.sh` under the same lock, and ending the post-restart wait early when a restart cannot fix the problem.

**Follow-up after merge:** the first production `deploy-caddy.sh` should print `ACCOUNT_GATE_TOKEN: running caddy matches /etc/caddy/account.env`. Because the Caddyfile placeholders changed, a signed-in `GET /account/claude` should then return 200.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr163-gauntlet-20261005-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2140063 cached reads)
- Output: 14616 tokens
- Cost: $1.4473166000000002
- Wall-clock: 401s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
