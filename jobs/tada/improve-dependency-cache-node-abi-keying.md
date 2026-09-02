Implemented and pushed commit f8dd428c9e to main2.

- Added resolved Node native-module ABI to dependency-cache keys and metadata.
- Cache hits now validate the active ABI before hardlinking; incompatible entries rebuild.
- Unresolved/changing ABIs install dependencies without cache reuse or publication.
- Expanded regression coverage for ABI isolation, mismatch rebuilding, bypass behavior, and botanist cache separation.
- Verified: project-worktree-isolation 52/52; botany scripts-disabled 7/7; ShellCheck and syntax checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependency-cache-node-abi-keying.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 332s

<!-- garden-usage-end -->
