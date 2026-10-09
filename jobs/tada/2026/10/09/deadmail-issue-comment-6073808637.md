I handed the work off and replied on the issue. Nothing is deployed yet: the builder job I posted still has to make the change, get it merged, and confirm a deploy works.

**What the comment answered:** kriskowal's comment on kriscendobot/garden#58 ("Use `ci.minion.town` for deploys until the billing reset") picks option (b) from heal job `heal-minion-town-39867df`. The change in kriscendobot/minion.town#169 (merge `39867df`) has merged but never deployed. That is because `deploy.yml` is hard-coded to GitHub-hosted runners, which the Actions billing block refuses. The failed deploy also caused the proxy screener to pause the minion.town merge delegation.

**What I did:**
- **Posted builder job `build-minion-town-deploy-on-ci-runner-20261009`**, which repeats the ISSUE NOTE block word for word. It asks the builder to:
  - make `deploy.yml`'s runner switchable the same way kriscendobot/minion.town#145 did for `test.yml`, and point it at `ci.minion.town`;
  - check first that the steps work on that arm64 runner and that the AWS deploy login (OIDC to `minion-town-github-cd`) is accepted from a self-hosted runner;
  - have a conductor merge the PR, because the proxy delegation is paused, using the maintainer's comment as the authorization;
  - confirm a main deploy runs on `ci-minion-town` and ships kriscendobot/minion.town#169, and check that this success un-pauses the screener;
  - update `skills/minion-town-ci-runner-switch/SKILL.md`, which currently says "CD is separate", so the scheduled switch back after the reset (~10-30) moves deploys back to hosted runners as well;
  - report back on issue #58.
- **Replied on the issue:** https://github.com/kriscendobot/garden/issues/58#issuecomment-6074406491

I made no commits to garden `main2`.

**Follow-up not posted:** the heal job also suggested a screener change (`scripts/jobs/screening/driver.py`). A deploy that never got a runner would count as "deferred by billing" instead of a failed merge. The maintainer hasn't approved it, so I didn't post it. Once deploys run on the self-hosted runner, this block shouldn't pause the screener again.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-6073808637.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (544738 cached reads)
- Output: 5141 tokens
- Cost: $0.5941516
- Wall-clock: 269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
