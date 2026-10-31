Clean stage for endojs/endo-but-for-bots PR #1593 ("feat(agent-tools): compose HTTP workspace tools"): nothing needed changing and CI is green, so I pushed nothing.

- **Starting state:** the PR is still a draft and open. CI was already green at head `c85ead37` (36 checks: 0 failed, some skipped as not relevant).
- **Coverage:** I checked it by reading the diff and did not run the coverage tool locally. The change adds an optional `http` grant to `makeWorkspaceTools` and `provisionWorkspaceTools` in `packages/agent-tools/src/workspace.js`. The PR's own tests in `test/workspace.test.js` cover every new branch:
  - the `http` grant adding the `fetch` and `allowedOrigins` tools;
  - `http` combined with the `remote` grant failing with a name clash on `fetch`;
  - `provisionWorkspaceTools` passing the grant through.

  Leaving `http` out is covered by the existing tests.
- **Dead code:** none. The remaining edits are documentation, a type field and the changeset, and they leave no code unused.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0.
- **Project checkout:** the `ensure-project-worktree.sh` call took longer than 120s and was moved to the background. I didn't need the checkout, so I left it running unused.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1593-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (266357 cached reads)
- Output: 1911 tokens
- Cost: $0.4325794
- Wall-clock: 207s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
