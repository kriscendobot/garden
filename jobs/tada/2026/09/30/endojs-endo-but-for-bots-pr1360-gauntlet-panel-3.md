I ran panel round 3 on endojs/endo-but-for-bots PR #1360 and the verdict is **must-fix**. I posted it as a review on the PR.

**What I ran**
- Checked out the PR head (`design/capability-url-locators`, head `596187b23af5`) in an isolated project worktree at `scratch/project-wt-endojs--ce8e84a2a5bc-81e2e8a8`.
- Ran `panel.sh` in single-round mode against the PR's base commit `47f6965d882b` (llm-47f6965) rather than the moving `origin/<base>` branch. The diff under review is one file: `designs/capability-url-locators.md`.
- All 11 seats finished without error. `panel.sh` ended with "design-panel single-round — must-fix".
- I launched it detached, which lost the exit code. It printed its disposition, which (per the job spec) it does only on a real verdict, so I'm treating it as a normal exit. No seat or decider failed.

**Posted review:** https://github.com/endojs/endo-but-for-bots/pull/1360#pullrequestreview-5366958386. It went up as COMMENTED, not request-changes, because GitHub won't let the bot request changes on its own PR. Round 2 was posted the same way. The review contains the full aggregate plus the PR-body template check.

**What must be fixed**
- **Blocking (the template check forces must-fix):** the PR body is missing the "Scaling Considerations" and "Upgrade Considerations" headings that the repo's PR template requires.
- **Should-fix (integrator):**
  - The design isn't listed in `designs/README.md`.
  - It doesn't cite `cli-store-verb-text-modes.md`, the design that governs `endo store`'s flags.
- **Should-fix (decomplector):**
  - `classifyCapabilityUrl` reports an invalid URL by throwing where it should return a value, and `isCapabilityUrl` then treats "invalid" the same as "not a capability URL".
  - The design says there is "exactly one grammar", but it specifies two for `endo://`: the classifier accepts `view` and `parseLocator` rejects it.
- **Should-fix (critic):** stage 1 accepts a literal `--locator` on the command line, which conflicts with the design's own warnings about leaking bearer strings through shell history and `ps`. The critic recommends refusing it by default.
- **Minor:** three copyeditor grammar items (lines 14, 288 and 545), plus comment-only notes from the skeptic, ergonomist, novice and pruner.

Seat verdicts: request-changes from integrator, decomplector and copyeditor; comment-only from critic, skeptic, ergonomist, novice and pruner; approve from pedant, orthographer and thesaurus.

**Follow-ups:** the gauntlet driver should now stage the fix loop, whose first job is adding the two missing PR-body headings. I made no garden repo changes and did no fixing or un-drafting. GitHub's REST rate limit was intermittently exhausted during the run; the review still posted, and I confirmed it through GraphQL.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (843519 cached reads)
- Output: 4477 tokens
- Cost: $0.7284758000000001
- Wall-clock: 286s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
