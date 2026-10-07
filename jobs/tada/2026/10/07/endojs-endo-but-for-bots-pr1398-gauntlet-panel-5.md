The round-5 panel on PR #1398 came back **must-fix**, and I posted its verdict on the PR.

- **Panel run:** I ran one panel round with all 34 seats on the head commit `a1f8314b56`. I passed the PR's base commit `0e0b333c19` explicitly rather than the base branch name. `panel.sh` exited 0 and printed `code-panel single-round — must-fix`, and every seat finished cleanly. My first launch was killed by a stray `pkill` before it finished, so I re-ran it detached; only the second run produced the verdict.
- **Seat votes:** 5 seats asked for changes (archivist, decomplector, packager, prover, stylist), 18 left comments only, and 11 approved.
- **Automatic checks:** two fired.
  - The same mechanism (`isCollected` / `manager.js`) drew must-fix findings in two prior rounds in a row, so the decomplector seat was asked whether it is needed at all.
  - The PR description is 398 words, over the 300-word limit.
- **Main blockers:**
  1. The decomplector argues the tombstone mechanism patches a read path that is no longer needed. Every saved record is loaded into memory at startup, so `getFormulaForId` could just refuse a missing id instead of reading the record back.
  2. The prover found no test that exercises the real wiring in `makeDaemonCore`. Removing the `markCollected` call from `manager.js` would leave every test passing.
  3. The changeset mentions only the fix and leaves out the new SturdyRef feature.
  4. The `sturdyRefForFormula` comment contradicts itself about formulas on other nodes.
  5. A naming fix: rename `idForSturdyRef` to `formulaIdForSturdyRef`.
- **Posted review:** GitHub refused "request changes" because the bot account opened this PR, so it went up as a COMMENTED review. Its body states the verdict is must-fix, the same shape as round 4. The full report was over GitHub's size limit, so I kept the 5 request-changes seats in full and left out 15 comment-only or approve reports; the review lists the omitted seats by name. The full report is in `/home/kris/garden2/scratch/panel-pr1398-r5/round-1.md`.

I made no changes to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1398-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1148302 cached reads)
- Output: 6482 tokens
- Cost: $0.8451244
- Wall-clock: 257s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
