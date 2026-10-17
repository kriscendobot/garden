Clean stage for PR #201 is done, but CI didn't finish by the 1h deadline: one of the three checks is still queued, so I'm reporting **still-pending** and the stage should be re-posted.

**Coverage pass** (`test/new-clip.test.ts`, commit `3e82b6b`, pushed with `safe-push-pr-head.sh`, which moved the head forward from `a61dc66`):
- **Before:** `src/endo/gateway/new-clip.ts` had 84% line coverage and `clips/new-clip/model.js` had 99%. Untested were the case where publishing fails and the rollback also fails, `loadNewClipFront`, and the invitation-locator validation.
- **Added tests:**
  - When the rollback fails too, the error carries both causes (an `AggregateError` with both messages).
  - `loadNewClipFront` throws ENOENT when the front isn't built, and otherwise returns the files in serving order with the right content types and bytes.
  - An invitation without the `endo://` prefix is rejected and a valid one is accepted.
- **After:** both files are at 100% line coverage, and `tsc --noEmit` is clean.

**Dead code:** none. The `PUBLISH_HOWTO_DOCUMENT` the PR removes has no remaining references, and every new export in `new-clip.ts` is used.

**Local test run:** the full `npm test` run had one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure…"). This PR doesn't touch that file, and CI's `test` job passes on this head. I believe it's the known false failure from the sandbox's git wrapper, but I didn't confirm that.

**CI at head `3e82b6b`:**

| Check | State |
|---|---|
| `test` | SUCCESS |
| `Claude harness (amd64)` | SUCCESS |
| `Claude harness (arm64)` | QUEUED |

- **Why it's slow:** minion.town has a single self-hosted runner (`ci-minion-town`), and it's working through a serial queue at roughly 10–60 minutes per run. Our run sat queued from 09:41Z until about 10:45Z.
- **Polling:** the `ci-wait-merge.sh` invocation was killed by the tool's background time limit before it returned an exit code. After that I polled the PR checks directly, and stopped about 20 minutes past the deadline (11:09Z) with arm64 still queued and nothing red.

**Follow-up:** re-post the clean stage. The coverage work is already pushed, so the next run only needs to wait for arm64 to finish.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1945304 cached reads)
- Output: 9908 tokens
- Cost: $1.1648288
- Wall-clock: 5360s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
