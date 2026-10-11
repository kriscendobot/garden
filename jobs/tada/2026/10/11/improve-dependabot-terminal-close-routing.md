Implemented and pushed commit `e5294cb9759` to `main2`.

- Terminal superseded/incompatible closes now use deterministic directives pinned to the GitHub-write-capable host.
- Added a no-LLM executor that revalidates proofs before closing.
- Comment failures no longer block closing; comment and close outcomes are recorded separately.
- Updated the existing engine-conflict closer with the same behavior.
- Tests passed: watcher 68/68, engine closer 5/5, terminal-close scenarios 2/2, preflight 43/43, repository checks 13/13.
- `gardener-worktree-test.sh` could not exercise its scenarios because its fixture omitted `scripts/jobs/bin`; this was unrelated to the changed paths.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-terminal-close-routing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 401s

<!-- garden-usage-end -->
