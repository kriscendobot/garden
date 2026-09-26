Panel round 1 complete for endojs/endo-but-for-bots PR #231.

**What I did:**
- Resolved the PR head (`endojs:design/familiar-release`, base `llm` @ `9675ba82`) and got an isolated project worktree.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against base SHA `9675ba82129f7e6883f271d88da2ac7ab18bd73a`. Seven seats fanned (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).
- **Disposition: must-fix.** Substantive request-changes findings clustered around: stale gap audit (G1 CI-wiring and G5 Node-pin already shipped at base; stale `electron` version and code line-citations), multiple dead cross-references (`endo-gateway.md`, `skills/verify-upstream-state.md`, `packages/daemon/src/daemon-node.js`), MVR resolutions that contradict the design's own non-developer success criterion (Gatekeeper `xattr`, chrome-sandbox setup, log-file naming), and an unasserted MVR exit criterion in the CI verification tiers.
- Posted the aggregate as a `gh pr review` on #231. Note: `--request-changes` is rejected by GitHub on the bot's own PR, so it posted as a **COMMENTED** review carrying the full must-fix aggregate (verified: author `kriscendobot`, state `COMMENTED`, `2026-08-31T04:02:35Z`).

**Stopped here** per single-round contract — no fix, no un-draft, no loop.

**Follow-up:** the next-stage-owed heuristic keys on the `must-fix` stage-result marker below; the review is a COMMENTED (not REQUEST_CHANGES) review because the panel bot authored the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr231-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (657629 cached reads)
- Output: 4043 tokens
- Cost: $0.8813975000000002
- Wall-clock: 437s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
