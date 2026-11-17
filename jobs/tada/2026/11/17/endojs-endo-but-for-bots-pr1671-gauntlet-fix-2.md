Fix round 2 for endojs/endo-but-for-bots PR #1671 is pushed and CI is green.

- **What was flagged:** the style pre-pass found one failure. Line 96 of `designs/endopi-prompt-templates.md` used the Unicode ellipsis `…` (U+2026). That line is the argument-grammar table row `` `$1`, `$2`, … ``.
- **Fix:** I changed it to the plain `...` the pre-pass asks for. When I re-ran the `typist-friendly-code-points` probe in the project checkout it passed. Other `…` characters in the file, on lines 105–129, sit inside code spans and the pre-pass did not flag them, so I left them alone.
- **Push:** I added the follow-up commit `782f9662f5` ("docs(endopi): type ASCII ellipsis in argument table") to `design/endopi-prompt-templates` using `safe-push-pr-head.sh` in advance mode. The head moved forward from `ef302e1423`, so no peer commits were overwritten.
- **CI:** `ci-wait-merge.sh --no-merge` exited 0, with 31 of 31 checks done and none failed.

No follow-ups. I did not re-run the panel; the driver will post panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (605911 cached reads)
- Output: 2514 tokens
- Cost: $0.5649022000000001
- Wall-clock: 624s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
