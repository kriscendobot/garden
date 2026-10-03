Clean stage report for kriscendobot/minion.town PR #85 (`feat/clip-upgrade-in-place`, still a draft): I added two tests to the PR and CI is green on the new head.

**What I did**
- **Starting point:** CI was already green at the old head `a5a2699`, but there was no record of a coverage pass, so I ran one.
- **Coverage run:** I used the v8 provider over the touched test files, then matched uncovered lines against the lines this PR adds under `src/`. The provider was installed in a throwaway scratch directory and removed afterwards, so the PR's dependencies are unchanged.
- **Gaps I closed:**
  - **Missing content right:** In `publish.ts`, nothing tested that a capability narrowed to the `powers` right is refused when it tries to replace content. The opposite case (a content-only capability trying to rebind powers) was already tested.
  - **Bad stored grants:** In `upgrade-capability.ts`, nothing tested how the file-backed capability table handles a missing file, unparseable JSON, a grant with an invalid right, or a key that isn't a valid digest.
- **Gaps I left:** a few defensive branches with no realistic trigger, and the MCP tool wrappers in `guest-tools.ts`, which only pass calls through.
- **Dead code:** the change leaves nothing unused.

**What changed** (commit `a41d704`, pushed with `safe-push-pr-head.sh` as a fast-forward from `a5a2699`)
- `test/gateway/publish.test.ts`: new test "attenuates to a powers-only capability that cannot replace content". It checks the request is refused with no charge and the front content is unchanged.
- `test/gateway/upgrade-capability.test.ts`: new test "treats a missing, corrupt, or malformed fs grant as no capability".

**Verification**
- Locally, typecheck passes and the full suite has 731 passing tests and 1 failure. The failure is `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`, which fails only on this host and is outside this PR.
- `ci-wait-merge.sh --no-merge` returned rc 0: all 3 checks passed at `a41d704`.

**Follow-ups:** none for this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 38 tokens (1088916 cached reads)
- Output: 7509 tokens
- Cost: $0.8433472000000002
- Wall-clock: 415s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
