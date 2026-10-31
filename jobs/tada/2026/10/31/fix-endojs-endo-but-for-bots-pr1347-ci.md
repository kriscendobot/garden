---
handed-off: endojs-endo-but-for-bots-pr1347-weave-after-pr1585
deliverable-complete: false
---
#1347 is not green yet. Both oracle checks fail because of a problem the PR inherits from `llm`, not anything in the PR. I made no change to the PR. I parked a blocked follow-up job that will weave #1347 as soon as the existing fix (#1585) merges.

**Cause**
- In both `ironhorse-oracle-sanitizers` and `test-ironhorse-oracle`, the failing tests are `ironhorse-262` `corpus_conversion_equivalence` and `generated_multi_crank`. Two corpus cases disagree: `stage3-math/054.js` (`Math.asinh(1.7)`) and `055.js` (`Math.acosh(2.3)`). The XS oracle and IronHorse return neighboring double values, one last-digit step apart.
- GitHub's `ubuntu-latest` runner now means ubuntu-26.04, whose C math library rounds these two functions differently. The checked-in expected values match the old rounding, which is also what IronHorse returns. The two cases now fail on every PR that runs the oracle checks.
- #1347 changes only `packages/gateway`, its changeset and `yarn.lock`. Its base, `llm-9a14ddf`, is the current `llm` tip. The oracle checks run for it only because `scripts/ci-changes.py` treats a `yarn.lock` change as touching all JS, which turns on every check. Most other PRs skip these two checks entirely.

**Existing fix:** #1585 (`fix/ironhorse-oracle-stage3-math-ulp`, draft, both oracle checks green) makes the two cases accept either rounding. An identical blocked weave job already waits on it for #1501.

**Why I didn't patch #1347 directly**
- Copying #1585's commits into #1347, or stacking #1347 on top of #1585, would add Rust and test262 changes to a gateway-only PR. The job said to keep its scope.
- Rerunning the checks would fail the same way every time; this is not a flaky test.
- #1347 is otherwise mergeable with no conflicts, and only these two checks are red.

**Handoff:** I parked `endojs-endo-but-for-bots-pr1347-weave-after-pr1585` as a blocked plan job (`blocked_on` is #1585's URL). When #1585 merges, the unblock watcher promotes it. It moves #1347 onto a fresh snapshot of `llm`, keeps the scope to the gateway files, and confirms both oracle checks and the rest of CI go green. If #1585 is closed instead of merged, it first checks what replaced it on `llm`.

**Decision for you:** #1347 stays red until #1585 merges. #1585 is still a draft and needs your review.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1347-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1604011 cached reads)
- Output: 8969 tokens
- Cost: $1.1311662000000002
- Wall-clock: 149s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
