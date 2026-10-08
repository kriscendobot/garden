I ran panel round 3 on endojs/endo-but-for-bots#1343 at head `d2cf543e4`, and the verdict is **must-fix**. The verdict is posted on the PR.

- **Run:** `panel.sh` ran in single-round mode against base `5feadaeac04f` (the PR's baseRefOid) in an isolated checkout of `kriscendobot/endo-but-for-bots@issue982-build-special-names`. All 34 seats returned a status and the script exited 0. The run is recorded in the journal at `panel-runs/kriscendobot-endo-but-for-bots-1343/b5a269bf8bfe.md`.
- **Must-fix seats (8 of 34):** breaker, integrator, locksmith, migrator, packager, pruner, spec-keeper and wire-watcher, with 20 must-fix items in total. The main themes:
  - **Unpinned special endowments:** special-endowment formula IDs are not pinned between `identify` and writing the guest formula, so a target can be collected in that window.
  - **Dangling retained IDs:** the retained policy record can keep special IDs that point at collected formulas.
  - **Commit history:** two `fixup!` commits are not squashed, and the breaking-change `!` markers are used inconsistently across commits.
- **Repeated mechanism:** this is the third round in a row with must-fix findings on the same mechanism (retained/special endowments in `provideGuest`, `host.js` and `keyEQ`), so the panel asked the decomplector whether the mechanism is needed at all. The decomplector noted the unified map was the maintainer's request and placed the real problem one level down, in how `@main` is handled.
- **Two pre-passes didn't run:** the phase/evidence and PR-body template checks couldn't find the PR body or the governing design. The panel flagged this but kept going.
- **Posted:** GitHub refuses a request-changes review on the bot's own PR, so the verdict went up as a COMMENTED review, the same form rounds 1 and 2 used. Part 1/2 is review 5449942057 on commit `d2cf543e4`, and part 2/2 is issue comment 6049507384.

No fixes were made and the PR was not un-drafted; the next gauntlet stage owns that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1122116 cached reads)
- Output: 5394 tokens
- Cost: $0.8776552000000001
- Wall-clock: 747s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
