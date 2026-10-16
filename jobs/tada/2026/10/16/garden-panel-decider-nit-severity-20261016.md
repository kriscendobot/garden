I pushed `3eb913e5515` directly to main2: nit-class findings no longer block a panel pass. The deterministic tests pass, and the live check against the real decider model got all 10 fixtures right. I did not touch any minion.town PR or gauntlet.

**What I changed**
- **Decider prompt** (`scripts/jobs/gardening/panel.sh`): the rubric now lives in one new function, `decider_rubric`. The decider grades each finding's severity itself and ignores the label the seat put on it.
  - **Should-fix, never blocks:** comment or JSDoc wording or accuracy that doesn't change behavior, identifier renames for spelling, abbreviation or style, commit-history tidiness, PR title or description completeness, and test-style preferences where the behavior is already tested.
  - **Must-fix, still blocks:** wrong behavior, security or authority errors, data loss, broken contracts, failing tests or missing tests for changed behavior, and a comment false enough to mislead a future change into unsafe behavior. I counted JSDoc type annotations that the type checker reads as contract, not prose.
  - **When unsure:** must-fix.
  - **Unchanged:** the two automatic pre-checks (phase/evidence and PR-body template) still force must-fix before the decider runs.
- **Juror briefs**, edited only where they conflicted:
  - archivist: JSDoc autofix additions and false comments that are harmless are now should-fix.
  - stylist: abbreviated identifiers and renames of non-public identifiers are now should-fix. Renaming a public identifier stays must-fix because it breaks a contract.
  - integrator: an incomplete PR description is should-fix; a description that is false about what lands is still must-fix.
  - packager: a messy autofix commit is now should-fix.
  - `skills/panel-review/SKILL.md`: the must-fix and should-fix buckets now match the new rules.
- **Docs:** the rule is written up in a new section, `skills/panel/SKILL.md` § Finding severity.
- **Gauntlet report:** wherever the "Unaddressed must-fix" list appears (the terminal PR comment, the journal report and the maintainer notice), a note now says the list counts every request-changes item from the seats, and that the nit classes on it don't block.

**Tests**
- New `scripts/jobs/test/panel-decider-severity-test.sh`, with one fixture per nit class and five real-defect fixtures, including one that mixes a real defect with nits. Every fixture is labeled request-changes, so the test exercises the decider's own judgment rather than the seat's label.
  - The default run uses a fake `claude`. It checks that each fixture reaches the decider and that its class appears under the right severity heading in the prompt (24/24 pass).
  - With `GARDEN_PANEL_DECIDER_LIVE=1` it runs the real decider model (sonnet). All 10 fixtures came back right: 5 pass, 5 must-fix. The old prompt returned must-fix on all five nit fixtures, so the change is what fixes them.
- `gauntlet-test.sh` checks the new note and passes 99/99. The existing panel tests pass (single-round, run-record, seat-tiering, details-disclosure, large-aggregate, decider-retry).
- `panel-provider-runner-test.sh` failed one check in my session because my budget setting (`GARDEN_CLAUDE_CALL_BUDGET_USD`) leaked into it. With that variable unset it passes 8/8; the failure is unrelated to this change.

**Follow-ups**
- The "must-fix items (N)" count in the panel-run record still counts every request-changes item from the seats, including nits. The completion reports now say so, but if you want a count of real defects only, that would be a separate change.
- The supervisor job `minion-town-carry-eight-prs-to-merge-20261016` can re-run its verification panels once this commit is deployed across the fleet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-panel-decider-nit-severity-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (3109290 cached reads)
- Output: 27374 tokens
- Cost: $2.05225
- Wall-clock: 1087s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
