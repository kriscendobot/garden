Panel round 1 on endojs/endo-but-for-bots#1425 finished with a **must-fix** verdict, and the review is posted on the PR.

**What I did**
- No earlier panel run or review existed, so this was a fresh round. I set up an isolated checkout of the PR head (`endojs`, branch `fix/ses-xs-lockdown-compartment-intrinsics`, at `3158064e5a`) at `/home/kris/garden2/scratch/project-wt-endojs--62cce6b284f6-42e9ab36`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1425 6ee3fda77b…`, passing the PR's base commit (`master-6ee3fda`). I ran it detached so a requeue wouldn't kill it. It exited 0 and its last line was "code-panel single-round — must-fix". The base-PR-body pruner was forced to run because the PR-description length check fired.
- 33 seats reported. Six requested changes: packager, saboteur, breaker, spec-keeper, wire-watcher and pruner.
- The main must-fix: after lockdown, XS compartments copy the start compartment's globals. That puts the powerful `%Initial*%` intrinsics under the `%Shared*%` names, so the PR's claim of matching other engines does not hold. The spec-keeper confirmed this by running a probe on XS.
- Also flagged: an unrelated CI commit that repins `paths-filter` and isn't mentioned in the PR body, and the length of the PR description.

**Review**
- The full aggregate is 75K characters, more than GitHub's review limit. I reordered the seats (request-changes first, then comment-only, then approve) and cut it to 63K. The nine seats left out (integrator, duality-auditor, benchmarker, scribe, releaser, transplanter, thesaurus, procurer, reexport-auditor) all approved and are listed by name in a note at the end.
- GitHub rejected `--request-changes` because the bot authored the PR, so the review went up as COMMENTED at 2026-10-08T11:33:05Z by kriscendobot. The body says "Disposition: must-fix" and keeps the must-fix/should-fix structure.

**Follow-ups**
- The fixer stage is next and is the driver's job, not this stage's.
- Because of the COMMENTED fallback, the next-stage heuristic has to read must-fix from the review body, not from the review state.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 38 tokens (1176050 cached reads)
- Output: 5905 tokens
- Cost: $0.8453740000000002
- Wall-clock: 286s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
