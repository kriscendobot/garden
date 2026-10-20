Draft PR opened: https://github.com/endojs/endo-but-for-bots/pull/1512

## What I did
- Got an isolated project checkout of `design/ocapn-noise-session-reconnect-protocol` with `ensure-project-worktree.sh`. Its HEAD is `75a361e7ed`, one commit on top of the frozen base `llm-92b91a7`, and it adds only `designs/ocapn-noise-session-reconnect-protocol.md` (329 lines).
- Ran `ensure-pr.sh` with the original design job base `design-endo-but-for-bots-ocapn-noise-session-reconnect` (so the PR carries that job's marker), the given title, and the given body. It opened endojs/endo-but-for-bots#1512.
- Checked the PR: it is a draft, head is `design/ocapn-noise-session-reconnect-protocol`, base is `llm-92b91a7`, and it changes exactly one file. I did not edit the design.
- `ensure-pr.sh` logged one notice: "no work/design-endo-but-for-bots-ocapn-noise-session-reconnect record on the board". That is expected, since the original design job was claimed on another host. It means the PR number was not written to that job's board record. This report names the PR instead, for the completion machinery to stage the design-panel gauntlet.

## Follow-ups
Build slices from `designs/ocapn-noise-session-reconnect-protocol.md`, in the order its Build Breakdown gives:
- **B1** (conformance tests): no merge needed first.
- **B3** (`sessionId` stays stable across epochs): runs per the design's Build Breakdown, in parallel with or after B1.
- **B2** (bounded retention): waits for #1483 to merge.
- **B4** (reconnect turned on in the daemon): waits for #1482 to merge.
- **D1** (fold this document into `designs/ocapn-noise-session-reconnect.md` and add its `designs/README.md` row): waits for #1487 to merge.
- Open questions for @kriskowal on #1512: C1 (confirming Rekey only), whether the daemon turns reconnect on by default, and B2's retention defaults.

<!-- garden-design-build-handoff: successor=build-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr state=recheck:endojs-endo-but-for-bots-pr1512-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1512 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177515 cached reads)
- Output: 2267 tokens
- Cost: $0.43458699999999995
- Wall-clock: 52s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
