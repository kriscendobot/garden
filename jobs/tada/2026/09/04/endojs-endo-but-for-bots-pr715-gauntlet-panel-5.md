Panel round 5 for endojs/endo-but-for-bots PR #715 (design(inspect): @endo/inspect package + shim) ran as a single-round staged gauntlet stage.

**What I did**
- Resolved the PR head (endojs/endo-but-for-bots @ `design/inspect-package`, HEAD `7f0f83774`) and provisioned an isolated project worktree keyed to this job base.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the worktree with the real merge-base SHA `6beb4e5b` (not the bare `llm` ref, per the base-normalization gotcha). Exit 0.
- Disposition: **must-fix**. Seat verdicts: critic, skeptic, decomplector, copyeditor all request-changes; ergonomist and novice comment-only; pedant approve.
- Posted the aggregate to PR #715. GitHub rejects a `--request-changes` review on the bot's own PR, so I posted it as a `--comment` review (the only available fallback) carrying the full round-5 aggregate under a `round 5 verdict: must-fix` header — visible to the fix-stage owner.

**Notable findings driving must-fix**
- critic: stale M10 rollups in `designs/README.md` (item count, duration bands, Gantt) not incremented for the added `inspect-package` entry, against the doc's own reconciliation convention.
- skeptic: XS condition-resolution never exercised through the real `compartment-mapper` build path; no cardinality/size bound (resource-exhaustion vector) in the never-throw safety contract.
- decomplector: options bag complects representation vs. delivery (root cause of the open `colors` hazard); condition axis applied to a condition-invariant `inspect` value.
- copyeditor: several subject-verb / antecedent / parallelism defects plus an unglossed `exo-` term.

**Follow-ups**
- This stage does not fix or un-draft (single-round). The gauntlet driver will read the `panel=must-fix` marker below and dispatch the next fix stage, which reads the just-posted verdict from the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr715-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1086336 cached reads)
- Output: 6325 tokens
- Cost: $1.218161
- Wall-clock: 322s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
