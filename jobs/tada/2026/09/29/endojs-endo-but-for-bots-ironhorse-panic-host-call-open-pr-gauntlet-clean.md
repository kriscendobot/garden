Clean stage for endojs/endo-but-for-bots#1379: no changes were needed, and CI is green on the current head.

- **PR state:** open and still a draft. Head is `endojs:llm-ironhorse-panic-host-call` at `42b05643`, base is `llm-1706e63`.
- **Coverage:** the head commit (`42b0564357`, "test(slot-machine): cover handle close, pure and outbound replay, and recovery guards") is already a coverage pass. In an isolated project checkout, `cargo test -p slot-machine-transcript` passed 42 tests with no compiler warnings, so there was no unused code to report.
- **Unused code:** the only suppression is `#![allow(dead_code)]` in `tests/common/mod.rs`. That is the usual pattern for a helper module shared by several test files, so I left it. The change left nothing unused to remove.
- **Push:** nothing was committed or pushed.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0: all 35 checks finished with none failing. The two macOS test cells were the last to finish.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 86 tokens (3468539 cached reads)
- Output: 17156 tokens
- Cost: $3.8164988000000006
- Wall-clock: 4545s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
