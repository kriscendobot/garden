**Clean stage done: kriscendobot/minion.town PR #242**, head `49320b76`, "feat(mcp)!: remove every guest tool that evaluate already does". Nothing needed changing and nothing was pushed.

- **CI:** green. All 4 checks pass at the current head (changes, test, Claude harness amd64 and arm64), and the bounded `ci-wait-merge.sh --no-merge` run returned rc 0.
- **Dead code:** none left behind. I compared against the PR's frozen base `c7c81caf` in an isolated checkout (`ensure-project-worktree.sh`):
  - The removed tool registrars, the `claudeForm` group, and the `submit` mount option are gone everywhere. No leftover imports or references in `src/server.ts`, `src/http.ts`, `src/endo/mcp-tool-names.ts` or `src/endo/guest-tools.ts`.
  - `tsc --noUnusedLocals` flags only one thing: `McpServer` is imported but unused in `src/http.ts`. That import is the same on the base commit, so this change didn't cause it.
  - Every export in `guest-tools.ts` is still used. `GuestToolDeps` is only used inside its own file, as it was before this change.
- **Coverage:** no new code paths. The change is almost entirely deletion, and the PR already updates its tests (tool-name snapshots, guest-tools, clip-tools and daemon integration tests), which pass in CI.

**Follow-ups:** none for this PR. If anyone wants it, the unused `McpServer` import in `src/http.ts` could be removed separately.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr242-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (487938 cached reads)
- Output: 2664 tokens
- Cost: $0.5622196000000002
- Wall-clock: 81s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
