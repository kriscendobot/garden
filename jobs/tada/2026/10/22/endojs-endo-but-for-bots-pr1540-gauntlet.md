gauntlet-status: not-viable
viability-result: closed
repo: endojs/endo-but-for-bots
pr_number: 1540
# gauntlet endojs-endo-but-for-bots-pr1540-gauntlet - not viable

the PR is closed; the gauntlet did not enter its budgeted loop.

## Viability report

## Viability report: endojs/endo-but-for-bots #1540

**Result: the gauntlet stops here. Target #1540 is an issue, not a pull request.**

- `gh pr view …/pull/1540` failed with "Could not resolve to a PullRequest with the number of 1540".
- The issue API shows that #1540 is an open **issue** with no pull request attached: "IBIS: Where should hand-written type definitions live?". The fleet's job `endo-handwritten-types-ibis` opened it today as the research report for PR #1393.
- The gauntlet was staged from kriskowal's comment on the issue (https://github.com/endojs/endo-but-for-bots/issues/1540#issuecomment-6350105579): *"Please produce a pull request that makes Endo consistently apply the recommendation, run the gauntlet, shepherd through CI."* The comment-watcher matched "run the gauntlet" and treated #1540 as the PR to run it on. But no PR exists yet. The comment asks for one to be **built** first.

**Deciding question:** Is #1540 an open, unmerged pull request whose motivation still holds and that nothing has replaced? No. It is an open issue, so there is nothing to clean, review, fix or un-draft.

**Evidence:**
- The GraphQL lookup cannot find a PR numbered 1540.
- REST `issues/1540` returns `pull_request: null` and `state: open`.
- The issue body is the IBIS report.
- The maintainer's comment asks for a new PR.

**Follow-up posted so the request is still carried out:**
- I posted builder job `build-endo-handwritten-types-normalization`, with an identity tied to that comment.
- It asks for a DRAFT PR that applies #1540's recommendation across the repository: checked `src/types.ts` plus a `types-index.d.ts` re-export index.
- It must not overlap the marshal change in #1393, and it should reply on #1540 with the PR URL.
- When the build succeeds, it stages the gauntlet automatically, so the real "run the gauntlet" will apply to that new PR. Shepherding through CI comes after.
- The research job told the fleet not to post the repository-wide follow-up unless the issue or the maintainer asked for it. kriskowal's comment on the issue is that request.

**What I did not do:**
- I did not mark this as `overtaken` and did not offer "close as superseded". Issue #1540 is live and should stay open.
- I spent no clean, panel, fix or CI budget.
- I made no garden code changes.

**Possible garden fix (not done):** the comment-watcher could check that a target is a PR before staging a gauntlet from an issue comment. When it is an issue, it should send the request to a build job instead.

<!-- gauntlet-stage-result: viability=closed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1540-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (516649 cached reads)
- Output: 4008 tokens
- Cost: $0.5267458
- Wall-clock: 258s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
