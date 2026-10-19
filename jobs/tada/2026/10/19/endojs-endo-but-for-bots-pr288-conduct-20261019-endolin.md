PR #288 (`@endo/cbor-frame`) is merged into `llm`, merge commit `92b91a7e93c936b30567924c480641da19f44f78`, at 2026-10-19T16:57:10Z.

**What I did**
- Made an isolated project checkout of `feat/cbors-package` at head `3ee08149e7`.
- Ran `ci-wait-merge.sh endojs/endo-but-for-bots 288` from that checkout on endolin. The base change that got a 403 on oros-studio worked here, and the script exited 0:
  - It moved the base from the frozen `llm-330cf99` back to `llm`. Four other PRs still sit on `llm-330cf99`, and none depend on #288.
  - The rebase changed nothing: the head stayed at `3ee08149e7`, so nothing was force-pushed.
  - CI was green on that head: 38 checks, 0 failed.
  - kriskowal's approval was re-checked on head `3ee08149e7` and still stands.
  - It merged with `--merge`, with no auto-merge.
- Ran `sweep-frozen-bases.sh endojs/endo-but-for-bots 288`. It kept `llm-330cf99` because open PRs #1502, #1503, #1504 and #1506 still use it as their base, and it skipped `llm` because that is the live trunk, not a frozen snapshot.

**Follow-ups**
- Job `endojs-endo-but-for-bots-pr288-weave-20261019-move-base` is now moot and can be dropped.
- The 403 on `updatePullRequest` on oros-studio is still there. Base changes have to keep running from endolin until that host's token permissions are fixed.
- I didn't change any garden code.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr288-conduct-20261019-endolin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (362249 cached reads)
- Output: 1860 tokens
- Cost: $0.5059937999999999
- Wall-clock: 63s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
