Round 4 of the design panel on kriscendobot/minion.town PR #147 came back **must-fix**, and I posted the verdict to the PR.

- **Setup:** I ran the panel against an isolated checkout of `design/mcp-resources-getting-started` at head `4e03a39`, compared with the PR's frozen base `af7af61` (`main-af7af61`). The only changed file is `designs/mcp-resources-getting-started.md`. `panel.sh` ran detached in single-round mode with `GARDEN_YARN=npm`, used the design panel (9 seats), exited 0 and printed `design-panel single-round — must-fix`.
- **Must-fix (critic):** every validation task in § 6.1 runs as a separate `claude -p` process with no saved session. But task T4 asks the agent to change "the page you published in T1", and nothing passes T1's URL or nonce into T4.
- **Should-fix:**
  - **Critic:** § 2 says access control is unchanged, but resources skip the per-guest scope check that tools run.
  - **Skeptic:**
    - Mounts are fixed per process, not per session, so the cold-agent suite can never exercise the no-clips branch.
    - The rollback copies it keeps can't be reached, because the § 4 ancestry check blocks swapping back to an older commit.
    - The Claude Code resource tool names in § 6.1 are unverified.
  - **Decomplector:** the `instructions` string is a second copy of guide facts and updates with the app release, not with the resources.
  - **Pedant:** the tables have no "Table N:" captions.
  - **Novice:** wants short explanations of the tools named in § 1 and of the "step-1 gate".
- **Other seats:** the ergonomist and copyeditor left comments only; the orthographer and thesaurus approved.
- **Review:** it posted as COMMENTED at 2026-10-03T14:42:49Z, because GitHub won't let the bot request changes on its own PR. The body starts with `<!-- disposition: must-fix -->`, which is what tells the gauntlet driver a fix stage is owed. The text is saved in `scratch/panel-147-r4-review.md`.

Nothing changed in the garden repo. As instructed, I didn't fix anything or move the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 22 tokens (575306 cached reads)
- Output: 3552 tokens
- Cost: $0.6381252000000001
- Wall-clock: 284s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
