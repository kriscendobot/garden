Round 8 of the panel on kriscendobot/minion.town PR #178 ran, and its verdict is **must-fix**. I posted that verdict as a review on the PR.

- **Checkout:** I used an isolated checkout of `git-remote-push-caps` at head `21c0c05`, compared against `origin/main-c7bdf20`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0. Its last line was `code-panel single-round — must-fix`. The run is recorded under the journal's `panel-runs/kriscendobot-minion.town-178/`.
- **Seats (34):**
  - 5 requested changes: saboteur, breaker, wire-watcher, integrator, pruner.
  - 18 were comment-only.
  - 11 approved.
  - Pruner's must-fix: the PR description is out of date. It still says "Three caps", leaves out the fourth knob `GIT_REMOTE_MAX_PENDING_PUSHES`, and leaves out the full-partition recovery step.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/178#pullrequestreview-5540113429
  - It went up as a comment-state review, like rounds 3–7. GitHub refused a request-changes review because the bot opened the PR.
  - It carries the `<!-- garden-panel-verdict: must-fix round=8 head=21c0c05… -->` marker.
  - The full aggregate (94 KB) is over GitHub's limit for a review body, so the five must-fix seats come first and in full.
  - Left out for length: the 11 approve seats and 3 comment-only seats (releaser, transplanter, decomplector). They are in the journal record.
- **Missing from the review:** decomplector's should-fix. It asks to merge `holdPushSlot` and `enqueueProjection` into one per-partition serializer, with a single admission gate in `limits.ts`. Its seat output is in the journal record. The next fixer may want to read it directly, since the slot mechanism has drawn must-fix findings two rounds running.

I stopped the first panel launch within seconds and restarted it, because a background command is cut off after 10 minutes. No changes were made to garden code, and nothing was fixed or un-drafted.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (995812 cached reads)
- Output: 6065 tokens
- Cost: $0.7932144000000001
- Wall-clock: 388s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
