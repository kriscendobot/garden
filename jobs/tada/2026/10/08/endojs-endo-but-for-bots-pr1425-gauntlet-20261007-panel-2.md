The round-2 panel on endojs/endo-but-for-bots PR #1425 came back **must-fix**, and I posted the verdict on the PR. `panel.sh` exited 0, so this is a real verdict, not a panel error.

**What I ran:** an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `fix/ses-xs-lockdown-compartment-intrinsics`, at `68129dd726`). I ran the panel in single-round mode against `6ee3fda77b`, the commit the PR's `master-6ee3fda` base points to. 33 seats ran.

**Must-fix items:**
1. **The PR title describes the approach the PR dropped** (integrator seat). The title "sample XS compartment intrinsics at lockdown" matches the first commit, `2d7e3bbcc9`. The fix that landed in `99e15702f8` builds the Compartment from the lockdown intrinsics record instead. Suggested title: `fix(ses): build the XS lockdown Compartment from lockdown intrinsics`.
2. **An unrelated CI change is in the PR** (packager seat). Commit `3158064e5a` re-pins paths-filter in `ci.yml`. It should move to its own PR, or the description should say why it belongs here.

**Should-fix notes:**
- Squash `2d7e3bbcc9` into `99e15702f8`, and fold the formatting fixup `68129dd726` into it.
- Post a top-level summary comment for the new head (scribe seat).
- Several seats raised test gaps; they are in the seat blocks of the review.

**The posted review:** it went up as a COMMENTED review (2026-10-08T12:38:30Z). GitHub refuses request-changes from the bot on its own PR. The full output was about 85KB, over GitHub's 65,536-character limit for a review body. So the review is about 54KB:
- a summary of the must-fix and should-fix items
- the full blocks for every seat that requested changes or left comments
- the approving seats that still raised should-fix notes (prover, migrator, saboteur, breaker, wire-watcher)

**Problem along the way:** my first launch used `setsid` in the background. It returned exit 0 immediately with an empty log, but the panel apparently kept running detached. Its partial set of seat results ended up in the same run directory, so the combined output held a duplicated, incomplete first set. I re-ran in the foreground and used only the second, complete set of 33 seats. That set is the one with the must-fix decision and the one I posted.

**Follow-up:** the next gauntlet stage is the fix loop for the two must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1165147 cached reads)
- Output: 7891 tokens
- Cost: $0.9311853999999999
- Wall-clock: 785s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
