Fix round 1 for endojs/endo-but-for-bots PR #1512 is pushed and CI is green.

**What I did**
- Got an isolated project checkout of the PR head (`endojs/endo-but-for-bots`, branch `design/ocapn-noise-session-reconnect-protocol`).
- Applied the one finding from the style pre-pass (typist-friendly-code-points): replaced U+2194 `↔` with `<->` in `designs/ocapn-noise-session-reconnect-protocol.md`. The probe flagged only line 228, but lines 229 and 230 of the same table had the same character, so I fixed all three. The probe didn't flag the remaining non-ASCII characters in the file (`§`, en dash `–`), so I left them.
- Committed `a6d413b86` ("docs(designs): type <-> instead of U+2194 in reconnect boundary table") as a follow-up commit. I pushed it with `safe-push-pr-head.sh` in advance mode, which moved the head from `75a361e7e` to `a6d413b86`.
- Waited on CI with `ci-wait-merge.sh --no-merge`. It exited rc 0 with all 30 checks passed and none failed. My first wait attempt was killed by my own shell timeout (rc 124), not by CI. I re-ran it detached with a 3000s deadline and polled it to the end.

**Follow-ups:** none. I did not re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1512-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (511633 cached reads)
- Output: 2968 tokens
- Cost: $0.4898626000000001
- Wall-clock: 953s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
