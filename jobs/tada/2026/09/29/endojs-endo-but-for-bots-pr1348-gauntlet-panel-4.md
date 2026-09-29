Panel round 4 on endojs/endo-but-for-bots PR #1348 returned **must-fix**, and the verdict is posted on the PR as review 5347326610. The work finished last session. The job came back only because my last report put the stage marker after the completion signal instead of before it.

- **Run:** single-round panel on head `b8a9e727d9` against the frozen base commit `54d654000d59` (`llm-54d6540`). All 33 seats ran ok: 19 approve, 11 comment-only, 2 request-changes (integrator and scribe). The last line was `code-panel single-round — must-fix`. I launched it detached and never saw its exit code directly, but it reached its verdict with no seat errors, so this is a real result, not an infrastructure failure.
- **Must-fix items:**
  1. **#731 parking:** the PR builds on JSON agent-tools that issue #731 parks. A maintainer has to decide whether to lift the parking for this slice or keep the PR draft.
  2. **Disposition mismatch:** the ledger calls the PR `deliverable` while deferring Phase 2c and Phase 4, the phase where grants must actually reach an agent.
  3. **Missing summary comment:** no completion-summary comment covers the round-3 fix commits `be32f1dde2` and `b8a9e727d9`.
- **Should-fix items:**
  - `harden(grantFreeOptions)` deep-freezes objects the caller still owns (four seats flagged this).
  - The README gets wrong when the `inspectShell`/`inspectGitRemote` renames happen.
  - New errors use a bare `TypeError` instead of `@endo/errors`.
  - The README overstates what `readOnly` removes.
  - Tests don't cover the collision path or which capability each renamed tool reaches.
  - The new `workspaceGrants` name collides with the "grants" concept from #965.
  - The fixup commits need regrouping.
- **Posting:** GitHub rejected `--request-changes` because the bot can't request changes on its own PR, so the review posted as COMMENTED, the same as round 3. I checked just now that it is still there, on head `b8a9e727`.
- **Next:** items 1 and 2 need a maintainer decision; a fixer can't settle them. Item 3 and the should-fix items can go to the next fixer stage. No garden code changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1163585 cached reads)
- Output: 8183 tokens
- Cost: $1.8269115999999999
- Wall-clock: 659s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
