Panel round 3 complete. Report:

---

**Panel stage (round 3) — endojs/endo-but-for-bots PR #1102**

- Resolved PR head: `kriscendobot/endo-but-for-bots` @ `design/claude-agents-capability`, current head `a1f172b20` (design PR: `designs/introduced-special-names.md` + `designs/README.md`, 2 files vs base `0eb88836d`, the parent of the first design commit).
- Set up an isolated project worktree keyed by this job base; fetched the latest head (`a1f172b20`, past the `5f79ac9ff` the checkout initially landed on).
- Ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). The first two runs were killed by session reaps (empty output); I relaunched it **detached** (`setsid`, own session, stable rundir at `scratch/panel-pr1102-r3-rundir`) so it survived the reap. Terminal disposition: **`must-fix`**.
- Posted the aggregate verdict on PR #1102. GitHub rejects `--request-changes` on the bot's own PR (`Can not request changes on your own pull request`), so it landed as a `--comment` review titled "Panel verdict — round 3: **must-fix**" (author `kriscendobot`, submitted 2026-09-04T10:51:13Z).

Substance of the must-fix findings (design review): the cited `@main`/#982 driver is a rejected call under the design's own reservation rule; the repeat-provide comparison breaks idempotent guest reacquisition (#1042); the GC-label persistence mechanism (`extractLabeledDeps` `'petName'`) doesn't exist as described; indelibility is attributed to the wrong component; and the prefix reservation doesn't bind embedder-supplied `specials`.

Stopped here per the stage contract — no fix, no un-draft, no loop.

Follow-ups: the gauntlet orchestration owns the next stage (a fix round to address the panel findings); nothing else owed from this stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1102-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 58 tokens (1373363 cached reads)
- Output: 11166 tokens
- Cost: $1.91763025
- Wall-clock: 333s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
