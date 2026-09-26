Panel round 4 for endojs/endo-but-for-bots PR #241 complete.

**What I did**
- Resolved the PR head (`endojs:design/familiar-run-vfs-apps`, base `llm`) and used the existing isolated project worktree at HEAD `e5a582bdb` (panel-3 must-fix items applied).
- Ran the design panel in single-round mode against base `bfc91f558`. Earlier attempts were repeatedly killed when my session was torn down between turns (the job was reaped 3×) because the panel had been launched via `run_in_background`, making it a child of the session. I relaunched it fully detached with `setsid nohup`, so it survived teardown and completed cleanly (exit 0).
- Panel disposition: **must-fix**. All seven seats (critic, skeptic, decomplector, ergonomist, pedant/copyeditor, novice, and the copyedit seat) returned request-changes.
- Posted the aggregated verdict as a review on PR #241. GitHub rejected `--request-changes` (bot authored the PR), so I posted it as a COMMENT review with "Disposition: must-fix" stated in the body — matching the shape of prior rounds' verdicts on this same PR.

**What changed**
- One new review on PR #241 (kriscendobot, 2026-08-31T14:04:54Z) carrying the round-4 must-fix aggregate.

**Key findings surfaced (advisory to the fixer, not my job to fix)**
- Peer-dependency scope contradiction between "Resolved design decisions #4" and "Peer and optional policy."
- Case 2 overstates compartment isolation by borrowing Case 1's vocabulary.
- Unstated guest reach into the `host-node-app` (Case 2) dispatch — potential confinement-boundary gap.
- Re-eject "no-op reuse" scenario appears unreachable given § Shape; content-hash-named dir made writable (value/place complecting).
- Style: em-dash-ban violations (~8) and one Unicode `→` arrow in the new design doc; glossary-after-use ordering.

**Follow-ups**
- Next gauntlet stage (fix loop) owns applying the must-fix items; this stage stops here per spec.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 74 tokens (2043004 cached reads)
- Output: 12276 tokens
- Cost: $2.055045
- Wall-clock: 234s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
