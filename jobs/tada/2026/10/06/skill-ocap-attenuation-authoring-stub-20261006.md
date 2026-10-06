The job is already complete. A prior attempt of this job authored and landed the deliverable directly on `main2`, and that commit is an ancestor of `origin/main2`. My fresh worktree is clean with no pending work.

Verification:
- `skills/ocap-attenuation-authoring/SKILL.md` exists, is tracked, and landed in commit `fa851da9cc6` ("skills: stub ocap-attenuation-authoring (placeholder pending minion.town ocap migration)").
- That commit is confirmed an ancestor of `origin/main2`.
- Working tree is clean (no uncommitted changes).

The landed stub correctly satisfies the spec:
- **Format** follows CLAUDE.md § Adding a skill: Purpose, (Current status), Inputs, State, Procedure, Output shape, Notes.
- **Honest stub, not padding.** The Procedure section says "Not yet. See the status note above," and routes real work to a minion.town design/build job rather than inventing a garden-side recipe.
- **Grounded in real, current migration state** (not a superseded snapshot): it cites the directive in `designs/mcp-endo-guest.md`, notes that `designs/remove-toy-tools-and-prune-minion-scopes.md` (landed via #30) still reads "design only" while the pruning was actually implemented by merged #20 (superseding closed #36), describes the current `src/auth/scopes.ts` state (`mcp/tools` + `mcp/guest`, no scope-to-tool table), and flags open follow-ups (#82, #50) and in-flux designs (#142, #37) as the gating conditions for expanding the stub.
- It lists existing in-tree attenuations (site-register-caplet, git-remote capability, claude-agents-capability design) as precedent, explicitly "not a template."

**Summary of the migration's state** (as the landed stub records): minion.town has moved authorization off OAuth scopes onto object capabilities. Scope-pruning is implemented (merged #20); scopes now only gate the route (`mcp/tools`) and guest admission (`mcp/guest`). The design doc text predates the build and is history. The authoring model for new attenuations is still settling (#82/#142 open), so a worked procedure would be premature — which is exactly why the deliverable is a pointer-to-the-design stub, to be expanded once the migration lands and a first real attenuation has been authored and used end to end.

No further action, no follow-ups needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/skill-ocap-attenuation-authoring-stub-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 30 tokens (790324 cached reads)
- Output: 8472 tokens
- Cost: $1.2326223
- Wall-clock: 150s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
