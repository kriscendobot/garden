Implemented and pushed to `main2` in commits `a243e98b48` and `a57dd05121`.

- Terminal completion and genuine doom now remove per-job project worktrees through their owning Git repository.
- Requeues and temporary budget holds preserve worktrees for resume.
- Fixed bare-repository deregistration in shared scratch cleanup.
- Added a leader-only, drain-independent scheduled sweeper for terminal garden/project worktrees and unregistered legacy orphans.
- Completed PR cleanup verifies live GitHub state and fails safe for open or unverifiable PRs.
- Integrated the existing 5% free-inode alert with the automated sweeper guidance.
- Documented the lifecycle and added CI regression coverage.

Verification passed: worktree teardown 9/9, gardener worktree 44/44, project isolation 52/52, reaper doom 9/9, root guard 76/76, enable-services 40/40, paused-unit 11/11, plus the repository’s focused checks.

Follow-ups: none.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/implement-worktree-teardown-on-job-completion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1647s

<!-- garden-usage-end -->
