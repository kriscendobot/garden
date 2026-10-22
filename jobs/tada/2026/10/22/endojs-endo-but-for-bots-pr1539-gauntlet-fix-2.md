Fix round 2 for endojs/endo-but-for-bots PR #1539 is pushed and CI is green.

**What I fixed:** The style pre-pass flagged two non-ASCII arrows in `designs/fs-interface-consolidation.md`, and I replaced both:
- Line 285: `getInfo() → {...}` is now `getInfo() -> {...}`.
- Line 347: `atime ← mtime` is now `atime <- mtime`.

**Push:** I pushed this as one follow-up commit, `7092e7adf` ("docs(fs): type ASCII arrows in consolidation design"), with `safe-push-pr-head.sh` in its default advance mode. The PR head on kriscendobot/endo-but-for-bots `docs/fs-interface-consolidation-status` moved from `5152b05aa` to `7092e7adf`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0. All 30 checks finished with none failing; because the change is docs-only, most of them were skipped.

**Follow-ups:** The same file still has a few `→` arrows on lines the pre-pass did not flag (134, 320, 350, 375, 382). Those lines were probably not part of this PR's change, so I left them alone. As instructed, I did not re-run the panel; the driver posts panel-3 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1539-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (466213 cached reads)
- Output: 2614 tokens
- Cost: $0.4844506000000001
- Wall-clock: 1322s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
