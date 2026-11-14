Completed weave of endojs/endo-but-for-bots PR #1559.

The root PR head is `69cafe166f5e5f5bbb158d5f65045da44d934e01`, rebased without conflicts onto frozen current-`llm` base `llm-48d6f3e` (`48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c`). The two original PR patches were preserved exactly by range-diff. PR #1590 remains based on `daemon-worker-import-from-mount-6d40c78`, and #1592 on `daemon-worker-import-from-mount-phase-three-9f0a7a6`, preserving the stack for their ordered reweaves.

Verification: 15 focused daemon tests passed; daemon and spaces-util lint passed with existing warnings; the pinned-base assertion passed. CI reached terminal state. Its only current failures are `zizmor` and `test-xs`, traced to action-pin comment and XS baseline/benchmark changes in the new base, outside this unchanged two-patch PR delta. A PR summary comment records the head, verification, and these results.

Follow-up: reweave #1590, then #1592. Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1559.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (2 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (2 engagement(s) unpriced)
- Wall-clock: 4705s

<!-- garden-usage-end -->
