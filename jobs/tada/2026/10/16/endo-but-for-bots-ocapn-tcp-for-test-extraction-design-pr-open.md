Draft design PR: https://github.com/endojs/endo-but-for-bots/pull/1480

## What I did
- Checked out branch `design/ocapn-tcp-for-test-extraction` in a separate project worktree. Its head is `d1c0d55c46`, one commit on top of the frozen base `llm-61cd656`. I did not change the design content.
- Opened the PR with `ensure-pr.sh`, using the predecessor's job key `endo-but-for-bots-ocapn-tcp-for-test-extraction-design`.
- Checked the PR on GitHub: it is a draft, its base is `llm-61cd656`, its head is `design/ocapn-tcp-for-test-extraction`, and its body carries the job body plus the `garden-job` marker.
- `ensure-pr.sh` logged one note: there is no `work/endo-but-for-bots-ocapn-tcp-for-test-extraction-design` record on the board, so PR #1480 is not linked to it there. That is expected, because the predecessor job ran on another host and this job claimed under a different job key. The marker in the PR body is how the completion machinery finds the PR later.

## Follow-ups
- build `ocapn-tcp-for-test-extraction` (one builder job, implementation PR rooted at `master`)
- The completion machinery stages the design gauntlet and the build handoff; I did not post either by hand.

<!-- garden-design-build-handoff: successor=endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open-build state=recheck:endojs-endo-but-for-bots-pr1480-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1480 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172814 cached reads)
- Output: 2266 tokens
- Cost: $0.4224268
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
