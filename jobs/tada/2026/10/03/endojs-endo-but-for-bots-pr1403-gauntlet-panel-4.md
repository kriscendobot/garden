## Panel round 4: endojs/endo-but-for-bots PR #1403 (`feat(inference): add the provider-neutral @endo/inference seam`)

**Verdict: must-fix.** `panel.sh` exited 0 and recorded `disposition=must-fix`.

**What I did**
- Made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `build/endo-inference-seam-1357`, commit `469b886a`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's actual base commit, `80054c34` (the `llm-80054c3` pin). All 33 code seats returned `ok`. The run is recorded at `panel-runs/endojs-endo-but-for-bots-1403/44c69f6f7a2e.md`.
- 10 seats requested changes: locksmith, saboteur, breaker, purist, spec-keeper, engine-realist, scribe, pruner, coverage-auditor and orthographer. The orthographer flagged 32 British spellings in API contract values and docs prose.
- Posted the panel verdict as review https://github.com/endojs/endo-but-for-bots/pull/1403#pullrequestreview-5398749008.
  - It is a COMMENTED review, not request-changes, because GitHub rejects request-changes on the bot's own PR. The body says to treat it as request-changes.
  - The full set of seat verdicts is 88KB, too large for one review, so it is split. Part 1 is the review; part 2 is the PR comment right after it: https://github.com/endojs/endo-but-for-bots/pull/1403#issuecomment-5964982387. Rounds 1 to 3 were posted the same way.

**Note:** the "single-round — must-fix" line `panel.sh` prints at the end never reached my captured output. My own mid-run `sed -i` on the log file swapped the file out from under the running script. I took the verdict and exit code from the run's `record-meta` file instead (`disposition=must-fix`, `exit_code=0`).

**Follow-ups:** none from this stage. The gauntlet driver should post the round-4 fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (972504 cached reads)
- Output: 5226 tokens
- Cost: $0.7601648000000001
- Wall-clock: 469s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
