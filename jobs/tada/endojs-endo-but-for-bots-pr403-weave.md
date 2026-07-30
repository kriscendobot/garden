Rebased PR #403 `feat/registry-capability` onto current `llm` tip using the frozen-base discipline. The rebase resolved cleanly — zero conflicts. All affected package tests pass. The head branch was force-pushed with `--force-with-lease` and the PR base was updated.

- Created frozen base `llm-b2e93cb` from upstream `llm` at `b2e93cb172`
- Rebased all 27 PR commits cleanly onto the new base (no conflicts)
- Ran `ava` tests on all 5 affected packages — all passed:
  - `mem-cas`: 11/11
  - `daemon-cas`: 9/9
  - `exo-npm`: 42/42
  - `init`: 5/5
  - `reminder`: 24/24
- Force-pushed `feat/registry-capability` → `fe34cb9b1f`
- Updated PR base from `llm` to `llm-b2e93cb`
- PR is MERGEABLE; `mergeStateStatus` shows UNSTABLE (transient — GitHub is recomputing after the base change)
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr403-weave.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (5 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (5 engagement(s) unpriced)
- Wall-clock: 2991s

<!-- garden-usage-end -->
