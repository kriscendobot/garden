Deciding question: Does the current `llm` still accept a bare string as a pet-name path, with no other change having taken over this PR's rule that the daemon Exo surface accepts only path arrays?

Evidence:
- **PR state:** #1390 is open, unmerged and still a draft. It has no reviews. The head is now `b7c33a65d1`. The sweep job added two commits after the halted `db60e05da7` run: "pass pet-name paths from string-variable callers" and "pass pet-name paths where typecheck and tests caught bare strings". That means the successor sweep job is still working on this branch.
- **Premise still holds:** on `origin/llm`, `packages/daemon/src/pet-name.js:148-152` still turns a bare string into a one-item path (`typeof nameOrPath === 'string' ? [nameOrPath] : nameOrPath`). kriskowal asked for strings to be rejected so agents aren't confused (review on #1343, 5360774903), and nothing upstream has done it yet.
- **Not superseded:** the frozen base `llm-8e53cc0` is only 4 commits behind `llm`, and none of those commits touches pet names, paths or `NameOrPath`. #1343, the PR this one coordinates with, is still open and unmerged. It only changes the endowment value side, which #1390 says it doesn't duplicate.
- **Why the last gauntlet stopped:** it halted because CI was red on an unfinished migration (the tsc `string → string[]` errors and test failures). The PR hasn't lost its reason to exist; the gauntlet's clean and fix stages are there to finish that work.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163021 cached reads)
- Output: 1595 tokens
- Cost: $0.39716019999999996
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
