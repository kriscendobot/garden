PR #1574 failed panel round 1 with a must-fix verdict: the panel found at least one change it wants made before merge.

1. **Pinned the PR.** Base is `81e5e47ae3d16223e94692e9f6fd0bf821621dc9` and head is `2ea0389b984e268a256bc3f21927e3971dc959e3`, on the in-repo branch `endojs/endo-but-for-bots` `design/api-key-agent-workbench` (a draft design PR). I checked out the head detached in `/home/kris/garden/scratch/project-wt-endojs--bd82f6b08d37-adefbe4b`, confirmed `git rev-parse HEAD` matches it, and confirmed the base object is present.
2. **Ran the style pre-pass.** `pre-push-gates.sh --no-auto-fix --probes-only` against the pinned base passed (exit 0, no output).
3. **Ran one panel round.** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with disposition must-fix.
   - Pre-pass checks forced three extra jurors:
     - the archivist, because of contradictory status lines;
     - the decomplector lens, over the cross-boundary ownership map;
     - the pruner, because the PR-body concision probe fired.
   - Because the PR is self-authored, panel.sh posted the verdict as a comment review, not a request-changes review. It went up as `kriscendobot` at 2026-10-27T05:02:23Z under the heading "Must-fix before merge". The critic seat asked for changes: it finds the approach sound, but raises three should-fix issues in the mechanics and questions one claim about how the controls behave.

I made no fixes, left the PR in draft, and changed no garden files. The fix stage takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1574-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (404735 cached reads)
- Output: 2329 tokens
- Cost: $0.4935510000000001
- Wall-clock: 188s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
