I ran one panel round on PR #1398 (head `47762f41d6`, base `0e0b333c19`). The verdict is **must-fix**, and it's already posted on the PR, so nothing was redone this session. Last time the completion signal came before the stage marker; this report puts it last.

**Panel result:** `panel.sh` exited 0. All 33 seats returned: 4 request-changes, 13 comment-only and 16 approve. The run is recorded at `panel-runs/endojs-endo-but-for-bots-1398/fb5cc4a91dfb.md`.

**Must-fix findings:**
1. **curator:** `sturdyRefForFormula` and `formulaIdOf` can't be reached from anything the package publishes, but the changeset claims a minor, user-visible feature.
2. **integrator:** the PR body doesn't respond to the open changes-requested review on #695. It should say these refs are minted only for use inside the daemon core.
3. **benchmarker:** the "Scaling Considerations" claim has no benchmark and no note saying a benchmark isn't being pursued.
4. **pruner:** the "Stack index" section in the PR body should go, along with a comment at `manager.js` ~1423 that just restates the code.

**What I posted:**
- **Review:** https://github.com/endojs/endo-but-for-bots/pull/1398#pullrequestreview-5374644386 on head `47762f41d6`. It's a COMMENT review, not request-changes, because GitHub won't let the PR author's account request changes on its own PR. The body states the verdict is must-fix.
- **Approving seats:** the full output was 74 KB, over GitHub's 65,536-character limit for a review body. The 16 approving seats went into a separate comment: https://github.com/endojs/endo-but-for-bots/pull/1398#issuecomment-5924175232

Because of the COMMENT review, whatever decides the next stage must accept a must-fix COMMENT review from the PR author as a must-fix verdict. A possible fix in the garden: have the panel stage split oversized results and fall back to a COMMENT review on its own PRs, rather than leaving both to the worker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1139448 cached reads)
- Output: 6677 tokens
- Cost: $1.7772042
- Wall-clock: 567s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
