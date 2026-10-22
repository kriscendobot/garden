Fix round 1 for endojs/endo-but-for-bots PR #1526 is pushed and CI is green.

**What I did**
- Made an isolated project checkout of the PR head (`endojs/endo-but-for-bots@design/endor-tui-phases`). The first attempt was killed by the 120s git time limit, a known problem on this host. It worked on retry with `GARDEN_REPO_GIT_TIMEOUT=900`.
- Fixed both pre-pass findings from the `typist-friendly-code-points` check in `designs/endor-tui.md`:
  - line 719: `↔` is now `<->`
  - line 858: `×` is now `x`
- The check's auto-fix rewrites the whole file, so it also replaced the other mechanically fixable glyphs in that file: the rest of the `↔`, the other `×`, every `→` (now `->`) and every `…` (now `...`). That is 14 lines changed in total. The `…` inside the two `<xsbug>` code spans were rewritten too, even though the check says it leaves code spans alone. Running the check again on the whole file prints `pass`.
- Committed this as `ee8abe169` ("docs(endor-tui): replace typist-unfriendly code points with ASCII") on top of `2f2b2e4cd`. I pushed it with `safe-push-pr-head.sh`, which moved the head forward to `2f2b2e4cd..ee8abe169`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0: 30 checks, 0 failed.

**Follow-ups:** none from this stage. The driver will post panel round 2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1526-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (719080 cached reads)
- Output: 3759 tokens
- Cost: $0.6151880000000001
- Wall-clock: 1297s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
