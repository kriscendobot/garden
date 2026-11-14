I didn't build anything this time: the work was finished on 2026-10-31 and is open as PR #1597. This post repeats a job that already completed.

**What I checked**
- `ensure-pr.sh --find-only` found the earlier PR by this job's marker: endojs/endo-but-for-bots#1597, "test(agent-tools): pin Git facet method sets across guards, types, and declarations" (head `bot/test/git-surface-contract`, base `llm-9a14ddf`). It is open, mergeable and no longer a draft. All CI checks are green, the assessor juror on the review panel approved it, and there are no outstanding comments.
- The journal already has a completion report for this job at `jobs/tada/2026/10/31/build-daemon-agent-tools-phase-five-contract-test.md`, plus a gauntlet run for #1597 completed the same day.

**What #1597 delivers**
- A new test, `packages/agent-tools/test/git-surface-contract.test.js`, checks four sources against each other for each of the reader, writer and rewriter postures:
  - the method list and facet guard in `@endo/exo-git/src/interfaces.js`
  - the posture type in `types.ts`
  - the checked-in generated code-mode declaration
- It also checks that `GitInterface` matches the rewriter facet, and that `git` and `gitHistory` together cover it.
- The new test found one existing drift: the read-only declaration left out `followRootChanges`, `followLatestRoot` and `help`, which the reader facet already accepts. The hand-kept `GIT_READONLY_MEMBERS` list that caused it is gone, and the declaration was regenerated.
- The PR also adds a changeset and ticks the checklist item in `designs/daemon-agent-tools.md`.
- The `473b718b3` commit the job names is not on the remote. Its type-level assertions already live on `llm` in `exo-git/test/types.test-d.ts`, so the PR adds the runtime and declaration checks around them instead of restoring the commit.

**Follow-ups**
- #1597 only needs the maintainer's merge decision.
- Whoever posted this job should know the post wasn't swallowed as a duplicate, even though the base had already completed. That cost one extra claim.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-phase-five-contract-test.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 114 tokens (5096558 cached reads)
- Output: 26138 tokens
- Cost: $3.344895599999999
- Wall-clock: 933s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
