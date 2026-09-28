Implemented and pushed commit `894f2675637` to `main2`.

- Shared Node runtime selection between worktree provisioning and local verification.
- Added `.node-version`, `.nvmrc`, Volta, and single-major `engines.node` resolution.
- Warm caches now select the pinned runtime before ABI lookup; mismatched ABIs rebuild into distinct cache entries.
- Added the cross-ABI regression and updated local-verify documentation.
- Verified: project-worktree isolation 55/55, local-verify 103/103, botanist cache tests 7/7, Bash syntax and diff checks passed.
- Self-improvement: updated `skills/local-verify/SKILL.md` and `field-notes.md` with the shared runtime-selection requirement.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-project-worktree-warm-cache-node-abi.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 431s

<!-- garden-usage-end -->
