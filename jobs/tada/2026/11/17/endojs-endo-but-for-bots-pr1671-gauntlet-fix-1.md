Fix round 1 for endojs/endo-but-for-bots PR #1671 is done: the style pre-pass fixes are pushed and CI is green.

**What changed:** I applied both pre-pass findings from the typist-friendly-code-points probe in `designs/endopi-prompt-templates.md`:
- **Line 31:** the ellipsis `…` is now `...`.
- **Line 239:** the table arrow `→` is now `->`.

I also changed the matching arrows in the same table (lines 240–241) to `->`, though the probe hadn't flagged them. Other `…` characters in the file are inside inline code spans, which the probe skips, so I left them alone.

**Push and CI:**
- The fix is one follow-up commit, `ef302e1423`, pushed with `safe-push-pr-head.sh` to `design/endopi-prompt-templates` (from `b765de9f56`).
- `ci-wait-merge.sh --no-merge` returned rc 0: 31 checks, none failed (7 passed, 24 skipped).

**Follow-ups:** none from this stage. The gauntlet driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (679509 cached reads)
- Output: 3016 tokens
- Cost: $0.6091898
- Wall-clock: 689s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
