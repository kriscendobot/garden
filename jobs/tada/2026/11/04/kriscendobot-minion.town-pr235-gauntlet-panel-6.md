Panel round 6 on [PR #235](https://github.com/kriscendobot/minion.town/pull/235) came back **must-fix**. `panel.sh` posted its own review, and nothing was fixed or un-drafted.

- **Pinned refs:** base `3f6c2b24a9855e98a339cb242f05efc7339b9e0d`, head `c7c81caff8c03038661c383250ba47098fb2fb6b`. The isolated checkout was verified at that head, and the PR head had not moved after the panel.
- **Style pre-pass:** the read-only probes exited 0, with one non-blocking advisory that sent the pruner to the 9-line prose comment at `src/resources.ts:1`.
- **Panel:** it ran in `GARDEN_PANEL_SINGLE_ROUND=1` mode. My polling didn't capture the exit code, so I'm relying on the stage-result marker, which it prints only after the review posts, and on the review being visible on GitHub.
- **Review:** [review 5763013072](https://github.com/kriscendobot/minion.town/pull/235#pullrequestreview-5763013072), posted against head `c7c81caf`. It is a comment review because the PR is self-authored, and it keeps the `Must-fix before merge` heading.
- **Main must-fix:** I read only the start of the review, so there may be others. The archivist found that `DEPLOYMENT.md:1482` says the guide directory defaults to `resources/` next to `dist/` and that the EC2 deploy relies on this.
    - **Actual path:** `defaultGuideDirectory()` at `src/resources.ts:52` resolves to `dist/resources/` once compiled.
    - **Effect on EC2:** the guide ships at the app root and `MCP_RESOURCES_DIRECTORY` is never set, so the loader warns and serves no guide or instructions.
- **Forced seats:** the panel forced the archivist, decomplector and pruner onto this round, including the decomplector's is-it-needed question because must-fix findings keep recurring on one mechanism.
- **Un-draft hold:** the phase/evidence pre-pass returned `hold-draft`, so un-draft stays withheld regardless of this verdict. Design phases 1, 2, 4, 5 and 6 are still open, and the named successor is `minion-town-mcp-guide-remaining-slices-20261104`.

**Follow-up:** the gauntlet driver routes this review to the next fix stage. I posted no other jobs and made no garden changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (332260 cached reads)
- Output: 3269 tokens
- Cost: $0.493048
- Wall-clock: 997s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
