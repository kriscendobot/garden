Pushed cleanly to `main2`. The job is complete.

## Completion report

**Job:** Fix the shared-frozen-base guard in `scripts/jobs/gardening/ci-wait-merge.sh` so it stops conflating siblings-on-a-shared-pin with a dependency stack.

**Re-derivation:** Fresh worktree off `origin/main2`; no prior attempt had committed anything (last touch to these files predated the job). Clean start.

**What changed** (commit `8f80bd866e`, pushed to `main2`):

1. **New predicate.** `unfreeze_base_if_frozen()` no longer counts PRs on the frozen base. It now reads this PR's `headRefName` and queries open PRs whose **base ref is this PR's head ref** — the true definition of a dependent. It blocks (`return 10`) **only** when such a genuine dependent exists (forwarding this PR to live and merging it would orphan the dependent off the shared base). Merely sharing the frozen base with siblings proceeds — the retarget is a single `pr edit --base` that leaves every sibling byte-for-byte unchanged, exactly as the maintainer ruled.

2. **Guard preserved for the dangerous case.** Precisely stated in the code and alert: the still-blocking case is a real dependency stack (an open PR based on this PR's head). The "not stranded silently, not force-merged under a dependent" property is retained; a `?` read-failure fails closed (refuse to unfreeze).

3. **Alert text corrected.** Replaced the false "would fork the stack off the shared base" wording (which asserted a consequence that doesn't follow for siblings) with an accurate statement about orphaning the specific dependent PR(s).

4. **Sibling count reported, not blocking.** On a successful unfreeze the summary line now includes "N sibling PR(s) remain on '<base>', left untouched (no dependent stacks on #PR)" as context — informational only.

5. **Regression tests (both directions).** In `scripts/jobs/test/ci-wait-merge-test.sh`: **T10** now asserts siblings on a shared pin unfreeze and merge without blocking (rc=0, base edited, merge called); new **T10b** asserts a genuine dependent stack still blocks (rc=1, no merge, no base edit). Full suite: **PASS=63 FAIL=0**.

**Follow-ups:** none. The six other PRs on `llm-387ea66` (siblings) will now pass this guard on their own conduct runs rather than each needing case-by-case authorization.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-shared-frozen-base-guard-sibling-vs-stack-20260918.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 26 tokens (841161 cached reads)
- Output: 21303 tokens
- Cost: $1.7059834999999999 (1 engagement(s) unpriced)
- Wall-clock: 272s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
