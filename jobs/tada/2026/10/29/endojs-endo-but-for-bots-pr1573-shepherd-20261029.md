The rerun came back green. The 4 remaining "fail" rows are 0-second matrix-parent placeholders from the cancelled duplicate run. I'm finishing up.

## Shepherd report: endojs/endo-but-for-bots#1573 (`feature/api-key-provider-registry`)

PR #1573 is green on its head `71b9ab575bd3f5899832d8373cb7dcbf2b0f237d`. CI run [40784560853](https://github.com/endojs/endo-but-for-bots/actions/runs/40784560853) finished with `completed success` once I reran its failed jobs. I pushed no code: both failures were known flakes in code this PR doesn't touch.

**The two red checks:**
- **`sandbox-drivers`**: `bwrap › bwrap timeout and repeated cancellation reap process groups` failed with "process group 7702 survived bounded cleanup" (`packages/sandbox/test/bwrap.test.js:266`). This is the known runner-portability problem with the bwrap tests, which open PR #1566 fixes. The PR doesn't touch `packages/sandbox`. It passed on rerun.
- **`test (24.x, macos-15)`**: in `packages/daemon/test/http-content-plane.test.js`, every assertion passed, but an unhandled rejection made the test process exit non-zero: `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. This is the known macOS `ClientDestroyedError` flake. The PR doesn't change the HTTP content-plane code. It passed on rerun.

**Still showing red:** `gh pr checks` lists 4 "fail" rows (`test`, `cover`, `test-async-hooks`, `viable-release`), each 0 seconds long. They come from run 40784559683 on the same SHA, which was cancelled because the run above superseded it. The real jobs with those names all passed in run 40784560853. I didn't rerun the cancelled run because that would cost another ~55 minutes of CI just to clear these rows.

**Not done:** I posted no PR comment, since the job didn't authorize commenting on the PR. The PR is still a draft, and I left it that way.

**Follow-ups:** none required. #1575 can stack on this green base. Landing #1566 would remove the bwrap flake for every PR.

next: none
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-shepherd-20261029.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1144615 cached reads)
- Output: 4742 tokens
- Cost: $0.816635
- Wall-clock: 3515s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
