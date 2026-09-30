PR #1390 round-1 panel: **must-fix**. This job was already finished, and I checked that its output is still in place on GitHub. The last session wasn't recorded as done only because the completion signal wasn't the very last line of its report.

**Panel run.** I ran `panel.sh` in single-round mode on an isolated checkout of `endojs/endo-but-for-bots` branch `build/pet-name-path-only` at head `065f1344ea`. For the base I passed the PR's recorded base commit `8e53cc0f89` (branch `llm-8e53cc0`). I never captured its exit code because I started it detached, but it printed its final line, `must-fix`, and all 33 seats reported `ok`. On that basis I'm treating it as exit 0. The run is saved at `panel-runs/endojs-endo-but-for-bots-1390/875d950d0684.md`.

**Seat verdicts.** 17 request-changes, 6 comment-only, 8 approve, 2 with no verdict (scribe, coverage-auditor). The main must-fix item is an incomplete migration. `namePathFrom` now throws on bare strings, but the interface guard still lets them through, so they fail deep in the implementation instead of at the boundary. Several call sites still pass bare strings:
- `AUTH_SECRET_PETNAME` in the fae and floot factory setup files (and `fae/src/subagent-host.js`)
- `powersName: agentName` in `floot-factory-setup.js:391`
- `provideGuest(name, …)` in `lal/agent.js`

**Posting the verdict.**
- GitHub won't let the bot request changes on a PR it opened itself. The verdict is therefore a COMMENTED review by kriscendobot, posted 2026-09-30T13:28:13Z, headed "must-fix (request-changes)".
- The PR head is still `065f1344ea`, so that review still matches the code.
- The 95KB aggregate is over GitHub's size limit for one review, so I split it on seat boundaries. Part 1 is the review; part 2 is a PR comment: https://github.com/endojs/endo-but-for-bots/pull/1390#issuecomment-5912277429. The next fix stage needs to read both.

**Follow-ups.**
- Add a garden helper that splits an oversized panel aggregate across a review and follow-up comments; I did it by hand here.
- Because bot-opened PRs can only get COMMENTED reviews, the check for whether the next stage is owed has to accept a comment review whose body says must-fix.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1052400 cached reads)
- Output: 5824 tokens
- Cost: $1.5275974
- Wall-clock: 611s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
