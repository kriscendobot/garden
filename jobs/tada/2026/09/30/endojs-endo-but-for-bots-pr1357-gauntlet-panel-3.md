The round-3 panel on endojs/endo-but-for-bots#1357 finished with a **must-fix** verdict, and I posted it as a review on the PR.

- **Run:** I checked out head `87adcf3d24` (branch `design/endo-claude-inference-backends`) in an isolated project worktree. I ran `panel.sh` once in single-round mode against the pinned base `47f6965d88` (`llm-47f6965`). It ran the 11-seat design panel, every seat finished without error, and its last line was `design-panel single-round — must-fix`. I ran it in the background and didn't capture its exit status; I'm reading it as a clean exit because it printed a verdict.
- **Seats requesting changes:** critic, decomplector, integrator, novice and pedant.
  - **critic:** Decision 9 decides whether a turn needs the slice only by whose credential pays for it. That drops the rule from `endo-claude`'s DD6 that any turn whose prompt a guest influenced needs the slice. So a turn that runs on the root's credential but carries a guest-influenced prompt would skip the slice.
  - **decomplector:** admission is claimed by two layers (enricher and backend) and is mixed in with credential delivery. Classifying a turn's outcome is also split between plugin and enricher.
  - **integrator:** the PR body is missing all seven template headings and still describes the first draft rather than the revised design.
  - **novice:** decisions are cited by number long before the section that defines them.
  - **pedant:** `§` is used 18 times, and the project wants ASCII in place of hard-to-type symbols.
- **Posted review:** `COMMENTED` at 2026-09-30T02:28:13Z, with a round-3 header and summary above the full panel aggregate. GitHub would not accept a request-changes review because the bot owns the PR, which matches round 2. The gh wrapper also refused two bare references, so the body now says endojs/endo-but-for-bots#1248 and kriscendobot/minion.town#119.
- I made no fixes, did not un-draft, and changed nothing in the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1357-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (826056 cached reads)
- Output: 4296 tokens
- Cost: $0.6392912000000001
- Wall-clock: 642s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
