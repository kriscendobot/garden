Implemented and pushed commit `ecd688ed12` to `main2`.

- Added a recurring `<5%` free-inode check to `root-repo-guard.sh`, with classified, coalesced maintainer alerts and recovery notices. It never performs unattended deletion.
- Added deterministic coverage for low headroom, recovery, and malformed `df` output. `root-repo-guard-test.sh` passes all 58 checks; Bash syntax, filtered ShellCheck, and `git diff --check` pass.
- Documented the host audit and bounded cleanup proposal. Visible garden consumers measured about 1.34M inodes under `scratch/` and 996K under legacy `worktrees/`. The seven named completed worktrees’ `node_modules` comprise about 172K unique inodes as a hardlink-aware batch.
- No worktrees were deleted. The proposal requires reconfirming `jobs/tada/`, excluding active jobs, removing only those seven through Git worktree mechanics, then measuring recovery before another batch.
- Current filesystem state is 26,653,794 free of 244,121,600 inodes, about 10.9%; the wider host-side consumer still warrants investigation because container-visible garden paths do not explain the filesystem-wide total.
- Follow-up: deploy `main2` through the normal deliberate-deploy path, then execute the reviewed cleanup batch if approved.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-ymax-stdio-mcp-host-inode-exhaustion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 478s

<!-- garden-usage-end -->
