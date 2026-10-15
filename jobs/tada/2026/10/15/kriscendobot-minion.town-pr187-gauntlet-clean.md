Clean stage for kriscendobot/minion.town#187 ("fix(deploy): install ACL tooling for content GC", draft, head `364e8e4a3b5`): nothing needed changing, so I pushed nothing. CI is green at the current head.

- **Idempotence check:** `gh pr view` can't read `statusCheckRollup` with this token (a known limitation on this host). I read CI through the Actions runs API instead. The one workflow, "test (typecheck + vitest)", passed.
- **Coverage:** the PR changes three files. In `deploy/aws/scripts/deploy-endo-gateway-gc.sh` and `deploy/aws/scripts/deploy-git-remote.sh`, it installs the `acl` package when `setfacl` is missing, then checks for `setfacl` again. `test/gateway/content-gc-deploy.test.ts` checks that both scripts contain the `apt-get install ... acl` line, alongside the `setfacl` grant checks already there. That covers what the change adds; I added no tests.
- **Dead code:** none. The old FATAL guard was rewritten in place, and nothing else was left unused.
- **CI watch:** `ci-wait-merge.sh kriscendobot/minion.town 187 --no-merge` returned rc 0 (CI GREEN). It could only see Actions workflow runs: commit statuses and non-Actions check runs aren't visible with this token, so if any of those exist they weren't checked.
- **Follow-ups:** none for this stage. Panel review comes next in the gauntlet.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr187-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (198227 cached reads)
- Output: 1489 tokens
- Cost: $0.3659934
- Wall-clock: 61s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
