Report for job `endojs-endo-but-for-bots-pr1348-review-3fce8521`

I answered kriskowal's question on endojs/endo-but-for-bots#1348 ("tell me more about shell tools and how they're confined") with a reply comment: https://github.com/endojs/endo-but-for-bots/pull/1348#issuecomment-5940470770

**What I did**
- The preflight returned exit 0 (go ahead). The review has no inline comments; its body is the single ask, and it is a question rather than a code change. So the deliverable was an explanation, and I did not route it to a fixer or designer.
- I checked the explanation against the code at PR head `cb763267fc`, not just the design doc. The reply quotes the design's § The honest boundary and covers:
  - **How a shell is granted:** `provideShell` takes a mount cap only and refuses a read-only mount. Its policy is fixed when the host creates it and survives a daemon restart, and the agent only receives a shell if the caller hands one over.
  - **What is enforced:** the command must be on the exact allowlist before anything starts; commands run as argument lists with no `/bin/sh` in between; programs are looked up on a path the policy sets; the child gets a clean environment; output and run time are capped, and on timeout the whole process group is killed. The tool layer's veto options are advisory only.
  - **What is not confined today:** the only engine available runs the command as an ordinary process under the daemon's OS user. It can read and write outside the worktree and use the network. Allowing an interpreter-like command (node, npm, make, sed, awk, find) amounts to allowing anything. A descendant that calls `setsid` escapes the timeout kill. There are no CPU, memory or pid limits.
  - **Where real confinement will come from:** the sandbox engine (Phase 2c), which is still unbuilt. The design requires it before shells are given to less-trusted agents.

**One gap found**
`makeWorkspaceTools` accepts `readOnly: true` together with a `shell` (or `git`) grant without complaint. `readOnly` only restricts the file tools, so a "read-only" workspace can still change the worktree. The reply suggests making that combination an error, or documenting the limit, and offers to do it as a follow-up if the maintainer wants it. I posted no job for it; it waits on the maintainer's answer.

**What changed:** only the PR comment. No code or commits in the garden or the project repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-review-3fce8521.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (812988 cached reads)
- Output: 6679 tokens
- Cost: $0.8446496000000001
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
