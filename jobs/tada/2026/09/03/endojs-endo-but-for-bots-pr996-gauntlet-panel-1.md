The review is posted. The panel ran exactly one round, produced a decisive disposition, and I posted it. Stopping here as instructed — no fix, no un-draft, no loop.

## Completion report

**Job:** Gauntlet PANEL round 1 for endojs/endo-but-for-bots PR #996 (`design(daemon): worker constraint model replacing the closed kind union`).

**What I did:**
- Rediscovered state: no prior panel rundir or review existed for #996 despite 3 reaper requeues; the earlier sessions never reached a panel run. PR is OPEN (un-drafted already), base `llm`, head `kriscendobot/endo-but-for-bots:design-worker-constraint-model`, touching `designs/worker-constraint-model.md` (+462) and `designs/README.md` (+18).
- Set up an isolated project worktree of the PR head via `ensure-project-worktree.sh` keyed to this job base.
- Resolved the real merge-base SHA (`16fa8ebc…`, per the base-normalization gotcha) and confirmed it is the exact merge-base in the checkout.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 996 16fa8ebc…`. All 7 design-panel seats returned OK (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice). Panel exit 0, terminal disposition: **must-fix** (four seats request-changes; two comment-only).
- Assembled the aggregate (`round-1.md`) into a review body and posted it to the PR.

**What changed:** One `gh pr review` posted on PR #996 carrying the full aggregate and the must-fix disposition. Posted as a **comment** review, not request-changes, because GitHub forbids request-changes on your own PR (the bot identity `kriscendobot` owns the head fork). The `panel=must-fix` stage marker below is the authoritative signal to the gauntlet; the review body states the disposition for human readers.

**Follow-ups:** The next gauntlet stage (fix-loop) is owed, per the must-fix result. Substantive must-fixes surfaced: (1) the migration/zero-identity-churn rule is defined over caller-input shape rather than resolved value — needs an explicit equality test; (2) `ResolvedWorkerConstraints` referenced but never defined; (3) persistence axis bakes mutable metering/retention into an immutable content-addressed formula (undercuts the #984 acceptance case); (4) no test named to guard the byte-for-byte formula-preservation invariant; plus ergonomic axis-naming/shape inconsistencies and pedant nits (`-ly` hyphen, `→` glyphs, missing `## Prompt`).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr996-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 40 tokens (1219163 cached reads)
- Output: 7500 tokens
- Cost: $1.4427514999999997
- Wall-clock: 415s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
