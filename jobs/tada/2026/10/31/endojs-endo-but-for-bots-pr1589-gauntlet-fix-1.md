Fix round 1 for PR #1589 is done and CI is green (`ci-wait-merge.sh` returned rc 0 with 36 checks and 0 failures). I pushed nothing this round, because an earlier claimant of this job had already pushed the fixes to the PR head `build-daemon-git-capability` (now at `fb40b59e0a`, 72 minutes old when I started).

**Panel must-fix items already resolved on the head:**
- **Read-only Git plus a remote:** `provisionFaeWorkspaceTools` now refuses a remote beside a read-only Git (`1a9afe6fe6`), and the test matrix covers it.
- **History rewrite via `exec`:** a writable Git is narrowed with `scope('writer')` before any tool closes over it, and a test checks this.
- **Duplicate composition:** the Fae code now reuses `provisionWorkspaceTools` from `@endo/agent-tools`. `93096f406c` added a `gitFacet` selector to that shared helper, with a test and a changeset.
- **`executeTool` result type:** `fb40b59e0a` keeps the string result contract.
- **Fixture hardening and Windows:** the fixture exports are hardened, and `/dev/null` became `os.devNull`.
- **Tests for the Fae side:** `workspace-tools.test.js` now checks that remote tools reach the granted remote, and `subagent-loop.test.js` gained 161 lines. I did not read that test, so I can't say it covers the end-to-end `createAgent` handoff the prover asked for.
- **Unresolved pet names:** `locateGrant` fails closed on an unresolved pet name.
- **Help text, README and changeset:** all were updated.

**Not done, with reasons:**
- **Mismatched Git/remote pairing:** the code does not check that a granted remote belongs to the granted Git. The code comment says the pairing is the operator's choice, since nothing on a `GitRemote` names its Git. That is a documented design decision, not a fix.
- **Code-mode direction (decomplector):** the decomplector said to stop for maintainer confirmation, or follow the code-mode direction, because the PR adds new JSON-tool exposure. That decision belongs to the maintainer, and I did not resolve it.
- **PR description trim (pruner):** I did not check whether the description was trimmed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 158 tokens (9507737 cached reads)
- Output: 40503 tokens
- Cost: $4.127362900000001
- Wall-clock: 6109s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
