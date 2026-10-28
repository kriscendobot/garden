CI on endojs/endo-but-for-bots#1575 is now green: 15 checks passed and 19 were skipped, with nothing failing or pending, on head `86c5cfa873`.

**Cause:** the code in the PR wasn't at fault. The mutual-dependency `build` job ran on `ubuntu-latest`, which is now Ubuntu 26.04. That version's Graphviz package leaves out `tred`, so `scripts/check-dependency-cycles.sh` stopped with `tred: command not found` (exit 127). The `llm` branch had already fixed this in `fc2b4719a3` by pinning the job to `ubuntu-24.04`. This PR sits on the frozen base `feature/api-key-provider-registry-43bf47f`, which predates that fix.

**Fix:** I added one commit to `feature/api-key-provider-adapters` that copies `llm`'s change. It pins `.github/workflows/depcheck.yml` to `runs-on: ubuntu-24.04` and adds the same explanatory comment. No other files changed.

**Follow-ups:**
- The PR it's stacked on, #1573 (`feature/api-key-provider-registry`), is also red. Its failing checks are `build` (probably the same `tred` problem), `test` (22.x and 24.x on ubuntu-latest, 24.x on macos-15), `sandbox-drivers` and `cover` (22.x and 24.x). I didn't look into it because it's outside this job; it needs its own fix job or a weave onto current `llm`.
- When the stack is woven onto current `llm`, this commit becomes redundant with `fc2b4719a3` and should drop out cleanly.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-fix-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (521584 cached reads)
- Output: 3525 tokens
- Cost: $0.5584648000000001
- Wall-clock: 676s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
