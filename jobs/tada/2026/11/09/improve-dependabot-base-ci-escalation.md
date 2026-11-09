Pushed to `main2` as `16ea23b4137`. The dependabot watcher now posts one repair job per shared red base commit, instead of only noting the shared failures in each botanist job. The fixture suite passes: 89 passed, 0 failed (it had 76 checks before this change).

**What changed** (`scripts/jobs/dependabot-watcher.sh`):
- **Rechecking PRs that already have a botanist job.** The check that compares a PR's failures with its base used to skip these PRs. Those are exactly the reviewed MERGE-NOW PRs that stayed blocked on 2026-11-09. Now, once the PRs still awaiting review have been checked, any checks left in the existing 4-per-tick cap go to these older PRs. Each one is rechecked at most once per `GARDEN_DEP_BASE_CI_REPROBE_SECS` (default 3600s, tracked by a timestamp file per PR under `$GARDEN_STATE`). This works through a large backlog without new API cost beyond the cap. Their existing botanist jobs are never rewritten.
- **One repair job per base commit.** All the results from a tick are grouped by exact base SHA. If every result on a base shows only failures that the base shares, the watcher posts a shepherd job named `<slug>-base-ci-<sha12>`. The name depends only on the base SHA, so re-runs on later ticks or other hosts do nothing once the job exists anywhere on the board. If the base moves to a new SHA and is still red, that counts as a new outage and gets a new job.
- **What the repair job contains.** Its header lists the repo, base SHA and member PRs, and its text gives the steps:
  1. Re-read the base checks, and stop if the base is now green.
  2. If the live base branch is already green, post weave jobs to move the PRs onto a fresh base.
  3. Otherwise shepherd an existing fix PR, or open a repair PR through `ensure-pr.sh`, or escalate to the maintainer. On a repo the bot doesn't own, it only writes a recommendation.
  4. Never touch the Dependabot PRs themselves.

  Only commit SHAs, counts and PR numbers go into the body, never check names.
- **Botanist jobs point to it.** A botanist job whose failures are all shared now names the repair job and is told to cite it rather than open its own escalation.
- **Existing safety rules are kept.** Every result is still validated field by field before it is used. A base escalates only when every result on it is all-shared: a base where some PR also has failures of its own is not escalated. Malformed results, missing results, API errors and a GraphQL rate-limit cooldown all fall back to the ordinary review with no escalation.

**Tests** (`scripts/jobs/test/dependabot-watcher-test.sh`):
- **ESC:** two all-shared PRs on one base get a single repair job and a second base gets its own. A malformed result and a PR with no result are both excluded, the botanist body names the repair job, and re-running with the timer forced to zero creates no duplicates.
- **ESC-POSTED:** PRs whose botanist jobs already exist get rechecked within the cap and trigger the repair job. The timer makes successive ticks take turns through the backlog and skips PRs checked recently, and no duplicate botanist job is posted.
- **BCI:** a base where some PR has failures of its own gets no repair job.
- **Test directory:** I also made the suite's scratch directory overridable with `GARDEN_DEPW_TEST_DIR`. The previous hard-coded `/home/kris/...` path was read-only in this sandbox, so the suite couldn't run here.

**Follow-ups:**
- The new behaviour only takes effect once the host's root checkout is deployed past `16ea23b4137`.
- I didn't look into #1646 itself. The next watcher tick after deploy should post a repair job for that base, provided all of its PRs show only shared failures.
- `roles/botanist/AGENT.md` doesn't mention the repair job yet. The instruction to cite it lives only in the job body the watcher writes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-base-ci-escalation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1895888 cached reads)
- Output: 21004 tokens
- Cost: $1.6714096
- Wall-clock: 440s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
