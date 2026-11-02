---
handed-off: orch-endojs-endo-but-for-bots-pr1482-reweave-green-20261102
deliverable-complete: false
---
**PR #1482 is still red, and I handed the rest off to a new orchestration.** None of the five failures come from this PR, and they aren't flakes. They need a stack weave that goes beyond this PR's own head, so I pushed nothing and didn't rerun anything.

**Failures (head `ac167c2f8b`, run 41365746422)**

Every failing test in all five jobs is in `packages/sandbox/test/bwrap.test.js`; none are in `ocapn-noise`, the package this PR changes.

| Check | Failing tests |
|---|---|
| `test (22.x, ubuntu-latest)`, `test (24.x, ubuntu-latest)` | "bwrap parent death leaves no owned process group" |
| `cover (22.x, ubuntu-latest)`, `cover (24.x, ubuntu-latest)`, `sandbox-drivers` | the same test, plus "prlimit nproc cap is enforced inside the slice" (`/bin/sh: 1: ulimit: Illegal option -u`) |

**Root cause**
- **Stale base:** the frozen base `build/ocapn-noise-session-reconnect-rekey-4d8b59b` is 207 commits behind `llm` and lacks `27705a4cdf` (`test(sandbox): fix Linux resource limit and cleanup assertions`). The base's test file still has the old `/bin/sh -c 'ulimit -u'` call, while `llm` uses `/bin/bash`.
- **Why a rerun won't help:** dash, the `/bin/sh` on the runner's ubuntu-26.04 image, rejects `ulimit -u` every time. CI also tests against the same stale base, so I treated these as deterministic and didn't retry; that rests on the code and the repeated log signature, not on a test rerun.
- **Evidence a weave fixes it:** the #1478 weave report says its CI run 41385445799 passed in full, including these bwrap tests. #1476 is also green.

**Why I didn't fix it here**
- **#1481 has to move first:** #1482 sits on a snapshot of #1481, whose head also lacks the fix (its base is the old `build/ocapn-noise-session-queue-2a16357`). Pushing to #1481 is outside the shepherd's limit of working only on the PR's own head.
- **No cherry-pick:** copying the sandbox fix into #1482 would add unrelated test changes to its diff, and the stack would still need the weave.

**Successor orchestration:** `orch-endojs-endo-but-for-bots-pr1482-reweave-green-20261102` is serial and halts if a child fails. I confirmed the record and all three children on `origin/journal2`:
1. `weave-endojs-endo-but-for-bots-pr1481-onto-pr1478-20261102` is pinned to endolin, because this host's token can't write PRs on `endojs` and moving a PR base needs that. Expect real conflicts, because #1478 was squashed and hand-ported during its own weave. It waits for #1478's shepherd if that job is still running with CI in progress.
2. `weave-endojs-endo-but-for-bots-pr1482-onto-pr1481-20261102` is also pinned to endolin. It keeps #1482's 17 commits and must recheck that the diff is limited to #1482's own files.
3. `shepherd-endojs-endo-but-for-bots-pr1482-ci-after-weave-20261102` drives CI to green on the rewoven head.

**Still open**
- **#1483 and #1515:** #1483 is stacked on an older #1482 snapshot, and #1515 is listed on a snapshot of #1483's branch. Neither is in this orchestration and both will likely need their own weave later.
- **Other red checks that may appear after the weave:** the #1591 bwrap timeout flake and the ironhorse oracle `stage3-math` 054/055 failures (pending #1585 and #1613) can still show up. The ironhorse sanitizer workflow did turn #1478 red; here it passed on the current head, but the new base could change that. The child jobs are told to name these rather than chase them.
- **Maintainer ruling:** #1482 stays a draft, and its body still awaits a ruling on the time limit on deference and on accepting any later epoch. The gauntlet will need a separate resume after CI is green.

Next stage: `next: weaver`, via the orchestration above.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1482-ci-20261102.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (981126 cached reads)
- Output: 16961 tokens
- Cost: $1.1812532000000002
- Wall-clock: 393s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
