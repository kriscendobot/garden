The round-3 panel for endojs/endo-but-for-bots#1428 came back **must-fix**. I posted the full panel review on the PR as a COMMENTED review, because GitHub won't let the bot request changes on its own PR.

**What I ran**
- An isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `fix-upstream-master-ci`, head `042ec99966`).
- `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 1428 356d6e70af…`, using the PR's `baseRefOid` for the base. It ran detached, so a reap wouldn't kill it.
- `panel.sh` exited 0, last line `code-panel single-round — must-fix`.

**The review**
- I tried `--request-changes` first. GitHub refused it with "Can not request changes on your own pull request", so it went up as a COMMENTED review at 2026-10-06T06:14:54Z.
- Its body starts with `## Gauntlet panel round 3 — disposition: must-fix`.

**Panel results:** 34 seats. Most approved or left comments only; four asked for changes:
- **prover (must-fix):** no regression test, and no regression-test note, comes with the `git clean` exclude fix (`-e '!.yarn/install-state.gz'` in `package.json:52` and `scripts/pack-all.mjs`). It suggests a small scratch-repo test that runs `git clean -ndX` with the old and the new exclude arguments.
- **integrator (should-fix):**
  - Commit `c6af9f0aa8` is a review-round fixup that `042ec99966` later retracts, so it shouldn't land in history.
  - The description lists `test (22.x, macos-15)` as failing but no change targets it.
  - The description walks through the commits one by one.
- **pruner:** cut the PR-body sections that add nothing ("Scaling", "Upgrade", "Documentation" and "Testing" considerations) and trim the "Security" and "Compatibility" sections.
- **fourth seat (request-changes):** comment-only items. Name the `.gitignore:62` (`.yarn/*`) dependency in the `pack-all.mjs` comment, and cross-reference it from AGENTS.md. Its seat name is in the posted review.

I did no fixing and didn't un-draft the PR, as this stage requires. The fix round is the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (586026 cached reads)
- Output: 3235 tokens
- Cost: $0.5623212
- Wall-clock: 870s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
