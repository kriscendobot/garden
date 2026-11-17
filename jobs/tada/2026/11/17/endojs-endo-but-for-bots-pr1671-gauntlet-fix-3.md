FIX round 3 is done for endojs/endo-but-for-bots PR #1671: the style fix is pushed and CI is green.

- **Finding:** the pre-pass flagged one `typist-friendly-code-points` failure, a U+2026 ellipsis at `designs/endopi-prompt-templates.md:105`.
- **Fix:** I replaced all five remaining `…` in that file with `...`, at lines 105, 110, 111, 125 and 129. Rounds 1 and 2 each fixed only one line, which is why the gauntlet kept coming back. Some of the replaced ellipses sit inside inline code spans (`${...}`, `${n...}`, `$1`...`$n`). The ASCII spelling means the same thing there, and it ends the cycle of one fix per round. The probe now passes on the staged change.
- **Push:** commit `4afda8675c` ("docs(endopi): type ASCII ellipsis throughout prompt-templates design") went onto `design/endopi-prompt-templates` through `safe-push-pr-head.sh` in advance mode, moving the head from `782f9662f5` to `4afda8675c`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0, with 31 checks and 0 failures.

There are no follow-ups. Next, the driver re-posts the panel as round 4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (679983 cached reads)
- Output: 2458 tokens
- Cost: $0.5970766
- Wall-clock: 564s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
